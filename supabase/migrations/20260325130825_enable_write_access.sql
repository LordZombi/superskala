-- Odstránime staré (ak by tam náhodou boli pre zlý názov) a pridáme správne
DROP POLICY IF EXISTS "Allow public upload" ON storage.objects;
DROP POLICY IF EXISTS "Allow public update" ON storage.objects;

-- Povolenie uploadu do tvojho konkrétneho bucketu
CREATE POLICY "Allow public upload" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'boulder-photos');

CREATE POLICY "Allow public update" ON storage.objects
    FOR UPDATE USING (bucket_id = 'boulder-photos') WITH CHECK (bucket_id = 'boulder-photos');

-- Povolenie čítania (aby lezci videli fotky)
CREATE POLICY "Allow public select" ON storage.objects
    FOR SELECT USING (bucket_id = 'boulder-photos');
