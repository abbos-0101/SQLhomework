
-------------------------   HOMEWORK 17   -------------------------

-- task 1

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);


-- Barcha noyob distributorlardan va hududlardan kombinatsiya hosil qilamiz
WITH AllCombos AS (
    SELECT r.Region, d.Distributor
    FROM (SELECT DISTINCT Region FROM #RegionSales) r
    CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
)
SELECT 
    a.Region,
    a.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM AllCombos a
LEFT JOIN #RegionSales rs
    ON a.Region = rs.Region AND a.Distributor = rs.Distributor
ORDER BY a.Distributor, a.Region;

-- task 2

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT 
    m.id AS ManagerID,
    m.Name AS ManagerName,
    COUNT(e.id) AS DirectReportCount
FROM Employee e
JOIN Employee m ON e.ManagerID = m.id
GROUP BY m.id, m.Name
HAVING COUNT(e.id) >= 5;

-- task 3

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

select
	Products.product_name,
	Sum(unit) as sumunit
from Orders
join Products on Products.product_id = Orders.product_id
where Month(Orders.order_date) = 2 
Group by Products.product_name
Having Sum(unit) >= 100

-- task 4

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

WITH VendorCounts AS (
    SELECT 
        CustomerID,
        Vendor,
        COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID, Vendor
),
MaxVendor AS (
    SELECT 
        CustomerID,
        MAX(OrderCount) AS MaxCount
    FROM VendorCounts
    GROUP BY CustomerID
)
SELECT 
    vc.CustomerID,
    vc.Vendor,
    vc.OrderCount
FROM VendorCounts vc
JOIN MaxVendor mv
  ON vc.CustomerID = mv.CustomerID AND vc.OrderCount = mv.MaxCount
ORDER BY vc.CustomerID;


-- task 5

DECLARE @Check_Prime INT = 29;  -- bu yerda istalgan sonni yozing
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;

IF @Check_Prime < 2
    SET @IsPrime = 0;
ELSE
BEGIN
    WHILE @i <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

-- task 6

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');


WITH LocationSignalCount AS (
    SELECT 
        Locations,
        COUNT(*) AS TotalSignals
    FROM Device
    GROUP BY Locations
),
DeviceSignalCount AS (
    SELECT 
        Device_id,
        COUNT(*) AS TotalDeviceSignals
    FROM Device
    GROUP BY Device_id
)
SELECT 
    (SELECT COUNT(DISTINCT Locations) FROM Device) AS NumberOfLocations,  -- joylar soni
    (SELECT TOP 1 Locations FROM LocationSignalCount ORDER BY TotalSignals DESC) AS LocationMostSignalsSent,  -- eng ko'p signal yuborilgan joy
    d.Device_id,
    d.TotalDeviceSignals
FROM DeviceSignalCount d;

-- task 7

drop table Employee
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

SELECT EmpID, EmpName, Salary
FROM Employee e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);



-- task 8

create table Numbers (
	Number int
	)

insert into Numbers values (25),(45),(78)

create table Tickets (
	Ticket_id varchar(50),
	Number int
	)

insert into Tickets 
values 
('A23423', 25), ('A23423', 45), ('A23423', 78),
('B35643', 25), ('B35643', 45), ('B35643', 98),
('C98787', 67), ('C98787', 86), ('C98787', 91)


-- Har bir ticket bo'yicha nechta to'g'ri raqam borligini aniqlaymiz
WITH TicketMatches AS (
    SELECT 
        t.Ticket_id,
        COUNT(*) AS MatchingNumbers
    FROM Tickets t
    JOIN Numbers n ON t.Number = n.Number
    GROUP BY t.Ticket_id
),
-- Har bir chiptadagi yutuqli holatni aniqlaymiz
Winnings AS (
    SELECT 
        t.Ticket_id,
        CASE 
            WHEN tm.MatchingNumbers = (SELECT COUNT(*) FROM Numbers) THEN 100
            WHEN tm.MatchingNumbers > 0 THEN 10
            ELSE 0
        END AS Prize
    FROM (SELECT DISTINCT Ticket_id FROM Tickets) t
    LEFT JOIN TicketMatches tm ON t.Ticket_id = tm.Ticket_id
)
-- Har bir chiptaning yutug'ini ko'rsatish
SELECT * FROM Winnings;

-- Umumiy yutuqni hisoblash
SELECT SUM(Prize) AS Total_Winnings FROM Winnings;


-- task 9

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);


WITH DeviceUsage AS (
    SELECT
        user_id,
        spend_date,
        MAX(CASE WHEN platform = 'Mobile' THEN 1 ELSE 0 END) AS used_mobile,
        MAX(CASE WHEN platform = 'Desktop' THEN 1 ELSE 0 END) AS used_desktop,
        SUM(amount) AS total_spent
    FROM Spending
    GROUP BY user_id, spend_date
)
SELECT
    spend_date,

    -- Faqat mobil foydalanuvchilar
    COUNT(CASE WHEN used_mobile = 1 AND used_desktop = 0 THEN 1 END) AS mobile_only_users,
    SUM(CASE WHEN used_mobile = 1 AND used_desktop = 0 THEN total_spent END) AS mobile_only_amount,

    -- Faqat desktop foydalanuvchilar
    COUNT(CASE WHEN used_mobile = 0 AND used_desktop = 1 THEN 1 END) AS desktop_only_users,
    SUM(CASE WHEN used_mobile = 0 AND used_desktop = 1 THEN total_spent END) AS desktop_only_amount,

    -- Ikkalasini ham ishlatgan foydalanuvchilar
    COUNT(CASE WHEN used_mobile = 1 AND used_desktop = 1 THEN 1 END) AS both_users,
    SUM(CASE WHEN used_mobile = 1 AND used_desktop = 1 THEN total_spent END) AS both_amount

FROM DeviceUsage
GROUP BY spend_date
ORDER BY spend_date;

-- task 10

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

WITH Numbers AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects  -- bu tez raqamlar generatori
)
SELECT g.Product, 1 AS Quantity
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product;



