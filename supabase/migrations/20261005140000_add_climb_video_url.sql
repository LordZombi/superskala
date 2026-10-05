-- Odkaz na video prelezu (YouTube, Vimeo…) – v detaile cesty sa zobrazí ako odznak VIDEO
ALTER TABLE public.climbs
    ADD COLUMN IF NOT EXISTS video_url text;

-- Medené Hámre: videá zo sekcie VIDEOBETA v bouldertope boulder.sk 2024
UPDATE public.climbs c
SET video_url = v.video_url
FROM (VALUES
    ('Sedembolestný', 'Ježiškov spacáčik', 'https://www.youtube.com/watch?v=X89FHRE-PMg'),
    ('Sedembolestný', 'Stigmy', 'https://www.youtube.com/watch?v=H8av9mr4dGY'),
    ('Sedembolestný', 'Najsvetlejšia tma', 'https://www.youtube.com/watch?v=x8YI7R5KJwA'),
    ('Moonboard', 'One size too much', 'https://www.youtube.com/watch?v=zeclaQhMam8'),
    ('Moonboard', 'Čiara', 'https://www.youtube.com/watch?v=H5LrrK7i1RY'),
    ('Moonboard', 'Obdobie sucha', 'https://www.youtube.com/shorts/v28C7KWG-U0'),
    ('Prízemie', 'Majka z Gurunu', 'https://www.youtube.com/watch?v=6tioJiWTxJY'),
    ('Prízemie', 'Slimačím tempom', 'https://www.youtube.com/watch?v=-2Ii47a9tXE'),
    ('Prízemie', 'Fleet Street', 'https://www.youtube.com/watch?v=nahAHqWoctg'),
    ('Prízemie', 'Mravčie vojny', 'https://vimeo.com/88110457'),
    ('Prízemie', 'Blízke diaľavy', 'https://vimeo.com/88288703'),
    ('Poschodie', 'Sivá eminencia', 'https://www.youtube.com/watch?v=ySp1Gkd3q4M'),
    ('Poschodie', 'Črepiny', 'https://www.youtube.com/watch?v=BVZA770h1dg'),
    ('Poschodie', 'Lombardér', 'https://www.youtube.com/watch?v=uLWM4Q_hCbQ'),
    ('Poschodie', 'Voda na suchu', 'https://www.youtube.com/watch?v=5CSc9MY8NDs'),
    ('Poschodie', 'Kocky sú hodené', 'https://www.youtube.com/watch?v=ZlylcVTFG-k'),
    ('Poschodie', 'Hlavolam', 'https://www.youtube.com/watch?v=nxIjjQE5c1I'),
    ('Poschodie', 'Prekročenie Rubikonu', 'https://www.youtube.com/watch?v=XyqZIscwGtw'),
    ('Vlna', 'Vlna', 'https://www.youtube.com/watch?v=nvYD2NeDdLE')
) AS v(sector, name, video_url),
     public.boulders b,
     public.sectors s,
     public.areas a
WHERE c.boulder_id = b.id
  AND b.sector_id = s.id
  AND s.area_id = a.id
  AND a.name = 'Medené Hámre'
  AND s.name = v.sector
  AND c.name = v.name;
