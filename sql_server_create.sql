CREATE DATABASE LibrarySystem;
GO

USE LibrarySystem;

/* Scripts to Create Tables.......................*/

CREATE TABLE Dimension_Employee
(
    EmployeeID            INT IDENTITY(1,1),
    EmployeeNumber        NVARCHAR(20),
    FirstName             NVARCHAR(50),
    LastName              NVARCHAR(50),
    HireDate              DATETIME,
    Shift                 NVARCHAR(10),
    LoadDate              DATETIME,
    EffectiveStartDate     DATETIME,
    EffectiveEndDate       DATETIME,
    CurrentStatus         NVARCHAR(10),
    CONSTRAINT Employee_pk PRIMARY KEY (EmployeeID)
);

CREATE TABLE Dimension_Membership
(
    MemberID              INT IDENTITY(1,1),
    AccessCode            NVARCHAR(20),
    FirstName             NVARCHAR(50),
    LastName              NVARCHAR(50),
    RegistrationDate      DATETIME,
    LoadDate              DATETIME,
    EffectiveStartDate    DATETIME,
    EffectiveEndDate      DATETIME,
    CurrentStatus         NVARCHAR(10),
    CONSTRAINT Member_pk PRIMARY KEY (MemberID)
);

CREATE TABLE Dimension_Vendor
(
    VendorID              INT IDENTITY(1,1),
    VendorCode            NVARCHAR(20),
    FirstName             NVARCHAR(50),
    LastName              NVARCHAR(50),
    CompanyName           NVARCHAR(100),
    CONSTRAINT Vendor_pk PRIMARY KEY (VendorID)
);
CREATE TABLE Dimension_Library
(
    LibraryID           INT IDENTITY(1,1),
    LibraryCode         NVARCHAR(20),
    Name                NVARCHAR(50),
    City                NVARCHAR(50),
    Address             NVARCHAR(10),
    PostalCode          NVARCHAR(50),
    LoadDate            DATETIME,
    EffectiveStartDate   DATETIME,
    EffectiveEndDate     DATETIME,
    CurrentStatus       NVARCHAR(10),
    CONSTRAINT Library_pk PRIMARY KEY (LibraryID)
);
CREATE TABLE Dimension_Book
(
    BookID              INT IDENTITY(1,1),
    BookCode            NVARCHAR(20),
    PurchaseDate        DATETIME,
    BookTitle           NVARCHAR(50),
    Department          NVARCHAR(50),
    Defect              NVARCHAR(10),
    DefectDate          DATETIME,
    LoadDate            DATETIME,
    EffectiveStartDate   DATETIME,
    EffectiveEndDate     DATETIME,
    CurrentStatus       NVARCHAR(10),
    CONSTRAINT Book_pk PRIMARY KEY (BookID)
);
CREATE TABLE Dimension_Advertisement
(
    AdID                INT IDENTITY(1,1),
    AdCode              NVARCHAR(20),
    AdName              NVARCHAR(50),
    Medium              NVARCHAR(50),
    Defect              NVARCHAR(10),
    AdStartDate         DATETIME,
    AdEndDate           DATETIME,
    LoadDate            DATETIME,
    EffectiveStartDate   DATETIME,
    EffectiveEndDate     DATETIME,
    CurrentStatus       NVARCHAR(10),
    CONSTRAINT Ad_pk PRIMARY KEY (AdID)
);

CREATE TABLE Dimension_Date
(
    DateKey             INT,
    FullDate            DATETIME,
    DayNumberOfMonth     INT,
    DaySuffix           VARCHAR(4),
    DayNumberOfWeek      INT,
    DayOfWeekName        VARCHAR(10),
    WeekOfYear           INT,
    WeekOfMonth          INT,
    MonthNumber          INT,
    MonthName            VARCHAR(30),
    Quarter              INT,
    QuarterName          VARCHAR(6),
    Year                 INT,
    CONSTRAINT DateId_pk PRIMARY KEY (DateKey)
);
CREATE TABLE Fact_PurchaseTrans
(
    PurchaseTransID      INT IDENTITY(1,1),
    TransID              NVARCHAR(20),
    InvoiceNumber        NVARCHAR(20),
    PurchaseAmount       INT,
    Quantity             INT,
    VendorID             INT,
    BookID               INT,
    LibraryID            INT,
    EmployeeID           INT,
    OrderDateKey         INT,
    DeliveryDateKey      INT,
    LoadDate             DATETIME,
    EffectiveStartDate    DATETIME,
    EffectiveEndDate      DATETIME,
    CurrentStatus        NVARCHAR(10),
    CONSTRAINT TransID_pk PRIMARY KEY (PurchaseTransID),
    CONSTRAINT PurchaseTrans_Vendor_fk FOREIGN KEY (VendorID) REFERENCES Dimension_Vendor (VendorID),
    CONSTRAINT PurchaseTrans_Book_fk FOREIGN KEY (BookID) REFERENCES Dimension_Book (BookID),
    CONSTRAINT PurchaseTrans_Library_fk FOREIGN KEY (LibraryID) REFERENCES Dimension_Library (LibraryID),
    CONSTRAINT PurchaseTrans_Employee_fk FOREIGN KEY (EmployeeID) REFERENCES Dimension_Employee (EmployeeID),
    CONSTRAINT OrderDate_fk FOREIGN KEY (OrderDateKey) REFERENCES Dimension_Date (DateKey),
    CONSTRAINT DeliveryDate_fk FOREIGN KEY (DeliveryDateKey) REFERENCES Dimension_Date (DateKey)
);