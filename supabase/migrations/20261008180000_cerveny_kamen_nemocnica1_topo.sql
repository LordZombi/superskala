-- Červený Kameň – Hrad, Predný sektor, Nemocnica 1: čiary ciest 4a–4g ako topo_path a fotka bez čiar zo samotného topa.
-- Fotka cerveny-kamen-48-clean.jpg je nový výrez z cerveny-kamen-2020.pdf (str. 29) bez nápisu „4. Nemocnica“ a s vymazanými
-- nakreslenými čiarami, číslami a krížikmi; treba ju pred `supabase db push` nahrať do bucketu boulder-photos.
-- Súradnice sú v % tohto nového výrezu (nie pôvodnej fotky 48), preto sa mení aj image_url. Čiary sú trasované od oka, doladiť v editore.
-- Nekrológ a Ultrazvuk nemajú v tope číslo ani čiaru, ostávajú bez topo_path.
DO $$
DECLARE
    boulder_id_var uuid;
BEGIN
SELECT b.id INTO STRICT boulder_id_var
FROM public.boulders b
    JOIN public.sectors s ON s.id = b.sector_id
    JOIN public.areas a ON a.id = s.area_id
WHERE a.name = 'Červený Kameň' AND s.name = 'Hrad - Predný sektor' AND b.name = 'Nemocnica 1';

UPDATE public.boulders
SET image_url = 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/cerveny-kamen-48-clean.jpg'
WHERE id = boulder_id_var;

UPDATE public.climbs c
SET start_x = v.start_x, start_y = v.start_y, top_x = v.top_x, top_y = v.top_y, topo_path = v.topo_path
FROM (VALUES
    ('4a', 35.4, 91.7, 44.7, 5.0, 'M 35.45% 91.67% L 37.30% 82.22% L 35.98% 71.11% L 35.45% 60.00% L 35.05% 47.78% L 34.66% 36.67% L 36.38% 28.89% L 39.68% 22.22% L 42.59% 13.33% L 44.71% 5.00%'),
    ('4b', 50.9, 93.1, 47.0, 4.4, 'M 50.93% 93.11% L 52.91% 86.67% L 54.89% 77.78% L 56.22% 66.67% L 55.56% 57.78% L 54.89% 50.00% L 50.93% 46.67% L 43.65% 42.22% L 37.70% 37.78% L 37.30% 35.56% L 38.62% 28.89% L 41.01% 18.89% L 44.31% 11.11% L 46.96% 4.44%'),
    ('4c', 52.2, 93.9, 80.3, 29.8, 'M 52.25% 93.89% L 55.56% 87.78% L 58.86% 81.11% L 61.51% 73.33% L 64.81% 66.67% L 69.44% 57.78% L 72.49% 50.00% L 74.74% 42.22% L 76.72% 35.56% L 80.29% 29.78%'),
    ('4d', 51.6, 92.8, 88.4, 57.6, 'M 51.59% 92.78% L 53.17% 86.67% L 55.29% 80.00% L 58.20% 75.56% L 63.49% 72.22% L 68.78% 70.56% L 73.41% 69.11% L 79.37% 64.44% L 84.66% 60.56% L 88.36% 57.56%'),
    ('4e', 71.4, 80.2, 65.7, 17.8, 'M 71.43% 80.22% L 68.78% 72.22% L 64.15% 67.78% L 59.52% 63.33% L 57.54% 58.89% L 57.14% 52.22% L 58.20% 46.67% L 60.19% 36.67% L 61.11% 28.89% L 63.49% 22.22% L 65.74% 17.78%'),
    ('4f', 72.1, 79.8, 88.0, 58.3, 'M 72.09% 79.78% L 75.40% 75.56% L 79.37% 68.89% L 83.99% 62.78% L 87.96% 58.33%'),
    ('4g', 72.8, 76.7, 78.4, 27.2, 'M 72.75% 76.67% L 72.49% 68.89% L 68.78% 66.11% L 66.80% 62.22% L 67.20% 57.78% L 69.05% 55.00% L 70.77% 50.00% L 72.49% 42.22% L 75.40% 33.33% L 78.44% 27.22%')
) AS v(topo_number, start_x, start_y, top_x, top_y, topo_path)
WHERE c.boulder_id = boulder_id_var AND c.topo_number = v.topo_number;

END $$;
