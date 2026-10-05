-- Medené Hámre: presné súradnice sektorov
UPDATE public.sectors s
SET lat = v.lat, lon = v.lon
FROM (VALUES
    ('Sedembolestný', 48.2595219, 17.1176758),
    ('Moonboard',     48.2622233, 17.1170772),
    ('Pod Medeným',   48.2643978, 17.1180422),
    ('Prízemie',      48.2638375, 17.1179925),
    ('Poschodie',     48.2672967, 17.1197742),
    ('Vlna',          48.2689686, 17.1196642)
) AS v(name, lat, lon)
WHERE s.name = v.name
  AND s.area_id = (SELECT id FROM public.areas WHERE name = 'Medené Hámre');
