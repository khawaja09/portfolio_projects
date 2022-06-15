select * from PortfolioProject..Sheet1$

-- Standardize Date Format

update PortfolioProject..Sheet1$ 
set SaleDate = convert(date, SaleDate)

alter table PortfolioProject..Sheet1$
add SaleDateConverted date

update PortfolioProject..Sheet1$ 
set SaleDateConverted = convert(date, SaleDate)

-- Populate Property Address

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Sheet1$ a
join PortfolioProject..Sheet1$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Sheet1$ a
join PortfolioProject..Sheet1$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
 
 -- break out column address city state


select PropertyAddress, RIGHT(PropertyAddress, LEN(PropertyAddress)- CHARINDEX(' ', PropertyAddress))
FROM PortfolioProject..Sheet1$


select LEFT(PropertyAddress, CHARINDEX(' ', PropertyAddress))
FROM PortfolioProject..Sheet1$

ALTER TABLE PortfolioProject..Sheet1$
add address varchar

update PortfolioProject..Sheet1$ 
set address = LEFT(PropertyAddress, CHARINDEX(' ', PropertyAddress))

ALTER TABLE PortfolioProject..Sheet1$
ALTER COLUMN address varchar(20)

select * from PortfolioProject..Sheet1$

select right('hello world', CHARINDEX(' ', 'hello world'))
select right('hello, world', CHARINDEX(',', 'hello, world'))


select PropertyAddress, left(PropertyAddress, CHARINDEX(',', PropertyAddress)-1),
RIGHT(PropertyAddress, len(PropertyAddress)- CHARINDEX(',', PropertyAddress)-1)
from PortfolioProject..Sheet1$

select *
from PortfolioProject..Sheet1$

ALTER TABLE PortfolioProject..Sheet1$
ADD PropertyCity Nvarchar(20)


update PortfolioProject..Sheet1$
set PropertyCity = RIGHT(PropertyAddress, len(PropertyAddress)- CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE PortfolioProject..Sheet1$
ADD PropertySplitAddress Nvarchar(255)


update PortfolioProject..Sheet1$
set PropertySplitAddress = left(PropertyAddress, CHARINDEX(',', PropertyAddress)-1)

select *
from PortfolioProject..Sheet1$


-- SEPARATE OWNER ADDRESS, CITY, STATE

select OwnerAddress, 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) AS State
from
PortfolioProject..Sheet1$
-- ADD COLUMNS FOR ADDRESS, CITY AND STATE

alter table PortfolioProject..Sheet1$
add OwnerSplitAddress Nvarchar(255)

alter table PortfolioProject..Sheet1$
add OwnerSplitCity Nvarchar(50)

alter table PortfolioProject..Sheet1$
add OwnerSplitState Nvarchar(50)

-- POPULATE COLUMNS

update PortfolioProject..Sheet1$
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

update PortfolioProject..Sheet1$
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

update PortfolioProject..Sheet1$
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT * FROM
PortfolioProject..Sheet1$


-- CHANGE 'Y' & 'N' IN SoldAsVacant to 'YES' and 'NO'

select distinct soldasvacant, count(soldasvacant)
from PortfolioProject..Sheet1$
group by soldasvacant


update PortfolioProject..Sheet1$
set soldasvacant = CASE 
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END

-- REMOVE DUPLICATES

select * from PortfolioProject..Sheet1$

with RowNumCTE as (
SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate,
				legalreference
            ORDER BY 
                uniqueID
        ) row_num

     FROM PortfolioProject..Sheet1$
	 )
select * from RowNumCTE 
where row_num >1

DELETE FROM RowNumCTE
WHERE row_num > 1;


-- DELETE UN-USED COLUMNS

ALTER TABLE PortfolioProject..Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;


ALTER TABLE PortfolioProject..Sheet1$
DROP COLUMN SaleDate

select * from
PortfolioProject..Sheet1$