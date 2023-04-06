-- create the database
CREATE DATABASE EmployeeDB;
GO
-- use the database
USE EmployeeDB;
GO
-- create the department table
CREATE TABLE Department (
    DepartId INT PRIMARY KEY,
    DepartName VARCHAR(50) NOT NULL,
    Description VARCHAR(100) NOT NULL
);
GO
-- create the employee table
CREATE TABLE Employee (
    EmpCode CHAR(6) PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Birthday SMALLDATETIME NOT NULL,
    Gender BIT DEFAULT 1,
    Address VARCHAR(100),
    DepartID INT,
    Salary MONEY,
    CONSTRAINT fk_Department FOREIGN KEY (DepartID) REFERENCES Department(DepartId)
);
GO


-- 1.insert into department table
INSERT INTO Department (DepartId, DepartName, Description)
VALUES 
    (101, 'Sales', 'Ban san pham va dich vu'),
    (102, 'Marketing', 'Quang ba cac san pham'),
    (103, 'Engineering', 'Thiet ke va xay dung san pham');
GO
-- insert into employee table
INSERT INTO Employee (EmpCode, FirstName, LastName, Birthday, Gender, Address, DepartID, Salary)
VALUES
    ('E10101', 'Son', 'Anh', '1982-01-01', 1, 'Ha Noi', 101, 50000),
    ('E10102', 'Quang', 'Tuan', '1965-03-12', 0, 'Bac Ninh', 101, 55000),
    ('E10201', 'Luong', 'Son', '2003-06-23', 1, 'Ninh Binh', 102, 60000),
    ('E10202', 'Van', 'An', '1976-10-25', 0, 'Hai Phong', 102, 65000),
    ('E10301', 'Quang', 'Duong', '1982-03-21', 1, 'Da Nang', 103, 70000),
    ('E10302', 'Tran', 'Cong', '1990-1-12', 0, 'TP HCM', 103, 75000);
GO
--2.increase the salary for all employees by 10
UPDATE Employee
SET Salary = Salary * 1.1;

--3.using ALTER TABLE statement to add constraint on Employee table to ensure that salary always greater than 0
ALTER TABLE Employee
ADD CONSTRAINT CK_Salary CHECK (Salary > 0);

--4.	
create trigger TG_CheckBirthday
on Employee
after update, insert
as
BEGIN
    declare @dayOfBirthDay date;
	select @dayOfBirthDay  = inserted.Birthday from inserted;

	if(Day(@dayOfBirthDay) <= 23 ) 
	BEGIN
	    print 'Day of birthday must be greater than 23!';
		rollback transaction;
	END
END
GO

--5.Create an unique, none-clustered index named IX_DepartmentName on DepartName column on Department table
create nonclustered index IX_DepartmentName
 on Department(DepartName)
 GO
 --8.Create a stored procedure named sp_delDept that accepts employee Id as given input parameter to delete an employe
 create procedure sp_delDept(@empCode char(6))
 as 
 BEGIN
   if (select count (*) from Employee where Employee.Empcode = @empCode) > 0
   BEGIN
      delete from Employee
	  where EmpCode = @empCode
   END
   else
   BEGIN
      print 'Dont find employee!';
	  rollback transaction;
   END
 END
 exec sp_delDept @empCode = 'E001'
 GO