USE AdventureWorks
;

-- dbo.AWBuildVersion (Table)
CREATE TABLE dbo.AWBuildVersion
    (
     SystemInformationID tinyint IDENTITY(1,1) NOT NULL ,
     [Database Version]  nvarchar(25) NOT NULL ,
     VersionDate         datetime NOT NULL ,
     ModifiedDate        datetime NOT NULL CONSTRAINT DF_AWBuildVersion_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_AWBuildVersion_SystemInformationID PRIMARY KEY CLUSTERED (SystemInformationID)
    )
;

-- dbo.DatabaseLog (Table)
CREATE TABLE dbo.DatabaseLog
    (
     DatabaseLogID int IDENTITY(1,1) NOT NULL ,
     PostTime      datetime NOT NULL ,
     DatabaseUser  sysname NOT NULL ,
     Event         sysname NOT NULL ,
     [Schema]      sysname ,
     Object        sysname ,
     TSQL          nvarchar(max) NOT NULL ,
     XmlEvent      xml NOT NULL ,
     CONSTRAINT PK_DatabaseLog_DatabaseLogID PRIMARY KEY NONCLUSTERED (DatabaseLogID)
    )
;

-- dbo.ErrorLog (Table)
CREATE TABLE dbo.ErrorLog
    (
     ErrorLogID     int IDENTITY(1,1) NOT NULL ,
     ErrorTime      datetime NOT NULL CONSTRAINT DF_ErrorLog_ErrorTime DEFAULT (getdate()) ,
     UserName       sysname NOT NULL ,
     ErrorNumber    int NOT NULL ,
     ErrorSeverity  int ,
     ErrorState     int ,
     ErrorProcedure nvarchar(126) ,
     ErrorLine      int ,
     ErrorMessage   nvarchar(4000) NOT NULL ,
     CONSTRAINT PK_ErrorLog_ErrorLogID PRIMARY KEY CLUSTERED (ErrorLogID)
    )
;

-- dbo.sysdiagrams (Table)
CREATE TABLE dbo.sysdiagrams
    (
     name         sysname NOT NULL ,
     principal_id int NOT NULL ,
     diagram_id   int IDENTITY(1,1) NOT NULL ,
     version      int ,
     definition   varbinary(max) ,
     PRIMARY KEY CLUSTERED (diagram_id)
    )
;

ALTER TABLE dbo.sysdiagrams
    ADD CONSTRAINT UK_principal_name UNIQUE NONCLUSTERED
    (
     principal_id ,
     name
    )
;

-- HumanResources.Department (Table)
CREATE TABLE HumanResources.Department
    (
     DepartmentID smallint IDENTITY(1,1) NOT NULL ,
     Name         dbo.Name NOT NULL ,
     GroupName    dbo.Name NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_Department_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Department_DepartmentID PRIMARY KEY CLUSTERED (DepartmentID)
    )
;

