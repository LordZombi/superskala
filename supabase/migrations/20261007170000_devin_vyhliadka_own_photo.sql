-- Devín – Vyhliadka: vlastná fotka (devin-12.jpg) s čiarami pre cesty 5–19.
-- Čiary sú prenesené od oka z topa v devin.pdf (iný uhol záberu) – sú to návrhy, doladiť v editore.
-- Najmenej isté sú 5–9 a 19 (horná časť je skrátená perspektívou a čiastočne za lístím).
-- Cesty 1–4, 20 a 21 začínajú v bode A mimo záberu, ostávajú preto na pôvodnom výreze z topa (kameň „Vyhliadka“).
-- Fotku devin-12.jpg treba pred `supabase db push` nahrať do bucketu boulder-photos.
DO $$
DECLARE
    old_boulder_id_var uuid;
    boulder_id_var uuid;
BEGIN
SELECT b.id INTO STRICT old_boulder_id_var
FROM public.boulders b
    JOIN public.sectors s ON s.id = b.sector_id
    JOIN public.areas a ON a.id = s.area_id
WHERE a.name = 'Devín' AND s.name = 'Vyhliadka' AND b.name = 'Vyhliadka';

INSERT INTO public.boulders (sector_id, name, image_url)
SELECT sector_id, 'Vyhliadka – pravá časť', 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/devin-12.jpg'
FROM public.boulders WHERE id = old_boulder_id_var
    RETURNING id INTO boulder_id_var;

UPDATE public.climbs c
SET boulder_id = boulder_id_var, start_x = v.start_x, start_y = v.start_y, top_x = v.top_x, top_y = v.top_y, topo_path = v.topo_path
FROM (VALUES
    ('5', 4, 43, 42, 25.5, 'M 4.00% 43.00% L 10.00% 38.50% L 20.00% 34.00% L 29.00% 30.00% L 36.00% 27.50% L 42.00% 25.50%'),
    ('6', 10, 62, 25, 19, 'M 10.00% 62.00% L 13.00% 49.00% L 17.00% 37.00% L 22.00% 27.00% L 25.00% 19.00%'),
    ('7', 25, 66, 31, 18, 'M 25.00% 66.00% L 27.00% 53.00% L 28.00% 41.00% L 28.50% 31.00% L 30.00% 24.00% L 31.00% 18.00%'),
    ('8', 35, 56, 42, 25.5, 'M 35.00% 56.00% L 38.00% 46.00% L 40.00% 36.00% L 42.00% 25.50%'),
    ('9', 35, 56, 40.5, 15, 'M 35.00% 56.00% L 38.00% 46.00% L 40.00% 36.00% L 42.00% 25.50% L 42.00% 20.00% L 40.50% 15.00%'),
    ('10', 36, 66, 75, 24.5, 'M 36.00% 66.00% L 44.00% 62.00% L 54.00% 60.00% L 62.00% 57.00% L 68.00% 50.00% L 71.00% 42.00% L 73.00% 34.00% L 75.00% 28.00% L 75.00% 24.50%'),
    ('11', 50, 77, 64, 26, 'M 50.00% 77.00% L 51.00% 62.00% L 55.00% 52.00% L 60.00% 42.00% L 65.00% 33.00% L 64.00% 26.00%'),
    ('12', 51, 62, 64, 26, 'M 51.00% 62.00% L 55.00% 52.00% L 60.00% 42.00% L 65.00% 33.00% L 64.00% 26.00%'),
    ('13', 50, 77, 75, 24.5, 'M 50.00% 77.00% L 57.00% 68.00% L 63.00% 60.00% L 67.00% 52.00% L 71.00% 42.00% L 73.00% 34.00% L 75.00% 28.00% L 75.00% 24.50%'),
    ('14', 57, 76, 64, 26, 'M 57.00% 76.00% L 60.00% 66.00% L 63.00% 54.00% L 65.00% 44.00% L 65.00% 33.00% L 64.00% 26.00%'),
    ('15', 57, 76, 79, 24, 'M 57.00% 76.00% L 63.00% 65.00% L 70.00% 52.00% L 80.00% 44.50% L 90.00% 41.50% L 97.00% 37.00% L 93.00% 31.00% L 85.00% 26.00% L 79.00% 24.00%'),
    ('16', 57, 76, 75, 24.5, 'M 57.00% 76.00% L 63.00% 65.00% L 68.00% 55.00% L 71.00% 42.00% L 73.00% 34.00% L 75.00% 28.00% L 75.00% 24.50%'),
    ('17', 70, 52, 75, 24.5, 'M 70.00% 52.00% L 71.00% 42.00% L 73.00% 34.00% L 75.00% 28.00% L 75.00% 24.50%'),
    ('18', 70, 52, 79, 24, 'M 70.00% 52.00% L 80.00% 44.50% L 90.00% 41.50% L 97.00% 37.00% L 93.00% 31.00% L 85.00% 26.00% L 79.00% 24.00%'),
    ('19', 64, 26, 58, 10.5, 'M 64.00% 26.00% L 66.00% 20.00% L 64.00% 14.00% L 58.00% 10.50%')
) AS v(topo_number, start_x, start_y, top_x, top_y, topo_path)
WHERE c.boulder_id = old_boulder_id_var AND c.topo_number = v.topo_number;

END $$;
