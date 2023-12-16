-- SKS Bank Database --
-- Submitted By: --
-- Friedel Navarro, Sheryl Lugti, Lady Rose Alarcon, Justine Cruz, Aldwin Sean Eje, Nestle Juco --

USE master
GO
-- STEP 3 --
-- Create SKS Bank Database --
IF DB_ID('SKSBANKDB') IS NOT NULL
	DROP DATABASE SKSBANKDB
GO

CREATE DATABASE SKSBANKDB
GO

USE SKSBANKDB
GO

-- Create Bank Branch Table -- 
CREATE TABLE Branch(
BranchID INT PRIMARY KEY,
BranchName VARCHAR(255),
City VARCHAR(255), 
TotalDeposit DECIMAL (10,2),
TotalLoanAmount DECIMAL (10,2),
TotalLoanPaid DECIMAL (10,2),
BankReserve DECIMAL (10,2)
);

-- Create Account Table --
CREATE TABLE Account(
AccountNo INT PRIMARY KEY,
Balance DECIMAL (10,2),
AccountType VARCHAR(255),
CHECK (AccountType IN ('Savings', 'Checking')),
DateAccessed DATE,
SavInterestRate DECIMAL (10,2),
ChkDateTracking DATE,
ChkAmount DECIMAL (10,2),
ChkNoOverdraft INT
);

