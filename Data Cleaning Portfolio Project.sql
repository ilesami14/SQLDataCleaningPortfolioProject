/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject..NashvilleHousing

-- Standardize Date Format

select SaleDate, convert(date, SaleDate) as SaleDateConverted
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, SaleDate)


alter table NashvilleHousing
alter column SaleDate Date


-- Populate Property Address Data

select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address Into Individual Column (Address, City, State)


select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress))



select *
from PortfolioProject..NashvilleHousing





select OwnerAddress
from PortfolioProject..NashvilleHousing




select
PARSENAME(replace(OwnerAddress, ',','.') ,3),
PARSENAME(replace(OwnerAddress, ',','.') ,2),
PARSENAME(replace(OwnerAddress, ',','.') ,1)
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.') ,3)


alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.') ,2)


alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.') ,1)





select *
from PortfolioProject..NashvilleHousing


-- Change Y and N to Yes and No in " Sold as Vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end




-- Remove Duplicates

with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
					UniqueID
					) row_num

from PortfolioProject..NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress



-- Delete Unused Columns

select *
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table PortfolioProject..NashvilleHousing
drop column SaleDateConverted