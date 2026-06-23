-- Seed default product categories so the homepage category grid has content
INSERT INTO categories (name, description, type)
VALUES
  ('Цемент', 'Цемент и сухие смеси', 'product'),
  ('Кирпич', 'Кирпич и блоки', 'product'),
  ('Изоляция', 'Теплоизоляционные материалы', 'product'),
  ('Инструменты', 'Ручной и электроинструмент', 'product'),
  ('Краска', 'Краски и лакокрасочные материалы', 'product'),
  ('Трубы', 'Трубы и фитинги', 'product')
ON CONFLICT (name) DO NOTHING;