-- HumanResources.Employee (Table)
CREATE TABLE HumanResources.Employee
    (
     BusinessEntityID  int NOT NULL ,
     NationalIDNumber  nvarchar(15) NOT NULL ,
     LoginID           nvarchar(256) NOT NULL ,
     OrganizationNode  hierarchyid ,
     OrganizationLevel AS ([OrganizationNode].[GetLevel]()) ,
     JobTitle          nvarchar(50) NOT NULL ,
     BirthDate         date NOT NULL ,
     MaritalStatus     nchar(1) NOT NULL ,
     Gender            nchar(1) NOT NULL ,
     HireDate          date NOT NULL ,
     SalariedFlag      dbo.Flag NOT NULL CONSTRAINT DF_Employee_SalariedFlag DEFAULT ((1)) ,
     VacationHours     smallint NOT NULL CONSTRAINT DF_Employee_VacationHours DEFAULT ((0)) ,
     SickLeaveHours    smallint NOT NULL CONSTRAINT DF_Employee_SickLeaveHours DEFAULT ((0)) ,
     CurrentFlag       dbo.Flag NOT NULL CONSTRAINT DF_Employee_CurrentFlag DEFAULT ((1)) ,
     rowguid           uniqueidentifier NOT NULL CONSTRAINT DF_Employee_rowguid DEFAULT (newid()) ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_Employee_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Employee_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
;

-- HumanResources.EmployeeDepartmentHistory (Table)
CREATE TABLE HumanResources.EmployeeDepartmentHistory
    (
     BusinessEntityID int NOT NULL ,
     DepartmentID     smallint NOT NULL ,
     ShiftID          tinyint NOT NULL ,
     StartDate        date NOT NULL ,
     EndDate          date ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_EmployeeDepartmentHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID PRIMARY KEY CLUSTERED (BusinessEntityID, StartDate, DepartmentID, ShiftID)
    )
;

-- HumanResources.EmployeePayHistory (Table)
CREATE TABLE HumanResources.EmployeePayHistory
    (
     BusinessEntityID int NOT NULL ,
     RateChangeDate   datetime NOT NULL ,
     Rate             money NOT NULL ,
     PayFrequency     tinyint NOT NULL ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_EmployeePayHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_EmployeePayHistory_BusinessEntityID_RateChangeDate PRIMARY KEY CLUSTERED (BusinessEntityID, RateChangeDate)
    )
;

-- HumanResources.JobCandidate (Table)
CREATE TABLE HumanResources.JobCandidate
    (
     JobCandidateID   int IDENTITY(1,1) NOT NULL ,
     BusinessEntityID int ,
     Resume           xml ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_JobCandidate_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_JobCandidate_JobCandidateID PRIMARY KEY CLUSTERED (JobCandidateID)
    )
;

-- HumanResources.Shift (Table)
CREATE TABLE HumanResources.Shift
    (
     ShiftID      tinyint IDENTITY(1,1) NOT NULL ,
     Name         dbo.Name NOT NULL ,
     StartTime    time(7) NOT NULL ,
     EndTime      time(7) NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_Shift_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Shift_ShiftID PRIMARY KEY CLUSTERED (ShiftID)
    )
;

-- Person.Address (Table)
CREATE TABLE Person.Address
    (
     AddressID       int IDENTITY(1,1) NOT NULL ,
     AddressLine1    nvarchar(60) NOT NULL ,
     AddressLine2    nvarchar(60) ,
     City            nvarchar(30) NOT NULL ,
     StateProvinceID int NOT NULL ,
     PostalCode      nvarchar(15) NOT NULL ,
     SpatialLocation geography ,
     rowguid         uniqueidentifier NOT NULL CONSTRAINT DF_Address_rowguid DEFAULT (newid()) ,
     ModifiedDate    datetime NOT NULL CONSTRAINT DF_Address_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Address_AddressID PRIMARY KEY CLUSTERED (AddressID)
    )
;

-- Person.AddressType (Table)
CREATE TABLE Person.AddressType
    (
     AddressTypeID int IDENTITY(1,1) NOT NULL ,
     Name          dbo.Name NOT NULL ,
     rowguid       uniqueidentifier NOT NULL CONSTRAINT DF_AddressType_rowguid DEFAULT (newid()) ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_AddressType_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_AddressType_AddressTypeID PRIMARY KEY CLUSTERED (AddressTypeID)
    )
;

-- Person.BusinessEntity (Table)
CREATE TABLE Person.BusinessEntity
    (
     BusinessEntityID int IDENTITY(1,1) NOT NULL ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_BusinessEntity_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_BusinessEntity_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_BusinessEntity_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
;

-- Person.BusinessEntityAddress (Table)
CREATE TABLE Person.BusinessEntityAddress
    (
     BusinessEntityID int NOT NULL ,
     AddressID        int NOT NULL ,
     AddressTypeID    int NOT NULL ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_BusinessEntityAddress_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_BusinessEntityAddress_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID PRIMARY KEY CLUSTERED (BusinessEntityID, AddressID, AddressTypeID)
    )
;

-- Person.BusinessEntityContact (Table)
CREATE TABLE Person.BusinessEntityContact
    (
     BusinessEntityID int NOT NULL ,
     PersonID         int NOT NULL ,
     ContactTypeID    int NOT NULL ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_BusinessEntityContact_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_BusinessEntityContact_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID PRIMARY KEY CLUSTERED (BusinessEntityID, PersonID, ContactTypeID)
    )
;

-- Person.ContactType (Table)
CREATE TABLE Person.ContactType
    (
     ContactTypeID int IDENTITY(1,1) NOT NULL ,
     Name          dbo.Name NOT NULL ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_ContactType_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ContactType_ContactTypeID PRIMARY KEY CLUSTERED (ContactTypeID)
    )
;

-- Person.CountryRegion (Table)
CREATE TABLE Person.CountryRegion
    (
     CountryRegionCode nvarchar(3) NOT NULL ,
     Name              dbo.Name NOT NULL ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_CountryRegion_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_CountryRegion_CountryRegionCode PRIMARY KEY CLUSTERED (CountryRegionCode)
    )
;

-- Person.EmailAddress (Table)
CREATE TABLE Person.EmailAddress
    (
     BusinessEntityID int NOT NULL ,
     EmailAddressID   int IDENTITY(1,1) NOT NULL ,
     EmailAddress     nvarchar(50) ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_EmailAddress_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_EmailAddress_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_EmailAddress_BusinessEntityID_EmailAddressID PRIMARY KEY CLUSTERED (BusinessEntityID, EmailAddressID)
    )
;

-- Person.Password (Table)
CREATE TABLE Person.Password
    (
     BusinessEntityID int NOT NULL ,
     PasswordHash     varchar(128) NOT NULL ,
     PasswordSalt     varchar(10) NOT NULL ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_Password_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_Password_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Password_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
;

-- Person.Person (Table)
CREATE TABLE Person.Person
    (
     BusinessEntityID      int NOT NULL ,
     PersonType            nchar(2) NOT NULL ,
     NameStyle             dbo.NameStyle NOT NULL CONSTRAINT DF_Person_NameStyle DEFAULT ((0)) ,
     Title                 nvarchar(8) ,
     FirstName             dbo.Name NOT NULL ,
     MiddleName            dbo.Name ,
     LastName              dbo.Name NOT NULL ,
     Suffix                nvarchar(10) ,
     EmailPromotion        int NOT NULL CONSTRAINT DF_Person_EmailPromotion DEFAULT ((0)) ,
     AdditionalContactInfo xml ,
     Demographics          xml ,
     rowguid               uniqueidentifier NOT NULL CONSTRAINT DF_Person_rowguid DEFAULT (newid()) ,
     ModifiedDate          datetime NOT NULL CONSTRAINT DF_Person_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Person_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
;

-- Person.PersonPhone (Table)
CREATE TABLE Person.PersonPhone
    (
     BusinessEntityID  int NOT NULL ,
     PhoneNumber       dbo.Phone NOT NULL ,
     PhoneNumberTypeID int NOT NULL ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_PersonPhone_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID PRIMARY KEY CLUSTERED (BusinessEntityID, PhoneNumber, PhoneNumberTypeID)
    )
;

-- Person.PhoneNumberType (Table)
CREATE TABLE Person.PhoneNumberType
    (
     PhoneNumberTypeID int IDENTITY(1,1) NOT NULL ,
     Name              dbo.Name NOT NULL ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_PhoneNumberType_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_PhoneNumberType_PhoneNumberTypeID PRIMARY KEY CLUSTERED (PhoneNumberTypeID)
    )
;

-- Person.StateProvince (Table)
CREATE TABLE Person.StateProvince
    (
     StateProvinceID         int IDENTITY(1,1) NOT NULL ,
     StateProvinceCode       nchar(3) NOT NULL ,
     CountryRegionCode       nvarchar(3) NOT NULL ,
     IsOnlyStateProvinceFlag dbo.Flag NOT NULL CONSTRAINT DF_StateProvince_IsOnlyStateProvinceFlag DEFAULT ((1)) ,
     Name                    dbo.Name NOT NULL ,
     TerritoryID             int NOT NULL ,
     rowguid                 uniqueidentifier NOT NULL CONSTRAINT DF_StateProvince_rowguid DEFAULT (newid()) ,
     ModifiedDate            datetime NOT NULL CONSTRAINT DF_StateProvince_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_StateProvince_StateProvinceID PRIMARY KEY CLUSTERED (StateProvinceID)
    )
;

-- Production.BillOfMaterials (Table)
CREATE TABLE Production.BillOfMaterials
    (
     BillOfMaterialsID int IDENTITY(1,1) NOT NULL ,
     ProductAssemblyID int ,
     ComponentID       int NOT NULL ,
     StartDate         datetime NOT NULL CONSTRAINT DF_BillOfMaterials_StartDate DEFAULT (getdate()) ,
     EndDate           datetime ,
     UnitMeasureCode   nchar(3) NOT NULL ,
     BOMLevel          smallint NOT NULL ,
     PerAssemblyQty    decimal(8,2) NOT NULL CONSTRAINT DF_BillOfMaterials_PerAssemblyQty DEFAULT ((1.00)) ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_BillOfMaterials_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_BillOfMaterials_BillOfMaterialsID PRIMARY KEY NONCLUSTERED (BillOfMaterialsID)
    )
;

-- Production.Culture (Table)
CREATE TABLE Production.Culture
    (
     CultureID    nchar(6) NOT NULL ,
     Name         dbo.Name NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_Culture_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Culture_CultureID PRIMARY KEY CLUSTERED (CultureID)
    )
;

-- Production.Document (Table)
CREATE TABLE Production.Document
    (
     DocumentNode    hierarchyid NOT NULL ,
     DocumentLevel   AS ([DocumentNode].[GetLevel]()) ,
     Title           nvarchar(50) NOT NULL ,
     Owner           int NOT NULL ,
     FolderFlag      bit NOT NULL CONSTRAINT DF_Document_FolderFlag DEFAULT ((0)) ,
     FileName        nvarchar(400) NOT NULL ,
     FileExtension   nvarchar(8) NOT NULL ,
     Revision        nchar(5) NOT NULL ,
     ChangeNumber    int NOT NULL CONSTRAINT DF_Document_ChangeNumber DEFAULT ((0)) ,
     Status          tinyint NOT NULL ,
     DocumentSummary nvarchar(max) ,
     Document        varbinary(max) ,
     rowguid         uniqueidentifier NOT NULL CONSTRAINT DF_Document_rowguid DEFAULT (newid()) ,
     ModifiedDate    datetime NOT NULL CONSTRAINT DF_Document_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Document_DocumentNode PRIMARY KEY CLUSTERED (DocumentNode)
    )
;

ALTER TABLE Production.Document
    ADD UNIQUE NONCLUSTERED
    (
     rowguid
    )
;

-- Production.Illustration (Table)
CREATE TABLE Production.Illustration
    (
     IllustrationID int IDENTITY(1,1) NOT NULL ,
     Diagram        xml ,
     ModifiedDate   datetime NOT NULL CONSTRAINT DF_Illustration_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Illustration_IllustrationID PRIMARY KEY CLUSTERED (IllustrationID)
    )
;

-- Production.Location (Table)
CREATE TABLE Production.Location
    (
     LocationID   smallint IDENTITY(1,1) NOT NULL ,
     Name         dbo.Name NOT NULL ,
     CostRate     smallmoney NOT NULL CONSTRAINT DF_Location_CostRate DEFAULT ((0.00)) ,
     Availability decimal(8,2) NOT NULL CONSTRAINT DF_Location_Availability DEFAULT ((0.00)) ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_Location_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Location_LocationID PRIMARY KEY CLUSTERED (LocationID)
    )
;

-- Production.Product (Table)
CREATE TABLE Production.Product
    (
     ProductID             int IDENTITY(1,1) NOT NULL ,
     Name                  dbo.Name NOT NULL ,
     ProductNumber         nvarchar(25) NOT NULL ,
     MakeFlag              dbo.Flag NOT NULL CONSTRAINT DF_Product_MakeFlag DEFAULT ((1)) ,
     FinishedGoodsFlag     dbo.Flag NOT NULL CONSTRAINT DF_Product_FinishedGoodsFlag DEFAULT ((1)) ,
     Color                 nvarchar(15) ,
     SafetyStockLevel      smallint NOT NULL ,
     ReorderPoint          smallint NOT NULL ,
     StandardCost          money NOT NULL ,
     ListPrice             money NOT NULL ,
     Size                  nvarchar(5) ,
     SizeUnitMeasureCode   nchar(3) ,
     WeightUnitMeasureCode nchar(3) ,
     Weight                decimal(8,2) ,
     DaysToManufacture     int NOT NULL ,
     ProductLine           nchar(2) ,
     Class                 nchar(2) ,
     Style                 nchar(2) ,
     ProductSubcategoryID  int ,
     ProductModelID        int ,
     SellStartDate         datetime NOT NULL ,
     SellEndDate           datetime ,
     DiscontinuedDate      datetime ,
     rowguid               uniqueidentifier NOT NULL CONSTRAINT DF_Product_rowguid DEFAULT (newid()) ,
     ModifiedDate          datetime NOT NULL CONSTRAINT DF_Product_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Product_ProductID PRIMARY KEY CLUSTERED (ProductID)
    )
;

-- Production.ProductCategory (Table)
CREATE TABLE Production.ProductCategory
    (
     ProductCategoryID int IDENTITY(1,1) NOT NULL ,
     Name              dbo.Name NOT NULL ,
     rowguid           uniqueidentifier NOT NULL CONSTRAINT DF_ProductCategory_rowguid DEFAULT (newid()) ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_ProductCategory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductCategory_ProductCategoryID PRIMARY KEY CLUSTERED (ProductCategoryID)
    )
;

-- Production.ProductCostHistory (Table)
CREATE TABLE Production.ProductCostHistory
    (
     ProductID    int NOT NULL ,
     StartDate    datetime NOT NULL ,
     EndDate      datetime ,
     StandardCost money NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_ProductCostHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductCostHistory_ProductID_StartDate PRIMARY KEY CLUSTERED (ProductID, StartDate)
    )
;

-- Production.ProductDescription (Table)
CREATE TABLE Production.ProductDescription
    (
     ProductDescriptionID int IDENTITY(1,1) NOT NULL ,
     Description          nvarchar(400) NOT NULL ,
     rowguid              uniqueidentifier NOT NULL CONSTRAINT DF_ProductDescription_rowguid DEFAULT (newid()) ,
     ModifiedDate         datetime NOT NULL CONSTRAINT DF_ProductDescription_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductDescription_ProductDescriptionID PRIMARY KEY CLUSTERED (ProductDescriptionID)
    )
;

-- Production.ProductDocument (Table)
CREATE TABLE Production.ProductDocument
    (
     ProductID    int NOT NULL ,
     DocumentNode hierarchyid NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_ProductDocument_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductDocument_ProductID_DocumentNode PRIMARY KEY CLUSTERED (ProductID, DocumentNode)
    )
;

-- Production.ProductInventory (Table)
CREATE TABLE Production.ProductInventory
    (
     ProductID    int NOT NULL ,
     LocationID   smallint NOT NULL ,
     Shelf        nvarchar(10) NOT NULL ,
     Bin          tinyint NOT NULL ,
     Quantity     smallint NOT NULL CONSTRAINT DF_ProductInventory_Quantity DEFAULT ((0)) ,
     rowguid      uniqueidentifier NOT NULL CONSTRAINT DF_ProductInventory_rowguid DEFAULT (newid()) ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_ProductInventory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductInventory_ProductID_LocationID PRIMARY KEY CLUSTERED (ProductID, LocationID)
    )
;

-- Production.ProductListPriceHistory (Table)
CREATE TABLE Production.ProductListPriceHistory
    (
     ProductID    int NOT NULL ,
     StartDate    datetime NOT NULL ,
     EndDate      datetime ,
     ListPrice    money NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_ProductListPriceHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductListPriceHistory_ProductID_StartDate PRIMARY KEY CLUSTERED (ProductID, StartDate)
    )
;

-- Production.ProductModel (Table)
CREATE TABLE Production.ProductModel
    (
     ProductModelID     int IDENTITY(1,1) NOT NULL ,
     Name               dbo.Name NOT NULL ,
     CatalogDescription xml ,
     Instructions       xml ,
     rowguid            uniqueidentifier NOT NULL CONSTRAINT DF_ProductModel_rowguid DEFAULT (newid()) ,
     ModifiedDate       datetime NOT NULL CONSTRAINT DF_ProductModel_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductModel_ProductModelID PRIMARY KEY CLUSTERED (ProductModelID)
    )
;

-- Production.ProductModelIllustration (Table)
CREATE TABLE Production.ProductModelIllustration
    (
     ProductModelID int NOT NULL ,
     IllustrationID int NOT NULL ,
     ModifiedDate   datetime NOT NULL CONSTRAINT DF_ProductModelIllustration_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductModelIllustration_ProductModelID_IllustrationID PRIMARY KEY CLUSTERED (ProductModelID, IllustrationID)
    )
;

-- Production.ProductModelProductDescriptionCulture (Table)
CREATE TABLE Production.ProductModelProductDescriptionCulture
    (
     ProductModelID       int NOT NULL ,
     ProductDescriptionID int NOT NULL ,
     CultureID            nchar(6) NOT NULL ,
     ModifiedDate         datetime NOT NULL CONSTRAINT DF_ProductModelProductDescriptionCulture_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID PRIMARY KEY CLUSTERED (ProductModelID, ProductDescriptionID, CultureID)
    )
;

-- Production.ProductPhoto (Table)
CREATE TABLE Production.ProductPhoto
    (
     ProductPhotoID         int IDENTITY(1,1) NOT NULL ,
     ThumbNailPhoto         varbinary(max) ,
     ThumbnailPhotoFileName nvarchar(50) ,
     LargePhoto             varbinary(max) ,
     LargePhotoFileName     nvarchar(50) ,
     ModifiedDate           datetime NOT NULL CONSTRAINT DF_ProductPhoto_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductPhoto_ProductPhotoID PRIMARY KEY CLUSTERED (ProductPhotoID)
    )
;

-- Production.ProductProductPhoto (Table)
CREATE TABLE Production.ProductProductPhoto
    (
     ProductID      int NOT NULL ,
     ProductPhotoID int NOT NULL ,
     [Primary]      dbo.Flag NOT NULL CONSTRAINT DF_ProductProductPhoto_Primary DEFAULT ((0)) ,
     ModifiedDate   datetime NOT NULL CONSTRAINT DF_ProductProductPhoto_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductProductPhoto_ProductID_ProductPhotoID PRIMARY KEY NONCLUSTERED (ProductID, ProductPhotoID)
    )
;

-- Production.ProductReview (Table)
CREATE TABLE Production.ProductReview
    (
     ProductReviewID int IDENTITY(1,1) NOT NULL ,
     ProductID       int NOT NULL ,
     ReviewerName    dbo.Name NOT NULL ,
     ReviewDate      datetime NOT NULL CONSTRAINT DF_ProductReview_ReviewDate DEFAULT (getdate()) ,
     EmailAddress    nvarchar(50) NOT NULL ,
     Rating          int NOT NULL ,
     Comments        nvarchar(3850) ,
     ModifiedDate    datetime NOT NULL CONSTRAINT DF_ProductReview_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductReview_ProductReviewID PRIMARY KEY CLUSTERED (ProductReviewID)
    )
;

-- Production.ProductSubcategory (Table)
CREATE TABLE Production.ProductSubcategory
    (
     ProductSubcategoryID int IDENTITY(1,1) NOT NULL ,
     ProductCategoryID    int NOT NULL ,
     Name                 dbo.Name NOT NULL ,
     rowguid              uniqueidentifier NOT NULL CONSTRAINT DF_ProductSubcategory_rowguid DEFAULT (newid()) ,
     ModifiedDate         datetime NOT NULL CONSTRAINT DF_ProductSubcategory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductSubcategory_ProductSubcategoryID PRIMARY KEY CLUSTERED (ProductSubcategoryID)
    )
;

-- Production.ScrapReason (Table)
CREATE TABLE Production.ScrapReason
    (
     ScrapReasonID smallint IDENTITY(1,1) NOT NULL ,
     Name          dbo.Name NOT NULL ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_ScrapReason_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ScrapReason_ScrapReasonID PRIMARY KEY CLUSTERED (ScrapReasonID)
    )
;

-- Production.TransactionHistory (Table)
CREATE TABLE Production.TransactionHistory
    (
     TransactionID        int IDENTITY(100000,1) NOT NULL ,
     ProductID            int NOT NULL ,
     ReferenceOrderID     int NOT NULL ,
     ReferenceOrderLineID int NOT NULL CONSTRAINT DF_TransactionHistory_ReferenceOrderLineID DEFAULT ((0)) ,
     TransactionDate      datetime NOT NULL CONSTRAINT DF_TransactionHistory_TransactionDate DEFAULT (getdate()) ,
     TransactionType      nchar(1) NOT NULL ,
     Quantity             int NOT NULL ,
     ActualCost           money NOT NULL ,
     ModifiedDate         datetime NOT NULL CONSTRAINT DF_TransactionHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_TransactionHistory_TransactionID PRIMARY KEY CLUSTERED (TransactionID)
    )
;

-- Production.TransactionHistoryArchive (Table)
CREATE TABLE Production.TransactionHistoryArchive
    (
     TransactionID        int NOT NULL ,
     ProductID            int NOT NULL ,
     ReferenceOrderID     int NOT NULL ,
     ReferenceOrderLineID int NOT NULL CONSTRAINT DF_TransactionHistoryArchive_ReferenceOrderLineID DEFAULT ((0)) ,
     TransactionDate      datetime NOT NULL CONSTRAINT DF_TransactionHistoryArchive_TransactionDate DEFAULT (getdate()) ,
     TransactionType      nchar(1) NOT NULL ,
     Quantity             int NOT NULL ,
     ActualCost           money NOT NULL ,
     ModifiedDate         datetime NOT NULL CONSTRAINT DF_TransactionHistoryArchive_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_TransactionHistoryArchive_TransactionID PRIMARY KEY CLUSTERED (TransactionID)
    )
;

-- Production.UnitMeasure (Table)
CREATE TABLE Production.UnitMeasure
    (
     UnitMeasureCode nchar(3) NOT NULL ,
     Name            dbo.Name NOT NULL ,
     ModifiedDate    datetime NOT NULL CONSTRAINT DF_UnitMeasure_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_UnitMeasure_UnitMeasureCode PRIMARY KEY CLUSTERED (UnitMeasureCode)
    )
;

-- Production.WorkOrder (Table)
CREATE TABLE Production.WorkOrder
    (
     WorkOrderID   int IDENTITY(1,1) NOT NULL ,
     ProductID     int NOT NULL ,
     OrderQty      int NOT NULL ,
     StockedQty    AS (isnull([OrderQty]-[ScrappedQty],(0))) ,
     ScrappedQty   smallint NOT NULL ,
     StartDate     datetime NOT NULL ,
     EndDate       datetime ,
     DueDate       datetime NOT NULL ,
     ScrapReasonID smallint ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_WorkOrder_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_WorkOrder_WorkOrderID PRIMARY KEY CLUSTERED (WorkOrderID)
    )
;

-- Production.WorkOrderRouting (Table)
CREATE TABLE Production.WorkOrderRouting
    (
     WorkOrderID        int NOT NULL ,
     ProductID          int NOT NULL ,
     OperationSequence  smallint NOT NULL ,
     LocationID         smallint NOT NULL ,
     ScheduledStartDate datetime NOT NULL ,
     ScheduledEndDate   datetime NOT NULL ,
     ActualStartDate    datetime ,
     ActualEndDate      datetime ,
     ActualResourceHrs  decimal(9,4) ,
     PlannedCost        money NOT NULL ,
     ActualCost         money ,
     ModifiedDate       datetime NOT NULL CONSTRAINT DF_WorkOrderRouting_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence PRIMARY KEY CLUSTERED (WorkOrderID, ProductID, OperationSequence)
    )
;

-- Purchasing.ProductVendor (Table)
CREATE TABLE Purchasing.ProductVendor
    (
     ProductID        int NOT NULL ,
     BusinessEntityID int NOT NULL ,
     AverageLeadTime  int NOT NULL ,
     StandardPrice    money NOT NULL ,
     LastReceiptCost  money ,
     LastReceiptDate  datetime ,
     MinOrderQty      int NOT NULL ,
     MaxOrderQty      int NOT NULL ,
     OnOrderQty       int ,
     UnitMeasureCode  nchar(3) NOT NULL ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_ProductVendor_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ProductVendor_ProductID_BusinessEntityID PRIMARY KEY CLUSTERED (ProductID, BusinessEntityID)
    )
;

-- Purchasing.PurchaseOrderDetail (Table)
CREATE TABLE Purchasing.PurchaseOrderDetail
    (
     PurchaseOrderID       int NOT NULL ,
     PurchaseOrderDetailID int IDENTITY(1,1) NOT NULL ,
     DueDate               datetime NOT NULL ,
     OrderQty              smallint NOT NULL ,
     ProductID             int NOT NULL ,
     UnitPrice             money NOT NULL ,
     LineTotal             AS (isnull([OrderQty]*[UnitPrice],(0.00))) ,
     ReceivedQty           decimal(8,2) NOT NULL ,
     RejectedQty           decimal(8,2) NOT NULL ,
     StockedQty            AS (isnull([ReceivedQty]-[RejectedQty],(0.00))) ,
     ModifiedDate          datetime NOT NULL CONSTRAINT DF_PurchaseOrderDetail_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID PRIMARY KEY CLUSTERED (PurchaseOrderID, PurchaseOrderDetailID)
    )
;

-- Purchasing.PurchaseOrderHeader (Table)
CREATE TABLE Purchasing.PurchaseOrderHeader
    (
     PurchaseOrderID int IDENTITY(1,1) NOT NULL ,
     RevisionNumber  tinyint NOT NULL CONSTRAINT DF_PurchaseOrderHeader_RevisionNumber DEFAULT ((0)) ,
     Status          tinyint NOT NULL CONSTRAINT DF_PurchaseOrderHeader_Status DEFAULT ((1)) ,
     EmployeeID      int NOT NULL ,
     VendorID        int NOT NULL ,
     ShipMethodID    int NOT NULL ,
     OrderDate       datetime NOT NULL CONSTRAINT DF_PurchaseOrderHeader_OrderDate DEFAULT (getdate()) ,
     ShipDate        datetime ,
     SubTotal        money NOT NULL CONSTRAINT DF_PurchaseOrderHeader_SubTotal DEFAULT ((0.00)) ,
     TaxAmt          money NOT NULL CONSTRAINT DF_PurchaseOrderHeader_TaxAmt DEFAULT ((0.00)) ,
     Freight         money NOT NULL CONSTRAINT DF_PurchaseOrderHeader_Freight DEFAULT ((0.00)) ,
     TotalDue        AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))) PERSISTED NOT NULL ,
     ModifiedDate    datetime NOT NULL CONSTRAINT DF_PurchaseOrderHeader_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_PurchaseOrderHeader_PurchaseOrderID PRIMARY KEY CLUSTERED (PurchaseOrderID)
    )
;

-- Purchasing.ShipMethod (Table)
CREATE TABLE Purchasing.ShipMethod
    (
     ShipMethodID int IDENTITY(1,1) NOT NULL ,
     Name         dbo.Name NOT NULL ,
     ShipBase     money NOT NULL CONSTRAINT DF_ShipMethod_ShipBase DEFAULT ((0.00)) ,
     ShipRate     money NOT NULL CONSTRAINT DF_ShipMethod_ShipRate DEFAULT ((0.00)) ,
     rowguid      uniqueidentifier NOT NULL CONSTRAINT DF_ShipMethod_rowguid DEFAULT (newid()) ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_ShipMethod_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ShipMethod_ShipMethodID PRIMARY KEY CLUSTERED (ShipMethodID)
    )
;

-- Purchasing.Vendor (Table)
CREATE TABLE Purchasing.Vendor
    (
     BusinessEntityID        int NOT NULL ,
     AccountNumber           dbo.AccountNumber NOT NULL ,
     Name                    dbo.Name NOT NULL ,
     CreditRating            tinyint NOT NULL ,
     PreferredVendorStatus   dbo.Flag NOT NULL CONSTRAINT DF_Vendor_PreferredVendorStatus DEFAULT ((1)) ,
     ActiveFlag              dbo.Flag NOT NULL CONSTRAINT DF_Vendor_ActiveFlag DEFAULT ((1)) ,
     PurchasingWebServiceURL nvarchar(1024) ,
     ModifiedDate            datetime NOT NULL CONSTRAINT DF_Vendor_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Vendor_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
;

-- Sales.CountryRegionCurrency (Table)
CREATE TABLE Sales.CountryRegionCurrency
    (
     CountryRegionCode nvarchar(3) NOT NULL ,
     CurrencyCode      nchar(3) NOT NULL ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_CountryRegionCurrency_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode PRIMARY KEY CLUSTERED (CountryRegionCode, CurrencyCode)
    )
;

-- Sales.CreditCard (Table)
CREATE TABLE Sales.CreditCard
    (
     CreditCardID int IDENTITY(1,1) NOT NULL ,
     CardType     nvarchar(50) NOT NULL ,
     CardNumber   nvarchar(25) NOT NULL ,
     ExpMonth     tinyint NOT NULL ,
     ExpYear      smallint NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_CreditCard_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_CreditCard_CreditCardID PRIMARY KEY CLUSTERED (CreditCardID)
    )
;

-- Sales.Currency (Table)
CREATE TABLE Sales.Currency
    (
     CurrencyCode nchar(3) NOT NULL ,
     Name         dbo.Name NOT NULL ,
     ModifiedDate datetime NOT NULL CONSTRAINT DF_Currency_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Currency_CurrencyCode PRIMARY KEY CLUSTERED (CurrencyCode)
    )
;

-- Sales.CurrencyRate (Table)
CREATE TABLE Sales.CurrencyRate
    (
     CurrencyRateID   int IDENTITY(1,1) NOT NULL ,
     CurrencyRateDate datetime NOT NULL ,
     FromCurrencyCode nchar(3) NOT NULL ,
     ToCurrencyCode   nchar(3) NOT NULL ,
     AverageRate      money NOT NULL ,
     EndOfDayRate     money NOT NULL ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_CurrencyRate_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_CurrencyRate_CurrencyRateID PRIMARY KEY CLUSTERED (CurrencyRateID)
    )
;

-- Sales.Customer (Table)
CREATE TABLE Sales.Customer
    (
     CustomerID    int IDENTITY(1,1) NOT NULL ,
     PersonID      int ,
     StoreID       int ,
     TerritoryID   int ,
     AccountNumber AS (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')) ,
     rowguid       uniqueidentifier NOT NULL CONSTRAINT DF_Customer_rowguid DEFAULT (newid()) ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_Customer_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Customer_CustomerID PRIMARY KEY CLUSTERED (CustomerID)
    )
;

-- Sales.PersonCreditCard (Table)
CREATE TABLE Sales.PersonCreditCard
    (
     BusinessEntityID int NOT NULL ,
     CreditCardID     int NOT NULL ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_PersonCreditCard_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_PersonCreditCard_BusinessEntityID_CreditCardID PRIMARY KEY CLUSTERED (BusinessEntityID, CreditCardID)
    )
;

-- Sales.SalesOrderDetail (Table)
CREATE TABLE Sales.SalesOrderDetail
    (
     SalesOrderID          int NOT NULL ,
     SalesOrderDetailID    int IDENTITY(1,1) NOT NULL ,
     CarrierTrackingNumber nvarchar(25) ,
     OrderQty              smallint NOT NULL ,
     ProductID             int NOT NULL ,
     SpecialOfferID        int NOT NULL ,
     UnitPrice             money NOT NULL ,
     UnitPriceDiscount     money NOT NULL CONSTRAINT DF_SalesOrderDetail_UnitPriceDiscount DEFAULT ((0.0)) ,
     LineTotal             AS (
         isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))
     ) ,
     rowguid               uniqueidentifier NOT NULL CONSTRAINT DF_SalesOrderDetail_rowguid DEFAULT (newid()) ,
     ModifiedDate          datetime NOT NULL CONSTRAINT DF_SalesOrderDetail_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID PRIMARY KEY CLUSTERED (SalesOrderID, SalesOrderDetailID)
    )
;

-- Sales.SalesOrderHeader (Table)
CREATE TABLE Sales.SalesOrderHeader
    (
     SalesOrderID           int IDENTITY(1,1) NOT NULL ,
     RevisionNumber         tinyint NOT NULL CONSTRAINT DF_SalesOrderHeader_RevisionNumber DEFAULT ((0)) ,
     OrderDate              datetime NOT NULL CONSTRAINT DF_SalesOrderHeader_OrderDate DEFAULT (getdate()) ,
     DueDate                datetime NOT NULL ,
     ShipDate               datetime ,
     Status                 tinyint NOT NULL CONSTRAINT DF_SalesOrderHeader_Status DEFAULT ((1)) ,
     OnlineOrderFlag        dbo.Flag NOT NULL CONSTRAINT DF_SalesOrderHeader_OnlineOrderFlag DEFAULT ((1)) ,
     SalesOrderNumber       AS (
         isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')
     ) ,
     PurchaseOrderNumber    dbo.OrderNumber ,
     AccountNumber          dbo.AccountNumber ,
     CustomerID             int NOT NULL ,
     SalesPersonID          int ,
     TerritoryID            int ,
     BillToAddressID        int NOT NULL ,
     ShipToAddressID        int NOT NULL ,
     ShipMethodID           int NOT NULL ,
     CreditCardID           int ,
     CreditCardApprovalCode varchar(15) ,
     CurrencyRateID         int ,
     SubTotal               money NOT NULL CONSTRAINT DF_SalesOrderHeader_SubTotal DEFAULT ((0.00)) ,
     TaxAmt                 money NOT NULL CONSTRAINT DF_SalesOrderHeader_TaxAmt DEFAULT ((0.00)) ,
     Freight                money NOT NULL CONSTRAINT DF_SalesOrderHeader_Freight DEFAULT ((0.00)) ,
     TotalDue               AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))) ,
     Comment                nvarchar(128) ,
     rowguid                uniqueidentifier NOT NULL CONSTRAINT DF_SalesOrderHeader_rowguid DEFAULT (newid()) ,
     ModifiedDate           datetime NOT NULL CONSTRAINT DF_SalesOrderHeader_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesOrderHeader_SalesOrderID PRIMARY KEY CLUSTERED (SalesOrderID)
    )
