## Assignment 3 - Normalizing Spatial Data in a Real Estate Database

### **Objectives:**
#### The objective of this lab is to work with Third and Fourth-Order Normalization in PostgreSQL. I created a database with a table that violates 3NF and 4NF then worked to fix the issues and demonstrate compliance. I then added extra dummy data from Worcester to demonstrate the population of all new tables with data and ran a spatial query based on distance.

### **Files:**
#### 1. Gaskill_Assignment_3.sql
#####  - The main SQL script
#### 2. Readme.md
#####  - The Readme file containing metadata and reports
#### 3. Images
#####  - Images folder containing command line screenshots of initial database creation, the empty table structures, and Worcester Data Insertion, Exploration, and Querying.

### **Normalization Report:**
####  A non-3NF table was created named 'PropertyDetails' consisting of a primary key ID, Address, City, State, Country, Zoningtype, Utility, GeoLocation, and CityPopulation.

#### Next, the data was normalized to the Third Normal Form by creating a CityDemographics table with City, State, Country, and CityPopulation. This achieved 3NF by removing transitive dependencies. The PropertyDetails table was altered, removing the columns now contained in CityDemographics.

#### Then, the data was normalized to the Fourth Normal Form by creating a PropertyZoning table with PropertyID foreign key and Zoningtype. This achieved 4NF by removing multi-valued dependencies. The PropertyDetails table was altered removing the columns now contained in PropertyZoning.

#### Test data provided in the lab document was inserted into the database and a test spatial query using PostGIS and ST_DWithin was successfully run. 

#### The dummy data was deleted and replaced with 3 locations in Worcester, including the National Grid Power Company, Clark University, and the DCU Center. Appropriate fields were entered into each table to demonstrate compliance up to the 4th Normal Form. An assumption was made for the utility field that there is only one utility (primary general purpose) for each location, such as 'electric company', 'education', and 'entertainment'.

#### Finally, a Spatial Query was run to find properties within 2 km of Worcester City Hall. Please note that the spatial query still returns all 3 when I expected it to only return 2. This is because National Grid is ~5km away and should not be included.

### **Initial Database and Table Creation:**
![This file contains all of the initial SQL Scripts required to generate the required tables.](/Images/database_creation.png)

### **Empty Table Structure:**
![This file contains the complete empty table structure of each table, demonstrating 4NF compliance.](/Images/empty_tables.png)

### **Worcester Data Insertion:**
![This file contains all of the SQL Scripts required to insert 3 columns of data relating to Worcester locations.](/Images/worcester_1.png)

### **Worcester Selection and Spatial Data Query:**
![This file contains all of the SQL Scripts required to view the table structure with Worcester locations inserted, as well as the results of a spatial data query.](/Images/worcester_1.png)
