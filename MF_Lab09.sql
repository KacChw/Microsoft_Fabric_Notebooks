 SELECT 
     p.Name AS ProductName,
     pc.Name AS CategoryName,
     p.ListPrice
 FROM 
     SalesLT.Product p
 INNER JOIN 
     SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
 ORDER BY 
 p.ListPrice DESC;

------------------------------------------------------

SELECT 
     c.FirstName,
     c.LastName,
     soh.OrderDate,
     soh.SubTotal
 FROM 
     SalesLT.Customer c
 INNER JOIN 
     SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
 ORDER BY 
     soh.OrderDate DESC;

--------------------------------------------------------

 CREATE TABLE SalesLT.PublicHolidays (
     CountryOrRegion NVARCHAR(50),
     HolidayName NVARCHAR(100),
     Date DATE,
     IsPaidTimeOff BIT
 );

---------------------------------------------------

 INSERT INTO SalesLT.PublicHolidays (CountryOrRegion, HolidayName, Date, IsPaidTimeOff)
 VALUES
     ('Canada', 'Victoria Day', '2024-02-19', 1),
     ('United Kingdom', 'Christmas Day', '2024-12-25', 1),
     ('United Kingdom', 'Spring Bank Holiday', '2024-05-27', 1),
     ('United States', 'Thanksgiving Day', '2024-11-28', 1);

-----------------------------------------------

 -- Insert new addresses into SalesLT.Address
 INSERT INTO SalesLT.Address (AddressLine1, City, StateProvince, CountryRegion, PostalCode, rowguid, ModifiedDate)
 VALUES
     ('123 Main St', 'Seattle', 'WA', 'United States', '98101', NEWID(), GETDATE()),
     ('456 Maple Ave', 'Toronto', 'ON', 'Canada', 'M5H 2N2', NEWID(), GETDATE()),
     ('789 Oak St', 'London', 'England', 'United Kingdom', 'EC1A 1BB', NEWID(), GETDATE());
    
 -- Insert new orders into SalesOrderHeader
 INSERT INTO SalesLT.SalesOrderHeader (
     SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, 
     PurchaseOrderNumber, AccountNumber, CustomerID, ShipToAddressID, BillToAddressID, 
     ShipMethod, CreditCardApprovalCode, SubTotal, TaxAmt, Freight, Comment, rowguid, ModifiedDate
 )
 VALUES
     (1001, 1, '2024-12-25', '2024-12-30', '2024-12-26', 1, 1, 'PO12345', 'AN123', 1, (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '789 Oak St'), (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '123 Main St'), 'Ground', '12345', 100.00, 10.00, 5.00, 'New Order 1', NEWID(), GETDATE()),
     (1002, 1, '2024-11-28', '2024-12-03', '2024-11-29', 1, 1, 'PO67890', 'AN456', 2, (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '123 Main St'), (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '456 Maple Ave'), 'Air', '67890', 200.00, 20.00, 10.00, 'New Order 2', NEWID(), GETDATE()),
     (1003, 1, '2024-02-19', '2024-02-24', '2024-02-20', 1, 1, 'PO54321', 'AN789', 3, (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '456 Maple Ave'), (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '789 Oak St'), 'Sea', '54321', 300.00, 30.00, 15.00, 'New Order 3', NEWID(), GETDATE()),
     (1004, 1, '2024-05-27', '2024-06-01', '2024-05-28', 1, 1, 'PO98765', 'AN321', 4, (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '789 Oak St'), (SELECT TOP 1 AddressID FROM SalesLT.Address WHERE AddressLine1 = '789 Oak St'), 'Ground', '98765', 400.00, 40.00, 20.00, 'New Order 4', NEWID(), GETDATE());

----------------------------------------------------------

 SELECT DISTINCT soh.SalesOrderID, soh.OrderDate, ph.HolidayName, ph.CountryOrRegion
 FROM SalesLT.SalesOrderHeader AS soh
 INNER JOIN SalesLT.Address a
     ON a.AddressID = soh.ShipToAddressID
 INNER JOIN SalesLT.PublicHolidays AS ph
     ON soh.OrderDate = ph.Date AND a.CountryRegion = ph.CountryOrRegion

---------------------------------------

 CREATE VIEW SalesLT.vw_SalesOrderHoliday AS
 SELECT DISTINCT soh.SalesOrderID, soh.OrderDate, ph.HolidayName, ph.CountryOrRegion
 FROM SalesLT.SalesOrderHeader AS soh
 INNER JOIN SalesLT.Address a
     ON a.AddressID = soh.ShipToAddressID
 INNER JOIN SalesLT.PublicHolidays AS ph
     ON soh.OrderDate = ph.Date AND a.CountryRegion = ph.CountryOrRegion
 WHERE a.CountryRegion = 'United Kingdom';

----------------------------------------

 -- Create the role
 CREATE ROLE SalesOrderRole;
    
 -- Grant select permission on the view to the role
 GRANT SELECT ON SalesLT.vw_SalesOrderHoliday TO SalesOrderRole;

--------------------------

 SELECT 
     p.Name AS ProductName,
     pc.Name AS CategoryName,
     p.ListPrice
 FROM 
     SalesLT.Product p
 INNER JOIN 
     SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
 ORDER BY 
 p.ListPrice DESC;