;

-- Sales.SalesOrderHeaderSalesReason (Table)
CREATE TABLE Sales.SalesOrderHeaderSalesReason
    (
     SalesOrderID  int NOT NULL ,
     SalesReasonID int NOT NULL ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_SalesOrderHeaderSalesReason_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID PRIMARY KEY CLUSTERED (SalesOrderID, SalesReasonID)
    )
;

-- Sales.SalesPerson (Table)
CREATE TABLE Sales.SalesPerson
    (
     BusinessEntityID int NOT NULL ,
     TerritoryID      int ,
     SalesQuota       money ,
     Bonus            money NOT NULL CONSTRAINT DF_SalesPerson_Bonus DEFAULT ((0.00)) ,
     CommissionPct    smallmoney NOT NULL CONSTRAINT DF_SalesPerson_CommissionPct DEFAULT ((0.00)) ,
     SalesYTD         money NOT NULL CONSTRAINT DF_SalesPerson_SalesYTD DEFAULT ((0.00)) ,
     SalesLastYear    money NOT NULL CONSTRAINT DF_SalesPerson_SalesLastYear DEFAULT ((0.00)) ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_SalesPerson_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_SalesPerson_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesPerson_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
;

-- Sales.SalesPersonQuotaHistory (Table)
CREATE TABLE Sales.SalesPersonQuotaHistory
    (
     BusinessEntityID int NOT NULL ,
     QuotaDate        datetime NOT NULL ,
     SalesQuota       money NOT NULL ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_SalesPersonQuotaHistory_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_SalesPersonQuotaHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate PRIMARY KEY CLUSTERED (BusinessEntityID, QuotaDate)
    )
;

-- Sales.SalesReason (Table)
CREATE TABLE Sales.SalesReason
    (
     SalesReasonID int IDENTITY(1,1) NOT NULL ,
     Name          dbo.Name NOT NULL ,
     ReasonType    dbo.Name NOT NULL ,
     ModifiedDate  datetime NOT NULL CONSTRAINT DF_SalesReason_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesReason_SalesReasonID PRIMARY KEY CLUSTERED (SalesReasonID)
    )
;

-- Sales.SalesTaxRate (Table)
CREATE TABLE Sales.SalesTaxRate
    (
     SalesTaxRateID  int IDENTITY(1,1) NOT NULL ,
     StateProvinceID int NOT NULL ,
     TaxType         tinyint NOT NULL ,
     TaxRate         smallmoney NOT NULL CONSTRAINT DF_SalesTaxRate_TaxRate DEFAULT ((0.00)) ,
     Name            dbo.Name NOT NULL ,
     rowguid         uniqueidentifier NOT NULL CONSTRAINT DF_SalesTaxRate_rowguid DEFAULT (newid()) ,
     ModifiedDate    datetime NOT NULL CONSTRAINT DF_SalesTaxRate_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesTaxRate_SalesTaxRateID PRIMARY KEY CLUSTERED (SalesTaxRateID)
    )
;

-- Sales.SalesTerritory (Table)
CREATE TABLE Sales.SalesTerritory
    (
     TerritoryID       int IDENTITY(1,1) NOT NULL ,
     Name              dbo.Name NOT NULL ,
     CountryRegionCode nvarchar(3) NOT NULL ,
     [Group]           nvarchar(50) NOT NULL ,
     SalesYTD          money NOT NULL CONSTRAINT DF_SalesTerritory_SalesYTD DEFAULT ((0.00)) ,
     SalesLastYear     money NOT NULL CONSTRAINT DF_SalesTerritory_SalesLastYear DEFAULT ((0.00)) ,
     CostYTD           money NOT NULL CONSTRAINT DF_SalesTerritory_CostYTD DEFAULT ((0.00)) ,
     CostLastYear      money NOT NULL CONSTRAINT DF_SalesTerritory_CostLastYear DEFAULT ((0.00)) ,
     rowguid           uniqueidentifier NOT NULL CONSTRAINT DF_SalesTerritory_rowguid DEFAULT (newid()) ,
     ModifiedDate      datetime NOT NULL CONSTRAINT DF_SalesTerritory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesTerritory_TerritoryID PRIMARY KEY CLUSTERED (TerritoryID)
    )
;

-- Sales.SalesTerritoryHistory (Table)
CREATE TABLE Sales.SalesTerritoryHistory
    (
     BusinessEntityID int NOT NULL ,
     TerritoryID      int NOT NULL ,
     StartDate        datetime NOT NULL ,
     EndDate          datetime ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_SalesTerritoryHistory_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_SalesTerritoryHistory_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID PRIMARY KEY CLUSTERED (BusinessEntityID, StartDate, TerritoryID)
    )
;

-- Sales.ShoppingCartItem (Table)
CREATE TABLE Sales.ShoppingCartItem
    (
     ShoppingCartItemID int IDENTITY(1,1) NOT NULL ,
     ShoppingCartID     nvarchar(50) NOT NULL ,
     Quantity           int NOT NULL CONSTRAINT DF_ShoppingCartItem_Quantity DEFAULT ((1)) ,
     ProductID          int NOT NULL ,
     DateCreated        datetime NOT NULL CONSTRAINT DF_ShoppingCartItem_DateCreated DEFAULT (getdate()) ,
     ModifiedDate       datetime NOT NULL CONSTRAINT DF_ShoppingCartItem_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_ShoppingCartItem_ShoppingCartItemID PRIMARY KEY CLUSTERED (ShoppingCartItemID)
    )
;

-- Sales.SpecialOffer (Table)
CREATE TABLE Sales.SpecialOffer
    (
     SpecialOfferID int IDENTITY(1,1) NOT NULL ,
     Description    nvarchar(255) NOT NULL ,
     DiscountPct    smallmoney NOT NULL CONSTRAINT DF_SpecialOffer_DiscountPct DEFAULT ((0.00)) ,
     Type           nvarchar(50) NOT NULL ,
     Category       nvarchar(50) NOT NULL ,
     StartDate      datetime NOT NULL ,
     EndDate        datetime NOT NULL ,
     MinQty         int NOT NULL CONSTRAINT DF_SpecialOffer_MinQty DEFAULT ((0)) ,
     MaxQty         int ,
     rowguid        uniqueidentifier NOT NULL CONSTRAINT DF_SpecialOffer_rowguid DEFAULT (newid()) ,
     ModifiedDate   datetime NOT NULL CONSTRAINT DF_SpecialOffer_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SpecialOffer_SpecialOfferID PRIMARY KEY CLUSTERED (SpecialOfferID)
    )
;

-- Sales.SpecialOfferProduct (Table)
CREATE TABLE Sales.SpecialOfferProduct
    (
     SpecialOfferID int NOT NULL ,
     ProductID      int NOT NULL ,
     rowguid        uniqueidentifier NOT NULL CONSTRAINT DF_SpecialOfferProduct_rowguid DEFAULT (newid()) ,
     ModifiedDate   datetime NOT NULL CONSTRAINT DF_SpecialOfferProduct_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_SpecialOfferProduct_SpecialOfferID_ProductID PRIMARY KEY CLUSTERED (SpecialOfferID, ProductID)
    )
;

-- Sales.Store (Table)
CREATE TABLE Sales.Store
    (
     BusinessEntityID int NOT NULL ,
     Name             dbo.Name NOT NULL ,
     SalesPersonID    int ,
     Demographics     xml ,
     rowguid          uniqueidentifier NOT NULL CONSTRAINT DF_Store_rowguid DEFAULT (newid()) ,
     ModifiedDate     datetime NOT NULL CONSTRAINT DF_Store_ModifiedDate DEFAULT (getdate()) ,
     CONSTRAINT PK_Store_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
    )
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
GO
-- HumanResources.vEmployee (View)

CREATE VIEW [HumanResources].[vEmployee]
AS
SELECT
    e.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle] 
    ,pp.[PhoneNumber]
    ,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[Name] AS [StateProvinceName]
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName]
    ,p.[AdditionalContactInfo]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea
    ON bea.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [Person].[Address] a
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Person].[PersonPhone] pp
    ON pp.BusinessEntityID = p.[BusinessEntityID]
    LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
    ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]
    LEFT OUTER JOIN [Person].[EmailAddress] ea
    ON p.[BusinessEntityID] = ea.[BusinessEntityID];
