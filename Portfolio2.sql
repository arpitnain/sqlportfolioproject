--Clearing data with SQL

Select *
From Portfolio_Project.dbo.NashvilleHousing

--------------------------

--Standardize Date Format

Select SaleDateConverted,Convert(Date,SaleDate)
From Portfolio_Project.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate= Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

--Populate Property Address data where it is null

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing a
JOIN Portfolio_Project.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE A.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing a
JOIN Portfolio_Project.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is NULL

---Breaking out Addresss into  Individual Columns (Address,City,Name)

Select PropertyAddress
From Portfolio_Project.dbo.NashvilleHousing

SELECT 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS City
From Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
From Portfolio_Project.dbo.NashvilleHousing


SELECT OwnerAddress
From Portfolio_Project.dbo.NashvilleHousing

SELECT 
PARSENAME(REPlACE(OwnerAddress,',','.'),3),
PARSENAME(REPlACE(OwnerAddress,',','.'),2),
PARSENAME(REPlACE(OwnerAddress,',','.'),1)
From Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD  OwnerSplitAddress NvarChar(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPlACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NvarChar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPlACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitName VarChar(255)

Update NashvilleHousing
Set OwnerName = PARSENAME(REPlACE(OwnerAddress,',','.'),1)

------------------------------------------------
--Change Y and N to Yes and No in Sold As Vaccant

Select DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio_Project.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End
From Portfolio_Project.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant= CASE 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End
From Portfolio_Project.dbo.NashvilleHousing


-----------------

--Remove Duplicates 

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() Over (
Partition BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
Order BY UniqueID
) row_num

From Portfolio_Project.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1
Order by PropertyAddress
