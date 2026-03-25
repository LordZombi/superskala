-- UPDATED 'boulders' table (The physical rock)
-- Adds columns for an image and precise location.
ALTER TABLE public.boulders
ADD COLUMN IF NOT EXISTS image_url text,
ADD COLUMN IF NOT EXISTS lat double precision,
ADD COLUMN IF NOT EXISTS lon double precision;

-- UPDATED 'climbs' table (The specific route)
-- Adds detailed information for rendering topos and sorting.
ALTER TABLE public.climbs
ADD COLUMN IF NOT EXISTS grade_font text,    -- Boulder grade (e.g., 7B)
ADD COLUMN IF NOT EXISTS grade_french text,  -- Sport grade (e.g., 8a)
ADD COLUMN IF NOT EXISTS grade_value integer, -- Sorting value (e.g., 70 for 7A)
ADD COLUMN IF NOT EXISTS topo_path text,      -- SVG Path string (e.g., "M10 80 C 40 60, 60 40, 90 20")
ADD COLUMN IF NOT EXISTS start_x float8,      -- Start dot X position in % (0-100)
ADD COLUMN IF NOT EXISTS start_y float8,      -- Start dot Y position in % (0-100)
ADD COLUMN IF NOT EXISTS top_x float8,        -- Top dot X position in % (0-100)
ADD COLUMN IF NOT EXISTS top_y float8,        -- Top dot Y position in % (0-100)
ADD COLUMN IF NOT EXISTS is_sit_start boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS is_dangerous boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS climbing_style text, -- e.g., 'slab', 'overhang', 'crimp'
ADD COLUMN IF NOT EXISTS description text;
