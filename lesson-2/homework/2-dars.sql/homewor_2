CREATE DATABASE Homework_2
use Homework_2


create table Employees (
	EmpID int primary key,
	Name varchar(50),
	Salary decimal(10,2)
	)

insert into Employees (EmpID, Name, Salary)
values  (1, 'Sardor', 100)

insert into Employees (EmpID, Name, Salary)
values  (2, 'Ali', 101)

insert into Employees (EmpID, Name, Salary)
values  (3, 'Diyor', 102)

UPDATE Employees
SET Salary = 3000
WHERE EmpID = 1


delete from Employees
where EmpID = 2

alter table Employees
alter column Name varchar(100)

alter table Employees
ADD Department VARCHAR(50)

select * from Employees

alter table Employees
alter column Salary float

create table Departments (
	DepartId int primary key,
	DepartName varchar(50)
)

select * from Departments

truncate table Departments

INSERT INTO Departments (DepartID, DepartName)
SELECT top 5 EmpID, Name
FROM Employees

Update Employees
set Department = 'Manegment'
where Salary > 100

select * from Employees

alter table Employees
drop column Department

exec sp_rename 'Employees', 'StaffMembers'

select * from StaffMembers

drop table Departments

create table Products (
	ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    StockQuantity INT
)


alter table Products
add constraint check_price check (Price > 0)

alter table Products
add StockQuantity int default 50
--20
exec sp_rename 'Products.Category', 'ProductCatogry', 'column'

--21
INSERT INTO Products (ProductID, ProductName, ProductCatogry, Price, StockQuantity)
VALUES (1, 'Laptop', 'Electronics', 1200.00, 30);

INSERT INTO Products (ProductID, ProductName, ProductCatogry, Price, StockQuantity)
VALUES (2, 'Smartphone', 'Electronics', 800.00, 50);

INSERT INTO Products (ProductID, ProductName, ProductCatogry, Price, StockQuantity)
VALUES (3, 'Chair', 'Furniture', 150.00, 100);

INSERT INTO Products (ProductID, ProductName, ProductCatogry, Price, StockQuantity)
VALUES (4, 'Notebook', 'Stationery', 2.50, 500);

INSERT INTO Products (ProductID, ProductName, ProductCatogry, Price, StockQuantity)
VALUES (5, 'Water Bottle', 'Accessories', 10.00, 200);

--22
SELECT * INTO Products_Backup
FROM Products
--23
exec sp_rename 'Products', 'Inventory'

--24
alter table Inventory drop constraint check_price

alter table Inventory
alter column price float

--25
alter table Inventory add ProductCode int identity(1000, 5)

select * from Inventory




