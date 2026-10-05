-- Seed: Medené Hámre → sektor Sedembolestný (zdroj: bouldertopo boulder.sk, 2024)
-- Súradnice sú zatiaľ stred lomu (oma.sk), nie presná poloha sektoru.
DO $$
DECLARE
area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
    storage_url text := 'https://vdqnmfauxhzfcxrjvsre.supabase.co/storage/v1/object/public/boulder-photos/';
    approach text := 'Prvý sektor po príchode z Borinky, po ľavej strane. Parkovanie oproti malej vodárničke, chodníčkom ku schodisku a k jaskynke.';
    stigmy_tail text := ' L 39.90% 62.00% L 52.60% 59.20% L 63.80% 56.00% L 75.00% 51.30% L 82.90% 45.90% L 88.50% 38.50% L 89.60% 29.90% L 88.50% 20.30% L 85.30% 11.80% L 81.30% 5.30% L 78.90% 2.60%';
BEGIN
INSERT INTO public.areas (name, description, lat, lon)
VALUES ('Medené Hámre', 'Vápencový lom Prepadlé pri Borinke (Malé Karpaty).', 48.2639085, 17.1175495)
    RETURNING id INTO area_id_var;

INSERT INTO public.sectors (area_id, name, lat, lon)
VALUES (area_id_var, 'Sedembolestný', 48.2639085, 17.1175495)
    RETURNING id INTO sector_id_var;

-- Kameň 1: jaskynka
INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Jaskynka', approach, storage_url || 'medene-hamre-sedembolestny-jaskynka.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, description, start_x, start_y, top_x, top_y, topo_path)
VALUES (boulder_id_var, 'Ježiškov spacáčik', (SELECT id FROM public.grades WHERE font = '7A+'), true,
        '7A+/B. SD, nástup hlbšie v jaskyni z dvoch označených chytov a doľava až do madla, nestúpa sa múrik vľavo pod previsom.',
        68.3, 71.7, 30.0, 14.4,
        'M 68.30% 70.00% L 66.50% 62.40% L 60.00% 58.00% L 52.00% 52.00% L 45.00% 44.00% L 40.00% 36.00% L 36.50% 26.70% L 33.00% 18.70%');

-- Kameň 2: previs
INSERT INTO public.boulders (sector_id, name, description, image_url)
VALUES (sector_id_var, 'Previs', approach, storage_url || 'medene-hamre-sedembolestny-previs.jpg')
    RETURNING id INTO boulder_id_var;

INSERT INTO public.climbs (boulder_id, name, grade_id, is_sit_start, description, start_x, start_y, top_x, top_y, topo_path)
VALUES
    (boulder_id_var, 'Stigmy', (SELECT id FROM public.grades WHERE font = '7A+'), true,
     'SD v madielku vľavo a pokračovať doprava po hrane previsu až do stienky a tou na vrchol.',
     10.5, 67.9, 78.9, 2.6,
     'M 10.50% 67.90% L 19.10% 66.70% L 28.70% 64.10%' || stigmy_tail),
    (boulder_id_var, 'Najsvetlejšia tma', (SELECT id FROM public.grades WHERE font = '7B+'), true,
     'SD, nástup ako Ježiškov spacáčik a z hrany previsu ďalej ako Stigmy.',
     25.8, 75.2, 78.9, 2.6,
     'M 25.80% 75.20% L 26.00% 69.40% L 28.40% 64.50%' || stigmy_tail);
END $$;
