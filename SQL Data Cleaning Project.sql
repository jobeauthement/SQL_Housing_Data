/*
 Cleaning Data in SQL Queries
 */

-- Querying all columns and rows from the NashvilleHousing table

Select * From PortfolioProject.dbo.NashvilleHousing 

-- Converting the SaleDate column to a standard date format

Select
    SaleDateConverted,
    CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

-- Updating the SaleDate column in the NashvilleHousing table with the converted date

Update NashvilleHousing Set SaleDate = CONVERT(Date, SaleDate) 

-- If the above update doesn't work, you can create a new column called SaleDateConverted and populate it with the converted date

ALTER TABLE NashvilleHousing Add SaleDateConverted Date;

Update NashvilleHousing
Set
    SaleDateConverted = CONVERT(Date, SaleDate)

-- Querying all columns from the NashvilleHousing table where the PropertyAddress is null and ordering the results by ParcelID

Select *
From
    PortfolioProject.dbo.NashvilleHousing --Where PropertyAddress is null
Order By ParcelID

-- Populating the PropertyAddress column where it's null using data from other rows with the same ParcelID

Select
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress,
    ISNULL(
        a.PropertyAddress,
        b.PropertyAddress
    )
From
    PortfolioProject.dbo.NashvilleHousing a
    JOIN PortfolioProject.dbo.NashvilleHousing b On a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET
    PropertyAddress = ISNULL(
        a.PropertyAddress,
        b.PropertyAddress
    )
From
    PortfolioProject.dbo.NashvilleHousing a
    JOIN PortfolioProject.dbo.NashvilleHousing b On a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Splitting the PropertyAddress column into separate columns for Address, City, and State

Select PropertyAddress
From
    PortfolioProject.dbo.NashvilleHousing --Where PropertyAddress is null
    --Order By ParcelID

-- Using the SUBSTRING and CHARINDEX functions to extract the address and city from the PropertyAddress column

SELECT
    SUBSTRING(
        PropertyAddress,
        1,
        CHARINDEX(',', PropertyAddress) - 1
    ) as Address,
    SUBSTRING(
        PropertyAddress,
        CHARINDEX(',', PropertyAddress) + 1,
        Len(PropertyAddress)
    ) as Address
From PortfolioProject.dbo.NashvilleHousing

-- Adding new columns to store the split address and city

ALTER TABLE NashvilleHousing Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set
    PropertySplitAddress = SUBSTRING(
        PropertyAddress,
        1,
        CHARINDEX(',', PropertyAddress) - 1
    )

ALTER TABLE NashvilleHousing Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set
    PropertySplitCity = SUBSTRING(
        PropertyAddress,
        CHARINDEX(',', PropertyAddress) + 1,
        Len(PropertyAddress)
    )

Select * From PortfolioProject.dbo.NashvilleHousing 

-- Splitting the OwnerAddress column into separate columns for Address, City, and State

Select OwnerAddress From PortfolioProject.dbo.NashvilleHousing 

-- Using the PARSENAME function to extract the address, city, and state from the OwnerAddress column

Select PARSENAME(
        Replace
(OwnerAddress, ',', '.'),
            3
    ),
    PARSENAME(
        Replace
(OwnerAddress, ',', '.'),
            2
    ),
    PARSENAME(
        Replace
(OwnerAddress, ',', '.'),
            1
    )
From PortfolioProject.dbo.NashvilleHousing

-- Adding new columns to store the split address, city, and state

ALTER TABLE NashvilleHousing Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set
    OwnerSplitAddress = PARSENAME(
        Replace
(OwnerAddress, ',', '.'),
            3
    )

ALTER TABLE NashvilleHousing Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(
        Replace
(OwnerAddress, ',', '.'),
            2
    )

ALTER TABLE NashvilleHousing Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set
    OwnerSplitState = PARSENAME(
        Replace
(OwnerAddress, ',', '.'),
            1
    )

Select * From PortfolioProject.dbo.NashvilleHousing 

-- Changing the values of the SoldAsVacant column from Y and N to Yes and No

SELECT
    Distinct(SoldAsVacant),
    Count(SoldAsVacant)
From
    PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

-- Using a CASE statement to change the values

Select
    SoldAsVacant,
    CASE
        When SoldAsVacant = 'Y' Then 'Yes'
        When SoldAsVacant = 'N' Then 'No'
        ELSE SoldAsVacant
    END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET
    SoldAsVacant = CASE
        When SoldASVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'Y' Then 'Yes'
        When SoldAsVacant = 'N' Then 'No'
        ELSE SoldAsVacant
    END

-- Removing duplicates from the NashvilleHousing table using the ROW_NUMBER() function

WITH RowNumCTE AS(
        Select
            *,
            ROW_NUMBER() OVER (
                PARTITION BY ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY
                    UniqueID
            ) row_num
        From
            PortfolioProject.dbo.NashvilleHousing -- order by ParcelID
    )
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

SELECT * From PortfolioProject.dbo.NashvilleHousing 

-- Deleting unused columns from the NashvilleHousing table

Select * From PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE
    PortfolioProject.dbo.NashvilleHousing DROP COLUMN OwnerAddress,
    TaxDistrict,
    PropertyAddress

ALTER TABLE
    PortfolioProject.dbo.NashvilleHousing DROP COLUMN SaleDate