
-------------------------------------------		HOMEWORK 18  --------------------------

-- task 1

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

CREATE TABLE #MonthlySales (
    ProductID INT,
    ProductName VARCHAR(100),
    TotalQuantity INT,
    TotalRevenue DECIMAL(18,2)
);

INSERT INTO #MonthlySales (ProductID, ProductName, TotalQuantity, TotalRevenue)
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE 
    MONTH(s.SaleDate) = MONTH(GETDATE()) AND
    YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY p.ProductID, p.ProductName;

-- task 2

CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    ISNULL(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price;


-- task 3

CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2)

    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    INNER JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID

    RETURN ISNULL(@TotalRevenue, 0)
END;

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS RevenueForProduct1;


-- task 4

CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT
        SUM(s.Quantity) AS SumQuantity,
        SUM(p.Price * s.Quantity) AS TotalRevenue
    FROM Sales s
    INNER JOIN Products p ON s.ProductID = p.ProductID
    WHERE p.Category = @Category;


	SELECT * FROM fn_GetSalesByCategory('Electronics');

-- task 5

CREATE FUNCTION FN_TUB (@Number INT)
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime INT = 1;
	declare @status varchar(30)
    IF @Number < 2
        SET @IsPrime = 0;
    ELSE
    BEGIN
        WHILE @i < @Number
        BEGIN
            IF @Number % @i = 0
            BEGIN
                SET @IsPrime = 0;
                BREAK;
            END
            SET @i = @i + 1;
        END
    END

    IF @IsPrime = 1
        set @status = 'Yes'
    ELSE
        set @status =  'No'
	return @status
END


SELECT dbo.FN_TUB(23)

-- task 6

CREATE FUNCTION fn_GetNumbersBetween 
(
    @Start INT,
    @End INT
)
RETURNS @Numbers TABLE
(
    Number INT
)
AS
BEGIN
    DECLARE @Current INT = @Start;

    WHILE @Current <= @End

        SET @Current = @Current + 1;
    END

    RETURN;
    BEGIN
        INSERT INTO @Numbers (Number)
        VALUES (@Current);
END

SELECT * FROM dbo.fn_GetNumbersBetween(5, 10);

-- task 7

CREATE TABLE Employee
(
    id INT PRIMARY KEY,
    salary INT
);

INSERT INTO Employee (id, salary) VALUES
(1, 100),
(2, 200),
(3, 300);

DECLARE @N INT = 2;  

SELECT 
    MIN(Salary) AS NthHighestSalary
FROM (
    SELECT DISTINCT TOP (@N) Salary
    FROM Employee
    ORDER BY Salary DESC
) AS TopSalaries;

-- 1-chi eng yuqori
DECLARE @N INT = 1;
SELECT MIN(Salary) FROM (SELECT DISTINCT TOP (@N) Salary FROM Employee ORDER BY Salary DESC) AS TopSalaries;

-- 2-chi eng yuqori
DECLARE @N INT = 2;
SELECT MIN(Salary) FROM (SELECT DISTINCT TOP (@N) Salary FROM Employee ORDER BY Salary DESC) AS TopSalaries;

-- 4-chi eng yuqori (mavjud emas => NULL)
DECLARE @N INT = 4;
SELECT MIN(Salary) FROM (SELECT DISTINCT TOP (@N) Salary FROM Employee ORDER BY Salary DESC) AS TopSalaries;


--  task 8

CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY COUNT(*) DESC;


-- task 9

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);


CREATE VIEW vw_CustomerOrderSummary AS
SELECT
    c.customer_id,
    c.name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city;


SELECT * FROM vw_CustomerOrderSummary;


-- task 10

DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);


WITH FilledCTE AS (
    -- Boshlang'ich satr (RowNumber = 1)
    SELECT
        RowNumber,
        TestCase,
        TestCase AS Workflow
    FROM Gaps
    WHERE RowNumber = 1

    UNION ALL

    -- Rekursiv qism: keyingi satrlarni oladi va NULL bo'lsa oldingi Workflow'ni qo'yadi
    SELECT
        g.RowNumber,
        g.TestCase,
        COALESCE(g.TestCase, f.Workflow) AS Workflow
    FROM Gaps g
    INNER JOIN FilledCTE f ON g.RowNumber = f.RowNumber + 1
)

SELECT RowNumber, Workflow
FROM FilledCTE
ORDER BY RowNumber
OPTION (MAXRECURSION 0);

