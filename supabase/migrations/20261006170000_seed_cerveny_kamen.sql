-- Seed: Červený Kameň (Píla) – sektory Pytón, Lovec, Hrad (predný a zadný). Zdroj: „Bouldering v okolí Červeného Kameňa“, 2. verzia 4/2020 (boulder.sk).
-- Fotky sú výrezy z topa aj s nakreslenými líniami; cesty bez vlastných čiar (topo_path NULL).
-- Súradnice: Hrad – predný sektor je bod z mapy.cz; ostatné sektory sú odhad podľa prehľadovej mapy v tope (cca ±100 m).
INSERT INTO public.grades (font, value) VALUES ('2', 20)
ON CONFLICT (font) DO NOTHING;

DO $$
DECLARE
area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
BEGIN
INSERT INTO public.areas (name, description, lat, lon)
VALUES ('Červený Kameň', 'Bouldering v okolí hradu Červený Kameň pri dedine Píla (Malé Karpaty): sektory Pytón, Lovec a Hrad.', 48.3933, 17.3285)
    RETURNING id INTO area_id_var;

-- ===== Pytón =====
INSERT INTO public.sectors (area_id, name, description, lat, lon)
VALUES (area_id_var, 'Pytón', 'Medzi Častou a Dubovou odbočte na dedinu Píla a pokračujte po hlavnej ceste smerom na Papierničku až na veľkú križovatku (po pravej strane autobusová zastávka). Tu odbočte doľava a zaparkujte po ľavej strane pri smetných košoch. Hneď za nimi vedie do lesa chodníček, naľavo sú prvé kamene. Do centra sektora pokračujte cestičkou mierne nahor a odbočte na traverzovú vrstevnicu; po cca piatich minútach uvidíte vľavo mohutný masív Zelovoc. K Borisovi sa dá ísť aj z dediny od krčmy okolo tenisového kurtu, cez potok a strmo hore. Býva tu veľa kliešťov, výlezy zvyknú zapadať lístím.', 48.392306, 17.326652)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mantelofil', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-01.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mantelofil', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z dvoch líšt na hrane a priamo hore.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Čokina 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-02.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Čokina', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z chytu, priamo hore.', 'A'),
    (boulder_id_var, 'Orieškovo', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z chytu, traverzom doprava až na hranu.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Čokina 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-03.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mliečna dráha', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z chytu, traverzom doľava až za roh, výlez cez mantel na konci.', 'C');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Snorič', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-04.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Snorič', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z chytu v previse, pozor na dotyk.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Loptoš', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-05.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Loptoško', (SELECT id FROM public.grades WHERE font = '3'), true, false, 'Z chytu na hrane.', 'A'),
    (boulder_id_var, 'Potvorka', (SELECT id FROM public.grades WHERE font = '3'), true, false, 'Z veľkého chytu.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Princ', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-06.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Malý princ', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z chytu v previse, bez spodnej nohy.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pierko', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-07.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pierko', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Z hrany a ľahko na vrchol.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bochník', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-08.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Bochník', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup z dvoch líšt a priamo cez mantel.', 'A'),
    (boulder_id_var, 'Kvások', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Nástup z dvoch líšt a stienkou doľava.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ihrisko', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-09.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Preliezka', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Z diery, mierne doľava a hore.', 'A'),
    (boulder_id_var, 'Rozliezka', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Z diery a priamo hore.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zelovoc 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-10.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Gala', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Nástup z podstavca a priamo hore.', 'A'),
    (boulder_id_var, 'Evelina', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Nástup z podstavca, doľava a hore bez ľavej skaly.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zelovoc 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-11.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ertépel', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z lišty, doľava do hrany a hore.', 'C'),
    (boulder_id_var, 'Pytel zemiakov', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z lišty a priamo hore mantlom.', 'D'),
    (boulder_id_var, 'Ručný zber', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup vpravo v obline, traverz doľava a výlez Pytlom.', 'E'),
    (boulder_id_var, 'Samé krumple', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Nástup vpravo v obline, traverz doľava a výlez Ertéplom.', 'F'),
    (boulder_id_var, 'Dozrievanie', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z dvoch chytov a po hrane.', 'G'),
    (boulder_id_var, 'Hurmikaki', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Nástup ako Dozrievanie a doľava do platne.', 'H'),
    (boulder_id_var, 'Ibakako', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Nástup z veľkej police a priamo hore do platne.', 'I'),
    (boulder_id_var, 'Šparglík', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Nástup v madle a výraznou špárou hore.', 'J');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zelovoc 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-12.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'La Tomatina', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Nástup v madle a traverzom doľava až do hrany a tou.', 'K');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zelovoc 4', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-13.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Džemík', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z madla a nahor bez obmedzení.', 'L'),
    (boulder_id_var, 'Marmenálada', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z veľkého bočáku previsom nahor.', 'M');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zelovoc 5', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-14.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Silovoc', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Nástup pravou z diery a ľavou z malej dierky za hranou.', 'N');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pindili', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-15.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pindili', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Nástup v madielku a hore do topu.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Olgoj Chorchoj', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-16.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Olgoj Chorchoj', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Nástup hlboko v previse zo špárky, podstavec sa na nohy môže, ďalej do hrany a po nej (bez steny vpravo). Dbať na čistotu prelezu.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Loktibrada', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-17.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Loktibrada', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup z chytu v previse a hore.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Dvojtakt', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-18.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Dvojtakt', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Nástup z bočáku a po lištách jemne doľava.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Dekadencia', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-19.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Dekadencia', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Nástup vo výraznom chyte a doprava traverzom po hrane. Dbať na čistotu prelezu.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Riť', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-20.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Odysea', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup v chyte pod previsom, do hrany a ňou.', 'A'),
    (boulder_id_var, 'Ariadnina riť', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Nástup v chyte pod previsom, do previsu a ním aj s použitím hrany.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Arkas', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-21.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Arkas', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Objať balvan a plácať až hore.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Domček z karát', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-22.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Projekt (Domček z karát)', NULL, false, true, 'Veľkým previsom až hore.', 'A'),
    (boulder_id_var, 'Domček z karát', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Nástup z kameňa so šípkou, na nohy sa používa iba ten, previsom až hore.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Smrtihlav', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-23.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Jazva', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup z veľkej police do hrany, hore do špáry a dolez priamo.', 'A'),
    (boulder_id_var, 'Smrtihlav', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Nástup na začiatku špáry a ňou až do nosu a hore.', 'B'),
    (boulder_id_var, 'Projekt (Smrtihlav)', NULL, false, true, 'Nástup z veľkej police a stropom do nosu.', 'C');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Trupík', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-24.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Trupík', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Nástup zo stisku, do hrany a mantel.', 'A'),
    (boulder_id_var, 'Truperzík', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Nástup zo stisku, do hrany a ňou až doľava.', 'B'),
    (boulder_id_var, 'Rukanoha', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Nástup zo spoďáku a priamo hore.', 'C'),
    (boulder_id_var, 'Sedí trupík na zastávke', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup zo spoďáku, doprava a hore.', 'D');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bumerang', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-25.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Bumerang', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Nástup zo stoja z chytu pod hranou a hore, bez okolitých kameňov.', 'A'),
    (boulder_id_var, 'Projekt (Bumerang)', NULL, false, true, 'Nástup ako Bumerang a pokračovať po hrane až na koniec.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Milanov', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-26.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Milanovina', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Nástup vpravo za špárou a na konci výlez.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Žirafa', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-27.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Žirafa', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Nástup z kameňa, do hrany a ňou až na koniec.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Krteček', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-28.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Krteček', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Nástup z diery a priamo hore.', 'A'),
    (boulder_id_var, 'Projekt (Krteček)', NULL, false, true, 'Nástup úplne vľavo a plácačka až do Krtečka.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pytón 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-29.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Boa', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Nástup vo veľkom chyte na hrane, doprava do previsu, do rampy a odbočiť doľava.', 'A'),
    (boulder_id_var, 'Malá Boa', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Nástup v spodnom madle v strope a pokračovať ako Boa.', NULL),
    (boulder_id_var, 'Pytón', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Nástup vo veľkom chyte na hrane, doprava do previsu, pokračovať do rampy a tou doprava až na hranu.', 'B'),
    (boulder_id_var, 'Malý Pytón', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Nástup v spodnom madle v strope a pokračovať ako Pytón.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pytón 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-30.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mamba', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Nástup vo veľkom chyte na hrane a pokračovať po hrane, výlez ako Boa.', 'C');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Boris 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-31.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Botaska', (SELECT id FROM public.grades WHERE font = '2'), true, false, 'Z madielka ľahko hore.', 'A'),
    (boulder_id_var, 'Nandal', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z lišty pod previsom do madla a hore.', 'B'),
    (boulder_id_var, 'Ryšavý Boris', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z dvoch bočákov priamo hore.', 'C'),
    (boulder_id_var, 'Forhend', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z dvoch bočákov do lišty a doprava na hranu.', 'D'),
    (boulder_id_var, 'Grandslam Poetry', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Nástup ako Nandal, po lištách do Borisa.', 'E');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Boris 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-32.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Tajbrejk', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Nástup ako Botaska a traverzom do Forhendu.', 'F'),
    (boulder_id_var, 'Wibledol', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup ako Boris a doľava do Nandala.', 'G');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vodná víla', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-33.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vodná víla', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Nástup z lokrového madla a rovno hore.', 'A');

-- ===== Lovec =====
INSERT INTO public.sectors (area_id, name, description, lat, lon)
VALUES (area_id_var, 'Lovec', 'Parkovanie je spoločné so sektorom Pytón. Stačí prejsť cez križovatku na druhú stranu a hneď za autobusovou zastávkou natrafíte na balvan Karosa. Ostatné kamene sú popri ceste v smere ku hradu. Pri chatke je prameň.', 48.393932, 17.326286)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Karosa', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-34.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Posledná Karosa', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z nízkeho chytu, cez bočák priamo hore.', 'A'),
    (boulder_id_var, 'Opitý vodič', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z bočáku, doľava do Karosy.', 'B');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Čert', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-35.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, '1000 čertov', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z chytu rovno hore.', 'A'),
    (boulder_id_var, '100 čertov', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z chytu mierne doprava a hore.', 'B'),
    (boulder_id_var, '10 čertov', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Zo špárky mierne doľava a hore.', 'C'),
    (boulder_id_var, 'Traja čerti', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, 'D');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Strieška', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-36.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Strieška', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z dvoch stiskov do hrany a mantel.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kamikadze', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-37.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Kam mi kadíš', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z chytu, do hrany a výlez.', 'A'),
    (boulder_id_var, 'Komu káže', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z chytu, do hrany a dolez po hrane až nakoniec.', 'B'),
    (boulder_id_var, 'Kamikadze', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Nástup vpravo dole na hrane a po celej hrane až nakoniec.', 'C');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lovec', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-38.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Lovec perál', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Nástup z najnižšej lišty a hore.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Priekopa 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-39.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Batyskaf', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z dvoch spodných chytov a priamo hore.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Priekopa 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-40.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mariánska priekopa', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup v hlbinách priekopy z hrany a po nej až na vrchol.', 'B'),
    (boulder_id_var, 'Torpédo', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z madla priamo hore.', 'C');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Priekopa 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-41.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Tsunami', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Z dvoch chytov, stropom doprava, hore a doľava do hrany.', 'D'),
    (boulder_id_var, 'Projekt (Priekopa)', NULL, false, true, 'Z dvoch chytov, stropom doprava, výlez priamo.', 'E');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Katka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-42.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Chatka Katka', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Zo spoďáku priamo hore.', 'A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ovečka', NULL)
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ovečka', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Mantlom priamo hore.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Maslo', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-43.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Maslo', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z chytu na hrane, do poličky a doľava hore, bez bočákov z Masielka.', 'A'),
    (boulder_id_var, 'Masielko', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z chytu na hrane, do poličky a cez bočáky.', 'B'),
    (boulder_id_var, 'Namasle', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z chytu na hrane a po nej až hore.', 'C');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Rúfus', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-44.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rúfus', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z veľkého chytu, hore a výlez doľava.', 'A');

-- ===== Hrad - Predný sektor =====
INSERT INTO public.sectors (area_id, name, description, lat, lon)
VALUES (area_id_var, 'Hrad - Predný sektor', 'Pri Červenom Kameni blízko starého židovského cintorína. Zaparkujte na veľkom parkovisku pri hrade čo najbližšie pri rampe v jeho pravom rohu (parkovisko sa zatvára každý deň o 17:00). Od rampy je to asi minúta. Sektor je komfortný, v tieni stromov a vhodný aj pre rodiny s deťmi. Bouldre sú na skalách vyznačené malými čiernymi šípkami, pri SD sa nastupuje rukami pod šípkou.', 48.3940667, 17.3299386)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Recepcia', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-45.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Formulár', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Nástup z bočákov a priamo hore.', '1a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zub', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-46.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Plomba', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z dvoch stiskov do hrany a mantel.', '2a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'RZP', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-47.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Defibrilátor', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Začiatok vpravo v madle zo sedu na kameni, mierne doľava a hore. Spodný kameň sa nestúpa.', '3a'),
    (boulder_id_var, 'Defibrilátorom pod pás', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Začiatok pod hranou z definovaných chytov s bodkami. Pokračovať na hranu a hore kameňom. Spodný kameň sa nepoužíva.', '3b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Nemocnica 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-48.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Patológia', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Nástup v lištách pod šípkou a rovno hore cez veľkú dieru.', '4a'),
    (boulder_id_var, 'Chirurg na dôchodku', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Nástup veľký spoďák, cez lišty hore do ľavej diery a doľava Patológiou na vrchol. Predskalie sa nestúpa.', '4b'),
    (boulder_id_var, 'Neurológia', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Nástup veľký spoďák, cez lišty hore do diery vpravo a na vrchol. Predskalie sa nestúpa.', '4c'),
    (boulder_id_var, 'Anatómia', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Nástup veľký spoďák, lišty hore a bez veľkých dier traverzom doprava a na vrchol bouldrom 4f. Predskalie sa nestúpa.', '4d'),
    (boulder_id_var, 'Urgentný príjem', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Nástup madlo, traverzom do diery vľavo a priamo na vrchol mantlom. Na hrane neodbočovať, diera vpravo sa nepoužíva.', '4e'),
    (boulder_id_var, 'Transfúzia', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Morfo. Nástup madlo, mierne doprava na vrchol, mantel doprava bez horného kameňa.', '4f'),
    (boulder_id_var, 'Gynekológia', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Nástup madlo, mierne doľava a veľkou dierou na vrchol.', '4g'),
    (boulder_id_var, 'Nekrológ', (SELECT id FROM public.grades WHERE font = '6A+'), false, false, 'Zo stoja na pravej strane skaly, po celej hrane doľava až do výlezu Patológie.', NULL),
    (boulder_id_var, 'Ultrazvuk', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Nástup ako Patológia a doprava až do Transfúzie.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Nemocnica 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-49.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Urológia', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Jaskyňa za kameňom. Nástup nízke madlo vpravo, spoďákmi a hranou doľava, koniec znamená vyliezť na hranu previsu, rukami ďalší kameň.', '4h');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Poliklinika', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-50.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Čakáreň', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z madla mierne doprava a madlami na vrchol.', '5a'),
    (boulder_id_var, 'Ošetrovňa', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z madla mierne doľava a dierami na vrchol.', '5b'),
    (boulder_id_var, 'Lekáreň', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z malých líšt, pre nižších nástup z podrepu, lištami mierne doľava hore.', '5c'),
    (boulder_id_var, 'Transfúzna stanica', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z police priamo hore, výrastky sa používajú.', '5d');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Nos 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-51.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Šušeň', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z madla mierne doľava a hore.', '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Nos 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-52.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Výter', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Nástup pod nosom z lišty a stisku, doľava a stienkou hore. Madlá na nose nad nástupom sa nechytajú.', '6b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Krtinec', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-53.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Krtkúf dort', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z madla vpravo mierne doľava a na vrchol.', '7a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Brucho', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-54.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pásový opar', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z líšt na hrane hore.', '8a'),
    (boulder_id_var, 'Pruh', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z police pod kameňom na hranu a Oparom hore. Predskalie sa nestúpa.', '8b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vlna', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-55.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Podvodník', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z madla vpravo v praskline a ňou celkom doprava a hore.', '9a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Špic', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-56.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Špicolez', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z madla vpravo priamo hore.', '10a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zoo 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-57.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Macko Pú', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Nízke SD pod kameňom z bodiek a cez brucho hore. Bez predskalia.', '11a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zoo 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-58.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pravý kraul', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Zo zubatej police priamo hore. Predskalie a kameň vpravo sa nestúpa.', '11b'),
    (boulder_id_var, 'Levý kraul', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Oblapiť kameň a priamo hore. Predskalie sa nestúpa.', '11c');

-- ===== Hrad - Zadný sektor =====
INSERT INTO public.sectors (area_id, name, description, lat, lon)
VALUES (area_id_var, 'Hrad - Zadný sektor', 'Od rampy parkoviska po cestičke popod areál hradu až k ohnisku, kde sú prvé kamene, alebo spodnou spojnicou z predného sektora. Okrem prvých dvoch kameňov je sektor vo svahu a v náročnejšom teréne. Vhodný na zimné lezenie, v lete tu býva veľmi teplo.', 48.393169, 17.332103)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pukanec 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-59.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pepo', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Z madla vpravo doľava a mantlom na vrchol. Predskalie sa nepoužíva.', '1a'),
    (boulder_id_var, 'Škrkátko', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Zo stiskov na spodku kameňa s bodkami doprava do Pepa a ním na vrchol. Predskalie sa nepoužíva.', '1b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pukanec 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-60.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Projekt (Pukanec)', NULL, false, true, 'Nástup ako Škrkátko, doľava a madlami na hrane na vrchol. Predskalie sa nepoužíva.', '1c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Opekáček', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-61.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Špekáček', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z police priamo hore.', '2a'),
    (boulder_id_var, 'Slaninka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z police traverz doľava a bruchom na vrchol.', '2b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Cukráreň', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-62.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Bernardínov náklad', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z dvojlišty doľava a hore.', '3a'),
    (boulder_id_var, 'Horálka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z dvojlišty, cez spoďáky a hore.', '3b'),
    (boulder_id_var, 'Viedenská káva', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Cez veľkú prasklinu hore.', '3c'),
    (boulder_id_var, 'Osie hniezdo', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Nástup vo veľkej diere a ňou na vrchol.', '3d'),
    (boulder_id_var, 'Kakaové nárezy', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Po hrane hore.', '3e');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ambulancia 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-63.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Krátka púť obličkového kameňa', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z veľkého madla cez brucho na vrchol.', '4a'),
    (boulder_id_var, 'Dlhá púť obličkového kameňa', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z madielka nízky prechod do Krátkej púte a ňou hore.', '4b'),
    (boulder_id_var, 'Chudokrvnosť', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z madielka na hranu a mantlom mierne doľava hore.', '4c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ambulancia 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-64.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Tučnokrvnosť', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z madielka na hranu a mierne doprava do veľkého kameňa hore.', '4d'),
    (boulder_id_var, 'Krvný obeh', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Z madielka vpravo na hranu, traverz doľava a výlez Krátkou púťou.', '4e'),
    (boulder_id_var, 'Ubehaná krv', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z madielka vpravo na hranu a mantlom priamo hore.', '4f');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ľavá nora', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-65.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Podliezač', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z veľkého bočáku hore. Predskalie sa nestúpa.', '5a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pravá nora 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-66.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Prndolíno', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z najnižších líšt hore. Pre vyšších krkolomný nástup.', '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pravá nora 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-67.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Čumák', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Oblapiť pod šípkou a cez policu hore.', '6b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pravá nora 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-68.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ploténka', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Zo spoďákov a cez lišty hore.', '6c');
END $$;
