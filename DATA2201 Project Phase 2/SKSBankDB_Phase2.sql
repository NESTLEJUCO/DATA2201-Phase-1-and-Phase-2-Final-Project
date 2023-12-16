-- SKS Bank Database Project Phase 2 --
-- Submitted By: --
-- Nestle Juco, Aldwin Sean Eje, Lady Rose Alarcon, Friedel Navarro, Sheryl Lugti, Justine Cruz--
 
/*STEP 1. Create a login and have different level of users, assign appropriate privilege. 
For instance customer can read transactions but they can’t update or delete. Accountant
can read, edit or delete records etc. (15 point)*/

/*A. Create a user as customer_yourID and password customer. When you login with this account 
you should be able to read only on selected tables that are related to customer such as customer, 
account, loan and payment tables. Provide testing query script after you enforced the privileges.
*/

USE SKSBANKDB;

-- CUSTOMER PRIVILAGE -- 
-- Revoke any existing permissions on the ff. tables
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Account FROM CustomerRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Customer FROM CustomerRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Loan FROM CustomerRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Payment FROM CustomerRole;

-- Create Customer Login, User, and Role--
CREATE LOGIN customer_1 WITH PASSWORD = 'customer';
CREATE USER customer_1 FOR LOGIN customer_1 ;
CREATE ROLE CustomerRole; --AUTHORIZATION dbo;
ALTER ROLE CustomerRole ADD MEMBER customer_1;
GRANT SELECT ON DATABASE::SKSBANKDB TO CustomerRole;
DENY INSERT, UPDATE, DELETE ON OBJECT::dbo.Account TO CustomerRole;
 
-- Login as customer
EXEC AS USER = 'customer_1';
 
-- Test SELECT on customer table
SELECT * FROM Customer WHERE CustomerID = 1;
 
-- Test SELECT on account table
SELECT * FROM Account  WHERE AccountNo = 10001;
 
-- Test UPDATE on account table (denied)
UPDATE dbo.Account SET ChkAmount = 2000.00 WHERE AccountNo = 10001;

-- Test DELETE on account table (denied)
DELETE dbo.Account WHERE AccountNo = 10001;

-- Test INSERT on account table (denied)
INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (10006, 5000.00, 'Checking', '10-01-2023', NULL, '10-05-2023', 1000.00, 101);
 
-- Test SELECT on loan table
SELECT * FROM Loan WHERE CustomerID = 1;
 
-- Test SELECT on payment table
SELECT * FROM Payment WHERE CustomerID = 1;

REVERT;

/*B. Create a user as accountant_yourID and password accountant. 
When you login with this account you should be able read all tables but can update account, 
payment and loan tables. Provide testing query script after you enforced the privileges. */

-- ACCOUNTANT PRIVILAGE -- 
-- Revoke any existing permissions on the ff. tables
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Account FROM AccountantRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Customer FROM AccountantRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Loan FROM AccountantRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT::Payment FROM AccountantRole;

 -- Create Accountant Login, User, and Role--
CREATE LOGIN accountant_1 WITH PASSWORD = 'accountant';
CREATE USER accountant_1 FOR LOGIN accountant_1 ;
CREATE ROLE AccountantRole; --AUTHORIZATION dbo;
ALTER ROLE AccountantRole ADD MEMBER accountant_1;
GRANT SELECT, INSERT, UPDATE, DELETE ON DATABASE::SKSBANKDB TO AccountantRole;

-- Login as customer
EXEC AS USER = 'accountant_1';
 
-- Test SELECT on customer table
SELECT * FROM Employee;
 
-- Test SELECT on account table
SELECT * FROM Customer;

-- Test INSERT on Branch Table
INSERT INTO Branch(BranchID, BranchName, City, TotalDeposit, TotalLoanAmount, TotalLoanPaid, BankReserve)
VALUES (6, 'SKS_Millrise', 'Calgary', 0.00, 0.00, 0.00, 500000.00);

-- Test Delete on Branch Table --
DELETE dbo.Branch WHERE BranchID = 6;

REVERT;

/* STEP 2. Create different set of triggers to monitor the different DML and DDL activities 
in the database (15 point)*/

/*A. Create trigger that report a message during a new customer registration and 
new account creation*/

-- Trigger for new customer registration
CREATE TRIGGER tr_NewCustomer --or ALTER TRIGGER tr_NewCustomer
ON Customer
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerName NVARCHAR(100);
    SELECT @CustomerName = CustomerName FROM INSERTED;
    PRINT 'New customer registered: ' + @CustomerName;
END;
GO

-- Trigger for new account creation
CREATE TRIGGER tr_NewAccount --or ALTER TRIGGER tr_NewAccount
ON Account
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AccountNo NVARCHAR(50);
    SELECT @AccountNo = AccountNo FROM INSERTED;
    PRINT 'New account created: ' + @AccountNo;
END;
GO

-- Test New Customer Creation trigger
INSERT INTO Customer(CustomerID, AccountNo, CustomerName, Address, LoanOfficer, ContactNumber, Status,  BranchID)
VALUES (10, 30001, 'Graham Knox', '12 Mountain View Rd SW, Calgary AB', 'Victoria Noir', 123458889, 'Active', 3);

