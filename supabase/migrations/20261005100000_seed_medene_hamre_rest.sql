-- Seed: Medené Hámre – sektory Moonboard, Prízemie, Pod Medeným, Poschodie, Vlna
-- Zdroj: bouldertopo boulder.sk 2024. Fotky sú dočasné (z PDF), cesty bez čiar (topo_path NULL).
-- Súradnice sektorov sú zatiaľ stred lomu, nie presná poloha.

INSERT INTO public.grades (font, value) VALUES
    ('1', 10), ('3', 30), ('5A', 51), ('5B', 52), ('5C', 53)
ON CONFLICT (font) DO NOTHING;

DO $$
DECLARE
area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
BEGIN
SELECT id INTO STRICT area_id_var FROM public.areas WHERE name = 'Medené Hámre';

-- ===== Moonboard =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Moonboard', 48.2639085, 17.1175495)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Moonboard 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-001.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Listomor', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z veľkej police priamo po dobrých chytoch.'),
    (boulder_id_var, 'Puklinár', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, ako Listomor, ale odbočiť puklinou doprava a výlez za lianou.'),
    (boulder_id_var, 'Čiara', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'SD ako Listomor, doprava bouldrom One size too much a pokračovať trhlinou až do výlezu.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Moonboard 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-002.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Liana', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, z lišty a priamo hore.'),
    (boulder_id_var, 'One size fits all', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'SD, z lišty, doprava a priamo do hrany - bez veľkého madla vpravo.'),
    (boulder_id_var, 'One size too much', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, ako Listomor a nízky traverz do One size fits all.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Moonboard 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-003.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Obdobie sucha', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, z označených chytov, doľava až do výlezu Čiary.'),
    (boulder_id_var, 'Klimatická kríza', NULL, true, true, 'SD, ako Obdobie sucha a po lištách doprava hore.');

-- ===== Prízemie =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Prízemie', 48.2639085, 17.1175495)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Majka 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-005.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Majka', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, z veľkého chytu a priamo hore.'),
    (boulder_id_var, 'Kvašňák', (SELECT id FROM public.grades WHERE font = '3'), true, false, 'SD, z označených chytov a priamo hore.'),
    (boulder_id_var, 'Valko', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, z veľkého chytu mierne doľava hore, bez pravej hrany.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Majka 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-006.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Kompiš', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, ako Valko, ale pokračovať traverzom stienkou doľava bez hornej hrany až do výlezu Majky.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Majka 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-007.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Gurun', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, ako Majka, pokračovať doľava hore po lištách.'),
    (boulder_id_var, 'Majka z Gurunu', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, ako Majka, doľava cez lišty a obliny, výlez za ľavou hranou - s obmedzením podľa červenej čiary.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Majka 4', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-008.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Čabovce', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, zo spodnej lišty, silovými krokmi hore po hrane.'),
    (boulder_id_var, 'Václav Borovička', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, z lišty, priamo hore do hrany a ňou - bez spodných kameňov.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Majka 5', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-009.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Nadpozemská noha', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, z označených líšt, doľava do hrany a ňou.'),
    (boulder_id_var, 'Kto kráča po vode', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD ako Nadpozemská noha, doprava stienkou až do pravej hrany - bez použitia ľavej hrany.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Majka 6', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-010.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Bloody Mary', (SELECT id FROM public.grades WHERE font = '7A'), true, false, '7A/+. SD, nástup ako Čabovce, Majkou z Gurunu naopak s rovnakými obmedzeniami, výlez stienkou doprava.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Politik', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-018.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Ľavica', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z chytu a priamo hore.'),
    (boulder_id_var, 'Pravica', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, z lišty a priamo hore – bez pravej hrany.'),
    (boulder_id_var, 'Kadisvet', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z lišty, doprava do hrany a ňou.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-019.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Lokál Borec', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, z lišty a priamo hore až na vrchol.'),
    (boulder_id_var, 'Mravčí variant', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, doprava nahor, bez veľkých bočákov z Borca.'),
    (boulder_id_var, 'Mravčie vojny', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, doprava do lišty a stredom stienky nahor – bez veľkých bočákov z Borca.'),
    (boulder_id_var, 'Blízke diaľavy', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'SD, z obliny a priamo hore bez hrán.'),
    (boulder_id_var, 'Kamarát Ostriež', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z hrany a po nej až na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-020.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Slimačím tempom', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, zo šikmej lišty priamo hore bez veľkých chytov vľavo.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-021.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Fleet Street', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, ľavou malý bočák a pravou nástupový chyt z Borca, po hrane a priamo mantlom.'),
    (boulder_id_var, 'Electric Avenue', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'SD ako Fleet, pokračovať ďalej doľava Elektrikom naopak až za roh a na vrchol. Variant Fleet Street.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 4', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-022.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Nadrobno', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD, ako Mravčie vojny, nízkym traverzom ďalej doprava do hrany Ostrieža a ňou.'),
    (boulder_id_var, 'Haliere', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD ako Ostriež a ďalej doľava nízkym traverzom do Borca a ním. Variant Nadrobno.'),
    (boulder_id_var, 'Numizmatik', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Ako Haliere, ale z Borca pokračovať po hrane doľava Elektrikom naopak, obliezť hranu a vyliezť úplne na konci ako Prierez kamennej tvorby. Variant Nadrobno.'),
    (boulder_id_var, 'Hoď si mincou', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'SD ako Elektrik a ďalej po hrane až do Lokál Borca, ním poklesnúť a doliezť ako Nadrobno. Variant Nadrobno.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 5', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-023.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Tŕne pichľavého svedomia', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, z police doprava na vrchol.'),
    (boulder_id_var, 'Prierez kamennej tvorby', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z veľkého bočáku, ďalej do hrany a ňou na vrchol.'),
    (boulder_id_var, 'Elektrik', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, z dvoch malých líšt, do hrany a ňou doprava, koniec mantlom.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 6', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-024.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Banálna story', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, z poličky, priamo hore do hrany a mantel.'),
    (boulder_id_var, 'Storyline', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, ako Story a pokračovať doprava po hrane až na vrchol.'),
    (boulder_id_var, 'Linestory', (SELECT id FROM public.grades WHERE font = '6B'), true, false, '6B/+. SD, pokračovať ďalej doľava po hrane až za roh a na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 7', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-025.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Sweeniar Todd', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Nástup z dvoch malých chytov a na hranu – nenaskakovať! SD je projekt.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kocka 8', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-026.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Mantelko', (SELECT id FROM public.grades WHERE font = '3'), true, false, 'SD, z oblej hrany a priamo hore bez pravej hrany.'),
    (boulder_id_var, 'Tupé tŕne', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, pokračovať doprava po hrane a ďalej ako Tŕne.'),
    (boulder_id_var, 'Elektrické tŕne ostrieža', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD ako Tupé tŕne, pokračovať doprava po hrane, pokles do Elektrika a ďalej doprava až úplne na koniec do špicu Ostrieža. Variant Tupé tŕne.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Monohran 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-027.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Zážitky zo šachty', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD na kameni, ľavou tupý spoďák a pravou bočák.'),
    (boulder_id_var, 'Paternoster', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, z dvoch líšt stienkou hore.'),
    (boulder_id_var, 'Výťah opäť nechodí', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, pravou hrana a ľavou čokoľvek.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Monohran 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-028.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Pre veteránov', (SELECT id FROM public.grades WHERE font = '3'), true, false, 'SD, obojručne na hrane a po nej až na vrchol.'),
    (boulder_id_var, 'Strom je láva', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, traverzom doprava do Elevátorka a ním.'),
    (boulder_id_var, 'Elevátorko', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z bočákovej lišty a priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Monohran 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-029.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Akrofóbia', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD na kameni, nástup v dobrej lište a priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Monohran 4', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-030.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Prevádzková štúdia', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, nástup na oblej hrane pred vyvýšením.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Infantil', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-031.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Infantilko', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD vpravo na dobrej polici, traverzom okolo kameňa, výlez úplne naľavo.');

-- ===== Pod Medeným =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Pod Medeným', 48.2639085, 17.1175495)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Pod Medeným 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-011.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Nechaj sa viesť', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, z bočáku, do lišty, ďalej doľava a hore po hrane.'),
    (boulder_id_var, 'From Dirt Grows the Trees', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, priamo hore kompaktnou stienkou - neberie sa veľký bočák vpravo nad nástupom.'),
    (boulder_id_var, 'Return of the Sleep Waker', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, do bočáku, ďalej do pravej hrany a ňou.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Pod Medeným 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-012.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Čó ja?', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, z bočáku, do lišty a doľava po oblinách - vľavo hore sa neberie pravá hrana a ide sa stienkou.'),
    (boulder_id_var, 'Honey báger', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, z políc a priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Pod Medeným 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-013.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Nech sa ľúbi', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, z označených chytov a po hrane na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Pod Medeným 4', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-014.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Špinavá krása', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, ako Nech sa ľúbi a dolez From Dirt...'),
    (boulder_id_var, 'Nechaj sa ľúbiť', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, ako Nech sa ľúbi a dolez ako Nechaj sa viesť.'),
    (boulder_id_var, 'Len ty', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'SD, ako Nechaj sa ľúbiť, ale dolez bouldrom Čo já? Variant Nechaj sa ľúbiť.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Pod Medeným 5', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-015.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Zľava', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, z obliny, doprava do hrany a ňou.'),
    (boulder_id_var, 'Zľava na prekvapenia', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, z obliny, pokračovať poklesom do lišty a dolez ako From Dirt...');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Pod Medeným 6', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-016.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Nečakaný návrat', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'SD, z obliny, popod hranu poklesom až do Return a ním – obmedzenie červenou.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Amerika', 'Kúsok vyššie vo svahu, boulder je orientovaný z opačnej strany.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-017.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Amerika v noci', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD v kúte, z bočáka a stisku, doľava cez bočáky do hrany a hore.');

-- ===== Poschodie =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Poschodie', 48.2639085, 17.1175495)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava 1', 'Posprejovaná kocka.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-033.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Devina', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, z poličky, doľava na hranu a po nej.'),
    (boulder_id_var, 'Štvorka', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, priamo hore.'),
    (boulder_id_var, 'Zlatá horúčka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, mierne doprava, do špicu a výlez mantlom zľava.'),
    (boulder_id_var, 'Biela zlatá horúčka', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, doprava popod previs, do pravej hrany.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava 2', 'Posprejovaná kocka.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-034.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Zahájenie', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, z lišty, doprava stienkou bez hrán.'),
    (boulder_id_var, 'Sivá mágia', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, doľava po hrane a výlez po rampe stienkou.'),
    (boulder_id_var, 'Sivobiela mágia', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, doľava po hrane až na vrchol.'),
    (boulder_id_var, 'Biela mágia', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, doľava po hrane, ďalej popod previs do ľavej hrany, výlez zľava.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava 3', 'Posprejovaná kocka.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-035.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Hlavolam', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'SD, ľavou spoďák a pravou oblina na hrane, popod previs doľava, bez ľavej hrany, za roh a po hrane na vrchol kocky.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava 4', 'Posprejovaná kocka.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-036.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Suchár', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, z madielka, po hrane až na vrchol kocky.'),
    (boulder_id_var, 'Suchá voda', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, doľava po hrane.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava 5', 'Posprejovaná kocka.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-037.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Plytká bolesť', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, mierne doprava stienkou po lištách.'),
    (boulder_id_var, 'Plytká radosť', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, mierne doľava hore po dobrých chytoch.'),
    (boulder_id_var, 'Modrá karikatúra', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, doľava po hrane.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava 6', 'Posprejovaná kocka.', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-038.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Potápač', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, z nízkeho chytu, do hrany a po nej.'),
    (boulder_id_var, 'Pravý potápač', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, do hrany a výlez bouldrom Plytká radosť.'),
    (boulder_id_var, 'Hlboká bolesť', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, doprava po hrane, výlez bouldrom Plytká bolesť.'),
    (boulder_id_var, 'Voda na suchu', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, doprava po hrane až na vrchol kocky.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Hlava – kombinácie', 'Posprejovaná kocka. Kombinácie cez viac stien kameňa.', NULL)
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Kocky sú hodené', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'SD z madielka ako Suchár, doprava po hrane, potom popod previs s výlezom doprava bez hrotu poličkou ako Sivá mágia.'),
    (boulder_id_var, 'Kocky sú zhodené', (SELECT id FROM public.grades WHERE font = '7A'), true, false, '7A/+. SD, presne ako Kocky sú hodené, ale pokračovať medvedičkou previsom s výlezom doprava.'),
    (boulder_id_var, 'Prekročenie Rubikonu', (SELECT id FROM public.grades WHERE font = '7B'), true, false, '7B/7B+. SD v lište ako Zahájanie, ďalej traverz po hrane okolo kameňa, na konci s mantlom doľava do platne.'),
    (boulder_id_var, 'Na hrane dneška', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD ako Voda na suchu, ale pokračovať traverzom ďalej po hrane až do hrotu, výlez doprava.'),
    (boulder_id_var, 'Víťaz derie všetko', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'SD ako Voda na suchu a dolez bouldrom Kocky sú hodené.'),
    (boulder_id_var, 'Perpetuo', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'SD v lište ako Zahájanie, doľava popod previs a ďalej ako Prekročenie Rubikonu.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Kornútok', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-039.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Kornútok', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, z označených chytov priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Perinka 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-040.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Paplónik', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, ľavou hrana a pravou lišta, priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Perinka 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-041.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Vankúšik', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, z chytu, priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Perinka 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-042.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Perinka', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z označených chytov, priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Gilotína 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-043.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Gilotína', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, priamo hore bez diery vpravo.'),
    (boulder_id_var, 'Láskobrána', (SELECT id FROM public.grades WHERE font = '5A'), false, false, 'Zo stoja, platňou priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Gilotína 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-044.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Láskobrána SD', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, ľavou diera a pravou bočák, priamo hore.'),
    (boulder_id_var, 'Madame Déficit', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'SD, doľava, traverzom do Gilotíny.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Gilotína 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-045.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Mária Antoinetta', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, doprava do Láskobrány.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Nová doba 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-046.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Stará novina', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, z obliny, po hrane až na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Nová doba 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-047.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Nová doba', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, ľavou hrana a pravou veľký bočák, do hrany a ňou doprava na vrchol.'),
    (boulder_id_var, 'Old School', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z police, hore po madlách.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Suťovisko', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-048.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Suťovec', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, z hrany, doľava až na vrchol.'),
    (boulder_id_var, 'Nesúť ho', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, priamo hore mantlom, bez ľavej hrany.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Raptor 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-049.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Ranger', (SELECT id FROM public.grades WHERE font = '5C'), false, false, 'Zo stoja, z výrazného chytu, po hrane až na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Raptor 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-050.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Raptor', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'SD, ľavou hrana a pravou spoďák, priamo hore.'),
    (boulder_id_var, 'Velociraptor', (SELECT id FROM public.grades WHERE font = '6B+'), true, false, 'SD, spoďák a malá lišta, po hrane až na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Farmatraverz', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-051.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Dojímavo', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, doprava po hrane a v strede mantel.'),
    (boulder_id_var, 'Doják', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, doprava po hrane až na koniec.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Črepiny 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-052.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Lombardér', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD, ľavou dierka a pravou bočák, priamo hore aj s ľavou hranou, označený chyt sa neberie.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Črepiny 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-053.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Lombarber', (SELECT id FROM public.grades WHERE font = '7B'), true, false, '7B/+. SD, ako Lombardér, ďalej doľava bez hornej hrany, výlez stienkou vľavo.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Črepiny 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-054.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Barber', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, ľavou nízky spoďák a pravou bočák, stienkou doľava.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Črepiny 4', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-055.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Sivá eminencia', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'SD, obojručne z hrany, priamo hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Črepiny 5', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-056.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Črep', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'SD, z lišty, priamo hore.'),
    (boulder_id_var, 'Chujko Putin', (SELECT id FROM public.grades WHERE font = '6B'), false, false, 'Zo stoja, obojručne staticky z bočáku, stienkou doprava bez ľavej hrany.'),
    (boulder_id_var, 'Superslab', (SELECT id FROM public.grades WHERE font = '6A+'), false, false, 'Stienkou priamo hore bez hrán.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Črepiny 6', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-057.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Črepiny', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'SD, z lišty, bez ľavej hrany, do bouldra Chujko Putin a ním hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Obliezka 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-058.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Trestuhodná obliezka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, v polici úplne vľavo, doprava a obliezť kameň až na vrchol.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Obliezka 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-059.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Preliezkavo', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, z chytu na hrane, priamo hore mantlom.'),
    (boulder_id_var, 'Rozliezkavo', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, doprava po hrane.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Obliezka 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-060.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Reverzík', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, z chytu v stienke, doľava do hrany a reverzom do výlezu Preliezkava.'),
    (boulder_id_var, 'Direktík', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, priamo hore.');

-- ===== Vlna =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Vlna', 48.2639085, 17.1175495)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Vlna 1', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-062.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Spenené mliečko', (SELECT id FROM public.grades WHERE font = '1'), false, false, 'Položenou stienkou bez hrán.'),
    (boulder_id_var, 'Doparoma', (SELECT id FROM public.grades WHERE font = '5A'), true, false, 'SD, z veľkého chytu obojručne a po hrane hore.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Vlna 2', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-063.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Ľahké ruky', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, z lišty, výlez doprava aj s hranou.'),
    (boulder_id_var, 'Ťažké nohy', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'SD, doľava, do mantla a výlez aj s ľavou hranou.'),
    (boulder_id_var, 'Naháňačka zážitkov', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, doľava a výlez ako Geometria.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Vlna 3', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-064.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Vlna', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'SD, čokoľvek na položenom a výlez priamo bez použita hrán.'),
    (boulder_id_var, 'Kmit', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'SD, ako Vlna, ale výlez aj s ľavou hranou.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Vlna 4', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-065.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Geometria pohybu', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, obojručne na hrane a mierne doľava až na vrchol.'),
    (boulder_id_var, 'Geometria ohybu', (SELECT id FROM public.grades WHERE font = '5B'), true, false, 'SD, doprava po hrane a výlez ako Ľahké ruky.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Vlna 5', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-066.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Ostrá snaha', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, z dierky a lišty, doľava do hrany a ňou.'),
    (boulder_id_var, 'Takmer skvelé', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, priamo stienkou hore.'),
    (boulder_id_var, 'Nevynechaj radosť', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, stienkou doprava, po hrane a výlez ako Ľahké ruky.');

INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Vlna 6', NULL, 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/medene-hamre-067.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description)
VALUES
    (boulder_id_var, 'Moai', (SELECT id FROM public.grades WHERE font = '4'), true, false, 'SD, z lišty, priamo hore bez hrán.'),
    (boulder_id_var, 'Tu sme skončili', (SELECT id FROM public.grades WHERE font = '5C'), true, false, 'SD, ako Doparoma a výlez ako Ľahké ruky bez obmedzení.');

END $$;