GO
-- HumanResources.vEmployeeDepartment (View)

CREATE VIEW [HumanResources].[vEmployeeDepartment]
AS
SELECT
    e.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]
    ,d.[Name] AS [Department]
    ,d.[GroupName]
    ,edh.[StartDate]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh
    ON e.[BusinessEntityID] = edh.[BusinessEntityID]
    INNER JOIN [HumanResources].[Department] d
    ON edh.[DepartmentID] = d.[DepartmentID]
WHERE edh.EndDate IS NULL
GO
-- HumanResources.vEmployeeDepartmentHistory (View)

CREATE VIEW [HumanResources].[vEmployeeDepartmentHistory]
AS
SELECT
    e.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,s.[Name] AS [Shift]
    ,d.[Name] AS [Department]
    ,d.[GroupName]
    ,edh.[StartDate]
    ,edh.[EndDate]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh
    ON e.[BusinessEntityID] = edh.[BusinessEntityID]
    INNER JOIN [HumanResources].[Department] d
    ON edh.[DepartmentID] = d.[DepartmentID]
    INNER JOIN [HumanResources].[Shift] s
    ON s.[ShiftID] = edh.[ShiftID];
GO
-- HumanResources.vJobCandidate (View)

CREATE VIEW [HumanResources].[vJobCandidate]
AS
SELECT
    jc.[JobCandidateID]
    ,jc.[BusinessEntityID]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.Prefix)[1]', 'nvarchar(30)') AS [Name.Prefix]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.First)[1]', 'nvarchar(30)') AS [Name.First]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.Middle)[1]', 'nvarchar(30)') AS [Name.Middle]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.Last)[1]', 'nvarchar(30)') AS [Name.Last]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.Suffix)[1]', 'nvarchar(30)') AS [Name.Suffix]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Skills)[1]', 'nvarchar(max)') AS [Skills]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Address/Addr.Type)[1]', 'nvarchar(30)') AS [Addr.Type]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Address/Addr.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(100)') AS [Addr.Loc.CountryRegion]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Address/Addr.Location/Location/Loc.State)[1]', 'nvarchar(100)') AS [Addr.Loc.State]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Address/Addr.Location/Location/Loc.City)[1]', 'nvarchar(100)') AS [Addr.Loc.City]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Address/Addr.PostalCode)[1]', 'nvarchar(20)') AS [Addr.PostalCode]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/EMail)[1]', 'nvarchar(max)') AS [EMail]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/WebSite)[1]', 'nvarchar(max)') AS [WebSite]
    ,jc.[ModifiedDate]