DELETE Customer WHERE CustomerID = 10;

-- Test New Customer Account trigger
INSERT INTO Account(AccountNo, Balance, AccountType, DateAccessed, SavInterestRate, ChkDateTracking, ChkAmount, ChkNoOverdraft)
VALUES (20002, 10000.00, 'Savings', '2023-11-29', 4.00, NULL, NULL, NULL);

UPDATE Branch SET TotalDeposit = TotalDeposit + 10000 WHERE BranchID = 2;

/*B. Create trigger that report a message that confirm loan payment is made. 
When a payment is done saving or checking account value of that particular 
record will be updated, loan table will be updated and the payment table will be updated. 
Try to observe the relationship between this three table and how a change in one table 
affect the other.*/

CREATE TRIGGER tr_NewPayment --or ALTER TRIGGER tr_NewPayment
ON Payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PaymentID NVARCHAR(50);
	DECLARE @PaymentAmount NVARCHAR(50);
    SELECT @PaymentID = PaymentID FROM INSERTED;
	SELECT @PaymentAmount = PaymentAmount FROM INSERTED;
    PRINT 'New payment has been made, Payment Transaction ID: ' + @PaymentID + ' Payment Amount: $' + @PaymentAmount;
END;
GO

-- Test New Payment Trigger
INSERT INTO Payment(PaymentID, PaymentAmount, PaymentDate, CustomerID, BranchID)
VALUES (10, 1000, '10-15-2024', 4, 1);
UPDATE Branch SET TotalLoanPaid = TotalLoanPaid + 1000 WHERE BranchID = 1;


/*C. Create trigger that report data update during transaction performance on saving or 
checking account */

DROP TABLE AccountAudit;

-- Create an audit table to store update information
CREATE TABLE AccountAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    AccountNo INT,
    AccountType NVARCHAR(50),
    OldBalance DECIMAL(18, 2),
    NewBalance DECIMAL(18, 2),
    DateUpdate DATETIME
);

-- Create a trigger to log updates on the Account table
CREATE TRIGGER trg_AccountUpdate --or ALTER TRIGGER trg_AccountUpdate
ON dbo.Account
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Insert into the audit table
    INSERT INTO AccountAudit (AccountNo, AccountType, OldBalance, NewBalance, DateUpdate)
    SELECT d.AccountNo, d.AccountType, d.Balance AS OldBalance, i.Balance AS NewBalance, GETDATE()
    FROM Deleted d
    INNER JOIN Inserted i ON d.AccountNo = i.AccountNo;
	DECLARE @AuditID NVARCHAR(50);
	DECLARE @AccountNo NVARCHAR(50);
	DECLARE @AccountType NVARCHAR(50);
	DECLARE @OldBalance NVARCHAR(50);
	DECLARE @NewBalance NVARCHAR(50);
	DECLARE @DateUpdate NVARCHAR(50);
 
    SELECT @AuditID = AuditID FROM AccountAudit;
	SELECT @AccountNo = AccountNo FROM AccountAudit;
	SELECT @AccountType = AccountType FROM AccountAudit;
	SELECT @OldBalance = OldBalance FROM AccountAudit;
	SELECT @NewBalance = NewBalance FROM AccountAudit;
	SELECT @DateUpdate = DateUpdate FROM AccountAudit;
 
    PRINT 'Transaction Processed. AuditID: ' + @AuditID + ' Account No:' + @AccountNo + ' Account Type: ' + @AccountType + ' New Balance: ' + @NewBalance + ' Date Update: ' +@DateUpdate;
END;
-- Test Update Checking/Savings Balance
UPDATE Account SET Balance = 5000 WHERE AccountNo = 20001;


/* STEP 3. Create index based on frequently used attribute for three of any table (15 point)*/


/*A. Replace the default cluster index with non-key attribute for one table.*/

ALTER TABLE Payment_Test
DROP CONSTRAINT PK_Payment_9B556A58B746F57D;

CREATE CLUSTERED INDEX PK_Payment_9B556A58B746F57D ON Payment_Test  (PaymentDate);


/*B. Create Composite clustered index for one of the table by removing the 
default clustered index.*/

DROP INDEX PK_Payment_9B556A58B746F57D ON Payment_Test;

-- Create a clustered index on Payment table using PaymentDate as an example
CREATE CLUSTERED INDEX idx_PaymentTest ON Payment_Test (PaymentDate);

-- Test query using the clustered index on Payment table
SELECT * FROM Payment_Test WHERE PaymentDate BETWEEN '2023-10-01' AND '2024-01-31';

DROP INDEX idx_PaymentTest ON Payment_Test;

/*C. Create non clustered composite index for one of the table you have.*/

-- Create a non-clustered index on Payment table using TransactionDate as an example
CREATE NONCLUSTERED INDEX idx_PaymentTest ON Payment_Test (PaymentDate);

-- Test query using the non-clustered index on Payment table
SELECT * FROM Payment_Test WHERE PaymentDate BETWEEN '2023-10-01' AND '2024-01-31';

REVERT;


-- FOR TEST USE ONLY View Tables -- 
/*
SELECT * FROM Branch;
SELECT * FROM Loan;
SELECT * FROM Payment;
SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM AccountAudit;
SELECT * FROM Employee;
*/

