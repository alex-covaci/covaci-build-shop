ALTER TABLE products
ADD COLUMN IF NOT EXISTS images text[] NOT NULL DEFAULT '{}';

ALTER TABLE equipment
ADD COLUMN IF NOT EXISTS images text[] NOT NULL DEFAULT '{}';

UPDATE products
SET images = ARRAY[image_url]
WHERE image_url IS NOT NULL AND images = '{}';

UPDATE equipment
SET images = ARRAY[image_url]
WHERE image_url IS NOT NULL AND images = '{}';
