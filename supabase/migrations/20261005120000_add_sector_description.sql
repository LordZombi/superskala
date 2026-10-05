-- Popis sektoru (prístup, parkovanie) – zobrazuje sa na stránke oblasti
ALTER TABLE public.sectors
    ADD COLUMN IF NOT EXISTS description text;

-- Medené Hámre: prístupy podľa bouldertopa boulder.sk 2024
UPDATE public.sectors s
SET description = v.description
FROM (VALUES
    ('Sedembolestný', 'Prvý sektor po príchode z Borinky, nachádza sa po ľavej strane. Zaparkujte oproti malej vodárničke na malom parkovacom mieste. Za ním vedie nenápadný chodníček až ku schodisku, ktoré vás privedie priamo k jaskynke.'),
    ('Moonboard', 'Zaparkujte na hlavnom parkovisku lezeckej oblasti. Odtiaľ sa môžete vybrať popod stenu doľava, rebríkom hore k štôlni a pokračovať traverzom doľava až k sektoru. Druhá možnosť je o niečo pohodlnejšia: z parkoviska sa vydajte dole po hlavnej ceste a za schátranými budovami malými schodíkmi doprava do lesa, odtiaľ mierne doľava až pod skaly.'),
    ('Prízemie', 'Zaparkujte na hlavnom parkovisku a odtiaľ sa vydajte doprava lúkou. Po ľavej strane uvidíte Majku. K ostatným kameňom sa dostanete, ak budete pokračovať ďalej lomom.'),
    ('Pod Medeným', 'Zaparkujte na hlavnom parkovisku a odtiaľ sa vydajte doprava lúkou. Sektor sa nachádza vo svahu vpravo nad Majkou, privedie vás k nemu nenápadný chodníček kúsok opodiaľ.'),
    ('Poschodie', 'Zaparkujte v ľavotočivej zákrute po pravej strane, alebo vojdite do lomu a nechajte auto hneď na začiatku. Odtiaľ už vidno prvé súskalie.'),
    ('Vlna', 'Pokračujte po hlavnej ceste ešte ďalej za sektor Poschodie. Po výraznej ľavotočivej zákrute príde mierna pravotočivá, za ktorou je po ľavej strane menšie miesto na parkovanie. Od neho vedie asfaltová cesta, ktorou prídete až ku balvanu.')
) AS v(name, description)
WHERE s.name = v.name
  AND s.area_id = (SELECT id FROM public.areas WHERE name = 'Medené Hámre');
