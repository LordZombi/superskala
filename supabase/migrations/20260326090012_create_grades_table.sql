-- 1. Create the new 'grades' table
CREATE TABLE public.grades (
                               id serial PRIMARY KEY,
                               font text NOT NULL UNIQUE,
                               value integer NOT NULL
);

-- 2. Seed the 'grades' table with Fontainebleau grades
INSERT INTO public.grades (font, value) VALUES
                                            ('4', 40),
                                            ('5', 50),
                                            ('6A', 60), ('6A+', 61),
                                            ('6B', 62), ('6B+', 63),
                                            ('6C', 64), ('6C+', 65),
                                            ('7A', 70), ('7A+', 71),
                                            ('7B', 72), ('7B+', 73),
                                            ('7C', 74), ('7C+', 75),
                                            ('8A', 80), ('8A+', 81),
                                            ('8B', 82), ('8B+', 83),
                                            ('8C', 84), ('8C+', 85),
                                            ('9A', 90);

-- 3. Add the new 'grade_id' foreign key column to 'climbs'
ALTER TABLE public.climbs
    ADD COLUMN grade_id integer REFERENCES public.grades(id);

-- Optional but recommended: Populate the new 'grade_id' from old data
-- This query tries to match existing 'grade_font' values with the new table.
UPDATE public.climbs c
SET grade_id = g.id
    FROM public.grades g
WHERE c.grade_font = g.font;

-- 4. Drop the old, now redundant, grade columns from 'climbs'
ALTER TABLE public.climbs
DROP COLUMN grade_font,
DROP COLUMN grade_french,
DROP COLUMN grade_value;
