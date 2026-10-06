-- Kolárka: súradnice kameňa (48.3181786N, 17.2108608E).
-- Je to jediný kameň, preto ten istý bod dostane oblasť, sektor aj všetky jeho fotky (bouldre).
UPDATE public.areas SET lat = 48.3181786, lon = 17.2108608 WHERE name = 'Kolárka';

UPDATE public.sectors
SET lat = 48.3181786, lon = 17.2108608
WHERE area_id = (SELECT id FROM public.areas WHERE name = 'Kolárka');

UPDATE public.boulders
SET lat = 48.3181786, lon = 17.2108608
WHERE sector_id IN (
    SELECT s.id
    FROM public.sectors s
    JOIN public.areas a ON a.id = s.area_id
    WHERE a.name = 'Kolárka'
);
