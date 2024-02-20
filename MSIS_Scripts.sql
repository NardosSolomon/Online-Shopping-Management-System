CREATE TABLE Supplier (
  SupplierID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100),
  Address VARCHAR(100),
  Phone VARCHAR(20),
  Company VARCHAR(100),
  DOB DATE
);
CREATE TABLE Customer (
  CustomerID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100),
  Address VARCHAR(100),
  PhoneNumber VARCHAR(20)
);
CREATE TABLE Product (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Description TEXT,
  Price DECIMAL(10, 2),
  Category VARCHAR(50),
  StockQuantity INT,
  SupplierID INT,
  Expiry DATE,
  FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
CREATE TABLE `Order` (
  OrderID INT PRIMARY KEY,
  OrderDate DATE,
  CustomerID INT,
  TotalAmount DECIMAL(10, 2),
  Status VARCHAR(50),
  PaymentMethod VARCHAR(50),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE OrderItem (
  OrderID INT,
  ProductID INT,
  Quantity INT,
  Price DECIMAL(10, 2),
  PRIMARY KEY (OrderID, ProductID),
  FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
INSERT INTO Supplier (SupplierID, FirstName, LastName, Email, Address, Phone, Company, DOB)
VALUES
  (1, 'John', 'Doe', 'john.doe@example.com', '123 Main St', '555-1234', 'ABC Company', '1980-01-01'),
  (2, 'Jane', 'Smith', 'jane.smith@example.com', '456 Elm St', '555-5678', 'XYZ Corporation', '1985-03-15'),
  (3, 'David', 'Johnson', 'david.johnson@example.com', '789 Oak St', '555-9012', '123 Industries', '1975-07-22'),
  (4, 'Sarah', 'Williams', 'sarah.williams@example.com', '321 Pine St', '555-3456', 'XYZ Corporation', '1990-11-10'),
  (5, 'Michael', 'Brown', 'michael.brown@example.com', '654 Cedar St', '555-7890', 'ABC Company', '1988-06-05'),
  (6, 'Emily', 'Jones', 'emily.jones@example.com', '987 Walnut St', '555-2345', '789 Enterprises', '1982-09-12'),
  (7, 'Christopher', 'Davis', 'christopher.davis@example.com', '234 Maple St', '555-6789', '123 Industries', '1992-12-30');
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Address, PhoneNumber)
VALUES
  (1, 'John', 'Doe', 'john.doe@example.com', '123 Main St', '555-1234'),
  (2, 'Jane', 'Smith', 'jane.smith@example.com', '456 Elm St', '555-5678'),
  (3, 'David', 'Johnson', 'david.johnson@example.com', '789 Oak St', '555-9012'),
  (4, 'Sarah', 'Williams', 'sarah.williams@example.com', '321 Pine St', '555-3456'),
  (5, 'Michael', 'Brown', 'michael.brown@example.com', '654 Cedar St', '555-7890'),
  (6, 'Emily', 'Jones', 'emily.jones@example.com', '987 Walnut St', '555-2345'),
  (7, 'Christopher', 'Davis', 'christopher.davis@example.com', '234 Maple St', '555-6789');
INSERT INTO Product (ProductID, ProductName, Description, Price, Category, StockQuantity, SupplierID, Expiry)
VALUES
  (1, 'T-Shirt', 'Cotton t-shirt with logo print', 19.99, 'Apparel', 50, 1, '2023-12-31'),
  (2, 'Jeans', 'Denim jeans with slim fit', 49.99, 'Apparel', 30, 2, '2023-11-30'),
  (3, 'Sneakers', 'Sports shoes for running', 79.99, 'Footwear', 20, 3, '2023-10-31'),
  (4, 'Backpack', 'Water-resistant backpack for travel', 39.99, 'Accessories', 40, 4, '2024-03-31'),
  (5, 'Smartphone', 'High-performance smartphone with advanced features', 999.99, 'Electronics', 10, 5, '2024-06-30'),
  (6, 'Headphones', 'Wireless headphones with noise-cancellation', 149.99, 'Electronics', 15, 6, '2023-09-30'),
  (7, 'Watch', 'Classic wristwatch with leather strap', 199.99, 'Accessories', 25, 7, '2024-01-31');
INSERT INTO `Order` (OrderID, OrderDate, CustomerID, TotalAmount, Status, PaymentMethod)
VALUES
  (1, '2023-05-01', 1, 99.99, 'Completed', 'Credit Card'),
  (2, '2023-05-02', 2, 149.99, 'Completed', 'PayPal'),
  (3, '2023-05-03', 3, 79.99, 'Shipped', 'Credit Card'),
  (4, '2023-05-04', 1, 199.99, 'Completed', 'Google Pay'),
  (5, '2023-05-05', 4, 29.99, 'Pending', 'Cash on Delivery'),
  (6, '2023-05-06', 5, 499.99, 'Completed', 'Credit Card'),
  (7, '2023-05-07', 2, 69.99, 'Completed', 'Apple Pay');
INSERT INTO OrderItem (OrderID, ProductID, Quantity, Price)
VALUES
  (1, 1, 2, 39.99),
  (1, 3, 1, 79.99),
  (2, 2, 1, 49.99),
  (3, 4, 3, 119.97),
  (4, 7, 1, 199.99),
  (5, 5, 2, 199.98),
  (6, 6, 1, 149.99);



SELECT * FROM Product WHERE Category = 'Apparel';


SELECT Customer.FirstName, Customer.LastName, `Order`.OrderID, `Order`.OrderDate, `Order`.TotalAmount
FROM Customer
INNER JOIN `Order` ON Customer.CustomerID = `Order`.CustomerID
WHERE Customer.CustomerID = 1;

SELECT SUM(TotalAmount) AS TotalSales
FROM `Order`
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';




SELECT ProductName, StockQuantity
FROM Product
WHERE StockQuantity < 40;


SELECT Customer.FirstName, Customer.LastName, `Order`.OrderID, `Order`.PaymentMethod
FROM Customer
INNER JOIN `Order` ON Customer.CustomerID = `Order`.CustomerID
WHERE `Order`.PaymentMethod = 'Credit Card';



SELECT Supplier.FirstName, Supplier.LastName, Supplier.Company, Product.ProductName
FROM Supplier
INNER JOIN Product ON Supplier.SupplierID = Product.SupplierID;


DELIMITER //
CREATE PROCEDURE CalculateOrderTotal(IN p_OrderID INT)
BEGIN
  UPDATE `Order`
  SET TotalAmount = (
    SELECT SUM(Price * Quantity)
    FROM OrderItem
    WHERE OrderItem.OrderID = p_OrderID
  )
  WHERE `Order`.OrderID = p_OrderID;
END //
DELIMITER ;


DELIMITER //

CREATE TRIGGER UpdateStockQuantity AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
  UPDATE Product
  SET StockQuantity = StockQuantity - NEW.Quantity
  WHERE ProductID = NEW.ProductID;
END //

DELIMITER ;














