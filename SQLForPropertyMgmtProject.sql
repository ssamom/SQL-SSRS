SELECT	po.OwnerId, p.Id AS PropertyId,
		p.Name AS PropertyName
FROM [dbo].[Property] p
JOIN [dbo].[OwnerProperty] po ON p.Id = po.PropertyId
WHERE (po.OwnerId = 1426) AND (p.IsActive = 1)


SELECT	p.Id AS PropertyId,
		p.Name AS PropertyName,
		pv.Value AS PropertyValue
FROM [dbo].[Property] p
JOIN [dbo].[OwnerProperty] po ON p.Id = po.PropertyId
JOIN [dbo].[PropertyHomeValue] pv ON p.Id = pv.PropertyId
WHERE (po.OwnerId = 1426) AND (p.IsActive = 1) AND (pv.IsActive = 1)

WITH PropertyByOwnerId
AS
(
	SELECT	p.Id AS PropertyId,
			p.Name AS PropertyName
	FROM [dbo].[Property] p
	JOIN [dbo].[OwnerProperty] po ON p.Id = po.PropertyId
	WHERE (po.OwnerId = 1426) AND (p.IsActive = 1)
)
SELECT	p.PropertyId AS PropertyId,
		p.PropertyName AS PropertyName,
		tp.PaymentFrequencyId AS PaymentFrequencyId,
		FORMAT (tp.StartDate,'dd-MM-yyyy') AS StartDate,
		FORMAT (tp.EndDate,'dd-MM-yyyy') AS EndDate,
		CASE
			WHEN tp.PaymentFrequencyId = 1 THEN CONVERT(DECIMAL(10,2),tp.PaymentAmount * DATEDIFF(week, StartDate, EndDate))
			WHEN tp.PaymentFrequencyId = 2 THEN CONVERT(DECIMAL(10,2),tp.PaymentAmount * DATEDIFF(week, StartDate, EndDate)/2)
			ELSE CONVERT(DECIMAL(10,2),tp.PaymentAmount * (DATEDIFF(month, StartDate, EndDate)+1))
		END AS PaymentAmount,
		CONVERT(Decimal(10,2),(PaymentAmount - pe.Amount)/pf.CurrentHomeValue*100) AS Yield
FROM PropertyByOwnerId p
JOIN [dbo].[TenantProperty] tp ON p.PropertyId = tp.PropertyId
JOIN [dbo].[PropertyFinance] pf ON p.PropertyId = tp.PropertyId
JOIN [dbo].[PropertyExpense] pe ON p.PropertyId = pe.PropertyId
WHERE tp.IsActive = 1


WITH PropertyByOwnerId
AS
(
	SELECT	p.Id AS PropertyId,
			p.Name AS PropertyName
	FROM [dbo].[Property] p
	JOIN [dbo].[OwnerProperty] po ON p.Id = po.PropertyId
	WHERE (po.OwnerId = 1426) AND (p.IsActive = 1)
)
SELECT  p.PropertyName AS PropertyName,
		per.FirstName AS FirstName,
		per.LastName AS LastName,
		tp.PaymentAmount AS RentalPayments,
		pf.Name AS Frequency
FROM PropertyByOwnerId p
JOIN [dbo].[TenantProperty] tp ON p.PropertyId = tp.PropertyId
JOIN [dbo].[Person] per ON tp.TenantId = per.Id
JOIN [dbo].[TenantPaymentFrequencies] pf ON tp.PaymentFrequencyId = pf.Id
WHERE tp.IsActive = 1


--FORMAT(@test, '#0.##') 


SELECT * 
FROM [dbo].[Job] j
JOIN [dbo].[JobStatus] js
ON j.JobStatusId = js.Id
WHERE js.Status = 'Open'

SELECT (DATEDIFF(week,'2018-01-01','2018-12-31'))

SELECT * 
FROM [dbo].[Job] j
JOIN [dbo].[JobStatus] js
ON j.JobStatusId = js.Id
WHERE js.Status = 'Open'

WITH PropertyByOwnerId
AS
(
	SELECT	p.Id AS PropertyId,
			p.Name AS PropertyName,
			po.OwnerId AS OwnerId
	FROM [dbo].[Property] p
	JOIN [dbo].[OwnerProperty] po ON p.Id = po.PropertyId
	WHERE (po.OwnerId = 1426) AND (p.IsActive = 1)
)
SELECT	p.PropertyId AS PropertyId,
		p.PropertyName AS PropertyName,
		p.OwnerId,
		tp.PaymentFrequencyId AS PaymentFrequencyId,
		FORMAT (tp.StartDate,'dd-MM-yyyy') AS StartDate,
		FORMAT (tp.EndDate,'dd-MM-yyyy') AS EndDate,
		CASE
			WHEN tp.PaymentFrequencyId = 1 THEN CONVERT(DECIMAL(10,2),tp.PaymentAmount * DATEDIFF(week, StartDate, EndDate))
			WHEN tp.PaymentFrequencyId = 2 THEN CONVERT(DECIMAL(10,2),tp.PaymentAmount * DATEDIFF(week, StartDate, EndDate)/2)
			ELSE CONVERT(DECIMAL(10,2),tp.PaymentAmount * (DATEDIFF(month, StartDate, EndDate)+1))
		END AS PaymentAmount,
		CASE
			WHEN pf.CurrentHomeValue = 0 THEN NULL
			ELSE CONVERT(Decimal(10,2),(PaymentAmount - pe.Amount)/pf.CurrentHomeValue*100)
		END AS Yield
FROM PropertyByOwnerId p
JOIN [dbo].[TenantProperty] tp ON p.PropertyId = tp.PropertyId
JOIN [dbo].[PropertyFinance] pf ON p.PropertyId = tp.PropertyId
JOIN [dbo].[PropertyExpense] pe ON p.PropertyId = pe.PropertyId
WHERE tp.IsActive = 1

