select*
from Stanovi

-- Prepravka adrese, popunjavanje null vrijednosti

select *
from Stanovi
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from Stanovi a
join Stanovi b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set a.PropertyAddress = b.PropertyAddress
from Stanovi a
join Stanovi b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Podjela adrese u vise kolona na adresu, grad i drzavu (substring)

select PropertyAddress
from Stanovi

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as City
from Stanovi

alter table Stanovi
Add Address nvarchar(255)

update Stanovi
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

alter table Stanovi
Add City nvarchar(255)

update Stanovi
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

select address, city
from Stanovi

-- Podjela adrese u vise kolona na adresu, grad i drzavu (parsename)

select
PARSENAME(replace(OwnerAddress, ',','.'),3) as Address,
PARSENAME(replace(OwnerAddress, ',','.'),2) as City,
PARSENAME(replace(OwnerAddress, ',','.'),1) as State
from Stanovi

alter table Stanovi
Add State nvarchar(255)

update Stanovi
set State = PARSENAME(replace(OwnerAddress, ',','.'),1)

select State
from Stanovi

select *
from Stanovi

--Promjena skracenice u punu rijec (CASE)

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Stanovi
Group by SoldAsVacant


Select SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From Stanovi

Update Stanovi
SET SoldAsVacant = CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From Stanovi

Select SoldAsVacant
From Stanovi

-- Brisanje duplih podataka

Select *
From Stanovi

With RowNumCTE as (
Select *,
	ROW_NUMBER() 
	OVER (Partition by
					ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by
					UniqueID ) row_num
From Stanovi
)


select *
From RowNumCTE
WHERE row_num > 1

Delete 
From RowNumCTE
WHERE row_num > 1

select *
From RowNumCTE
WHERE row_num > 1

-- Brisanje kolona

ALTER TABLE Stanovi
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

Select *
From Stanovi