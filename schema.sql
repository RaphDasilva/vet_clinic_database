/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id              INT GENERATED ALWAYS AS IDENTITY,
  name            VARCHAR(250),
  date_of_birth   DATE,
  escape_attempts INT,
  neutered        BOOLEAN,
  weight_kg       DECIMAL,
  PRIMARY KEY(id)
);

ALTER TABLE animals
ADD species varchar(255);

-- Multiple tables

CREATE TABLE owners (
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(255),
  age  INT,
  PRIMARY KEY (id)
);

CREATE TABLE species (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  PRIMARY KEY (id)
);

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals 
ADD COLUMN species_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species(id);

ALTER TABLE animals 
ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_owner
FOREIGN KEY(owner_id)
REFERENCES owners(id);

-- many-to-many

CREATE TABLE vets (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY (id)
);

CREATE TABLE specializations (
  species_id int,
  vets_id int,
  CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id),
  CONSTRAINT fk_vets FOREIGN KEY(vets_id) REFERENCES vets(id)
);

ALTER TABLE specializations 
ADD CONSTRAINT PK_specializations 
PRIMARY KEY (species_id ,vets_id);

CREATE TABLE visits (
  animal_id INT,
  vets_id INT,
  visit_date DATE,
  CONSTRAINT fk_animal FOREIGN KEY(animal_id)REFERENCES animals(id),
  CONSTRAINT fk_vets FOREIGN KEY(vets_id)REFERENCES vets(id),
  CONSTRAINT PK_visits PRIMARY KEY (animal_id ,vets_id,visit_date)
);

ALTER TABLE visits
DROP CONSTRAINT PK_visits;

ALTER TABLE visits 
ADD CONSTRAINT PK_visits 
PRIMARY KEY (animal_id, vets_id, visit_date);


-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Remove the primary keys from the visits table
ALTER TABLE visits DROP CONSTRAINT pk_visits;

CREATE INDEX animals_visits_ids ON visits(animal_id);

CREATE INDEX vets_visits_id ON visits(vets_id);

CREATE INDEX owners_visits_ids ON owners(email);