FROM [HumanResources].[JobCandidate] jc
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
    /Resume') AS Resume(ref);
GO
-- HumanResources.vJobCandidateEducation (View)

CREATE VIEW [HumanResources].[vJobCandidateEducation]
AS
SELECT
    jc.[JobCandidateID]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Level)[1]', 'nvarchar(max)') AS [Edu.Level]
    ,CONVERT(datetime, REPLACE([Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.StartDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Edu.StartDate]
    ,CONVERT(datetime, REPLACE([Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.EndDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Edu.EndDate]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Degree)[1]', 'nvarchar(50)') AS [Edu.Degree]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Major)[1]', 'nvarchar(50)') AS [Edu.Major]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Minor)[1]', 'nvarchar(50)') AS [Edu.Minor]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.GPA)[1]', 'nvarchar(5)') AS [Edu.GPA]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.GPAScale)[1]', 'nvarchar(5)') AS [Edu.GPAScale]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.School)[1]', 'nvarchar(100)') AS [Edu.School]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(100)') AS [Edu.Loc.CountryRegion]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Location/Location/Loc.State)[1]', 'nvarchar(100)') AS [Edu.Loc.State]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Edu.Location/Location/Loc.City)[1]', 'nvarchar(100)') AS [Edu.Loc.City]
FROM [HumanResources].[JobCandidate] jc
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
    /Resume/Education') AS [Education](ref);
GO
-- HumanResources.vJobCandidateEmployment (View)

CREATE VIEW [HumanResources].[vJobCandidateEmployment]
AS
SELECT
    jc.[JobCandidateID]
    ,CONVERT(datetime, REPLACE([Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.StartDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Emp.StartDate]
    ,CONVERT(datetime, REPLACE([Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.EndDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Emp.EndDate]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.OrgName)[1]', 'nvarchar(100)') AS [Emp.OrgName]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.JobTitle)[1]', 'nvarchar(100)') AS [Emp.JobTitle]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.Responsibility)[1]', 'nvarchar(max)') AS [Emp.Responsibility]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.FunctionCategory)[1]', 'nvarchar(max)') AS [Emp.FunctionCategory]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.IndustryCategory)[1]', 'nvarchar(max)') AS [Emp.IndustryCategory]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(max)') AS [Emp.Loc.CountryRegion]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.Location/Location/Loc.State)[1]', 'nvarchar(max)') AS [Emp.Loc.State]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (Emp.Location/Location/Loc.City)[1]', 'nvarchar(max)') AS [Emp.Loc.City]
FROM [HumanResources].[JobCandidate] jc
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
    /Resume/Employment') AS Employment(ref);
GO
-- Person.vAdditionalContactInfo (View)

