-- Create the 'areas' table
CREATE TABLE public.areas (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    CONSTRAINT areas_pkey PRIMARY KEY (id)
);

-- Create the 'sectors' table
CREATE TABLE public.sectors (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    area_id uuid NOT NULL,
    name text NOT NULL,
    lat double precision,
    lon double precision,
    CONSTRAINT sectors_pkey PRIMARY KEY (id),
    CONSTRAINT sectors_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id) ON DELETE CASCADE
);

-- Create the 'boulders' table
CREATE TABLE public.boulders (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    sector_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    CONSTRAINT boulders_pkey PRIMARY KEY (id),
    CONSTRAINT boulders_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES public.sectors(id) ON DELETE CASCADE
);

-- Create the 'climbs' table
CREATE TABLE public.climbs (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    boulder_id uuid NOT NULL,
    name text NOT NULL,
    grade text,
    is_project boolean NOT NULL DEFAULT false,
    CONSTRAINT climbs_pkey PRIMARY KEY (id),
    CONSTRAINT climbs_boulder_id_fkey FOREIGN KEY (boulder_id) REFERENCES public.boulders(id) ON DELETE CASCADE
);

-- Seed Data
DO $$
DECLARE
    area_id_var uuid;
    sector_id_var uuid;
    boulder_id_var uuid;
BEGIN
    -- Insert Area and get its ID
    INSERT INTO public.areas (name, description)
    VALUES ('Chtelnica', 'A climbing area in Slovakia.')
    RETURNING id INTO area_id_var;

    -- Insert Sector and get its ID
    INSERT INTO public.sectors (area_id, name, lat, lon)
    VALUES (area_id_var, 'Predný sektor', 48.611123, 17.576012)
    RETURNING id INTO sector_id_var;

    -- Insert Boulder and get its ID
    INSERT INTO public.boulders (sector_id, name)
    VALUES (sector_id_var, 'Šakty')
    RETURNING id INTO boulder_id_var;

    -- Insert Climb
    INSERT INTO public.climbs (boulder_id, name, grade)
    VALUES (boulder_id_var, 'Šakty', '7B');
END $$;


-- Enable RLS for all tables
ALTER TABLE public.areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.boulders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.climbs ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Allow public read access" ON public.areas
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access" ON public.sectors
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access" ON public.boulders
    FOR SELECT USING (true);

CREATE POLICY "Allow public read access" ON public.climbs
    FOR SELECT USING (true);
