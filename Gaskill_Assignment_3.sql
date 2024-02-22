-- Create a new databse named RealEstateDB
CREATE DATABASE "RealEstateDB"; 

-- Connect to the database
\c RealEstateDB

-- Enable the PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create PropertyDetails table that violates 3NF and 4NF
CREATE TABLE PropertyDetails (
	PropertyID SERIAL PRIMARY KEY,
	Address VARCHAR(255),
	City VARCHAR(100),
	State VARCHAR(50),
	Country VARCHAR(50),
	Zoningtype VARCHAR(100),
	Utility VARCHAR(100),
	GeoLocation GEOMETRY(Point, 4326), 
	CityPopulation INT
);

-- Create CityDemographics Table (achieve 3NF by removing transitive dependencies)
CREATE TABLE CityDemographics (
	City VARCHAR(100) PRIMARY KEY,
	State VARCHAR(50),
	Country VARCHAR(50),
	CityPopulation INT
);

-- Modify the PropertyDetails table
ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;

-- Create PropertyZoning Table (achieves 4NF by removing multi-valued dependencies)
CREATE TABLE PropertyZoning (
	PropertyZoningID SERIAL PRIMARY KEY,
	PropertyID INT REFERENCES PropertyDetails(PropertyID),
	Zoningtype VARCHAR(100)
);

-- Create PropertyUtilities Table (achieves 4NF by removing multi-valued dependencies)
CREATE TABLE PropertyUtilities (
	PropertyUtilityID SERIAL PRIMARY KEY,
	PropertyID INT REFERENCES PropertyDetails(PropertyID),
	Utility VARCHAR(100)
);

-- Remove original columns from PropertyDetails 
ALTER TABLE PropertyDetails DROP COLUMN Zoningtype, DROP COLUMN Utility;

-- Testing insert of a property with Geolocation (for spatial data manipulation)
INSERT INTO PropertyDetails (Address, City, GeoLocation)
VALUES ('123 Main St', 'Springfield', ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326));

-- Testing Query of finding Properties Within a Radius
SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);

-- Extra Section: Working with additional dummy data to fill all tables
-- Further demonstrates compliance up to the 4th Normal Form

-- Delete dummy data from PropertyDetails
DELETE FROM PropertyDetails;

-- Insertion of dummy data into all tables
-- Location 1: National Grid Electric Company
-- Location 2: Clark University
-- Location 3: DCU Center
INSERT INTO PropertyDetails (Address, City, Geolocation)
VALUES
	('939 Southbridge St', 'Worcester', ST_GeomFromText('POINT(-71.81701488745468 42.23564522085342)', 4326)),
	('950 Main St', 'Worcester', ST_GeomFromText('POINT(-71.82458034510321 42.25204844637529)', 4326)),
	('50 Foster St', 'Worcester', ST_GeomFromText('POINT(-71.7986075141289 42.26485349202969)', 4326));


INSERT INTO CityDemographics(City, State, Country, CityPopulation)
VALUES
	('Worcester', 'Massachusetts', 'United States', 2059180);

INSERT INTO PropertyZoning(PropertyID, Zoningtype)
VALUES
	(2, 'Commerical'),	-- Starting from index 2 since dummy data insertion took index 1
	(3, 'Academic'),
	(4, 'Arena');
	
INSERT INTO PropertyUtilities(PropertyID, Utility)
VALUES
	(2, 'Electric Company'),
	(3, 'Education'),
	(4, 'Entertainment');

-- Spatial Query to find properties within 2 km of Worcester City Hall
-- Note: the spatial query still returns all 3 when I expect it to only return 2.
-- Note: National Grid is ~5 km away and should not be included.
SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-71.80175342215435 42.26288124215141)', 4326),
    2000 -- 2km radius
);

-- Final Select statements to easily view each table
SELECT * FROM PropertyDetails;
SELECT * FROM CityDemographics;
SELECT * FROM PropertyZoning;
SELECT * FROM PropertyUtilities;