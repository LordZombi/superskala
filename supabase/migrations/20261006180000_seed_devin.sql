-- Seed: Devín – sektory Jaskynka (Lucka + Jaskynka), Vyhliadka, Bitúnok. Zdroj: devin.pdf.
-- Fotky sú výrezy z topa aj s nakreslenými líniami; cesty bez vlastných čiar (topo_path NULL).
-- Všetky sektory majú zatiaľ rovnaké súradnice (jeden bod z mapy.cz).
-- Cesty s lanom (UIAA / francúzska klasifikácia) sú bez grade_id, pôvodná klasifikácia je v popise.
DO $$
DECLARE
area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
BEGIN
INSERT INTO public.areas (name, description, lat, lon)
VALUES ('Devín', 'Vápencové skaly pod hradom Devín nad Dunajom: Jaskynka, Vyhliadka a Bitúnok.', 48.1740511, 16.9766317)
    RETURNING id INTO area_id_var;

-- ===== Jaskynka =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Jaskynka', 48.1740511, 16.9766317)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Lucka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-01.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Zverokruh', (SELECT id FROM public.grades WHERE font = '8A'), false, false, 'Začiatok pri asfaltke (jabloň), traverz celého kameňa.', '7'),
    (boulder_id_var, 'Dunaj direkt', NULL, false, false, 'Začiatok v madle N a rovno hore do zlaňáku X. Cesta s lanom, v tope klasifikácia 10 (nie bouldrová stupnica).', '8'),
    (boulder_id_var, 'Pozdrav mesiacu', (SELECT id FROM public.grades WHERE font = '7C+'), false, false, 'Začiatok v A, traverz ako Zverokruh, dolez cez 19-tku. Obtiažnosť v tope je neistá (?).', '11'),
    (boulder_id_var, 'Príliš neskorý zber', NULL, true, false, 'Začiatok B, potom ako 42 a dolez Dunajom do X. Cesta s lanom, v tope klasifikácia 10- (nie bouldrová stupnica).', '17'),
    (boulder_id_var, 'Volanie Dunaja', NULL, false, false, 'Začiatok A, traverz do N a výlez Dunajom do X. Cesta s lanom, v tope klasifikácia 10- ? (nie bouldrová stupnica).', '18'),
    (boulder_id_var, 'Dunaj', NULL, false, false, 'Začiatok N. Cesta s lanom, v tope klasifikácia 9+/10- (nie bouldrová stupnica).', '20'),
    (boulder_id_var, 'Drsný chlieb', NULL, true, false, 'Viď nákres Lucka. Cesta s lanom, v tope klasifikácia 10- (nie bouldrová stupnica).', '24'),
    (boulder_id_var, 'Projekt od lezenia k vode', NULL, false, true, 'Po cvaknutí druhého z Dunaja šikmo doprava a dolez Moravou. V tope 9+ ?.', '24b'),
    (boulder_id_var, 'Volanie Mora', NULL, false, false, 'Začiatok A, traverz do N a Ľubošovým ojebom dolez do Y. Cesta s lanom, v tope klasifikácia 9+/10- (nie bouldrová stupnica).', '25'),
    (boulder_id_var, 'Chlieb SD high', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Začiatok O do Q a hore do T (s lanom SD 9-/9, zo stoja cca 8+).', '28'),
    (boulder_id_var, 'Morava SD', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, '7A+/B (9/9+). Začiatok B a hore ako 30 do Y (boulder končí v oblom krídle S).', '29'),
    (boulder_id_var, 'Morava', NULL, false, false, 'Začiatok B, ale zo stoja, a hore pilierom do Y. Cesta s lanom, v tope klasifikácia 9 (nie bouldrová stupnica).', '30'),
    (boulder_id_var, 'Morava light', NULL, false, false, 'Začiatok N ako 36 a dolez 30 do Y. Cesta s lanom, v tope klasifikácia 9-/9 (nie bouldrová stupnica).', '31'),
    (boulder_id_var, 'Chlieb SD low', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, 'Začiatok O, koniec v Q.', '32'),
    (boulder_id_var, 'Serpentín SD high', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Začiatok B do Q a koniec v T (s lanom asi 8+/9-).', '33'),
    (boulder_id_var, 'Diagonál', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Začiatok B, koniec v Q.', '35'),
    (boulder_id_var, 'Ľubošov ojeb', (SELECT id FROM public.grades WHERE font = '6C+'), true, false, 'Začiatok N, koniec v S.', '36'),
    (boulder_id_var, 'Krížová cesta', NULL, true, false, 'Začiatok C, koniec v X. Cesta s lanom, v tope klasifikácia 8a (nie bouldrová stupnica).', '42'),
    (boulder_id_var, 'Oblinác', NULL, false, false, 'Začiatok P, hore trochu lámavé a morálové. Cesta s lanom, v tope klasifikácia 6a+ (nie bouldrová stupnica).', '43');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Jaskynka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-02.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Svetlo hviezd v latríne', (SELECT id FROM public.grades WHERE font = '8A'), false, false, 'Začiatok G a koniec v H. Obtiažnosť v tope je neistá (?).', '6'),
    (boulder_id_var, 'Klada', (SELECT id FROM public.grades WHERE font = '7C+'), false, false, '7C+/8A ?. Začiatok v B a dolez v K.', '10'),
    (boulder_id_var, 'Panvové dno direkt', (SELECT id FROM public.grades WHERE font = '7C+'), false, false, 'Začiatok v E, koniec v H (lezie sa direkt, nepoužíva sa kapsa na lavačku). Obtiažnosť v tope je neistá (?).', '12'),
    (boulder_id_var, 'Amulet SD', (SELECT id FROM public.grades WHERE font = '7C'), true, false, '7C/C+ ?. Začiatok G, koniec J (trochu ľahšie, keď sa začne v F).', '13'),
    (boulder_id_var, 'Kukulienka', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Začiatok M, koniec H (skrátená verzia Snívača). Obtiažnosť v tope je neistá (?).', '14'),
    (boulder_id_var, 'Kvantovit', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Začiatok B a direkt Moravou bez veľkého bočáku na lavačku.', '15'),
    (boulder_id_var, 'Kvantový mechanik', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Začiatok B rovnako ako Klada, dolez 27-čkou do H. Obtiažnosť v tope je neistá (?).', '16'),
    (boulder_id_var, 'Obušok zabudnutia', (SELECT id FROM public.grades WHERE font = '7C'), false, false, 'Začiatok C, koniec H (bez šikového bočáku z 27-čky, s ním 7B).', '19'),
    (boulder_id_var, 'Amulet', (SELECT id FROM public.grades WHERE font = '7B+'), false, false, '7B+ (9+/). Začiatok M, koniec J.', '21'),
    (boulder_id_var, 'Vstávanie z popola', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, '7B+ (9+/). Začiatok C, koniec ako Morava.', '22'),
    (boulder_id_var, 'Panvové dno', (SELECT id FROM public.grades WHERE font = '7B+'), false, false, 'Začiatok E, koniec H.', '23'),
    (boulder_id_var, 'Mimozemšťanka', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Začiatok E cez M, koniec K.', '26'),
    (boulder_id_var, 'Latrinátor', (SELECT id FROM public.grades WHERE font = '7B'), false, false, 'Začiatok D, koniec H. Klasika.', '27'),
    (boulder_id_var, 'Plazivé 7A', (SELECT id FROM public.grades WHERE font = '7A'), false, false, 'Začiatok G do M a dolez K.', '34'),
    (boulder_id_var, 'Madlo', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Začiatok F do M a dolez K.', '37'),
    (boulder_id_var, 'Zahrievač', (SELECT id FROM public.grades WHERE font = '6C'), false, false, 'Začiatok v madle úplne vpravo, traverz do M a dolez K.', '38'),
    (boulder_id_var, 'Pyramídka', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Začiatok F a dolez L do chytu pyramídkového tvaru a dolez.', '39'),
    (boulder_id_var, 'Oblinkár do pyramídky', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Začiatok tesne vľavo od G na pilierčeku a cez oblinu dolez L.', '40'),
    (boulder_id_var, 'Makadam', NULL, true, false, 'Začiatok G a hore sa spojí s L. Cesta s lanom, v tope klasifikácia 5b (nie bouldrová stupnica).', '41'),
    (boulder_id_var, 'Projekt najťažší', NULL, false, true, 'Začiatok G, traverz do N (viď Lucka) a Dunajom direkt do X. V tope 11- ?.', 'P1'),
    (boulder_id_var, 'Projekt (Jaskynka 2)', NULL, false, true, 'Začiatok G, pokračovanie ako 42 a dolez Dunajom do X. V tope 10+ ?.', 'P2'),
    (boulder_id_var, 'Projekt (Jaskynka 3)', NULL, false, true, 'Začiatok G, dolez Moravou 30 do Y. V tope 10+/11- ?.', 'P3'),
    (boulder_id_var, 'Zodiak (projekt)', NULL, false, true, 'Začiatok G a traverz do N a dolez cez Q 28-čkou. V tope 8A ?.', 'P4'),
    (boulder_id_var, 'Projekt Kladamulet', NULL, false, true, 'Začiatok B a koniec ako Amulet čiže J. V tope 8A+ ?.', 'P5'),
    (boulder_id_var, 'Projekt (Jaskynka 9)', NULL, false, true, 'Začiatok E a dolez ako Amulet, koniec v J. V tope 7C+/8A ?.', 'P9');

-- ===== Vyhliadka =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Vyhliadka', 48.1740511, 16.9766317)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vyhliadka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-03.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Zatiaľ bez názvu', (SELECT id FROM public.grades WHERE font = '4'), true, false, NULL, '1'),
    (boulder_id_var, 'Stehno', (SELECT id FROM public.grades WHERE font = '6A'), true, false, NULL, '2'),
    (boulder_id_var, 'Lehátko', (SELECT id FROM public.grades WHERE font = '6B'), true, false, NULL, '3'),
    (boulder_id_var, 'Mám v p... na lehátku', (SELECT id FROM public.grades WHERE font = '7A'), true, false, NULL, '4'),
    (boulder_id_var, 'Nemecký rebrík', (SELECT id FROM public.grades WHERE font = '5A'), true, false, NULL, '5'),
    (boulder_id_var, 'Vhĺbenie', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '6'),
    (boulder_id_var, 'Vyhliadka', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '7'),
    (boulder_id_var, 'Krtko-kot', (SELECT id FROM public.grades WHERE font = '7B'), false, false, NULL, '8'),
    (boulder_id_var, 'Krtko predĺženie', (SELECT id FROM public.grades WHERE font = '5B'), true, false, NULL, '9'),
    (boulder_id_var, 'Strosko-tanec', (SELECT id FROM public.grades WHERE font = '7B'), true, false, 'Začiatok čupiac v jaskynke s pohľadom na Dunaj.', '10'),
    (boulder_id_var, 'Krásavica nad Dunajom', (SELECT id FROM public.grades WHERE font = '6C'), true, false, 'Mega klasiker.', '11'),
    (boulder_id_var, 'Krásavica nad Dunajom zo stoja', (SELECT id FROM public.grades WHERE font = '6B+'), false, false, 'Zo stoja.', '12'),
    (boulder_id_var, 'Motorový čln', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, NULL, '13'),
    (boulder_id_var, 'Lodníkov učeň', (SELECT id FROM public.grades WHERE font = '7A+'), true, false, '7A+/B.', '14'),
    (boulder_id_var, 'Vlajková loď', (SELECT id FROM public.grades WHERE font = '7C'), true, false, 'Top boulder v BA. Pri nástupe sa nestúpa napravo od vhĺbenia a predskalie.', '15'),
    (boulder_id_var, 'Alfa sumec', (SELECT id FROM public.grades WHERE font = '7B+'), true, false, 'Začiatok ako Vlajková a výlez ako 10. a 13.', '16'),
    (boulder_id_var, 'Alfa sumec zo stoja', (SELECT id FROM public.grades WHERE font = '7A'), false, false, NULL, '17'),
    (boulder_id_var, 'Vlajková loď zo stoja', (SELECT id FROM public.grades WHERE font = '7B'), false, false, NULL, '18'),
    (boulder_id_var, 'Víza veľká', (SELECT id FROM public.grades WHERE font = '5'), false, false, 'Highball, ľahké, ale vzdušné, Dunaj pod nohami.', '19'),
    (boulder_id_var, 'Kto rozjebal betlehem', (SELECT id FROM public.grades WHERE font = '7C'), false, false, '7C/. Mám v p... a dolieza sa Betlehemom bez päty v najťažšom.', '20'),
    (boulder_id_var, 'Lodníkova míľa', (SELECT id FROM public.grades WHERE font = '7C'), false, false, '7C/+. Ako Lehátko a dolez Vlajkovou loďou.', '21');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Vyhliadka – východná stienka', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-04.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Betlehem', (SELECT id FROM public.grades WHERE font = '7B'), true, false, '7B/+. V origináli sa nepoužíva päta v Lehátku.', '22'),
    (boulder_id_var, 'Betlehem zo stoja', (SELECT id FROM public.grades WHERE font = '7A+'), false, false, NULL, '23');

-- ===== Bitúnok =====
INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Bitúnok', 48.1740511, 16.9766317)
    RETURNING id INTO sector_id_var;

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 1', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-05.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Pri hrad', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Nástup vo výraznejšom výmole, lezie sa s hranou aj chytmi v stienke, výlez cez hrot hore na kameň.', '1');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 2', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-06.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Podzemák tuzemák', (SELECT id FROM public.grades WHERE font = '5'), true, false, 'Začiatok výrazný bočák, stienkou a chytmi hore na hrot a výlez na kameň. Nestúpať predskalie v zemi.', '2');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 3', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-07.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vľavo hľaď', (SELECT id FROM public.grades WHERE font = '5'), true, false, 'Začiatok v polici, traverzom doľava a cez hranu na hrot, výlez na kameň.', '3');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 4', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-08.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vzducholoď', (SELECT id FROM public.grades WHERE font = '7A'), true, false, 'Nástup vo výraznom spoďáku v dolnej časti kameňa, kameňom na jeho vrchol a pokračovať na kameň nad ním, ním mantliť na vrchol. Lezie sa po dvoch kameňoch, kamene na bokoch sa nepoužívajú, stúpa sa iba predskalie pod nástupovým kameňom.', '4');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 5', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-09.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Vpravo hľaď', (SELECT id FROM public.grades WHERE font = '6A+'), true, false, 'Začiatok ako Vzducholoď v spoďáku, pokračuje sa kameňom doprava a prelieza sa na vedľajší kameň, ním doprava a na vrchol. Kamene vpravo od nástupu sa používajú, nepoužívajú sa predskalia pod druhým kameňom.', '5');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 6', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-10.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Budem prísť', (SELECT id FROM public.grades WHERE font = '5'), true, false, '5/6A. Začiatok v nízkej polici, lištami v praskline mierne doprava a na vrchol, stúpa sa všetko.', '6'),
    (boulder_id_var, 'Budem prísť pešo', (SELECT id FROM public.grades WHERE font = '6B'), true, false, 'Ako Budem prísť, ale nestúpajú sa predskalia a stienka za prasklinou.', '6A');

INSERT INTO public.boulders (sector_id, name, image_url)
VALUES (sector_id_var, 'Bitúnok 7', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-11.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, is_project, description, topo_number)
VALUES
    (boulder_id_var, 'Nedotknutá hovädzinka', (SELECT id FROM public.grades WHERE font = '6A'), true, false, 'Začiatok v dvoch bočákoch, nestúpajú sa výrazné predskalia, stienkou vľavo s použitím hrany na vrchol, lezie sa akoby po dvoch kameňoch.', '7');

END $$;
