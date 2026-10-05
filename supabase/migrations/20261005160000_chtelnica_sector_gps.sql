-- Chtelnica: odhad súradníc sektorov.
-- Predný sektor je rozložený pozdĺž pásu skál medzi dvoma známymi bodmi (SV koniec pásu z mapy.cz
-- a stena Pop podľa GPS cesty Šakty) v pomere podľa schémy v sprievodcovi – presnosť cca ±30 m.
-- Zadný sektor, Lapač a Kapurkova sú extrapolované ďalej tým istým smerom (vzdialenosti 200 m a 100 m
-- zo sprievodcu, medzera medzi sektormi odhadnutá) – presnosť cca ±100 m, treba overiť v teréne.
UPDATE public.sectors s
SET lat = v.lat, lon = v.lon
FROM (VALUES
    ('Predný sektor - Mega previs', 48.613054, 17.577686),
    ('Predný sektor - Enti', 48.612651, 17.577009),
    ('Predný sektor - Kanik west', 48.612357, 17.576515),
    ('Predný sektor - Kliešť a Pop', 48.611914, 17.57577),
    ('Predný sektor - 15 min', 48.61169, 17.575394),
    ('Predný sektor - Amfík', 48.611443, 17.574979),
    ('Predný sektor - Lord', 48.611245, 17.574646),
    ('Vane', 48.611652, 17.573909),
    ('Zadný sektor - Dungeon Master', 48.610704, 17.573737),
    ('Zadný sektor - Chlapeček z periferie', 48.61038, 17.573192),
    ('Zadný sektor - Blátotlačka', 48.609911, 17.572404),
    ('Zadný sektor - Hlina', 48.60952, 17.571748),
    ('Zadný sektor - Psychadelik', 48.609142, 17.571111),
    ('Zadný sektor - Plutvička', 48.608865, 17.570647),
    ('Zadný sektor - Lapač', 48.607664, 17.568627),
    ('Zadný sektor - Kapurkova', 48.607063, 17.567617)
) AS v(name, lat, lon)
WHERE s.name = v.name
  AND s.area_id = (SELECT id FROM public.areas WHERE name = 'Chtelnica');

UPDATE public.areas SET lat = 48.6119136, lon = 17.5757697 WHERE name = 'Chtelnica';
