-- Seed: Končitá (Vtáčnik, Kamenec pod Vtáčnikom) – sektory Vodáreň, Krokodíl, Levitácia, Prova, Planétka, Džungľa, Strapatá. Zdroj: koncita-2019.pdf (boulder.sk).
-- Súradnice oblasti: 48.6469108N, 18.5856208E (od Zombiho). Sektory majú bod z GPS uvedených v tope (Sabotér, Krokodíl, Makro, Prova, Planétka 12, Pán múch);
-- Strapatá v tope GPS nemá, preto je bez súradníc (na mape sa nezobrazí, kým ju niekto nedoplní).
-- Fotky sú len názvy súborov koncita-NN.jpg: výrezy z topa treba pred `supabase db push` nahrať do bucketu boulder-photos.
-- Cesty bez vlastných čiar (topo_path NULL). Projekty sú is_project bez stupňa.
DO $$
DECLARE
    area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
BEGIN
INSERT INTO public.areas (name, description, lat, lon)
VALUES ('Končitá', 'Andezitové bouldre pod Vtáčnikom nad obcou Kamenec pod Vtáčnikom, okolie Chaty pod Končitou: sektory Vodáreň, Krokodíl, Levitácia, Prova, Planétka, Džungľa a Strapatá.', 48.6469108, 18.5856208)
    RETURNING id INTO area_id_var;