CREATE VIEW [Person].[vAdditionalContactInfo]
AS
SELECT
    [BusinessEntityID]
    ,[FirstName]
    ,[MiddleName]
    ,[LastName]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:telephoneNumber)[1]/act:number', 'nvarchar(50)') AS [TelephoneNumber]
    ,LTRIM(RTRIM([ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:telephoneNumber/act:SpecialInstructions/text())[1]', 'nvarchar(max)'))) AS [TelephoneSpecialInstructions]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:Street)[1]', 'nvarchar(50)') AS [Street]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:City)[1]', 'nvarchar(50)') AS [City]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:StateProvince)[1]', 'nvarchar(50)') AS [StateProvince]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:PostalCode)[1]', 'nvarchar(50)') AS [PostalCode]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:CountryRegion)[1]', 'nvarchar(50)') AS [CountryRegion]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:SpecialInstructions/text())[1]', 'nvarchar(max)') AS [HomeAddressSpecialInstructions]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:eMail/act:eMailAddress)[1]', 'nvarchar(128)') AS [EMailAddress]
    ,LTRIM(RTRIM([ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:eMail/act:SpecialInstructions/text())[1]', 'nvarchar(max)'))) AS [EMailSpecialInstructions]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:eMail/act:SpecialInstructions/act:telephoneNumber/act:number)[1]', 'nvarchar(50)') AS [EMailTelephoneNumber]
    ,[rowguid]
    ,[ModifiedDate]
FROM [Person].[Person]
OUTER APPLY [AdditionalContactInfo].nodes(
    'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo";
    /ci:AdditionalContactInfo') AS ContactInfo(ref)
WHERE [AdditionalContactInfo] IS NOT NULL;
GO
-- Person.vStateProvinceCountryRegion (View)

CREATE VIEW [Person].[vStateProvinceCountryRegion]
WITH SCHEMABINDING
AS
SELECT
    sp.[StateProvinceID]
    ,sp.[StateProvinceCode]
    ,sp.[IsOnlyStateProvinceFlag]
    ,sp.[Name] AS [StateProvinceName]
    ,sp.[TerritoryID]
    ,cr.[CountryRegionCode]
    ,cr.[Name] AS [CountryRegionName]
FROM [Person].[StateProvince] sp
    INNER JOIN [Person].[CountryRegion] cr
    ON sp.[CountryRegionCode] = cr.[CountryRegionCode];
GO
-- Production.vProductAndDescription (View)

CREATE VIEW [Production].[vProductAndDescription]
WITH SCHEMABINDING
AS
-- View (indexed or standard) to display products and product descriptions by language.
SELECT
    p.[ProductID]
    ,p.[Name]
    ,pm.[Name] AS [ProductModel]
    ,pmx.[CultureID]
    ,pd.[Description]
FROM [Production].[Product] p
    INNER JOIN [Production].[ProductModel] pm
    ON p.[ProductModelID] = pm.[ProductModelID]
    INNER JOIN [Production].[ProductModelProductDescriptionCulture] pmx
    ON pm.[ProductModelID] = pmx.[ProductModelID]
    INNER JOIN [Production].[ProductDescription] pd
    ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO
-- Production.vProductModelCatalogDescription (View)

CREATE VIEW [Production].[vProductModelCatalogDescription]
AS
SELECT
    [ProductModelID]
    ,[Name]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace html="http://www.w3.org/1999/xhtml";
        (/p1:ProductDescription/p1:Summary/html:p)[1]', 'nvarchar(max)') AS [Summary]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Manufacturer/p1:Name)[1]', 'nvarchar(max)') AS [Manufacturer]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Manufacturer/p1:Copyright)[1]', 'nvarchar(30)') AS [Copyright]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Manufacturer/p1:ProductURL)[1]', 'nvarchar(256)') AS [ProductURL]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
        (/p1:ProductDescription/p1:Features/wm:Warranty/wm:WarrantyPeriod)[1]', 'nvarchar(256)') AS [WarrantyPeriod]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
        (/p1:ProductDescription/p1:Features/wm:Warranty/wm:Description)[1]', 'nvarchar(256)') AS [WarrantyDescription]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
        (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:NoOfYears)[1]', 'nvarchar(256)') AS [NoOfYears]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
        (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:Description)[1]', 'nvarchar(256)') AS [MaintenanceDescription]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
        (/p1:ProductDescription/p1:Features/wf:wheel)[1]', 'nvarchar(256)') AS [Wheel]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
        (/p1:ProductDescription/p1:Features/wf:saddle)[1]', 'nvarchar(256)') AS [Saddle]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
        (/p1:ProductDescription/p1:Features/wf:pedal)[1]', 'nvarchar(256)') AS [Pedal]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
        (/p1:ProductDescription/p1:Features/wf:BikeFrame)[1]', 'nvarchar(max)') AS [BikeFrame]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
        (/p1:ProductDescription/p1:Features/wf:crankset)[1]', 'nvarchar(256)') AS [Crankset]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Picture/p1:Angle)[1]', 'nvarchar(256)') AS [PictureAngle]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Picture/p1:Size)[1]', 'nvarchar(256)') AS [PictureSize]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Picture/p1:ProductPhotoID)[1]', 'nvarchar(256)') AS [ProductPhotoID]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Specifications/Material)[1]', 'nvarchar(256)') AS [Material]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Specifications/Color)[1]', 'nvarchar(256)') AS [Color]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Specifications/ProductLine)[1]', 'nvarchar(256)') AS [ProductLine]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Specifications/Style)[1]', 'nvarchar(256)') AS [Style]
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
        (/p1:ProductDescription/p1:Specifications/RiderExperience)[1]', 'nvarchar(1024)') AS [RiderExperience]
    ,[rowguid]
    ,[ModifiedDate]
FROM [Production].[ProductModel]
WHERE [CatalogDescription] IS NOT NULL;
GO
-- Production.vProductModelInstructions (View)

CREATE VIEW [Production].[vProductModelInstructions]
AS
SELECT
    [ProductModelID]
    ,[Name]
    ,[Instructions].value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions";
        (/root/text())[1]', 'nvarchar(max)') AS [Instructions]
    ,[MfgInstructions].ref.value('@LocationID[1]', 'int') AS [LocationID]
    ,[MfgInstructions].ref.value('@SetupHours[1]', 'decimal(9, 4)') AS [SetupHours]
    ,[MfgInstructions].ref.value('@MachineHours[1]', 'decimal(9, 4)') AS [MachineHours]
    ,[MfgInstructions].ref.value('@LaborHours[1]', 'decimal(9, 4)') AS [LaborHours]
    ,[MfgInstructions].ref.value('@LotSize[1]', 'int') AS [LotSize]
    ,[Steps].ref.value('string(.)[1]', 'nvarchar(1024)') AS [Step]
    ,[rowguid]
    ,[ModifiedDate]
FROM [Production].[ProductModel]
CROSS APPLY [Instructions].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions";
    /root/Location') MfgInstructions(ref)
CROSS APPLY [MfgInstructions].ref.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions";
    step') Steps(ref);
GO
-- Purchasing.vVendorWithAddresses (View)

CREATE VIEW [Purchasing].[vVendorWithAddresses] AS
SELECT
    v.[BusinessEntityID]
    ,v.[Name]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[Name] AS [StateProvinceName]
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName]
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityAddress] bea
    ON bea.[BusinessEntityID] = v.[BusinessEntityID]
    INNER JOIN [Person].[Address] a
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at
    ON at.[AddressTypeID] = bea.[AddressTypeID];
GO
-- Purchasing.vVendorWithContacts (View)

CREATE VIEW [Purchasing].[vVendorWithContacts] AS
SELECT
    v.[BusinessEntityID]
    ,v.[Name]
    ,ct.[Name] AS [ContactType]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityContact] bec
    ON bec.[BusinessEntityID] = v.[BusinessEntityID]
	INNER JOIN [Person].ContactType ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO
-- Sales.vIndividualCustomer (View)

CREATE VIEW [Sales].[vIndividualCustomer]
AS
SELECT
    p.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,[StateProvinceName] = sp.[Name]
    ,a.[PostalCode]
    ,[CountryRegionName] = cr.[Name]
    ,p.[Demographics]
FROM [Person].[Person] p
    INNER JOIN [Person].[BusinessEntityAddress] bea
    ON bea.[BusinessEntityID] = p.[BusinessEntityID]
    INNER JOIN [Person].[Address] a
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at
    ON at.[AddressTypeID] = bea.[AddressTypeID]
	INNER JOIN [Sales].[Customer] c
	ON c.[PersonID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID]
WHERE c.StoreID IS NULL;
GO
-- Sales.vPersonDemographics (View)

CREATE VIEW [Sales].[vPersonDemographics]
AS
SELECT
    p.[BusinessEntityID]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        TotalPurchaseYTD[1]', 'money') AS [TotalPurchaseYTD]
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        DateFirstPurchase[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [DateFirstPurchase]
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        BirthDate[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [BirthDate]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        MaritalStatus[1]', 'nvarchar(1)') AS [MaritalStatus]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        YearlyIncome[1]', 'nvarchar(30)') AS [YearlyIncome]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        Gender[1]', 'nvarchar(1)') AS [Gender]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        TotalChildren[1]', 'integer') AS [TotalChildren]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        NumberChildrenAtHome[1]', 'integer') AS [NumberChildrenAtHome]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        Education[1]', 'nvarchar(30)') AS [Education]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        Occupation[1]', 'nvarchar(30)') AS [Occupation]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        HomeOwnerFlag[1]', 'bit') AS [HomeOwnerFlag]
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
        NumberCarsOwned[1]', 'integer') AS [NumberCarsOwned]
FROM [Person].[Person] p
CROSS APPLY p.[Demographics].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    /IndividualSurvey') AS [IndividualSurvey](ref)
WHERE [Demographics] IS NOT NULL;
GO
-- Sales.vSalesPerson (View)

CREATE VIEW [Sales].[vSalesPerson]
AS
SELECT
    s.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,[StateProvinceName] = sp.[Name]
    ,a.[PostalCode]
    ,[CountryRegionName] = cr.[Name]
    ,[TerritoryName] = st.[Name]
    ,[TerritoryGroup] = st.[Group]
    ,s.[SalesQuota]
    ,s.[SalesYTD]
    ,s.[SalesLastYear]
FROM [Sales].[SalesPerson] s
    INNER JOIN [HumanResources].[Employee] e
    ON e.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = s.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea
    ON bea.[BusinessEntityID] = s.[BusinessEntityID]
    INNER JOIN [Person].[Address] a
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Sales].[SalesTerritory] st
    ON st.[TerritoryID] = s.[TerritoryID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO
-- Sales.vSalesPersonSalesByFiscalYears (View)

CREATE VIEW [Sales].[vSalesPersonSalesByFiscalYears]
AS
SELECT
    pvt.[SalesPersonID]
    ,pvt.[FullName]
    ,pvt.[JobTitle]
    ,pvt.[SalesTerritory]
    ,pvt.[2002]
    ,pvt.[2003]
    ,pvt.[2004]
FROM (SELECT
        soh.[SalesPersonID]
        ,p.[FirstName] + ' ' + COALESCE(p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName]
        ,e.[JobTitle]
        ,st.[Name] AS [SalesTerritory]
        ,soh.[SubTotal]
        ,YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear]
    FROM [Sales].[SalesPerson] sp
        INNER JOIN [Sales].[SalesOrderHeader] soh
        ON sp.[BusinessEntityID] = soh.[SalesPersonID]
        INNER JOIN [Sales].[SalesTerritory] st
        ON sp.[TerritoryID] = st.[TerritoryID]
        INNER JOIN [HumanResources].[Employee] e
        ON soh.[SalesPersonID] = e.[BusinessEntityID]
		INNER JOIN [Person].[Person] p
		ON p.[BusinessEntityID] = sp.[BusinessEntityID]
	 ) AS soh
