
Select *
From MyPortfolioProject ..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardizing Date Format(removig the time)


Select SaleDate, CONVERT(Date,SaleDate) as ConvertedDate
From MyPortfolioProject ..NashvilleHousing



ALTER TABLE MyPortfolioProject ..NashvilleHousing
Add ConvertedDate Date;

Update MyPortfolioProject ..NashvilleHousing
SET ConvertedDate = CONVERT(Date,SaleDate)
----------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From MyPortfolioProject..NashvilleHousing
Where PropertyAddress is not null
--order by ParcelID



Select a.ParcelID, b.PropertyAddress, a.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
From MyPortfolioProject..NashvilleHousing a
JOIN MyPortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From MyPortfolioProject..NashvilleHousing a
JOIN MyPortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From MyPortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From MyPortfolioProject..NashvilleHousing

ALTER TABLE MyPortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(200)

Update MyPortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE MyPortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(200);

Update MyPortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From MyPortfolioProject..NashvilleHousing





Select OwnerAddress
From MyPortfolioProject..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From MyPortfolioProject..NashvilleHousing



ALTER TABLE MyPortfolioProject..NashvilleHousing 
Add OwnerSplitAddress Nvarchar(100);

Update MyPortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE MyPortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(150);

Update MyPortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE MyPortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update MyPortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From MyPortfolioProject.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From MyPortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2 desc




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From MyPortfolioProject.dbo.NashvilleHousing


Update MyPortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

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

From MyPortfolioProject..NashvilleHousing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


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

From MyPortfolioProject..NashvilleHousing
)

delete
From RowNumCTE
Where row_num > 1
 



Select *
From MyPortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From MyPortfolioProject.dbo.NashvilleHousing


ALTER TABLE myPortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate,saledateConverted




























