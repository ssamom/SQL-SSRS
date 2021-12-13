SELECT	p.Name AS PropertyName, 
		CONCAT(per.FirstName,' ',per.LastName) AS OwnerName,
		CONCAT(a.Number,' ',a.Street) AS PropertyAddress,
		CONCAT(p.Bedroom,' ','Bedrooms',' ',p.Bathroom,' ','Bathrooms') AS PropertyDetails, 
		rp.Amount AS RentalPayment, 
		CASE	WHEN rt.Name = 'Weekly' THEN 'per week'
				WHEN rt.Name = 'Monthly' THEN 'per Month'
				WHEN rt.Name = 'Fortnightly' THEN 'per Fortnight'
		END AS FrequencyType,
		pe.Description AS Expense,
		pe.Amount AS Amount,
		FORMAT(pe.Date,'dd MMM yyyy') AS Date
FROM [dbo].[Person] per
JOIN [dbo].[OwnerProperty] po ON per.Id = po.OwnerId
JOIN [dbo].[Property] p ON po.PropertyId = p.Id
JOIN [dbo].[Address] a ON p.AddressId = a.AddressId
JOIN [dbo].[PropertyRentalPayment] rp ON p.Id = rp.PropertyId
JOIN [dbo].[TargetRentType] rt ON rp.FrequencyType = rt.Id
JOIN [dbo].[PropertyExpense] pe ON p.Id = pe.PropertyId
--WHERE p.Name = 'Property A'