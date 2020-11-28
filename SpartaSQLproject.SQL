	-- 1
	
	SELECT c.CustomerID , c.CompanyName , c.Address , c.PostalCode , c.City , c.Country  
	  
	 FROM Customers c  
	  
	 WHERE c.City IN ('Paris' , 'London')



-- 2

    SELECT *  
	  
	FROM Products p  
	  
	WHERE p.QuantityPerUnit LIKE '%Bottle%'


-- 3

	SELECT p.ProductName , s.CompanyName , s.Country  
	  
	FROM Products p   
	  
	INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID  
	  
	WHERE p.QuantityPerUnit LIKE '%Bottle%'

--4



	SELECT c.CategoryName , COUNT(c.CategoryID) AS "Category Count"  
	  
	FROM Products p  
	  
	INNER JOIN Categories c ON p.CategoryID = c.CategoryID  
	  
	GROUP BY c.CategoryName , c.CategoryID  
	  
	ORDER BY COUNT(c.CategoryID) DESC


-- 5



    	SELECT CONCAT(e.TitleOfCourtesy, + ' ' + e.FirstName + ' ' + e.LastName) AS "Employee Description"  
	, e.City  
	  
	  
	FROM Employees e  
	  
	WHERE e.Country IN ('UK')



-- 6


	SELECT rr.RegionID, rr.RegionDescription AS Region,    
	  
	FORMAT(SUM((UnitPrice * Quantity) * (1-Discount)),'C')    
	  
	AS "Regional Sales"   
	    FROM Orders AS o   
	    INNER JOIN [Order Details] AS od ON od.OrderID = o.OrderID   
	    INNER JOIN EmployeeTerritories AS et ON o.EmployeeID = et.EmployeeID   
	    INNER JOIN Territories AS t ON et.TerritoryID = t.TerritoryID   
	    INNER JOIN Region AS rr ON t.RegionID = rr.RegionID   
	    GROUP BY rr.RegionDescription, rr.RegionID   
	    HAVING SUM((UnitPrice * Quantity) * (1-Discount))  > 1
	    ORDER BY "Regional Sales" DESC;

-- 7



	SELECT COUNT(oo.OrderID) AS "Order count"  
	  
	FROM Orders oo   
	  
	WHERE oo.Freight > 100 AND oo.ShipCountry IN ('USA' , 'UK')


-- 8


	SELECT oo.Orderid AS "Order ID's",    
	  
	FORMAT((oo.UnitPrice * oo.Quantity) * oo.Discount,'C') AS "Total Discount added"   
	  
	   FROM [Order Details] oo  
	  
	   WHERE (oo.UnitPrice * oo.Quantity * oo.Discount) =   
	  
	   (SELECT MAX((oo.UnitPrice * oo.Quantity) * oo.Discount)  
	  
	   FROM [Order Details] oo) 


-- Exercise 2

DROP TABLE IF EXISTS Spartans;

-- 2.1 Write the correct SQL statement to create the following table:

CREATE TABLE Spartans (
    spartan_id INT IDENTITY PRIMARY KEY,
    title VARCHAR(5),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    university VARCHAR(50),
    course VARCHAR(50),
    mark VARCHAR(30)
)

-- 2.2 Write SQL statements to add the details of the Spartans in your course to the table you have created.

INSERT INTO Spartans VALUES 
('Mr', 'Svilen', 'Petrov', 'London Metropolitan University', 'BSc Computing', 'First'),
('Ms', 'Janja', 'Kovacevic', 'University of Massachusetts Amherst', 'Computer Science and Computational Mathematics', '3.9'),
('Mr', 'Shahid', 'Enayat', 'Brunel University', 'Electronic and Electrical Engineering', '2:2'),
('Mr', 'Dami', 'Oshidele', 'King''s College London', 'Electronic Engineering with Management', '2:1'),
('Mr', 'Chris', 'Cunningham', 'Loughborough', 'Computer Science', '2:1'),
('Mr', 'Ben', 'Swift', 'Nottingham Trent University', 'Computer Science', '2:1'),
('Mr', 'Toyin', 'Ajani', 'University Of Bath', 'Chemical engineering', 'First'),
('Mr', 'Reece', 'Louch', 'University Of Warwick', 'Computer Science', '2:2'),
('Mr', 'Saleh', 'Sandhu', 'University Of Westminister', 'Computer Science', '2:1');

-- SELECT * FROM Spartans;

-- 3.1 List all Employees from the Employees table and who they report to.
SELECT CONCAT (ee.FirstName + ' ' + ee.LastName) AS "Employee" , ee.ReportsTo , CONCAT (eee.FirstName + ' ' , +  eee.LastName)AS " Reports To "
FROM Employees ee
INNER JOIN Employees eee ON ee.ReportsTo = eee.EmployeeID
ORDER BY ee.ReportsTo

-- 3.2 List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart
SELECT ss.CompanyName , FORMAT (SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) , 'C') AS " Total Net Sales "
FROM [Order Details] od
INNER JOIN Products pp ON od.ProductID = pp.ProductID
INNER JOIN [Suppliers] ss ON pp.SupplierID = ss.SupplierID
GROUP BY ss.CompanyName
HAVING SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) > 10000
ORDER BY "Total Net Sales" DESC

-- 3.3 List the Top 10 Customers YTD for the latest year in the Orders file. Based on total value of orders shipped. 
SELECT TOP 10 c.CompanyName AS "Customer ID ",cc.CompanyName AS "Company Name",
FORMAT (SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) , 'C') 
AS "Year to date sales"
FROM Customers cc 
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE (YEAR(OrderDate) = (SELECT MAX(YEAR(OrderDate))
    FROM Orders ))
AND o.ShippedDate IS NOT NULL
GROUP BY cc.CustomerID
ORDER BY SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) DESC

-- 3.4 Plot the Average Ship Time by month for all data in the Orders Table using a line chart as below.
SELECT FORMAT(o.OrderDate, 'MMMM') AS "Month", YEAR(o.OrderDate) AS "Year", AVG(DATEDIFF(d, o.OrderDate, o.ShippedDate)) AS "Average Ship Time (Days)"
FROM Orders o 
GROUP BY FORMAT(o.OrderDate, 'MMMM'), YEAR(o.OrderDate)
ORDER BY "Year", DATEPART(MM, FORMAT(o.OrderDate, 'MMMM')+'01 1900')