PIVOT
(
    SUM([SubTotal])
    FOR [FiscalYear]
    IN ([2002], [2003], [2004])
) AS pvt;
GO
-- Sales.vStoreWithAddresses (View)

CREATE VIEW [Sales].[vStoreWithAddresses] AS
SELECT
    s.[BusinessEntityID]
    ,s.[Name]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[Name] AS [StateProvinceName]
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName]
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityAddress] bea
    ON bea.[BusinessEntityID] = s.[BusinessEntityID]
    INNER JOIN [Person].[Address] a
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at
    ON at.[AddressTypeID] = bea.[AddressTypeID];
GO
-- Sales.vStoreWithContacts (View)

CREATE VIEW [Sales].[vStoreWithContacts] AS
SELECT
    s.[BusinessEntityID]
    ,s.[Name]
    ,ct.[Name] AS [ContactType]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityContact] bec
    ON bec.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[ContactType] ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO
-- Sales.vStoreWithDemographics (View)

CREATE VIEW [Sales].[vStoreWithDemographics] AS
SELECT
    s.[BusinessEntityID]
    ,s.[Name]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/AnnualSales)[1]', 'money') AS [AnnualSales]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/AnnualRevenue)[1]', 'money') AS [AnnualRevenue]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/BankName)[1]', 'nvarchar(50)') AS [BankName]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') AS [BusinessType]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/YearOpened)[1]', 'integer') AS [YearOpened]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/Specialty)[1]', 'nvarchar(50)') AS [Specialty]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/SquareFeet)[1]', 'integer') AS [SquareFeet]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/Brands)[1]', 'nvarchar(30)') AS [Brands]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/Internet)[1]', 'nvarchar(30)') AS [Internet]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
        (/StoreSurvey/NumberEmployees)[1]', 'integer') AS [NumberEmployees]
FROM [Sales].[Store] s;
GO
-- Foreign keys
ALTER TABLE Production.WorkOrderRouting
    ADD CONSTRAINT FK_WorkOrderRouting_Location_LocationID FOREIGN KEY
    (
     LocationID
    )
    REFERENCES Production.Location
    (
     LocationID
    )
;

ALTER TABLE Production.WorkOrderRouting
    ADD CONSTRAINT FK_WorkOrderRouting_WorkOrder_WorkOrderID FOREIGN KEY
    (
     WorkOrderID
    )
    REFERENCES Production.WorkOrder
    (
     WorkOrderID
    )
;

ALTER TABLE Purchasing.PurchaseOrderHeader
    ADD CONSTRAINT FK_PurchaseOrderHeader_Employee_EmployeeID FOREIGN KEY
    (
     EmployeeID
    )
    REFERENCES HumanResources.Employee
    (
     BusinessEntityID
    )
;

ALTER TABLE Purchasing.PurchaseOrderHeader
    ADD CONSTRAINT FK_PurchaseOrderHeader_ShipMethod_ShipMethodID FOREIGN KEY
    (
     ShipMethodID
    )
    REFERENCES Purchasing.ShipMethod
    (
     ShipMethodID
    )
;

ALTER TABLE Purchasing.PurchaseOrderHeader
    ADD CONSTRAINT FK_PurchaseOrderHeader_Vendor_VendorID FOREIGN KEY
    (
     VendorID
    )
    REFERENCES Purchasing.Vendor
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.CurrencyRate
    ADD CONSTRAINT FK_CurrencyRate_Currency_FromCurrencyCode FOREIGN KEY
    (
     FromCurrencyCode
    )
    REFERENCES Sales.Currency
    (
     CurrencyCode
    )
;

ALTER TABLE Sales.CurrencyRate
    ADD CONSTRAINT FK_CurrencyRate_Currency_ToCurrencyCode FOREIGN KEY
    (
     ToCurrencyCode
    )
    REFERENCES Sales.Currency
    (
     CurrencyCode
    )
;

