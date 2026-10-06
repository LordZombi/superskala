-- Seed: Kolárka (Limbach) – jeden kameň, 15 línií. Zdroj: bouldertopo boulder.sk, update 5/2018.
-- Fotky sú výrezy z topa aj s nakreslenými líniami a písmenami; cesty bez vlastných čiar (topo_path NULL).
-- Oblasť ani sektor nemajú súradnice (topo ich neuvádza) – kým sa nedoplnia, Kolárka nie je na mape.
DO $$
DECLARE
area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
    storage_url text := 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/';
    red_line text := ' Chyty za červenou čiarou sa nepoužívajú (ani na nohy).';
BEGIN
INSERT INTO public.areas (name, description)
VALUES ('Kolárka', 'Kameň pri Limbachu na žltej turistickej značke zo Slnečného údolia smerom na Šenkárku, hneď vo svahu nad cestou po ľavej strane.')
    RETURNING id INTO area_id_var;

INSERT INTO public.sectors (area_id, name, description)
VALUES (area_id_var, 'Kolárka', 'V Limbachu odbočte na Slnečné údolie a pokračujte asfaltkou cca 3 km až k cyklistickému rázcestníku. Zaparkujte pri plastových smetiakoch a ďalej pešo po žltej značke, po 7 – 8 minútach dorazíte ku kameňu.')
    RETURNING id INTO sector_id_var;

-- Foto 1: a – e
INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kolárka 1', storage_url || 'kolarka-01.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, description, topo_number)
VALUES
    (boulder_id_var, 'Chochmes', (SELECT id FROM public.grades WHERE font = '6B'), true, 'SD, z dvoch chytov a dolez doľava platňou.', 'a'),
    (boulder_id_var, 'Rebríček', (SELECT id FROM public.grades WHERE font = '6B'), true, 'SD, z dvoch chytov a výlez priamo hore.', 'b'),
    (boulder_id_var, 'Prvé lásky', (SELECT id FROM public.grades WHERE font = '6B'), true, 'SD, z dvoch chytov a doprava do obliny, z nej dlhý krok doľava do madla.', 'c'),
    (boulder_id_var, 'Vtedy na východe', (SELECT id FROM public.grades WHERE font = '6B'), true, 'SD, z dvoch chytov a doprava do obliny, z nej doprava do madla.', 'd'),
    (boulder_id_var, 'Veľké problémy malého sveta', (SELECT id FROM public.grades WHERE font = '6C+'), false, 'Nástup z veľkej lišty z ľahu a priamo hore platňou.', 'e');

-- Foto 2: f – j
INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kolárka 2', storage_url || 'kolarka-02.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, description, topo_number)
VALUES
    (boulder_id_var, 'Novotvar', (SELECT id FROM public.grades WHERE font = '6C+'), true, 'SD v madle vpravo, traverzom doľava a dolez bouldrom Vtedy na východe.', 'f'),
    (boulder_id_var, 'Nové lásky', (SELECT id FROM public.grades WHERE font = '6C+'), true, 'SD v madle vpravo, traverzom doľava a dolez bouldrom Prvé lásky.', 'g'),
    (boulder_id_var, 'Rebríčisko', (SELECT id FROM public.grades WHERE font = '6C+'), true, 'SD v madle vpravo, traverzom doľava a dolez bouldrom Rebríček.', 'h'),
    (boulder_id_var, 'Pán Chochmes', (SELECT id FROM public.grades WHERE font = '6C+'), true, 'SD v madle vpravo, traverzom doľava a dolez bouldrom Chochmes.', 'i'),
    (boulder_id_var, 'Svetobežník', (SELECT id FROM public.grades WHERE font = '7B'), true, 'SD v madle vpravo, traverzom doľava až do nástupu bouldra Veľké problémy malého sveta a ním hore.', 'j');

-- Foto 3: k – o
INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Kolárka 3', storage_url || 'kolarka-03.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Dlhoprstí', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, z dvoch chytov a priamo hore do veľkej lišty a obliny, dolez ako Vtedy na východe.' || red_line, 'k'),
    (boulder_id_var, 'Strč prst skrz krk', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD v madle vpravo, traverzom doľava a dolez ako Dlhoprstí.' || red_line, 'l'),
    (boulder_id_var, 'Bál divožienok', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD, z dvoch chytov a priamo hore do veľkej lišty, z nej doprava do bočákov a výlez cez veľké madlo na hrane.' || red_line, 'm'),
    (boulder_id_var, 'Intimita', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'SD v madle vpravo, traverzom doľava a dolez ako Bál divožienok.' || red_line, 'n'),
    (boulder_id_var, 'Projekt', NULL, false, true, NULL, 'o');
END $$;
