-- Zápis do databázy a do bucketu boulder-photos len pre editorov (tabuľka editors), čítanie ostáva verejné.
--
-- Hneď po `supabase db push` pridaj svoj email (malými písmenami), inak sa z editora zamkneš:
--   insert into public.editors (email) values ('tvoj@email.sk');
-- Ďalšieho editora pridáš rovnakým riadkom, odobrať ho vieš cez delete. Prihlásenie je emailový kód (Supabase Auth),
-- takže šablóna "Magic Link" v Authentication → Emails musí obsahovať {{ .Token }}.

create table if not exists public.editors (
    email text primary key check (email = lower(email))
);

-- Bez politík: klienti tabuľku nevidia, číta ju len is_editor()
alter table public.editors enable row level security;

create or replace function public.is_editor()
    returns boolean
    language sql
    stable
    security definer
    set search_path = ''
as $$
select exists (select 1 from public.editors where email = lower(auth.jwt() ->> 'email'));
$$;

-- Zápisové politiky z dashboardu poznáme len podľa výsledku, nie podľa mena, preto sa zrušia všetky
-- (okrem SELECT) a nahradia editorskými.
do $$
    declare
        pol record;
    begin
        for pol in
            select schemaname, tablename, policyname
            from pg_policies
            where (schemaname = 'public' and tablename in ('areas', 'sectors', 'boulders', 'climbs', 'grades')
                and cmd <> 'SELECT')
               or (schemaname = 'storage' and tablename = 'objects'
                and (qual ilike '%boulder-photos%' or with_check ilike '%boulder-photos%')
                and cmd <> 'SELECT')
            loop
                execute format('drop policy %I on %I.%I', pol.policyname, pol.schemaname, pol.tablename);
            end loop;
    end
$$;

create policy "Editors write" on public.areas
    for all to authenticated using (public.is_editor()) with check (public.is_editor());
create policy "Editors write" on public.sectors
    for all to authenticated using (public.is_editor()) with check (public.is_editor());
create policy "Editors write" on public.boulders
    for all to authenticated using (public.is_editor()) with check (public.is_editor());
create policy "Editors write" on public.climbs
    for all to authenticated using (public.is_editor()) with check (public.is_editor());

create policy "Editors write photos" on storage.objects
    for all to authenticated
    using (bucket_id = 'boulder-photos' and public.is_editor())
    with check (bucket_id = 'boulder-photos' and public.is_editor());