-- Create Customer Table --
CREATE TABLE Customer(
CustomerID INT PRIMARY KEY,
AccountNo INT,
BranchID INT,
CustomerName VARCHAR(255),
Address VARCHAR(255),
LoanOfficer VARCHAR(255),
ContactNumber INT, --Added--
Status VARCHAR(255), --Added--
FOREIGN KEY (AccountNo) REFERENCES Account(AccountNo),
FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

-- Create Loan Table --
CREATE TABLE Loan(
LoanID INT PRIMARY KEY,
LoanAmount DECIMAL (10,2),
LoanDate DATE,
BranchID INT,
CustomerID INT, 
FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Create Payment Table --
CREATE TABLE Payment(
PaymentID INT PRIMARY KEY,
PaymentAmount DECIMAL (10,2),
PaymentDate DATE,
BranchID INT,
CustomerID INT, 
FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Create Employee Table --
CREATE TABLE Employee(
EmployeeID INT PRIMARY KEY,
EmployeeRole VARCHAR(255),
CHECK (EmployeeRole IN ('Manager', 'Banker', 'Loan Officer')),
EmployeeName VARCHAR(255),
EmployeeAddress VARCHAR(255),
WorkAssignment VARCHAR(255),
Username VARCHAR(255),--Added--
Password VARCHAR(255),--Added--

StartDate DATE
);

 
-- STEP 4 --
-- Add Branch --
INSERT INTO Branch(BranchID, BranchName, City, TotalDeposit, TotalLoanAmount, TotalLoanPaid, BankReserve)
VALUES (1, 'SKS_Shawnessy', 'Calgary', 0.00, 0.00, 0.00, 500000.00);
INSERT INTO Branch(BranchID, BranchName, City, TotalDeposit, TotalLoanAmount, TotalLoanPaid, BankReserve)
VALUES (2, 'SKS_Somerset', 'Calgary', 0.00, 0.00, 0.00, 600000.00);
INSERT INTO Branch(BranchID, BranchName, City, TotalDeposit, TotalLoanAmount, TotalLoanPaid, BankReserve)
VALUES (3, 'SKS_Chinook', 'Calgary', 0.00, 0.00, 0.00, 400000.00);
INSERT INTO Branch(BranchID, BranchName, City, TotalDeposit, TotalLoanAmount, TotalLoanPaid, BankReserve)
VALUES (4, 'SKS_Thorburn', 'Airdrie', 0.00, 0.00, 0.00, 700000.00);
INSERT INTO Branch(BranchID, BranchName, City, TotalDeposit, TotalLoanAmount, TotalLoanPaid, BankReserve)
VALUES (5, 'SKS_ForestLawn', 'Calgary', 0.00, 0.00, 0.00, 500000.00);

 

-- Add Accounts --
INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (10001, 5000.00, 'Checking', '10-01-2023', NULL, '10-05-2023', 1000.00, 101);
UPDATE Branch SET TotalDeposit = TotalDeposit + 5000 WHERE BranchID = 1;

 

INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (20001, 15200.00, 'Savings', '08-01-2023', 4.00, NULL, NULL, NULL);
UPDATE Branch SET TotalDeposit = TotalDeposit + 15200 WHERE BranchID = 2;

 

INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (30001, 18500.00, 'Savings', '06-04-2023', 4.00, NULL, NULL, NULL);
UPDATE Branch SET TotalDeposit = TotalDeposit + 15200 WHERE BranchID = 3;

 

INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (40001, 9500.00, 'Checking', '08-25-2023', NULL, '09-15-2023', 1000.00, 401);
UPDATE Branch SET TotalDeposit = TotalDeposit + 9500 WHERE BranchID = 4;

 

INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (50001, 10000.00, 'Savings', '02-22-2023', 4.00, NULL, NULL, NULL);
UPDATE Branch SET TotalDeposit = TotalDeposit + 10000 WHERE BranchID = 5;

-- Add Customer --
INSERT INTO Customer(CustomerID, AccountNo, CustomerName, Address, LoanOfficer, ContactNumber, Status, BranchID)
VALUES (1, 10001, 'Jaimie Carter', '103 Shawglen Way SW, Calgary AB', 'Hannah Douglas', 123456789, 'Active', 1);
INSERT INTO Customer(CustomerID, AccountNo, CustomerName, Address, LoanOfficer, ContactNumber, Status,  BranchID)
VALUES (2, 20001, 'Brent Dough', '827 Somerset Dr. SW, Calgary AB', 'Hailey Williams', 123456789, 'Active', 2);
INSERT INTO Customer(CustomerID, AccountNo, CustomerName, Address, LoanOfficer, ContactNumber, Status,  BranchID)
VALUES (3, 30001, 'Javier Graham', '63 Meadowview Rd SW, Calgary AB', 'Victoria Noir', 123456789, 'Active', 3);
INSERT INTO Customer(CustomerID, AccountNo, CustomerName, Address, LoanOfficer, ContactNumber, Status,  BranchID)
VALUES (4, 40001, 'Benson Barry', '66 Tipping Close, Airdrie AB', 'Frank Reynolds', 123456789, 'Active', 4);
INSERT INTO Customer(CustomerID, AccountNo, CustomerName, Address, LoanOfficer, ContactNumber, Status,  BranchID)
VALUES (5, 50001, 'Elliot Morrow', '24A 42 St SE, Calgary AB', 'Mary Cris Jumawan',  123456789, 'Active', 5);

-- Add Loan -- 
-- Insert the Loan information
INSERT INTO Loan(LoanID, LoanAmount, LoanDate, CustomerID, BranchID)
VALUES (1, 10000, '10-15-2023', 4, 1);
-- Update the TotalLoanAmount for the corresponding branch
UPDATE Branch SET TotalLoanAmount = TotalLoanAmount + 10000 WHERE BranchID = 1;

INSERT INTO Loan(LoanID, LoanAmount, LoanDate, CustomerID, BranchID)
VALUES (2, 5000, '10-14-2023', 5, 2);
UPDATE Branch SET TotalLoanAmount = TotalLoanAmount + 5000 WHERE BranchID = 2;

INSERT INTO Loan(LoanID, LoanAmount, LoanDate, CustomerID, BranchID)
VALUES (3, 6000, '09-20-2023', 2, 3);
UPDATE Branch SET TotalLoanAmount = TotalLoanAmount + 6000 WHERE BranchID = 3;

INSERT INTO Loan(LoanID, LoanAmount, LoanDate, CustomerID, BranchID)
VALUES (4, 5000, '06-01-2023', 1, 4);
UPDATE Branch SET TotalLoanAmount = TotalLoanAmount + 5000 WHERE BranchID = 4;

INSERT INTO Loan(LoanID, LoanAmount, LoanDate, CustomerID, BranchID)
VALUES (5, 8000, '05-15-2023', 3, 5);
UPDATE Branch SET TotalLoanAmount = TotalLoanAmount + 8000 WHERE BranchID = 5;

-- Add Payment -- 
-- Insert the Payment information
INSERT INTO Payment(PaymentID, PaymentAmount, PaymentDate, CustomerID, BranchID)
VALUES (1, 1000, '10-15-2024', 4, 1);
UPDATE Branch SET TotalLoanPaid = TotalLoanPaid + 1000 WHERE BranchID = 1;

INSERT INTO Payment(PaymentID, PaymentAmount, PaymentDate, CustomerID, BranchID)
VALUES (2, 500, '10-14-2024', 5, 2);
UPDATE Branch SET TotalLoanPaid = TotalLoanPaid + 500 WHERE BranchID = 2;

INSERT INTO Payment(PaymentID, PaymentAmount, PaymentDate, CustomerID, BranchID)
VALUES (3, 600, '12-20-2023', 2, 3);
UPDATE Branch SET TotalLoanPaid = TotalLoanPaid + 600 WHERE BranchID = 3;
 
INSERT INTO Payment(PaymentID, PaymentAmount, PaymentDate, CustomerID, BranchID)
VALUES (4, 500, '11-01-2023', 1, 4);
UPDATE Branch SET TotalLoanPaid = TotalLoanPaid + 500 WHERE BranchID = 4;

INSERT INTO Payment(PaymentID, PaymentAmount, PaymentDate, CustomerID, BranchID)
VALUES (5, 800, '10-15-2023', 3, 5);
UPDATE Branch SET TotalLoanPaid = TotalLoanPaid + 800 WHERE BranchID = 5;

-- Add Employee Manager -- 
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (1001, 'Manager', 'Crizel Bailey', '326 20 Ave SW, Calgary AB', 'SKS_Shawnessy', 'admin', 'admin', '07-22-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (2001, 'Manager', 'John Bradley', '1210 Bellevue Ave SE, Calgary AB', 'SKS_Somerset', 'admin', 'admin', '10-03-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (3001, 'Manager', 'Aaron Brown', '117 Roxboxo Rd SW, Calgary AB', 'SKS_Chinook', 'admin', 'admin', '04-22-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (4001, 'Manager', 'Alfred Collins', '216 200 Luxstone Pl SW, Airdrie', 'SKS_Thorburn', 'admin', 'admin', '05-17-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (5001, 'Manager', 'Apple Cooper', '3053 2 St SW, Calgary AB', 'SKS_ForestLawn', 'admin', 'admin', '08-06-2023');

-- Add Employee Loan Officer --
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (1002, 'Loan Officer', 'Hannah Douglas', '227 4 Ave NE, Calgary AB', 'SKS_Shawnessy', 'admin', 'admin', '02-10-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (2002, 'Loan Officer', 'Hailey Williams', '1914 12 St SW, Calgary AB', 'SKS_Somerset', 'admin', 'admin', '04-28-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (3002, 'Loan Officer', 'Victoria Noir', '1004 Elizabeth Rd SW, Calgary AB', 'SKS_Chinook', 'admin', 'admin', '09-05-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (4002, 'Loan Officer', 'Frank Reynolds', '69 MayFair Cl SE, Airdrie AB', 'SKS_Thorburn', 'admin', 'admin', '03-10-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (5002, 'Loan Officer', 'Mary Cris Jumawan', '7404 7 St SW, Calgary AB', 'SKS_ForestLawn', 'admin', 'admin', '07-18-2023');

-- Add Employee Banker -- 
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (1003, 'Banker', 'Ashley Dawson', '409 14 Ave NE, Calgary AB', 'SKS_Shawnessy', 'admin', 'admin', '07-25-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (2003, 'Banker', 'Harry Fisher', '608 14 Ave NE, Calgary AB', 'SKS_Somerset', 'admin', 'admin', '06-12-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (3003, 'Banker', 'James Ford', '439 25 Ave NE, Calgary AB', 'SKS_Chinook', 'admin', 'admin', '02-17-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (4003, 'Banker', 'Thomas Harris', '321 Bayside Cres SW, Airdrie', 'SKS_Thorburn', 'admin', 'admin', '09-25-2023');
INSERT INTO Employee(EmployeeID, EmployeeRole, EmployeeName, EmployeeAddress, WorkAssignment, Username, Password, StartDate)
VALUES (5003, 'Banker', 'Mekus Insan', '3015 2 St. SW, Calgary AB', 'SKS_ForestLawn', 'admin', 'admin', '01-27-2023');

-- FOR TEST USE ONLY View Tables -- 
/*
SELECT * FROM Branch;
SELECT * FROM Loan;
SELECT * FROM Payment;
SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Employee;
*/