ALTER TABLE Sales.Customer
    ADD CONSTRAINT FK_Customer_Person_PersonID FOREIGN KEY
    (
     PersonID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.Customer
    ADD CONSTRAINT FK_Customer_SalesTerritory_TerritoryID FOREIGN KEY
    (
     TerritoryID
    )
    REFERENCES Sales.SalesTerritory
    (
     TerritoryID
    )
;

ALTER TABLE Sales.Customer
    ADD CONSTRAINT FK_Customer_Store_StoreID FOREIGN KEY
    (
     StoreID
    )
    REFERENCES Sales.Store
    (
     BusinessEntityID
    )
;

ALTER TABLE Production.Document
    ADD CONSTRAINT FK_Document_Employee_Owner FOREIGN KEY
    (
     Owner
    )
    REFERENCES HumanResources.Employee
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesOrderDetail
    ADD CONSTRAINT FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID FOREIGN KEY
    (
     SalesOrderID
    )
    REFERENCES Sales.SalesOrderHeader
    (
     SalesOrderID
    )
    ON DELETE CASCADE
;

ALTER TABLE Sales.SalesOrderDetail
    ADD CONSTRAINT FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID FOREIGN KEY
    (
     SpecialOfferID ,
     ProductID
    )
    REFERENCES Sales.SpecialOfferProduct
    (
     SpecialOfferID ,
     ProductID
    )
;

ALTER TABLE Person.EmailAddress
    ADD CONSTRAINT FK_EmailAddress_Person_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE HumanResources.Employee
    ADD CONSTRAINT FK_Employee_Person_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_Address_BillToAddressID FOREIGN KEY
    (
     BillToAddressID
    )
    REFERENCES Person.Address
    (
     AddressID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_Address_ShipToAddressID FOREIGN KEY
    (
     ShipToAddressID
    )
    REFERENCES Person.Address
    (
     AddressID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_CreditCard_CreditCardID FOREIGN KEY
    (
     CreditCardID
    )
    REFERENCES Sales.CreditCard
    (
     CreditCardID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_CurrencyRate_CurrencyRateID FOREIGN KEY
    (
     CurrencyRateID
    )
    REFERENCES Sales.CurrencyRate
    (
     CurrencyRateID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_Customer_CustomerID FOREIGN KEY
    (
     CustomerID
    )
    REFERENCES Sales.Customer
    (
     CustomerID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_SalesPerson_SalesPersonID FOREIGN KEY
    (
     SalesPersonID
    )
    REFERENCES Sales.SalesPerson
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_SalesTerritory_TerritoryID FOREIGN KEY
    (
     TerritoryID
    )
    REFERENCES Sales.SalesTerritory
    (
     TerritoryID
    )
;

ALTER TABLE Sales.SalesOrderHeader
    ADD CONSTRAINT FK_SalesOrderHeader_ShipMethod_ShipMethodID FOREIGN KEY
    (
     ShipMethodID
    )
    REFERENCES Purchasing.ShipMethod
    (
     ShipMethodID
    )
;

ALTER TABLE HumanResources.EmployeeDepartmentHistory
    ADD CONSTRAINT FK_EmployeeDepartmentHistory_Department_DepartmentID FOREIGN KEY
    (
     DepartmentID
    )
    REFERENCES HumanResources.Department
    (
     DepartmentID
    )
;

ALTER TABLE HumanResources.EmployeeDepartmentHistory
    ADD CONSTRAINT FK_EmployeeDepartmentHistory_Employee_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES HumanResources.Employee
    (
     BusinessEntityID
    )
;

ALTER TABLE HumanResources.EmployeeDepartmentHistory
    ADD CONSTRAINT FK_EmployeeDepartmentHistory_Shift_ShiftID FOREIGN KEY
    (
     ShiftID
    )
    REFERENCES HumanResources.Shift
    (
     ShiftID
    )
;

ALTER TABLE HumanResources.EmployeePayHistory
    ADD CONSTRAINT FK_EmployeePayHistory_Employee_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES HumanResources.Employee
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesOrderHeaderSalesReason
    ADD CONSTRAINT FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID FOREIGN KEY
    (
     SalesOrderID
    )
    REFERENCES Sales.SalesOrderHeader
    (
     SalesOrderID
    )
    ON DELETE CASCADE
;

ALTER TABLE Sales.SalesOrderHeaderSalesReason
    ADD CONSTRAINT FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID FOREIGN KEY
    (
     SalesReasonID
    )
    REFERENCES Sales.SalesReason
    (
     SalesReasonID
    )
;

ALTER TABLE Sales.SalesPerson
    ADD CONSTRAINT FK_SalesPerson_Employee_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES HumanResources.Employee
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesPerson
    ADD CONSTRAINT FK_SalesPerson_SalesTerritory_TerritoryID FOREIGN KEY
    (
     TerritoryID
    )
    REFERENCES Sales.SalesTerritory
    (
     TerritoryID
    )
;

ALTER TABLE HumanResources.JobCandidate
    ADD CONSTRAINT FK_JobCandidate_Employee_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES HumanResources.Employee
    (
     BusinessEntityID
    )
;

ALTER TABLE Person.Password
    ADD CONSTRAINT FK_Password_Person_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesPersonQuotaHistory
    ADD CONSTRAINT FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Sales.SalesPerson
    (
     BusinessEntityID
    )
;

ALTER TABLE Person.Person
    ADD CONSTRAINT FK_Person_BusinessEntity_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.BusinessEntity
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesTaxRate
    ADD CONSTRAINT FK_SalesTaxRate_StateProvince_StateProvinceID FOREIGN KEY
    (
     StateProvinceID
    )
    REFERENCES Person.StateProvince
    (
     StateProvinceID
    )
;

ALTER TABLE Sales.PersonCreditCard
    ADD CONSTRAINT FK_PersonCreditCard_CreditCard_CreditCardID FOREIGN KEY
    (
     CreditCardID
    )
    REFERENCES Sales.CreditCard
    (
     CreditCardID
    )
;

ALTER TABLE Sales.PersonCreditCard
    ADD CONSTRAINT FK_PersonCreditCard_Person_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE Person.PersonPhone
    ADD CONSTRAINT FK_PersonPhone_Person_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE Person.PersonPhone
    ADD CONSTRAINT FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID FOREIGN KEY
    (
     PhoneNumberTypeID
    )
    REFERENCES Person.PhoneNumberType
    (
     PhoneNumberTypeID
    )
;

ALTER TABLE Sales.SalesTerritory
    ADD CONSTRAINT FK_SalesTerritory_CountryRegion_CountryRegionCode FOREIGN KEY
    (
     CountryRegionCode
    )
    REFERENCES Person.CountryRegion
    (
     CountryRegionCode
    )
;

ALTER TABLE Production.Product
    ADD CONSTRAINT FK_Product_ProductModel_ProductModelID FOREIGN KEY
    (
     ProductModelID
    )
    REFERENCES Production.ProductModel
    (
     ProductModelID
    )
;

ALTER TABLE Production.Product
    ADD CONSTRAINT FK_Product_ProductSubcategory_ProductSubcategoryID FOREIGN KEY
    (
     ProductSubcategoryID
    )
    REFERENCES Production.ProductSubcategory
    (
     ProductSubcategoryID
    )
;

ALTER TABLE Production.Product
    ADD CONSTRAINT FK_Product_UnitMeasure_SizeUnitMeasureCode FOREIGN KEY
    (
     SizeUnitMeasureCode
    )
    REFERENCES Production.UnitMeasure
    (
     UnitMeasureCode
    )
;

ALTER TABLE Production.Product
    ADD CONSTRAINT FK_Product_UnitMeasure_WeightUnitMeasureCode FOREIGN KEY
    (
     WeightUnitMeasureCode
    )
    REFERENCES Production.UnitMeasure
    (
     UnitMeasureCode
    )
;

ALTER TABLE Sales.SalesTerritoryHistory
    ADD CONSTRAINT FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Sales.SalesPerson
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.SalesTerritoryHistory
    ADD CONSTRAINT FK_SalesTerritoryHistory_SalesTerritory_TerritoryID FOREIGN KEY
    (
     TerritoryID
    )
    REFERENCES Sales.SalesTerritory
    (
     TerritoryID
    )
;

ALTER TABLE Production.ProductCostHistory
    ADD CONSTRAINT FK_ProductCostHistory_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Sales.ShoppingCartItem
    ADD CONSTRAINT FK_ShoppingCartItem_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.ProductDocument
    ADD CONSTRAINT FK_ProductDocument_Document_DocumentNode FOREIGN KEY
    (
     DocumentNode
    )
    REFERENCES Production.Document
    (
     DocumentNode
    )
;

ALTER TABLE Production.ProductDocument
    ADD CONSTRAINT FK_ProductDocument_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.ProductInventory
    ADD CONSTRAINT FK_ProductInventory_Location_LocationID FOREIGN KEY
    (
     LocationID
    )
    REFERENCES Production.Location
    (
     LocationID
    )
;

ALTER TABLE Production.ProductInventory
    ADD CONSTRAINT FK_ProductInventory_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.ProductListPriceHistory
    ADD CONSTRAINT FK_ProductListPriceHistory_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Person.Address
    ADD CONSTRAINT FK_Address_StateProvince_StateProvinceID FOREIGN KEY
    (
     StateProvinceID
    )
    REFERENCES Person.StateProvince
    (
     StateProvinceID
    )
;

ALTER TABLE Sales.SpecialOfferProduct
    ADD CONSTRAINT FK_SpecialOfferProduct_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Sales.SpecialOfferProduct
    ADD CONSTRAINT FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID FOREIGN KEY
    (
     SpecialOfferID
    )
    REFERENCES Sales.SpecialOffer
    (
     SpecialOfferID
    )
;

ALTER TABLE Person.StateProvince
    ADD CONSTRAINT FK_StateProvince_CountryRegion_CountryRegionCode FOREIGN KEY
    (
     CountryRegionCode
    )
    REFERENCES Person.CountryRegion
    (
     CountryRegionCode
    )
;

ALTER TABLE Person.StateProvince
    ADD CONSTRAINT FK_StateProvince_SalesTerritory_TerritoryID FOREIGN KEY
    (
     TerritoryID
    )
    REFERENCES Sales.SalesTerritory
    (
     TerritoryID
    )
;

ALTER TABLE Production.ProductModelIllustration
    ADD CONSTRAINT FK_ProductModelIllustration_Illustration_IllustrationID FOREIGN KEY
    (
     IllustrationID
    )
    REFERENCES Production.Illustration
    (
     IllustrationID
    )
;

ALTER TABLE Production.ProductModelIllustration
    ADD CONSTRAINT FK_ProductModelIllustration_ProductModel_ProductModelID FOREIGN KEY
    (
     ProductModelID
    )
    REFERENCES Production.ProductModel
    (
     ProductModelID
    )
;

ALTER TABLE Production.ProductModelProductDescriptionCulture
    ADD CONSTRAINT FK_ProductModelProductDescriptionCulture_Culture_CultureID FOREIGN KEY
    (
     CultureID
    )
    REFERENCES Production.Culture
    (
     CultureID
    )
;

ALTER TABLE Production.ProductModelProductDescriptionCulture
    ADD CONSTRAINT FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID FOREIGN KEY
    (
     ProductDescriptionID
    )
    REFERENCES Production.ProductDescription
    (
     ProductDescriptionID
    )
;

ALTER TABLE Production.ProductModelProductDescriptionCulture
    ADD CONSTRAINT FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID FOREIGN KEY
    (
     ProductModelID
    )
    REFERENCES Production.ProductModel
    (
     ProductModelID
    )
;

ALTER TABLE Production.BillOfMaterials
    ADD CONSTRAINT FK_BillOfMaterials_Product_ComponentID FOREIGN KEY
    (
     ComponentID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.BillOfMaterials
    ADD CONSTRAINT FK_BillOfMaterials_Product_ProductAssemblyID FOREIGN KEY
    (
     ProductAssemblyID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.BillOfMaterials
    ADD CONSTRAINT FK_BillOfMaterials_UnitMeasure_UnitMeasureCode FOREIGN KEY
    (
     UnitMeasureCode
    )
    REFERENCES Production.UnitMeasure
    (
     UnitMeasureCode
    )
;

ALTER TABLE Sales.Store
    ADD CONSTRAINT FK_Store_BusinessEntity_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.BusinessEntity
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.Store
    ADD CONSTRAINT FK_Store_SalesPerson_SalesPersonID FOREIGN KEY
    (
     SalesPersonID
    )
    REFERENCES Sales.SalesPerson
    (
     BusinessEntityID
    )
;

ALTER TABLE Production.ProductProductPhoto
    ADD CONSTRAINT FK_ProductProductPhoto_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.ProductProductPhoto
    ADD CONSTRAINT FK_ProductProductPhoto_ProductPhoto_ProductPhotoID FOREIGN KEY
    (
     ProductPhotoID
    )
    REFERENCES Production.ProductPhoto
    (
     ProductPhotoID
    )
;

ALTER TABLE Production.TransactionHistory
    ADD CONSTRAINT FK_TransactionHistory_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.ProductReview
    ADD CONSTRAINT FK_ProductReview_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.ProductSubcategory
    ADD CONSTRAINT FK_ProductSubcategory_ProductCategory_ProductCategoryID FOREIGN KEY
    (
     ProductCategoryID
    )
    REFERENCES Production.ProductCategory
    (
     ProductCategoryID
    )
;

ALTER TABLE Person.BusinessEntityAddress
    ADD CONSTRAINT FK_BusinessEntityAddress_Address_AddressID FOREIGN KEY
    (
     AddressID
    )
    REFERENCES Person.Address
    (
     AddressID
    )
;

ALTER TABLE Person.BusinessEntityAddress
    ADD CONSTRAINT FK_BusinessEntityAddress_AddressType_AddressTypeID FOREIGN KEY
    (
     AddressTypeID
    )
    REFERENCES Person.AddressType
    (
     AddressTypeID
    )
;

ALTER TABLE Person.BusinessEntityAddress
    ADD CONSTRAINT FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.BusinessEntity
    (
     BusinessEntityID
    )
;

ALTER TABLE Purchasing.ProductVendor
    ADD CONSTRAINT FK_ProductVendor_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Purchasing.ProductVendor
    ADD CONSTRAINT FK_ProductVendor_UnitMeasure_UnitMeasureCode FOREIGN KEY
    (
     UnitMeasureCode
    )
    REFERENCES Production.UnitMeasure
    (
     UnitMeasureCode
    )
;

ALTER TABLE Purchasing.ProductVendor
    ADD CONSTRAINT FK_ProductVendor_Vendor_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Purchasing.Vendor
    (
     BusinessEntityID
    )
;

ALTER TABLE Person.BusinessEntityContact
    ADD CONSTRAINT FK_BusinessEntityContact_BusinessEntity_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.BusinessEntity
    (
     BusinessEntityID
    )
;

ALTER TABLE Person.BusinessEntityContact
    ADD CONSTRAINT FK_BusinessEntityContact_ContactType_ContactTypeID FOREIGN KEY
    (
     ContactTypeID
    )
    REFERENCES Person.ContactType
    (
     ContactTypeID
    )
;

ALTER TABLE Person.BusinessEntityContact
    ADD CONSTRAINT FK_BusinessEntityContact_Person_PersonID FOREIGN KEY
    (
     PersonID
    )
    REFERENCES Person.Person
    (
     BusinessEntityID
    )
;

ALTER TABLE Purchasing.Vendor
    ADD CONSTRAINT FK_Vendor_BusinessEntity_BusinessEntityID FOREIGN KEY
    (
     BusinessEntityID
    )
    REFERENCES Person.BusinessEntity
    (
     BusinessEntityID
    )
;

ALTER TABLE Sales.CountryRegionCurrency
    ADD CONSTRAINT FK_CountryRegionCurrency_CountryRegion_CountryRegionCode FOREIGN KEY
    (
     CountryRegionCode
    )
    REFERENCES Person.CountryRegion
    (
     CountryRegionCode
    )
;

ALTER TABLE Sales.CountryRegionCurrency
    ADD CONSTRAINT FK_CountryRegionCurrency_Currency_CurrencyCode FOREIGN KEY
    (
     CurrencyCode
    )
    REFERENCES Sales.Currency
    (
     CurrencyCode
    )
;

ALTER TABLE Production.WorkOrder
    ADD CONSTRAINT FK_WorkOrder_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Production.WorkOrder
    ADD CONSTRAINT FK_WorkOrder_ScrapReason_ScrapReasonID FOREIGN KEY
    (
     ScrapReasonID
    )
    REFERENCES Production.ScrapReason
    (
     ScrapReasonID
    )
;

ALTER TABLE Purchasing.PurchaseOrderDetail
    ADD CONSTRAINT FK_PurchaseOrderDetail_Product_ProductID FOREIGN KEY
    (
     ProductID
    )
    REFERENCES Production.Product
    (
     ProductID
    )
;

ALTER TABLE Purchasing.PurchaseOrderDetail
    ADD CONSTRAINT FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID FOREIGN KEY
    (
     PurchaseOrderID
    )
    REFERENCES Purchasing.PurchaseOrderHeader
    (
     PurchaseOrderID
    )
;
