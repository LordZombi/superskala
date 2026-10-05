-- Chtelnica (Malé Skalky): doplnenie podľa sprievodcu „Malé Skalky – Bouldering“ v1.1 (2023).
-- Fotky sú výrezy zo sprievodcu aj s nakreslenými líniami a číslami; cesty bez vlastných čiar (topo_path NULL).
-- Nové sektory nemajú súradnice (lat/lon NULL) – sprievodca ich neuvádza.

-- Čísla v sprievodcovi obsahujú aj varianty (3a, 4b) a kombinácie (3+3a), preto text namiesto čísla
ALTER TABLE public.climbs
    ALTER COLUMN topo_number TYPE text USING topo_number::text;

DO $$
DECLARE
area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
BEGIN
SELECT id INTO STRICT area_id_var FROM public.areas WHERE name = 'Chtelnica';

UPDATE public.areas
SET description = 'Malé Skalky – najväčšia bouldrová oblasť Malých Karpát, kilometer dlhý pás zlepencových skál medzi Chtelnicou a Dobrou Vodou. Prístup: z námestia v Chtelnici ku kostolu a vľavo od neho smer priehrada, popri nej ďalej po asfaltke k betónovému rybníku (6 km z obce), kde sa dá zaparkovať. Odtiaľ pešo 10 min k prvým bouldrom, 25 min k posledným. Sezóna celý rok, lepšie v chladnej časti roka.'
WHERE id = area_id_var;

-- ===== Existujúce cesty na stene Pop: čísla z topa a opravy podľa sprievodcu =====
SELECT id INTO STRICT sector_id_var FROM public.sectors WHERE area_id = area_id_var AND name = 'Predný sektor - Kliešť a Pop';

UPDATE public.climbs c
SET topo_number = v.topo_number
FROM (VALUES
    ('Odlepriť', '1'), ('Invázia', '2'), ('Kamínky', '3'), ('Pop', '4'), ('Pán Boh zaplať', '5'),
    ('Šakty', '6'), ('Primitív', '7'), ('Balada pro banditu', '8'), ('Soho', '9'), ('Drum&Bass', '10'),
    ('Hydra', '6a'), ('Šakty primitív', '7a'), ('Nočný spoj', '8a')
) AS v(name, topo_number), public.boulders b
WHERE c.boulder_id = b.id AND b.sector_id = sector_id_var AND c.name = v.name;

-- Šakty sa podľa sprievodcu nastupuje zo stoja; názov kombinácie je „Šak ty primitív“
UPDATE public.climbs c SET is_sit_start = false
FROM public.boulders b WHERE c.boulder_id = b.id AND b.sector_id = sector_id_var AND c.name = 'Šakty';

UPDATE public.climbs c SET name = 'Šak ty primitív'
FROM public.boulders b WHERE c.boulder_id = b.id AND b.sector_id = sector_id_var AND c.name = 'Šakty primitív';

