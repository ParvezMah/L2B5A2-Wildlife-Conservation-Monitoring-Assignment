-- Active: 1747587952649@@127.0.0.1@5432@wildlife_conservation_db

--Creating Rangers table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NUll
);

INSERT INTO rangers(name, region) VALUES 
    ('Alice Green', 'Northern Hills'),
    ('Bob White', 'River Delta'),
    ('Carol King', 'Mountain Range');

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,    
    scientific_name VARCHAR(100) NOT NULL,   
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) CHECK (conservation_status IN('Endangered', 'Vulnerable'))
);

INSERT INTO species(common_name, scientific_name, discovery_date, conservation_status) 
    VALUES
        ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
        ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
        ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
        ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    Location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT DEFAULT 'No Notes Added'
);

INSERT INTO sightings(species_id, ranger_id, Location, sighting_time, notes)
    VALUES
        (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
        (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
        (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
        (1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;

-- drop TABLE sightings;






--✅1 Register a new ranger with provided data with name = 'Derek Fox' and region = 'Costal Plains'✅
INSERT INTO rangers(name, region) VALUES('Derek Fox', 'Costal Plains');






--✅2 count unique species ever sighted✅
-- SELECT count(species_id) AS unique_species_count FROM sightings;
SELECT count(DISTINCT species_id) AS unique_species_count FROM sightings;







--✅3 Find all sightings where the location includes "Pass".✅
SELECT location FROM sightings
    WHERE location LIKE '%Pass';









--✅4 List Each ranger's name and their total number or sightings✅
SELECT r.name, count(s.sighting_id) AS total_sightings 
    FROM rangers r 
    LEFT JOIN sightings s on r.ranger_id = s.ranger_id
    GROUP BY r.ranger_id, r.name 
    ORDER BY r.name;







--✅5 Lit species that have never been sighted✅
SELECT sp.common_name FROM species sp LEFT JOIN sightings sight on sp.species_id = sight.species_id
    WHERE sight.sighting_id is NULL;







--✅6 Show the most recent 2 sightings.✅
SELECT species.common_name, ranger_name, sighting_time FROM sightings;
SELECT species.common_name, name as ranger_name, sighting_time FROM sightings
    JOIN species on species.species_id = sightings.species_id
    JOIN rangers on rangers.ranger_id = sightings.ranger_id
    ORDER BY sightings.sighting_time DESC
    LIMIT 2;







-- ✅7 Update all species discoverd before year 1800 to have status 'Historic'✅
UPDATE species
    SET conservation_status = 'Historic'
    WHERE discovery_date < '1800-01-01';
-- Error : new row for relation "species" violates check constraint "species_conservation_status_check"
-- To solve that we have to drop check constraint
ALTER TABLE species DROP CONSTRAINT species_conservation_status_check;
-- Now adding that check constraint again with 'Historic';
ALTER TABLE species ADD CONSTRAINT species_conservation_status_check CHECK (conservation_status IN('Endangered', 'Vulnerable', 'Historic'));
UPDATE species
    SET conservation_status = 'Historic'
    WHERE discovery_date < '1800-01-01';
SELECT * FROM species;






-- ✅8 Label each sighting time of day as 'Morning', 'Afternoon', or 'Eveninng';✅
CREATE or REPLACE FUNCTION get_time_of_day(
    ts TIMESTAMP
)
RETURNS TEXT AS 
$$
    BEGIN 
        IF EXTRACT(HOUR FROM ts) < 12 THEN
            RETURN 'Morning';
        ELSEIF EXTRACT(HOUR FROM ts) BETWEEN 12 AND 17 THEN 
            RETURN 'Afternoon';
        ELSE
            RETURN 'Evening';
        END IF;
    END;
$$
LANGUAGE plpgsql;


SELECT sighting_id, get_time_of_day(sighting_time) AS time_of_day FROM sightings
    ORDER BY sighting_id;








-- ✅9 Delete rangers who have never sighted any species✅

-- finding which ranger have never sighted any species
-- SELECT * FROM sightings;
-- SELECT r.ranger_id, r.name FROM rangers r
--     LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
--     WHERE s.ranger_id IS NULL;

-- using it as subquery to delete that ranger
DELETE FROM rangers 
WHERE ranger_id IN (
    SELECT r.ranger_id FROM rangers r
    LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
    WHERE s.ranger_id IS NULL
);

SELECT * FROM rangers;