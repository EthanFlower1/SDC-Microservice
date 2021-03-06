-- \c ratrev;

--  DROP TABLE Reviews CASCADE;
--  DROP TABLE Characteristics CASCADE;
--  DROP TABLE Characteristics_Reviews CASCADE;
--  DROP TABLE Reviews_Photos  CASCADE;
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'ratrev'
  AND pid <> pg_backend_pid();

DROP DATABASE ratrev;



CREATE DATABASE RatRev;
\c ratrev;

 -- dont forget to use indexes
 -- Cant use SERIAL for ID's because imports ?

CREATE TABLE IF NOT EXISTS Reviews (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,        -- AUTO_INCREMENT integer, as primary key
  product_id INTEGER,
  rating INTEGER,
  date BIGINT,
  summary TEXT,
  body TEXT,
  recommend BOOLEAN,
  reported BOOLEAN,
  reviewer_name VARCHAR(32),
  reviewer_email VARCHAR(60),
  response TEXT,
  helpfulness INTEGER
);

CREATE TABLE IF NOT EXISTS Characteristics (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,        -- AUTO_INCREMENT integer, as primary key
  product_id INTEGER,
  name VARCHAR(7)
);

CREATE TABLE IF NOT EXISTS Characteristics_Reviews (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,        -- AUTO_INCREMENT integer, as primary key
  characteristics_id INTEGER,
  review_id INTEGER,
  value INTEGER,
  CONSTRAINT fk_characteristics
    FOREIGN KEY (characteristics_id)
    REFERENCES Characteristics(id)
);

CREATE TABLE IF NOT EXISTS Reviews_Photos (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,       -- AUTO_INCREMENT integer, as primary key
  review_id INTEGER,
  url VARCHAR(200),
  CONSTRAINT fk_reviews
    FOREIGN KEY (id)
    REFERENCES Reviews(id)
);

-- IMPORT CSV DATA BELOW
  COPY Reviews(id, product_id, rating, date, summary, body, recommend, reported, reviewer_name, reviewer_email, response, helpfulness)
  FROM '/Users/ethanflower/Downloads/reviews.csv'
  DELIMITER ','
  CSV HEADER;

  COPY Characteristics (id, product_id, name)
  FROM '/Users/ethanflower/Downloads/characteristics.csv'
  DELIMITER ','
  CSV HEADER;

  COPY Characteristics_Reviews (id, characteristics_id, review_id, value)
  FROM '/Users/ethanflower/Downloads/characteristic_reviews.csv'
  DELIMITER ','
  CSV HEADER;

  COPY Reviews_Photos(id, review_id, url)
  FROM '/Users/ethanflower/Downloads/reviews_photos.csv'
  DELIMITER ','
  CSV HEADER;

  SELECT pg_catalog.setval(pg_get_serial_sequence('reviews', 'id'), (SELECT MAX(id) FROM reviews)+1);
  SELECT pg_catalog.setval(pg_get_serial_sequence('reviews_photos', 'id'), (SELECT MAX(id) FROM reviews_photos)+1);
  SELECT pg_catalog.setval(pg_get_serial_sequence('characteristics', 'id'), (SELECT MAX(id) FROM characteristics)+1);
  SELECT pg_catalog.setval(pg_get_serial_sequence('characteristics_reviews', 'id'), (SELECT MAX(id) FROM characteristics_reviews)+1);

  ALTER TABLE reviews ADD COLUMN datetz DATE;
  UPDATE reviews SET datetz = to_timestamp(reviews.date/1000);
  ALTER TABLE reviews DROP COLUMN date;
  ALTER TABLE reviews RENAME COLUMN datetz TO date;

CREATE INDEX pid_idx ON reviews USING btree(
  product_id asc,
  rating asc,
  recommend asc
);
CREATE INDEX char_id_idx ON characteristics_reviews USING btree(
  characteristics_id asc,
  value asc
);
CREATE INDEX prod_id_idx ON characteristics USING btree(
  product_id asc,
  name asc
);
CREATE INDEX revid_idx ON reviews_photos USING btree(
  review_id asc
);