-- ===== Predný sektor - Mega previs =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Predný sektor - Mega previs')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mega previs 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-01.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ako sa ti páči', (SELECT id FROM public.grades WHERE font = '6B+'), false, false, NULL, '1'),
    (boulder_id_var, 'Houm', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Nástup bez skaly vpravo.', '2');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mega previs 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-02.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Óda na bolesť', (SELECT id FROM public.grades WHERE font = '7C'), true, false, '7C (+). Nielen pre krátkych snáď ešte ťažšie.', '3'),
    (boulder_id_var, 'Siaha', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Definovaný smer. Dlhé prešahy po madlách.', '3a'),
    (boulder_id_var, 'Óda na siahu', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Óda + Siaha.', '3+3a'),
    (boulder_id_var, 'Sochár Um', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Silová frajerina ako zo Švajcu. Tip: „Suchár lezie Sochára za sucha“!', '4'),
    (boulder_id_var, 'Od nikál do nikál', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Lištový traverz. Nízke sd projekt.', '5'),
    (boulder_id_var, 'Sochár od nikál', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Low SD viac vpravo 7C+ (5a.)', '5+4'),
    (boulder_id_var, '15 Snežných opíc', NULL, true, true, 'Po vylomení chytu znova projekt.', 'P1'),
    (boulder_id_var, 'Projekt', NULL, true, true, 'Jasná linka krížom cez strop.', 'P2');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mega previs 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-03.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, '30ka', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Začiatok v spoďáku a bočáku,skok do madielka a doprava. Sd projekt.', '1'),
    (boulder_id_var, 'Päťka', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '2'),
    (boulder_id_var, '6áčko', (SELECT id FROM public.grades WHERE font = '6A'), false, false, NULL, '3'),
    (boulder_id_var, 'Poopica', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Začiatok nízko z veľkého spoďáku a ďalej šikmo doľava.', '4'),
    (boulder_id_var, 'Na háku', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Začiatok nízko z veľkého spoďáku a ďalej po dierkach.', '5'),
    (boulder_id_var, 'Posledný akčný hrdina', (SELECT id FROM public.grades WHERE font = '6C'), true, false, NULL, '6');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mega previs 4', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-04.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'BIOmasa', (SELECT id FROM public.grades WHERE font = '5A'), false, false, 'Parádne chyty. Hajbólek.', '7'),
    (boulder_id_var, 'BIOšok', (SELECT id FROM public.grades WHERE font = '5B'), false, false, 'Nebojte sa BIA.! Hajbólek!', '8');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mega previs 5', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-05.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ópium', (SELECT id FROM public.grades WHERE font = '7B'), false, false, '7B/+.', '9'),
    (boulder_id_var, 'Superfet', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Variant z Ópia do Morfia.', '10'),
    (boulder_id_var, 'Morfium', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Prsty umŕtvi, myseľ nabudí.', '11'),
    (boulder_id_var, 'Projekt', NULL, false, true, NULL, '12');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Mega previs 6', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-06.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mechanický bublifuk', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Traverz bez horných madiel.', '13'),
    (boulder_id_var, 'Mechanický bublifuk turbo', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Traverz bez horných madiel.', '13a'),
    (boulder_id_var, 'Transchtelnická magistrála', (SELECT id FROM public.grades WHERE font = '7C'), true, false, '+ Turbo verzia.. odzadu a až do top madla z 6.', '13a+6'),
    (boulder_id_var, 'Kurvafix', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Doľava cez lištu, bez dobrej diery zo 6béčka.', '14'),
    (boulder_id_var, '6béčko', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ešte nižšie sd 6B+.', '15'),
    (boulder_id_var, 'Návšteva u zubára', (SELECT id FROM public.grades WHERE font = '7A'), true, false, NULL, '16'),
    (boulder_id_var, 'Plácačka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Jeden z prvých v sektore. Tvrdé :)', '17'),
    (boulder_id_var, 'Slávov', (SELECT id FROM public.grades WHERE font = '6C'), true, false, NULL, '18');

-- ===== Predný sektor - Enti =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Predný sektor - Enti')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-07.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Co ťa kaňa drápe?', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z madla. Nohy iba v strope.', '1');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-08.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Burčák', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z dierky a spoďáku. Stúpa sa aj predskalie. Variant s nohami iba v strope je 6B+.', '2'),
    (boulder_id_var, 'Slimačie sny', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Dlhý náčah doprava a cez diery hore.', '3'),
    (boulder_id_var, 'Rébus', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Narovnanie „Slimákov“.', '3a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-09.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Rozprdka', (SELECT id FROM public.grades WHERE font = '4'), false, false, NULL, '4');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 4', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-10.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Život Entov', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Hajbólek!', '5'),
    (boulder_id_var, 'Svít Fráns', (SELECT id FROM public.grades WHERE font = '5A'), false, false, NULL, '6'),
    (boulder_id_var, 'Za hubičku', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Traverz začína v madlách vpravo a končí „Rozprdkou“.', '7'),
    (boulder_id_var, 'Dík more', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Pre kratších ťažšie.', '8');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 5', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-11.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Home les', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Začiatok ľavou v bočáku a pravou na hrane.', '1');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 6', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-12.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Bolí horí', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Obojručne z odštepu, ďalej do dierky a na ľavú hranu.', '2');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 7', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-13.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Puta', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Šmak.', '3');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 8', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-14.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Neboj sa!', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Vo výleze opatrne. Hajbólek!', '2'),
    (boulder_id_var, 'Starouš', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Iba stienkou. Záver jemne doľava, bez špáry.', '3'),
    (boulder_id_var, 'Obézna chudoba', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Koniec v madle. Traverzová klasika. Pekná lezecká cesta bez lana.', '4'),
    (boulder_id_var, 'Chudoba', (SELECT id FROM public.grades WHERE font = '6A+'), false, false, 'Začiatok v diere a koniec v madle.', '4a'),
    (boulder_id_var, 'Stará Morla', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Z chytov rovno hore do špárky, bez madiel vpravo a kútu vľavo.', '5');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 9', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-15.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Zapeklitosť', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Bez stúpania do stienky vľavo. Opomínaný boulder, ktorý nieje zadarmo.', '6'),
    (boulder_id_var, 'Aha ďalší', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'V úvode sa nestúpa stienka vľavo a potom cez dierku a kamienok do madla.', '7'),
    (boulder_id_var, 'Do počtu', (SELECT id FROM public.grades WHERE font = '5A'), false, false, NULL, '8'),
    (boulder_id_var, 'Malý Súľov', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Nízko bez veľkých chytov z bouldra „Do počtu“.', '9');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Enti 10', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-16.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Medvedička', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Začiatok v kapse. Stiesnený, no perfektný boulder. Pozor na dotyk s okolitými skalami.', '1');

-- ===== Predný sektor - Kanik west =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Predný sektor - Kanik west')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kanik west 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-17.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Od Míša', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, NULL, '1');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kanik west 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-18.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Sen o ničnerobení', (SELECT id FROM public.grades WHERE font = '4'), false, false, NULL, '2'),
    (boulder_id_var, 'Atari', (SELECT id FROM public.grades WHERE font = '5C'), true, false, NULL, '3'),
    (boulder_id_var, 'Kuna Chtelnická', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Z lišty a dierky, bez ľavej hrany.', '4'),
    (boulder_id_var, 'Od Zany', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '5');

-- ===== Predný sektor - Kliešť a Pop (existujúci sektor) =====
SELECT id INTO STRICT sector_id_var FROM public.sectors WHERE area_id = area_id_var AND name = 'Predný sektor - Kliešť a Pop';

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kliešť a Pop 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-19.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Ňuňuša', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'Z veľkej lišty bez hrany a ľavého kameňa.', '1'),
    (boulder_id_var, 'Potvora', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'Sd z bočákov, berie sa všetko.', '2'),
    (boulder_id_var, 'Hip Hop', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '3'),
    (boulder_id_var, 'Klieštica', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Variant po hrane viac z prava.', '4a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kliešť a Pop 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-20.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Kliešť', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Asi prvé 6C v oblasti. Klasika.', '1'),
    (boulder_id_var, 'Chrumky', (SELECT id FROM public.grades WHERE font = '6C'), true, false, NULL, '2'),
    (boulder_id_var, 'Vibrácia', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Skvostná výzva v kolmom.', '4'),
    (boulder_id_var, 'Vibrácia', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Nízke SD. Ľavou bočáčik, pravou spoďák.', '4a'),
    (boulder_id_var, 'Vibračná plutvička', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Riči pri 1. preleze ohodnotil ako 8A/+.', '4a+4b'),
    (boulder_id_var, 'Lomidrevo', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Z SD „Vibrácie“ a z neho doprava do „Valibuka“.', '4a+5'),
    (boulder_id_var, 'Vibračná plutvička', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Začiatok zo stoja „Vibráciou“ a hore po hrane bez police v pravo. Hajbólek!', '4b'),
    (boulder_id_var, 'Valibuk a buk', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Z bočáku a madielka na pravačku. Výlez doprava cez obliny a hore.', '5'),
    (boulder_id_var, 'Miesiželezo', (SELECT id FROM public.grades WHERE font = '7C'), true, false, '7C(+). Technický traverz s ťažkým prechodom do „Valibuka“.', '6'),
    (boulder_id_var, 'Chvenie', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Začína ako „Miesiželezo“ a dolez „Vibráciou“.', '6+4'),
    (boulder_id_var, 'Cesta do neba', (SELECT id FROM public.grades WHERE font = '7C+'), true, false, 'Riči pri 1. preleze ohodnotil ako 8A.', '6+4b');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kliešť a Pop 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-21.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Loktibrada', (SELECT id FROM public.grades WHERE font = '5A'), false, false, NULL, '7'),
    (boulder_id_var, '135ka', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, NULL, '8'),
    (boulder_id_var, '135ka na stojáka', (SELECT id FROM public.grades WHERE font = '6C'), false, false, NULL, '8a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kliešť a Pop 4', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-22.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Techno', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'L stisk, P dierka, hore cez lišty do dier a záver v špáre.', '11'),
    (boulder_id_var, 'Punk', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Z malej dierky a lišty hore do položeného.', '12'),
    (boulder_id_var, 'Grif', (SELECT id FROM public.grades WHERE font = '7A'), true, false, '7A(6C). Morfo.', '13');

-- ===== Predný sektor - 15 min =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Predný sektor - 15 min')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, '15 min', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-23.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vari akčný guláš', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Začiatok ľavou spoďáková diera a pravou lišta, ďalej sa nechytá veľká diera vpravo a špára nad ňou.', '1'),
    (boulder_id_var, 'Drsná špára', (SELECT id FROM public.grades WHERE font = '4'), false, false, '4C. Bacha, no vylezte si to!', '2'),
    (boulder_id_var, '15 minút', (SELECT id FROM public.grades WHERE font = '7B+'), false, false, 'Klasika. Boulder par excellence.', '3'),
    (boulder_id_var, 'Vyvolávač slaniny', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Priamo hore cez stisk a lištičku.', '4'),
    (boulder_id_var, 'Vyvolávač slabiny', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Variant doprava, keď sa lištička berie ľavou a ďalej doprava do bližšej police.', '4a'),
    (boulder_id_var, 'Mäsakus', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Skvelý traverz a odvážny výlez „Špárou“.', '5'),
    (boulder_id_var, 'Guláš-majster', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Bez veľkej diery.', '5+1'),
    (boulder_id_var, 'Poníženie', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Nízky traverz z líšt bez horných chytov a ďalej do „Bandera“.', '6'),
    (boulder_id_var, 'Hlboké poníženie', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Štart z diery a ťažký krok do líšt bez diery a spoďákov hore.. Ďalej ako „Poníženie“.', '6a'),
    (boulder_id_var, '100 sekúnd', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Z „Hlbokého“ do „15 minút“.', '6a+3'),
    (boulder_id_var, 'Hlboké poníženie slaniny', (SELECT id FROM public.grades WHERE font = '7B'), true, false, NULL, '6a+4'),
    (boulder_id_var, 'Bandero', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Krásna 5ka.', '7'),
    (boulder_id_var, 'Bolo nás dvanásť', (SELECT id FROM public.grades WHERE font = '6C+'), false, false, 'Traverz po rampe. Moráles.', '8');

-- ===== Predný sektor - Amfík =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Predný sektor - Amfík')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Amfík 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-24.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Benčmark', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, NULL, '1'),
    (boulder_id_var, 'Benčmark hard', (SELECT id FROM public.grades WHERE font = '6B+'), false, false, 'Bez použitia spodnej skaly - nohy iba v previse.', '1a'),
    (boulder_id_var, 'Posadnutosť', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Začiatok 1a. Potom 3. opačne doprava a na konci špárky výlez hore.', '1a+3'),
    (boulder_id_var, 'Benchdrill', (SELECT id FROM public.grades WHERE font = '7B+'), false, false, 'Ako „Hard“ ďallej obloušpárkou doľava za hranu. Obmedzenie chytov nad špárkou a stúpania predskalia a položenej časti vľavo.', '2'),
    (boulder_id_var, 'Bench press', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Obojručne z oblinky a po oblej špáre do 1.', '3'),
    (boulder_id_var, 'Kandál vác', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Po špárke do 2.', '3+2'),
    (boulder_id_var, 'Prekusnutá fáza', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Zo stoja z dierok.', '4'),
    (boulder_id_var, 'Matrioška', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Skvelá silová linka po oblinách.', '6'),
    (boulder_id_var, 'Menštruácia', (SELECT id FROM public.grades WHERE font = '7C'), true, false, '7C(+). Ultimátna linka s prísnymi krokmi. Názov hovorí za všetko:)', '7');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Amfík 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-25.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'A'' Tuin', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Previerka odvahy a techniky.', '1'),
    (boulder_id_var, 'Teploplachý', (SELECT id FROM public.grades WHERE font = '7B+'), false, false, NULL, '2');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Amfík 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-26.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Mastodont', (SELECT id FROM public.grades WHERE font = '7A'), false, false, '7A(+). Cez brucho a lišty do tufy (7A) a highball dolez (+). S pomocou spoďáka vpravo ľahšie.', '3'),
    (boulder_id_var, 'Zlodej z Hlohovca', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Z bočáku hore a potom doľava do tufy, príp. hore.', '4'),
    (boulder_id_var, 'Tufifé', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Začiatok v spoďáku v kúte a traverz cez tufy.', '5'),
    (boulder_id_var, 'Ó liana', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Začiatok ľavou lišta a pravou stisk.', '6'),
    (boulder_id_var, 'Chtelničanka', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Do lišty a doľava. Nosná linka sektora.', '7'),
    (boulder_id_var, 'Missky zubaté', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Z police a doprava a hore.', '8'),
    (boulder_id_var, 'Levá noha ďábla', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Začiatok ako „Chtelničanka“ potom do „Misiek“.', '8a'),
    (boulder_id_var, 'Odmäk sa jej páči', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, NULL, '8a+9'),
    (boulder_id_var, 'Odmäk sa mi nepáči', (SELECT id FROM public.grades WHERE font = '7B'), true, false, NULL, '9'),
    (boulder_id_var, 'Kozatá Chtelničanka', (SELECT id FROM public.grades WHERE font = '7C'), true, false, NULL, '11+8+7');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Amfík 4', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-27.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Držme sa pri zemi!', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Nízky traverz doprava do hrany a hore cez obliny do police. Bez špáry vpravo.', '10'),
    (boulder_id_var, 'Kozy', (SELECT id FROM public.grades WHERE font = '6C'), true, false, NULL, '11'),
    (boulder_id_var, 'Ohnivá čára', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Cez obliny do kamienka. Madlo vpravo sa v závere nechytá, iba stúpa.', '12'),
    (boulder_id_var, 'Fénixové slzy', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Ako „Ohnivá čára“ no bez skaly vľavo.', '12a'),
    (boulder_id_var, 'Jeníček a perníček', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '13');

-- ===== Predný sektor - Lord =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Predný sektor - Lord')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lord', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-28.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Lord', (SELECT id FROM public.grades WHERE font = '6B'), true, false, NULL, '1'),
    (boulder_id_var, 'Kondoríček', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '2'),
    (boulder_id_var, 'Rampa', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '3'),
    (boulder_id_var, 'Goriláček', (SELECT id FROM public.grades WHERE font = '6C'), true, false, NULL, '4');

-- ===== Vane =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Vane')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vane 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-29.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vane', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Zo spoďáku po vaniach hore.', '1');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vane 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-30.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Dynamický úškrnok', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Z úsmevu hore do dierky a mierne doprava, bez madiel vľavo.', '2'),
    (boulder_id_var, 'Pätman', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Traverz nízko nad zemou po oblinách. Nechytajú sa horné dierky.', '3'),
    (boulder_id_var, '5C', (SELECT id FROM public.grades WHERE font = '5C'), true, false, NULL, '4');

-- ===== Zadný sektor - Dungeon Master =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Dungeon Master')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Dungeon Master', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-31.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Hnácačka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '1'),
    (boulder_id_var, 'Lapau', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Traverz do hrany a hore.', '2'),
    (boulder_id_var, 'Divé lipy', (SELECT id FROM public.grades WHERE font = '7A'), true, false, NULL, '3'),
    (boulder_id_var, 'Dungeon Master', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Skvost. Low SD z prava z madla 7A.', '4'),
    (boulder_id_var, 'Bananašuch', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, NULL, '5');

-- ===== Zadný sektor - Chlapeček z periferie =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Chlapeček z periferie')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Chlapeček z periferie 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-32.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vivat', (SELECT id FROM public.grades WHERE font = '5B'), false, false, NULL, '1'),
    (boulder_id_var, 'Jazda', (SELECT id FROM public.grades WHERE font = '5C'), false, false, NULL, '2'),
    (boulder_id_var, 'Flow', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Zo stoja z líšt a rovno hore stienkou.SD 7B.', '3'),
    (boulder_id_var, 'Divný Janko', (SELECT id FROM public.grades WHERE font = '6C+'), false, false, 'Vpravo od Flow. Neodbáčať do madiel.', '3a'),
    (boulder_id_var, 'Rozlejzak', (SELECT id FROM public.grades WHERE font = '5A'), false, false, NULL, '4');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Chlapeček z periferie 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-33.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Chlapeček z periferie', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Klasika. Kedysi 6A :)', '5'),
    (boulder_id_var, 'Chlapák', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Výlez priamo platňou cez jednoprdu.', '5a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Chlapeček z periferie 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-34.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vstupné', (SELECT id FROM public.grades WHERE font = '5A'), false, false, NULL, '6'),
    (boulder_id_var, 'Vápno', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Bez kúta cez vápencové chyty.', '7'),
    (boulder_id_var, 'Wolfenstein', (SELECT id FROM public.grades WHERE font = '5B'), false, false, 'Pilierom bez stienky vľavo.', '8'),
    (boulder_id_var, 'Doom', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Stienkou.', '9');

-- ===== Zadný sektor - Blátotlačka =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Blátotlačka')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Blátotlačka 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-35.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Drtička', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Z líšt šikmo doprava do hrany. Nízke sd zo spoďáku je projekt.', '1'),
    (boulder_id_var, 'Blátotlačka z Uralu', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD z dierky. Ďalej šikmo doľava do hrany a ňou na vrchol. Zo stoja z obliny 6C.', '2'),
    (boulder_id_var, 'Blátotlačka original', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Obojručne z obliny, pravou hore do lišty a ľavou plesk na hranu.', '2a'),
    (boulder_id_var, 'Vogónska poézia', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'SD z dierky a rovno hore bez ľavej hrany. Pôvodná verzia zo stoja z obliny je 7B.', '3'),
    (boulder_id_var, 'Vír totálnej perspektívy', (SELECT id FROM public.grades WHERE font = '7A+'), false, false, 'Pravou dierka z Jupíka, ľavou dierkostisk, hore a do police vpravo.', '4'),
    (boulder_id_var, 'Vír totálnej perspektívy', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'SD ako 3. a dolez „Vírom“.', '4a'),
    (boulder_id_var, 'Jupík', (SELECT id FROM public.grades WHERE font = '6B+'), false, false, 'Ľavou dierka a pravou oblina a šikmo doprava hore. Skvost.', '6'),
    (boulder_id_var, 'Jupík', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Začiatok obojručne v stiskoch. Skala vpravo sa nepoužíva.', '6a');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Blátotlačka 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-36.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Oheň a mádžo', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Zo sedu z oblej hrany a traverz doprava. Koniec v madle.', '7');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Blátotlačka 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-37.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Brkobong', (SELECT id FROM public.grades WHERE font = '6A'), false, false, NULL, '8');

-- ===== Zadný sektor - Hlina =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Hlina')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hlina 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-38.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Háj', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Ľavou madielko, pravou čosi a rovno hore.', '1'),
    (boulder_id_var, 'Krásňačik', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Ľavou madielko a v tej úrovni traverz doprava do madiel a hore.', '2'),
    (boulder_id_var, 'Bystruška', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Ľavou lišta, pravou čosi v tej výške a pravou bum do obliny a prásk doľava do madla.', '3'),
    (boulder_id_var, 'Skratka cez Moskvu', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Dierka ľavou a bác do obliny. Výlez už v pohode.', '4'),
    (boulder_id_var, 'Hlina', (SELECT id FROM public.grades WHERE font = '5C'), false, false, NULL, '5'),
    (boulder_id_var, 'H-linka', (SELECT id FROM public.grades WHERE font = '5C'), false, false, NULL, '5a'),
    (boulder_id_var, '???', (SELECT id FROM public.grades WHERE font = '5B'), false, false, NULL, '6');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Hlina 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-39.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Hilda', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '7'),
    (boulder_id_var, 'Nasadni', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, NULL, '8'),
    (boulder_id_var, 'Stropodíl', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Iba stropom bez vane na hrane.', '9');

-- ===== Zadný sektor - Psychadelik =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Psychadelik')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Psychadelik', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-40.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Tik', (SELECT id FROM public.grades WHERE font = '5B'), false, false, NULL, '1'),
    (boulder_id_var, 'Neurotik', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Lištová klasika.', '2'),
    (boulder_id_var, 'Psychadelik', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Lezte isto keď je hmlisto!', '3'),
    (boulder_id_var, 'Workoholik', (SELECT id FROM public.grades WHERE font = '6B+'), false, false, 'Hajbólek.', '4'),
    (boulder_id_var, 'Bobálky', (SELECT id FROM public.grades WHERE font = '5C'), false, false, NULL, '5'),
    (boulder_id_var, 'Hranostaj', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Po hrane. Dva varianty. Výlez doprava 6C.', '6');

-- ===== Zadný sektor - Plutvička =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Plutvička')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Plutvička', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-41.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Bez názvu (1)', (SELECT id FROM public.grades WHERE font = '6B'), true, false, NULL, '1'),
    (boulder_id_var, 'Loktúv kútek', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Z líšt hore.', '2'),
    (boulder_id_var, 'Bez názvu (2a)', (SELECT id FROM public.grades WHERE font = '5C'), false, false, NULL, '2a'),
    (boulder_id_var, 'Stereo plutvička', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Oblým kútom do diery. Pozor, ďalej je výlez v nekvalitnej skale.', '3'),
    (boulder_id_var, 'Hra-Na', (SELECT id FROM public.grades WHERE font = '6C+'), false, false, 'Začiatok z oblín. Stúpa sa iba masív hrany a po nej na vrchol.', '4'),
    (boulder_id_var, 'Freesolo', (SELECT id FROM public.grades WHERE font = '6A'), false, false, 'Do velˇkých dier a doľava na hranu. Borháky nechytať! :)', '5'),
    (boulder_id_var, 'Evergreen', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Päťková výzva.', '6'),
    (boulder_id_var, 'Bez názvu (7)', (SELECT id FROM public.grades WHERE font = '6A'), false, false, NULL, '7');

-- ===== Zadný sektor - Lapač =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Lapač')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lapač', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-42.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Posledný mokasín', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'Zo sedu iba jednou stienkou a hranou. Špárka vľavo sa nechytá.', '1'),
    (boulder_id_var, 'Lapač slov', (SELECT id FROM public.grades WHERE font = '7B'), true, false, NULL, '2'),
    (boulder_id_var, 'Kajnšmetke', (SELECT id FROM public.grades WHERE font = '6B'), true, false, NULL, '3');

-- ===== Zadný sektor - Kapurkova =====
INSERT INTO public.sectors (area_id, name)
VALUES (area_id_var, 'Zadný sektor - Kapurkova')
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kapurkova', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/chtelnica-43.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Reťazová reakcia', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Zo sedu v zdadu na rampe. Bez pravej steny. Skvostík.', '1'),
    (boulder_id_var, 'Kapurkova', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Top Chtelnické 6A-čko.', '2');

END $$;
