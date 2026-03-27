-- 1. Pridanie súradníc pre Areas (užitočné pre centrovanie mapy na celú oblasť)
ALTER TABLE public.areas
    ADD COLUMN lat double precision,
ADD COLUMN lon double precision;

-- 2. Pridanie súradníc pre konkrétne cesty (Climbs)
-- Aj keď sú na rovnakom bouldri, niekedy je fajn mať mikro-posun na mape
ALTER TABLE public.climbs
    ADD COLUMN lat double precision,
ADD COLUMN lon double precision;

-- 3. Odstránenie starého stĺpca 'grade' (string)
-- POZOR: Ak tam máš dáta, o ktoré nechceš prísť, predtým si ich manuálne premigruj do grade_id!
ALTER TABLE public.climbs
DROP COLUMN IF EXISTS grade;