-- ===== Vodáreň =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Vodáreň', 48.648361, 18.589694)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vodník', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-01.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rusalka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'S pomocou hrany.', '1a'),
    (boulder_id_var, 'Vodník', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Stienkou doľava, bez hrany.', '1b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Javor', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-02.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Javor', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, NULL, '2a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Sabotér', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-03.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Sabotér', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Zo spoďákov mierne doprava, bez ľavej hrany.', '3a'),
    (boulder_id_var, 'Šinobi', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Po ostrých lištách bez hrany.', '3b'),
    (boulder_id_var, 'Dan', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Po hrane.', '3c');

-- ===== Krokodíl =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Krokodíl', 48.646028, 18.587556)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Žaba – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-04.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Žabie predstavy', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z veľkého bočáku, výlez Kvakom.', '1a'),
    (boulder_id_var, 'Mŕtve žaby nesnívajú', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Úplne z hrany, výlez Žaburinou.', '1b'),
    (boulder_id_var, 'Hoď si žabkou', (SELECT id FROM public.grades WHERE font = '5C'), true, false, NULL, '1c'),
    (boulder_id_var, 'Žaba na jazyku', (SELECT id FROM public.grades WHERE font = '5C'), true, false, NULL, '1d');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Žaba – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-05.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Kvak', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Zo stoja, z líšt v špáre.', '1e'),
    (boulder_id_var, 'Projekt', NULL, true, true, NULL, NULL),
    (boulder_id_var, 'Žaburina', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Po hrane.', '1f');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Krokodíl', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-06.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Krokodíl', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Začiatok v špáre, dolez cez oko.', '2a'),
    (boulder_id_var, 'Aligátor', (SELECT id FROM public.grades WHERE font = '7A+'), false, false, 'Oboma špárami, bez pravej hrany.', '2b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Krokodíl – zadná strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-07.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pán Hrana', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Po hrane.', '2c'),
    (boulder_id_var, 'Festdirekt', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Stienkou bez ľavej hrany.', '2d'),
    (boulder_id_var, 'Pre pána Jána trest', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Ako 2d, špárou až nakoniec.', '2e');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Temné brehy', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-08.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Temné brehy', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Pri hrane, mierne doľava stienkou.', '3a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Strážca', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-09.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Strážca', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Mierne doprava.', '4a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hrebeň – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-10.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Zástava', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Po hrane.', '5a'),
    (boulder_id_var, 'Parcela', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Bez ľavej hrany.', '5b'),
    (boulder_id_var, 'Duša vo vetre', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Stienkou.', '5c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hrebeň – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-11.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Horský vzduch', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '5d'),
    (boulder_id_var, 'Výklus', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '5e'),
    (boulder_id_var, 'Kuľhavý atlét', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '5f');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Premiérky', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-12.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Premiérky', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z madla, bez okolitých kameňov.', '7a');

-- ===== Levitácia =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Levitácia', 48.645639, 18.590000)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Katión', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-13.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Katión', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z malých líšt, po hrane až na koniec.', '1a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Piza', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-14.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Šikmá veža', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ľavou hrana s dierkou, pravou chyt v stene.', '2a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Krab', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-15.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Klepietko', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Vo veľkom chyte a priamo hore.', '3a'),
    (boulder_id_var, 'Klepetá', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Vo veľkom chyte, do hrany a ňou až doprava.', '3b'),
    (boulder_id_var, 'Krabica', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Vo veľkom chyte, celý čas bez hornej hrany, sériou líšt až na koniec, obliezť hranu sprava.', '3c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Skeleton', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-16.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Skeleton', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Nízky nástup, po hrane až na koniec.', '4a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Makro – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-17.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Makro', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z diery, bez kameňa na nohu.', '5a'),
    (boulder_id_var, 'Makro na krok', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'S použitím kameňa na nohu.', NULL),
    (boulder_id_var, 'Mikro', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Bez pravej hrany.', '5b'),
    (boulder_id_var, 'Mimakro', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Ako 5b (v tope preklep „2b“), dolez Makrom.', '5c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Makro – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-18.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Malý Pepek', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z madla pri ľavej hrane, výlez 5g.', '5d'),
    (boulder_id_var, 'Pepek', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Doľava okolo kameňa, výlez Makrom.', '5e'),
    (boulder_id_var, 'Nalomená budúcnosť', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ako 5g a pokračovať doľava a hore, nekvalitná skala!', '5f'),
    (boulder_id_var, 'Ružové sady', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Pôvodne 5C, po výlome ošťažalo.', '5g');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Čivava', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-19.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Čivava', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z označených dier do hrany.', '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Termostat', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-20.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Termostat', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Vpravo za hranou, po špáre, bez ľavej hrany.', '7a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Cíp', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-21.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Cíp pravdy', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z police, výlez vľavo.', '8a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Diamant – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-22.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Averzia', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '9a'),
    (boulder_id_var, 'Beverzia', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '9b'),
    (boulder_id_var, 'Traverzia', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Ako 9a, výlez za hranou.', '9c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Diamant – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-23.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Neverzia', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, NULL, '9d');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pole', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-24.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pole neorané', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Za šípkou, doprava rampou.', '10a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Dolník', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-25.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Volanie doliny', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Mierne doľava stienkou.', '11a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Levitácia', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-26.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Levitácia', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z podstavca, stropom, dolez stienkou.', '12a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Múr', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-27.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Múr nárekov', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Pod previsom z lišty.', '13a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Komoda', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-28.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Šuflíky', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z veľkej lišty.', '14a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Franz', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-29.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rio mare', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z bočáku, bez spodného kameňa, výlez 12b.', '15a'),
    (boulder_id_var, 'Franz Joseph Jarná Cibuľka', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Zo spodného kameňa.', '15b'),
    (boulder_id_var, 'Džana', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '15c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pocestný', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-30.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Slabina pocestných', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Z dierky a lišty, bez kameňov dole.', '16a'),
    (boulder_id_var, 'Sadaj u nás', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'S definovanými nohami podľa červených bodiek.', NULL),
    (boulder_id_var, 'Pešia zóna', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Bez hornej police, doprava.', '16b'),
    (boulder_id_var, 'Motorest', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Bez spodného kameňa.', '16c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zákulisie', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-31.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Šumy', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Traverz doprava a nahor.', '17a'),
    (boulder_id_var, 'Prezliekáreň', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Po hrane.', '17b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Trojuholník', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-32.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pytagor', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Z lišty. Pozor na dunivý spoďák!', '18a'),
    (boulder_id_var, 'Magor', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Zo spoďáku. Pozor na dunivý spoďák!', '18b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Platnička', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-33.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Frankenjuro', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Ako 19b, po dierkach.', '19a'),
    (boulder_id_var, 'Pochod salamandier', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z bočáku za šípkou, špárkou na koniec.', '19b'),
    (boulder_id_var, 'Salamandra', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Zo špárky priamo hore.', '19c'),
    (boulder_id_var, 'Saláma', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Z výraznej police.', '19d');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Macek', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-34.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Balú', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '20a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Surfer', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-35.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Surfer', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Po hrane.', '21a'),
    (boulder_id_var, 'Hrc', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '21b');

-- ===== Prova =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Prova', 48.644611, 18.587583)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Nárazník', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-36.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Nárazník', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Po hrane.', '1a'),
    (boulder_id_var, 'Naraz nik', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Doľava stienkou.', '1b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kolotoč', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-37.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mama', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Objať kameň, priamo hore.', '2a'),
    (boulder_id_var, 'Kolotoč', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Pri šípke vpravo a doľava okolo kameňa.', '2b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ozembuch', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-38.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ozembuch', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Nástup so zadným kameňom na nohy.', '36a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Koala', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-39.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Koala', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Z chytov v strope, koniec v madle.', '3a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lupeň', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-40.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Smietka', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '4a'),
    (boulder_id_var, 'Lupeň', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '4b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Severanka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-41.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Severanka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z police, koniec v chyte.', '5a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Podivín', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-42.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Projekt', NULL, true, true, NULL, '6a'),
    (boulder_id_var, 'Chlomotina', (SELECT id FROM public.grades WHERE font = '4'), false, false, 'Z malých líšt, nenaskakovať!', '6b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Škola', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-43.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Na rohu dvanástej', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Z lišty.', '7a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Škola – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-44.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Šprt', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '7b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Apatia', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-45.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Apetít s apatiou', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z malých líšt za šípkou!, spodom doprava.', '8a'),
    (boulder_id_var, 'Apatia', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z lišty priamo hore.', '8b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Srandička', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-46.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Nedeľné srandičky', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z diery priamo hore.', '9a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Jelínek', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-47.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Jelínkova sila', (SELECT id FROM public.grades WHERE font = '7C'), false, false, NULL, '10a'),
    (boulder_id_var, 'Citlivý prístup', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Nástup ľavou rukou v diere z Jelínka, pravou najspodnejšie madlo.', '10b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Nevinnosť', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-48.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Nevinník', (SELECT id FROM public.grades WHERE font = '5C'), false, false, NULL, '11a'),
    (boulder_id_var, 'Nevinnosť', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Z najnižšieho chytu, výlez cez hranu.', '11b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Opozit', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-49.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ťažko na bojisku, ľahko do hrobu', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z chytov v strope, na hranu a hore.', '12a'),
    (boulder_id_var, 'Labúžo', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z madla vľavo a traverzom po hrane, mantel na záver.', '12b'),
    (boulder_id_var, 'Ranné vstávanie', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Na druhej strane kameňa. Obojručne z malého chytu, jednokrokovka.', '12c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Prova – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-50.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Na palubu', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Po hrane.', '13a'),
    (boulder_id_var, 'Rampičôčička', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z nízkych líšt špárkou, výlez pri strome.', '13b'),
    (boulder_id_var, 'Volanie medoviny', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Z dvoch malých líšt, špárou na vrchol.', '13c'),
    (boulder_id_var, 'Medovina', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Zo stoja.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Prova – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-51.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Le Wall', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Stienkou zo stoja.', '13d'),
    (boulder_id_var, 'La Prow', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Po hrane.', '13e'),
    (boulder_id_var, 'Prow & Wall', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Spojenie Wall a Prow.', '13f'),
    (boulder_id_var, 'Fly like an Eagle', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Z jaskyne za bielou šípkou, dolez ako La Prow.', '13g'),
    (boulder_id_var, 'Ilúzia', (SELECT id FROM public.grades WHERE font = '8A'), false, false, 'Nástup ako Fly, výlez Le Wall.', '13h'),
    (boulder_id_var, 'Medové rezy', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Z Volania medoviny do Le Wall.', '13i');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vrak – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-52.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Travellin Man', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z malých líšt, priamo hore.', '14a'),
    (boulder_id_var, 'Hard Swing', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Ako 14a, do obliny, z nej pokles do 14c.', '14b'),
    (boulder_id_var, 'Španielska čižma', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Z chytu pri červenej šípke.', '14c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vrak – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-53.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Smutný hrdina', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Nástup ako 14c, dolez hranou až na koniec.', '14d'),
    (boulder_id_var, 'Banánová republika', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Ako 14a, po hrane až na koniec.', '14e');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kafetéria', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-54.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Čo ťa operujú?', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z diery, doprava stienkou bez veľkých chytov vľavo.', '15a'),
    (boulder_id_var, 'Chrochtání kafeterie', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z madla, doľava a po hrane, bez kameňa dole.', '15b'),
    (boulder_id_var, 'Dolce Gusto', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Ako Chrochtání, koniec ako Jožkov Comeback.', '15c'),
    (boulder_id_var, 'Mlynček na prsty', (SELECT id FROM public.grades WHERE font = '8A'), true, false, 'Ako 15a, spodom do Chrochtání.', '15d'),
    (boulder_id_var, 'Mlynček na mäso', (SELECT id FROM public.grades WHERE font = '8A+'), true, false, 'Ako 15a, spodom do Chrochtání a pokračovať až do Jožkovho Comebacku.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kafetéria – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-55.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Hypnóza', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Z bočáku, po lištách pod malým previsom, bez kameňa dole.', '15e'),
    (boulder_id_var, 'Jožkov Comeback', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Ako 15e, po lištách vpravo od špáry (zo stoja 6C).', '15f'),
    (boulder_id_var, 'Kaviarenský anonym', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Ako 15e, bez hrany a chytov za špárou.', '15g');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zadnica', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-56.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Olovená zadnica', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z najspodnejších líšt.', '16a'),
    (boulder_id_var, 'Okom bokom', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Cez previs do diery a hore.', '16b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Tunel', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-57.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Na konci tunela už výrazne funela', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Úplne vpravo na hrane, traverz po špáre, koniec v chyte.', '17a'),
    (boulder_id_var, 'Statočné srdce', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Špárou.', '17b'),
    (boulder_id_var, 'Projekt', NULL, true, true, 'Stienkou, bez špáry a hrany.', '17c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mohykán', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-58.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Predposledný mohykán', (SELECT id FROM public.grades WHERE font = '6C+'), false, false, 'Z madla, bez spodného kameňa.', '18a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Očakávanie', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-59.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Nečakaná hrana', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Po hrane.', '19a'),
    (boulder_id_var, 'Pozitívne sklamanie', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z bočáku, stienkou bez ľavej hrany.', '19b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Skrýša', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-60.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Skrýša', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Ľavá spoďák, pravá malý chyt na hranu.', '20a'),
    (boulder_id_var, 'Keška dneška', (SELECT id FROM public.grades WHERE font = '7A+'), false, false, 'Ako Skrýša, ale pokračovať traverzom doľava až na koniec a vymantliť.', '20b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Emócia', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-61.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Emócia', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z diery.', '21a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Alcatraz', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-62.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Alcatraz', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Po lištách doprava a hore.', '22a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Odkvap', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-63.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Suché mozgy', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z bočáku, mierne doprava.', '23a'),
    (boulder_id_var, 'Mokré hlavy', (SELECT id FROM public.grades WHERE font = '3'), true, false, NULL, '23b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Balet', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-64.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Biely balet', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'S hranou, po lištách až na vrchol, bez chytov v špáre.', '24a'),
    (boulder_id_var, 'Slnečný balet', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Ako 24a, s chytmi v špáre.', '24b'),
    (boulder_id_var, 'Medzi svetmi', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z madielka, koniec v stienke.', '24c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lego – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-65.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Projekt', NULL, true, true, 'Pri hrane, traverzom po lištách do Lega.', '25a'),
    (boulder_id_var, 'Lego', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z dvoch líšt, bez pravej hrany, koniec v chyte.', '25b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lego – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-66.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Duplo', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Zo stoja, hranou do stienky a hore.', '25c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Renesancia – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-67.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Renesancia', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Z chytu, doľava a stienkou.', '26a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Renesancia – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-68.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Odliv umelcov', (SELECT id FROM public.grades WHERE font = '6A+'), false, false, 'Z chytu v stene, traverzom doprava, výlez 26c.', '26b'),
    (boulder_id_var, 'Kreatíva', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z nízkeho chytu, špárou, výlez na policu.', '26c'),
    (boulder_id_var, 'Expozícia', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ako 26c, traverz stienkou doprava, výlez na konci.', '26d');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Leháro – Začiatky síl', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-69.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Začiatky síl', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '27a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Leháro', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-70.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Leháro', (SELECT id FROM public.grades WHERE font = '5B'), false, false, 'Z ťahu, priamo hore.', '27b'),
    (boulder_id_var, 'Exit', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z malých líšt. Samostatný kameň 28.', '28a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bruch', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-71.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Big bruch', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Spod previsu, bez spodného kameňa.', '29a'),
    (boulder_id_var, 'Pravý bruch', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Ako 29a, mierne doprava.', '29b'),
    (boulder_id_var, 'Big úch', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Z diery, bez spodného kameňa.', '29c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ignorant', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-72.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ignorant', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z diery, na hranu a premantliť.', '30a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Sansára', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-73.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Choďák', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Hranou.', '31a'),
    (boulder_id_var, 'Korto', (SELECT id FROM public.grades WHERE font = '6A+'), false, false, 'Z líšt v špárke, priamo hore bez pravej hrany.', '31b'),
    (boulder_id_var, 'Sansára', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Ako 31a, do špárky a traverz úplne doľava do chytu na hrane, celý čas bez hornej hrany.', '31c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Skarabeus', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-74.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Skarabeus', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Priamo hore.', '32a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Úškrn', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-75.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Úškrn', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z úškrnu, koniec v chyte.', '33a'),
    (boulder_id_var, 'Hit', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '33b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hranolky', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-76.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Hranolky', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Do špicu.', '34a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Jašter', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-77.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Jašter', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z police, po hrane, výlez z ľavej strany.', '35a'),
    (boulder_id_var, 'Jašterko', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Zo spodného kameňa, používa sa na nohy.', '35b');

-- ===== Planétka =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Planétka', 48.643944, 18.589167)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Posed', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-78.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Slepý poľovník', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '1a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ohnisko', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-79.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vurstík', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'Špárou.', '2a'),
    (boulder_id_var, 'Burstík', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '2b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Rečník, Politik a Oponent', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-80.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Plané reči', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '3a'),
    (boulder_id_var, 'Projekt', NULL, false, true, 'Stredom steny bez hrán.', '4a'),
    (boulder_id_var, 'Team Spirit', (SELECT id FROM public.grades WHERE font = '7B+'), false, false, NULL, '4b'),
    (boulder_id_var, 'Pravica', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'S pravou hranou na vrchol, bez ostatných kameňov.', '4c'),
    (boulder_id_var, 'Špičkogram', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Pravica zo sedu.', NULL),
    (boulder_id_var, 'Citlivá oponentúra', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Stienkou bez pravej hrany.', '5a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ľud', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-81.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vôľa ľudu', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z líšt a priamo hore.', '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Paralela', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-82.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Paralelné svety', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '7a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Autodrom', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-83.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Autodrom', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Z volantu. Pozor na dunivý chyt!', '8a'),
    (boulder_id_var, 'Autodrom Low', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z kameňa pod previsom, bez bočných stien. Pozor na dunivý chyt!', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Fiškus', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-84.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Fiškus', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z dierok, bez hrán.', '9a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Karlov', NULL)
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Karlov', NULL, false, false, 'Zo stoja, bez rúk.', '10a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Trio', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-86.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Krpec', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Z hrany, výlez vľavo.', '11a'),
    (boulder_id_var, 'Prostredník', (SELECT id FROM public.grades WHERE font = '4'), false, false, 'Zo spoďákov, priamo.', '11b'),
    (boulder_id_var, 'Señor', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z dier, priamo hore.', '11c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Planétka – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-87.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Orbita', (SELECT id FROM public.grades WHERE font = '5B'), false, false, 'Po hrane.', '12a'),
    (boulder_id_var, 'Planétka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z ľavých oblín.', '12b'),
    (boulder_id_var, 'Kométka', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Z pravých oblín.', '12c'),
    (boulder_id_var, 'Debut', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z dierky a lišty pri hrane, bez pravej hrany.', '12d'),
    (boulder_id_var, 'Čierna diera', (SELECT id FROM public.grades WHERE font = '6C+'), false, false, '6C+/7A. Z hrany, nízkym traverzom do 12b.', '12e'),
    (boulder_id_var, 'Intergalaktika', (SELECT id FROM public.grades WHERE font = '7C+'), false, false, 'Z hrany, traverzom do 12d, bez madiel z Planétky.', '12f');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Planétka – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-88.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Fragment', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Doľava.', '12g'),
    (boulder_id_var, 'Ostrý fragment', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Doprava.', '12h');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Imágo – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-89.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Metalurg', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Vo výraznom chyte a po hrane.', '13a'),
    (boulder_id_var, 'Imágo', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Zo spodnej diery, stropom do mantlu, veľká diera a kapsa za hranou sa nepoužívajú.', '13b'),
    (boulder_id_var, 'Ideál', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Iba stropom, nič za hranou.', NULL),
    (boulder_id_var, 'Od buka do buka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ako 12a, doprava a cez veľké chyty.', '13c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Imágo – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-90.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Maximal', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Ako Imágo, výlez Minimalom.', '13d'),
    (boulder_id_var, 'Minimal', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Z police a priamo.', '13e');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zmija', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-91.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pekná na dlani, zmija za vami', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Doľava.', '14a'),
    (boulder_id_var, 'Slová, čo štípu', (SELECT id FROM public.grades WHERE font = '4'), false, false, NULL, '14b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Ostýchavec', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-92.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ostýchavec', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '15a');

-- ===== Džungľa =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Džungľa', 48.645389, 18.595667)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Underground', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-93.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Underground', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Z nízkej police, priamo, bez okolitých kameňov.', '1a'),
    (boulder_id_var, 'Projekt', NULL, true, true, 'Vzadu v jaskyni.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pán múch', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-94.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pán múch', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Z bočáku, priamo cez dierky.', '2a'),
    (boulder_id_var, 'Zelené svinstvo', (SELECT id FROM public.grades WHERE font = '6C'), true, false, NULL, '2b'),
    (boulder_id_var, 'Riť jak melóny', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Po hrane.', '2c'),
    (boulder_id_var, 'Rainbow pocket', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Ako 2a, bez veľkej diery z Pána.', '2d'),
    (boulder_id_var, 'Jenga', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Ako Pán múch, z diery doľava stienkou, žiadne stupy za špárou vľavo.', '2e'),
    (boulder_id_var, 'Oko muchy', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Pravou diera, ľavou spoďák a mierne doľava.', '2f');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Sliz', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-95.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Sliz', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z chytov, bez hrán.', '3a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vráskavec', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-96.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vráskavec', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z nízkeho madla, mierne doľava.', '4a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Sňatok', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-97.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ber či ver', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '5a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vežička', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-98.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vežička', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Poličky', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-99.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vitrína', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z lišty vľavo.', '7a'),
    (boulder_id_var, 'Poličky', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z diery a priamo bez pravej hrany.', '7b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vól', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-100.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Proti prúdu', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Traverzom doľava, výlez Putkami.', '8a'),
    (boulder_id_var, 'Zvonivé pútka', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z líšt a priamo.', '8b'),
    (boulder_id_var, 'Hromozvod', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Ako 8a, špárou hore.', '8c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hranomil', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-101.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Hranomil', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Po hrane.', '9a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Pidi', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-102.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Dôstojník', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, NULL, '10a'),
    (boulder_id_var, 'Pidi', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, NULL, '10b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kráľ', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-103.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Wind of Change', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'V špárke, bez použitia ľavej hrany.', '11a'),
    (boulder_id_var, 'Projekt', NULL, true, true, 'A stienkou doprava.', '11b'),
    (boulder_id_var, 'Pravá ruka kráľa', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Po hrane.', '11c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vreckár', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-104.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Prázdne vrecká', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Dole na hrane, výlez nad kameňom.', '12a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Helikopotvora', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-105.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Helikopotvora', (SELECT id FROM public.grades WHERE font = '7A+'), false, false, 'Z dvoch chytov.', '13a'),
    (boulder_id_var, 'Projekt', NULL, true, true, NULL, NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Zabudnutý', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-106.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Projekt', NULL, true, true, NULL, '14a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mladosť', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-107.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rozpoltená mladosť', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z bočákov, priamo cez ostrú dierku, bez veľkých chytov vľavo.', '15a'),
    (boulder_id_var, 'Staroba je absurdum', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Po hrane.', '15b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Klub', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-108.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Klub turistov', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z madielka, po hrane doľava.', '16a'),
    (boulder_id_var, 'Odznak', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'A priamo hore do hrany.', '16b');

-- ===== Strapatá =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Strapatá', NULL, NULL)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Syrček', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-109.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Romadúrek', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z lišty, doľava.', '1a'),
    (boulder_id_var, 'Hermelínek', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z lišty, do stienky.', '1b'),
    (boulder_id_var, 'Nivek', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z hrany pod madielkom.', '1c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Plutva', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-110.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Golfský prúd', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z veľkej police a hranou.', '2a'),
    (boulder_id_var, 'Plytčina', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Z veľkej police, stienkou doprava do hrany a ňou.', '2b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kocka – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-111.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Blud', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Dve malé lišty, bez ľavej hrany.', '3a'),
    (boulder_id_var, 'Mansonov trik', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Dve malé lišty, mierne doprava a priamo.', '3b'),
    (boulder_id_var, 'Macháček', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Vpravo, bez pravej hrany.', '3c'),
    (boulder_id_var, 'Malá rybka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Ako 3c, do hrany a po nej.', '3d'),
    (boulder_id_var, 'Bludný Macháček', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ako 3c, výlez 3a.', NULL);

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kocka – zadná strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-112.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Kozatá nesedí', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z oboch hrán a kútom.', '3e'),
    (boulder_id_var, 'Niekto sa pozerá', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Oblý bočák vpravo a ľavou rukou hrana pod okom.', '3f');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kocka – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-113.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Plastelína', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'A mierne doľava hore.', '3g'),
    (boulder_id_var, 'Projekt', NULL, true, true, 'V bočáku a sériou ďalších bočákov hore.', '3h');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hlava – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-114.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Šija', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Zo špáry a hore po hrane doprava.', '4a'),
    (boulder_id_var, 'Lýceum', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z police vpravo a stienkou doľava do hrany a premantliť.', '4b'),
    (boulder_id_var, 'Leze leze po čele', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z police ako Lýceum a po hrane na vrchol.', '4c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hlava – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-115.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Smola hrou', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'V polici a stienkou vpravo hore.', '4d');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Obchoďák', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-116.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Eskalátor', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z najnižšej police a bez hrán stienkou.', '5a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mlynček', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-117.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Čevapčiči', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'A stienkou hore.', '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Odrhovačka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-118.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Otvárak', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z police a doľava stienkou.', '7a'),
    (boulder_id_var, 'Odrhovačka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z police a priamo hore s pravou hranou.', '7b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Piano', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-119.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Nízke tóny', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z police a doľava.', '8a'),
    (boulder_id_var, 'Piano', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z police a priamo hore.', '8b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Buchtáreň', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-120.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Dukátová cesta', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z madla a po ľavej hrane až na koniec.', '9a'),
    (boulder_id_var, 'Buchtičky', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Z madla a po pravej hrane na koniec, mantel.', '9b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Parket', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-121.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pomáda', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Obojručne zo spoďáku a priamo hore po chytoch.', '10a'),
    (boulder_id_var, 'Tanec s tíkmi', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Obojručne zo spoďáku a traverzom stienkou až do diery.', '10b'),
    (boulder_id_var, 'Tancovala by som', (SELECT id FROM public.grades WHERE font = '3'), false, false, 'Z madielka rovno hore.', '10c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Tieň buku', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-122.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Zlodej', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Rukami pred bočákom, po hrane a mantel pred stromom.', '11a'),
    (boulder_id_var, 'Plíženec', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Rukami pred bočákom a po hrane až na koniec, výlez sprava za hranou, pozor na strom.', '11b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Xylofón – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-123.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rezonátor', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Z veľkého chytu, ľavou rukou do hrany, priamo hore a pokračovať doľava po tupej hrane.', '12a'),
    (boulder_id_var, 'Božská melódia', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Z veľkého chytu, ľavou rukou do hrany, priamo hore a pokračovať doprava po hrane.', '12b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Xylofón – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-124.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Projekt', NULL, true, true, 'A po hrane na vrchol.', '12c');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mantelko', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-125.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Zamantli!', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Objať hrany a vymantliť.', '13a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Huncovinka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-126.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Huncút', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'Z bočáku a lišty.', '14a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Boby', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-127.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Chcem naspäť to LEGO', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ľavou lišta a pravou prídržka.', '15a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Radosť', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-128.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Eufória', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Ľavou lišta a pravou kapsička.', '16a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Maco', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-129.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Medveďku daj facku', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ľavou bočák a pravou bočák.', '17a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Rácio – ľavá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-130.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Joystick', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Z dvoch chytov, do ľavej hrany a po nej.', '18a'),
    (boulder_id_var, 'Gamepad', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z dvoch chytov a priamo hore bez ľavej hrany.', '18b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Rácio – pravá strana', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/koncita-131.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rácio', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z dvoch chytov a priamo hore, pozor na chrbát, dbať na čistotu prelezu!', '18c');
END $$;
