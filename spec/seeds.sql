TRUNCATE TABLE items, orders RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO items (name, price, quantity) VALUES 
('Vorpal blade', 34.99 , 20), 
('Tardis', 139.5, 3),
('Scarab beetle', 10.99, 300),
('Light saber', 101, 13),
('Elder wand', 56.78, 1),
('Winged helmet', 14.69, 45),
('Flux capacitor', 20, 41),
('AT-AT', 2350, 2),
('Horcrux', 0.5, 7)
;

INSERT INTO orders (customer, date, item_id) VALUES 
('Doctor Who', '2056-04-13', 2),
('Voldermort', '2005-04-01', 9),
('Chewbacca', '1977-06-23', 1),
('Perseus', '10-01-15', 1),
('Harry Potter', '2013-08-01', 4),
('Sun Ra', '1979-12-31', 3)
;