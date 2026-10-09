-- Obrys oblasti a sektora: pole [lat, lon] bodov po obvode (min. 3), mapa z neho kreslí plochu.
-- Prázdne (NULL) = len bod, ako doteraz.
alter table public.areas add column if not exists outline jsonb;
alter table public.sectors add column if not exists outline jsonb;
