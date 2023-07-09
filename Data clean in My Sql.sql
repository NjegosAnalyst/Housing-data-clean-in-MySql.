SELECT * FROM portfolio_project.nashville_data;

--------STANDARDIZE--DATE_FORMAT------------------------------------------------------------------------------------------------------

SELECT SaleDate,convert(SaleDate, date) FROM portfolio_project.nashville_data;

alter table portfolio_project.nashville_data
modify SaleDate date


------Braking out in the separate columns--------------------------------------------------------------------------------------------
-----Adress


ALTER TABLE portfolio_project.nashville_data
ADD COLUMN Adresse VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;

UPDATE portfolio_project.nashville_data
SET Adresse = SUBSTRING_INDEX(PropertyAddress, ',', 1)
WHERE ï»¿UniqueID = ï»¿UniqueID;

-----City
SELECT SUBSTRING(PropertyAddress, CHAR_LENGTH(SUBSTRING_INDEX(PropertyAddress, ',', 1))+3) AS City
FROM portfolio_project.nashville_data;

SET SQL_SAFE_UPDATES = 0

ALTER TABLE portfolio_project.nashville_data
ADD COLUMN City VARCHAR(255);

UPDATE portfolio_project.nashville_data
SET City = SUBSTRING(PropertyAddress, CHAR_LENGTH(SUBSTRING_INDEX(PropertyAddress, ',', 1))+3)
WHERE ï»¿UniqueID = ï»¿UniqueID;

-----------------------------------------------------------------------------------------------------------------------------------

select OwnerAddress,
        SUBSTRING_INDEX(OwnerAddress, ', ', 1),
        SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ', ', -2), ', ', 1),
        SUBSTRING_INDEX(OwnerAddress, ', ', -1)

from portfolio_project.nashville_data

alter table portfolio_project.nashville_data
add column owner_address VARCHAR(255)

alter table portfolio_project.nashville_data
add column owner_city VARCHAR(255)

alter table portfolio_project.nashville_data
add column owner_state VARCHAR(255)


UPDATE portfolio_project.nashville_data
SET
    owner_address = SUBSTRING_INDEX(OwnerAddress, ', ', 1),
    owner_city = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ', ', -2), ', ', 1),
    owner_state = SUBSTRING_INDEX(OwnerAddress, ', ', -1);

----------------------------------------------------------------------------------------------------------------------------------

update  portfolio_project.nashville_data
 set SoldAsVacant =  case
       when SoldAsVacant = 'N' then 'No' 
       when SoldAsVacant = 'Y' then 'Yes' 
       else SoldAsVacant
       end ;




---------REMOVE DUPLICATE----

WITH tbl AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, LegalReference ORDER BY ï»¿UniqueID) AS row_num
    FROM portfolio_project.nashville_data
)
DELETE FROM portfolio_project.nashville_data
WHERE ï»¿UniqueID IN (
    SELECT ï»¿UniqueID
    FROM tbl
    WHERE row_num > 1
);


-----DELETE COLUMNS

ALTER TABLE portfolio_project.nashville_data
DROP COLUMN PropertyAddress,
DROP COLUMN SalePrice,
DROP COLUMN TaxDistrict;

ALTER TABLE portfolio_project.nashville_data
DROP COLUMN SaleDate


