--      3-misol
create table Products (
productid int primary key,
productname varchar(50),
price decimal(10, 2)
)


--		4-misol

insert into Products (productID, productName, price)
values (1, 'Laptop', 1200.00),
       (2, 'Smartphone', 850.50),
	   (3, 'Headphones', 150.99)
	 


--      6-misol

alter table Products
add constraint product_unique_name unique (productName)



--		8-misol

create table Categories (
    CategoryID int primary key,
    CategoryName varchar(100) unique
)




--		10-misol

create table Customers (
customer_id int,
cust_name varchar(50),
city varchar(50),
grade int,
salesman_id int
)


bulk insert [dbo].[Customers]
from 'C:\Users\Abbos\Desktop\a\Customers.csv'
with (
firstrow =2,
rowterminator = '\n',
fieldterminator =','
)



--		11-misol

alter table Products
add CategoryID int

alter table Products
add constraint Products_FK
foreign key (CategoryID) references Categories(CategoryID)


--		13-misol
alter table Products
add constraint CHK_Price
check (price > 0)



--		14-misol

alter table Products
add Stock int NOT NULL default 0


--		15-misol

SELECT 
    productid,
    productname,
    ISNULL(CategoryID, 0) as natija
FROM Products



--		17-misol

create table Custs (
    CustID int primary key,
    FullName varchar(100) NOT NULL,
    Age int NOT NULL,
    Email varchar(100),
    constraint CHK_Age check (Age >= 18)
)



--		18-misol


create table Orders (
    OrderID int identity(100, 10) primary key,
    CustomerName varchar(100)
)

insert into Orders (CustomerName) values ('Ali'),('Vali')



--		19-misol

CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    Productid INT NOT NULL,
    Quantity INT,
    Price DECIMAL(10, 2),
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, Productid)
)



--		21-misol

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Position VARCHAR(50),
    HireDate DATE
)


--		22-misol

CREATE TABLE Customer (
    CustID INT PRIMARY KEY,
    CustName VARCHAR(100)
)

CREATE TABLE Orders2 (
    OrderID INT PRIMARY KEY,
    CusteID INT,
    CONSTRAINT FK_Customer_Order
        FOREIGN KEY (CusteID)
        REFERENCES Customer(CustID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
