
---------------------------------  HOMEWORK 20  --------------------------------


CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

-- task 1

select 
	s1.CustomerName,
	s1.SaleDate
from #Sales s1

where Exists (
	select 1
	from #Sales s2
	where s1.SaleID = s2.SaleID and 
		  month(s1.SaleDate) = 3
		  )

-- task 2

SELECT 
	Product,

FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT Product, SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS Revenues
);

-- task 3

SELECT *
FROM #Sales AS S1
WHERE 2 = (
    SELECT COUNT(*) 
    FROM #Sales AS S2
    WHERE S2.Product = S1.Product
      AND S1.Quantity * S1.Price <= S2.Quantity * S2.Price
)
ORDER BY S1.Product, S1.Quantity * S1.Price;

-- task 4

SELECT DISTINCT
    DATENAME(MONTH, SaleDate) AS SaleMonth,
    DATENAME(YEAR, SaleDate)  AS SaleYear,
    (
        SELECT SUM(S.Quantity)
        FROM #Sales AS S
        WHERE YEAR(S.SaleDate) = YEAR(S1.SaleDate)
          AND MONTH(S.SaleDate) = MONTH(S1.SaleDate)
    ) AS TotalQuantity
FROM #Sales AS S1
ORDER BY SaleYear, SaleMonth;

-- task 5

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName <> s2.CustomerName
      AND s1.Product = s2.Product
);

-- task 6

create table Fruits(Name varchar(50), Fruit varchar(50))

insert into Fruits 
values
	('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), 
	('Francesko', 'Orange'),('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
	('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
	('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), ('Mario', 'Orange')

SELECT 
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name
ORDER BY Name;


-- task 7

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

WITH cte AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT a.ParentId, f.ChildID
    FROM cte a
    JOIN Family f ON a.ChildID = f.ParentId
)
SELECT * FROM cte
ORDER BY ParentId, ChildID;


-- task 8

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

SELECT *
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders o2
      WHERE o2.CustomerID = o.CustomerID
        AND o2.DeliveryState = 'CA'
  );


-- task 9

create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

select resid, address,
case 
  when address like '%name%' then address
  else 
    address + 'name=' + fullname
  end
from #residents 

update #residents set address = address + 'name='+ fullname 
where fullname not like '%name=%'


-- task 10

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

select * from  #Routes
go
select * from  #Routes
;with bekat1 as (
select * from #Routes
where DepartureCity = 'Tashkent')
select CONCAT(bekat1.DepartureCity,'-',bekat2.ArrivalCity,'-',bekat3.ArrivalCity,'-',bekat4.ArrivalCity) from bekat1
join #Routes as bekat2 on bekat1.ArrivalCity = bekat2.DepartureCity
join #Routes as bekat3 on bekat2.ArrivalCity = bekat3.DepartureCity
left join #Routes as bekat4 on bekat3.ArrivalCity = bekat4.DepartureCity



select route,cost from (
select *,MAX(cost) over() as max_val,min(cost) over() as min_val from (
select concat(bekat1.DepartureCity,'-',bekat1.ArrivalCity,'-',bekat2.ArrivalCity,'-',bekat3.ArrivalCity,'-',bekat4.ArrivalCity) as route,
		bekat1.cost + bekat2.Cost + isnull(bekat3.Cost,0) + isnull(bekat4.Cost,0) as cost from (
select * from #Routes 
where DepartureCity = 'Tashkent') as  bekat1
join #Routes as bekat2 on bekat1.ArrivalCity = bekat2.DepartureCity
left join #Routes as bekat3 on bekat2.ArrivalCity = bekat3.DepartureCity
left join #Routes as bekat4 on bekat3.ArrivalCity = bekat4.DepartureCity) as A) as B
where B.cost = B.max_val or B.cost = B.min_val


-- task 11

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')


WITH Markers AS (
    SELECT *,
           SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS GroupNum
    FROM #RankingPuzzle
),
ProductsOnly AS (
    SELECT Vals, GroupNum
    FROM Markers
    WHERE Vals <> 'Product'
),
FinalRanking AS (
    SELECT DISTINCT Vals, GroupNum
    FROM ProductsOnly
)
SELECT 
    Vals,
    RANK() OVER (ORDER BY MIN(GroupNum)) AS ProductRank
FROM FinalRanking
GROUP BY Vals;

-- task 12

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);


SELECT *
FROM #EmployeeSales E
WHERE E.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = E.Department
);


-- task 13

SELECT E1.*
FROM #EmployeeSales E1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales E2
    WHERE E1.SalesMonth = E2.SalesMonth
      AND E1.SalesYear = E2.SalesYear
    GROUP BY E2.SalesMonth, E2.SalesYear
    HAVING E1.SalesAmount = MAX(E2.SalesAmount)
);


-- task 14

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);


WITH DistinctMonths AS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales
)

SELECT DISTINCT E1.EmployeeName
FROM #EmployeeSales E1
WHERE NOT EXISTS (
    SELECT 1
    FROM DistinctMonths M
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales E2
        WHERE E2.EmployeeName = E1.EmployeeName
          AND E2.SalesMonth = M.SalesMonth
    )
);


-- task 15

SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);


-- task 16

SELECT Name 
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products)


-- task 17

SELECT Name
FROM Products

WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop')

-- task 18

SELECT Name
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics')


-- task 19

SELECT p1.Name
FROM Products p1
WHERE p1.Price > (SELECT AVG(p2.Price) FROM Products p2 WHERE p1.Category = p2.Category)

-- task 20

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');


SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

-- task 21

SELECT Name
FROM Products p
JOIN 
Orders o ON p.ProductID = o.ProductID
WHERE o.Quantity > (SELECT AVG(Quantity) FROM Orders)

-- task 22

SELECT p.Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-- task 23

SELECT TOP 1 
	p.Name, 
	SUM(o.Quantity) AS TotalOrdered
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY TotalOrdered DESC;


