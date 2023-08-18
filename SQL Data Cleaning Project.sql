/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.NashvilleHousing

-- Standaradize Date Format 

Select SaleDateConverted, CONVERT(Date,SaleDate) 
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

-- For when it doesn't update correctly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Propery Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND	a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND	a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order By ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)- 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, Len(PropertyAddress))  as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)- 1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, Len(PropertyAddress))  

Select * 
From PortfolioProject.dbo.NashvilleHousing




Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress, ',', '.') , 3)
,PARSENAME(Replace(OwnerAddress, ',', '.') , 2)
,PARSENAME(Replace(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing 




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') , 2)  

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') , 1) 

Select *
From PortfolioProject.dbo.NashvilleHousing



-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldASVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


From PortfolioProject.dbo.NashvilleHousing
-- order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress




SELECT *
From PortfolioProject.dbo.NashvilleHousing


-- Delete Unused Columns

Select * 
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate