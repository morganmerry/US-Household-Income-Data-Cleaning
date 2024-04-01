SELECT * 
FROM us_project.us_household_income_statistics;

-- Remove the extra characters from the id column name

ALTER TABLE us_household_income_statistics 
RENAME COLUMN `ï»¿id`TO `id`;

-- Identify the duplicate data

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;


SELECT *
FROM (
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_household_income) duplicates
WHERE row_num > 1;

-- Deleting the duplicate data from the table

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_household_income) duplicates
	WHERE row_num > 1);

-- Checking for duplicate data

SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;


SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY State_Name;

-- Fixing misspelled state name

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';


UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Find missing data

SELECT *
FROM us_household_income
WHERE place = '';

-- Fill in missing data

UPDATE us_household_income
SET place = 'Autaugaville'
WHERE county = 'Autauga County'
AND city = 'Vinemont';


SELECT type, COUNT(type)
FROM us_household_income
GROUP BY type;

-- Correct an error found in the type column

UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';
