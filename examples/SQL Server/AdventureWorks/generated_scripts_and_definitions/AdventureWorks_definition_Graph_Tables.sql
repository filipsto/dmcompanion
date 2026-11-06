USE AdventureWorks
;

-- graph.Products (Node table)
CREATE TABLE graph.Products
    (
     ProductID    int NOT NULL ,
     ProductName  nvarchar(50) NOT NULL ,
     StandardCost money NOT NULL ,
     PRIMARY KEY CLUSTERED (ProductID)
    ) AS NODE
;

-- graph.SalesReps (Node table)
CREATE TABLE graph.SalesReps
    (
     SalesRepID int NOT NULL ,
     FirstName  nvarchar(50) NOT NULL ,
     LastName   nvarchar(50) NOT NULL ,
     PRIMARY KEY CLUSTERED (SalesRepID)
    ) AS NODE
;

-- graph.Stores (Node table)
CREATE TABLE graph.Stores
    (
     StoreID   int NOT NULL ,
     StoreName nvarchar(50) NOT NULL ,
     PRIMARY KEY CLUSTERED (StoreID)
    ) AS NODE
;

-- graph.Vendors (Node table)
CREATE TABLE graph.Vendors
    (
     VendorID      int NOT NULL ,
     AccountNumber nvarchar(15) NOT NULL ,
     VendorName    nvarchar(50) NOT NULL ,
     PRIMARY KEY CLUSTERED (VendorID)
    ) AS NODE
;

-- graph.Orders (Edge table)
CREATE TABLE graph.Orders
    (
     OrderDate datetime NOT NULL ,
     OrderQty  smallint NOT NULL ,
     LineTotal money NOT NULL ,
     CONNECTION (graph.Stores TO graph.Products)
    ) AS EDGE
;

-- graph.Sells (Edge table)
CREATE TABLE graph.Sells
    (
     OrderDate datetime NOT NULL ,
     OrderQty  smallint NOT NULL ,
     LineTotal money NOT NULL ,
     CONNECTION (graph.SalesReps TO graph.Products)
    ) AS EDGE
;

-- graph.Supplies (Edge table)
CREATE TABLE graph.Supplies
    (
     StandardPrice money NOT NULL ,
     CONNECTION (graph.Vendors TO graph.Products)
    ) AS EDGE
;
