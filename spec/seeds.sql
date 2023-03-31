TRUNCATE TABLE albums, artists RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES 
('Future Days', '1973', 1), 
('Monster Movie', '1969', 1),
('Tell Her', '1969', 3),
('Can', '1975', 1),
('Ege Bamyasi', '1972', 1),
('Landed', '1975', 1),
('Surfer Rosa', '1988', 2),
('Doolittle', '1989', 2),
('Bossanova', '1990', 2)
;

INSERT INTO artists (name, genre) VALUES ('CAN', 'Krautrock'),
('Pixies', 'Indie'),
('Fred Williams', 'Afro-Rock')
;