
/********************************************
General tips for getting the highest score
Ensure the entire script can run from beginning to end without errors. If you
cannot fully implement a PART or some statements, add what works
correctly, and add comments to describe the issue. If you can't get a
statement to process correctly, comment it out and add comments to explain
the issue.
Again, the entire script needs to run without errors.
Every time a CREATE (Table, Index, Database, Stored Procedure, Trigger) is
used ensure it has a corresponding DROP IF EXISTS that precedes it. This
allows the script to be run over and over getting in an inconsistent state (e.g.
remanent objects)
See the CREATE database section below as an example for a CREATE
DATABASE statement, you'll need to do this for EVERY object (Table, Index,
Database, Stored Procedure, Trigger) you create.
For many batch statements, you'll need to use a GO as a separator, which
resets the transaction block,otherwise you'll get an error.
As an example, make sure your DROP statements that preceed a CREATE of
the same object have a GO in between
DROP statement <OBJECTA>
--followed by a
GO
--followed by a
CREATE statement <OBJECTA>
Without the GO, you'll get a Error like .....CREATE ....' must be the first
statement in a query batch
Also, while not absolute, the same type of error CAN happen after a CREATE
statement followed directly by a corresponding SELECT statement of the
same object. (e.g. Create VIEW followed by a GO, then by a SELECT from the
VIEW).
To be safe in this project, follow this pattern when you have the two
statements back to back.
CREATE statement <OBJECTA>
--followed by a
GO
--followed by a
SELECT statement <OBJECTA>
********************************************/
/********************************************
PART A
CREATE DATABASE
To house the project, create a database : schooldb, so the script can be run
over and over, use :
DROP DATABASE IF EXISTS schooldb statement before the CREATE
statement.
Dont forget to specify USE schooldb once the db is created.
********************************************/
USE Master;
GO
DROP DATABASE IF EXISTS schooldb;
GO
CREATE DATABASE schooldb;
GO
USE schooldb;
PRINT 'Part A Completed'
GO
-- ****************************
-- PART B
-- ****************************
-- Write statements below
DROP PROCEDURE IF EXISTS usp_dropTables
GO
CREATE PROCEDURE usp_dropTables
AS
DROP TABLE IF EXISTS Student_Courses 
DROP TABLE IF EXISTS CourseList
DROP TABLE IF EXISTS StudentInformation
DROP TABLE IF EXISTS StudentContacts
DROP TABLE IF EXISTS ContactType
DROP TABLE IF EXISTS Employees
DROP TABLE IF EXISTS EmpJobPosition

EXEC usp_dropTables

PRINT 'Part B Completed'
GO
-- ****************************
-- PART C
-- ****************************
-- Write statements below

CREATE TABLE CourseList
(
CourseID INT NOT NULL IDENTITY(10,1) PRIMARY KEY,
CourseDescription CHAR(100) NOT NULL,
CourseCost CHAR(100) NULL,
CourseDurationYears INT NULL,
Notes INT NULL
);
GO
CREATE TABLE StudentInformation
(
StudentID INT NOT NULL IDENTITY(100,1) PRIMARY KEY,
Title CHAR(100) NULL,
FirstName CHAR(100) NOT NULL,
LastName CHAR(100) NOT NULL,
Address1 CHAR(100) NULL,
Address2 CHAR(100) NULL,
City CHAR(100) NULL,
County CHAR(100) NULL,
Zip CHAR(100) NULL,
Country CHAR(100) NULL,
Telephone INT NULL,
Email CHAR(100) NULL,
Enrolled CHAR(100) NULL,
AltTelephone INT NULL,
);
GO
CREATE TABLE Student_Courses
(
StudentCourseID int NOT NULL Identity(1,1) PRIMARY KEY,
StudentID int NOT NULL,
CourseID int NOT NULL,
CourseStartDate DateTime NOT NULL,
CourseComplete DateTime NULL,
CONSTRAINT FK_StudentCourses_StudentInformation FOREIGN KEY (StudentID)
REFERENCES StudentInformation(StudentID),
CONSTRAINT FK_StudentCourses_CourseList FOREIGN KEY (CourseID)
REFERENCES CourseList(CourseID),
);
GO
CREATE TABLE ContactType
(
ContactTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
ContactType CHAR(100) NOT NULL
);
GO
CREATE TABLE EmpJobPosition
(
EmpJobPositionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
EmployeePosition CHAR(100) NOT NULL
);
GO
CREATE TABLE Employees
(
EmployeeID INT NOT NULL IDENTITY(1000,1) PRIMARY KEY,
EmployeeName CHAR(100) NOT NULL,
EmployeePositionID INT NOT NULL FOREIGN KEY REFERENCES EmpJobPosition(EmpJobPositionID),
EmployeePassword CHAR(100) NULL,
Access INT  NULL
);
GO
CREATE TABLE StudentContacts
(
ContactID INT NOT NULL IDENTITY(10000,1) PRIMARY KEY,
StudentID INT NOT NULL FOREIGN KEY REFERENCES StudentInformation(StudentID),
ContactTypeID INT NOT NULL FOREIGN KEY REFERENCES ContactType(ContactTypeID),
ContactDate DateTime NOT NULL,
EmployeeID INT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
ContactDetails CHAR(100) NULL,
);

GO
PRINT 'Part C Completed'
GO
-- ****************************
-- PART D
-- ****************************
-- Write statements below

ALTER TABLE Student_Courses
ADD CONSTRAINT UK_Student_Courses
UNIQUE(StudentID,CourseID)

GO

ALTER TABLE StudentInformation
ADD CreatedDateTime DateTime NOT NULL

GO

ALTER TABLE StudentInformation
ADD DEFAULT GETDATE() for CreatedDateTime

GO


ALTER TABLE StudentInformation
DROP COLUMN AltTelephone

GO

CREATE INDEX IX_LastName
ON StudentInformation(LastName)

GO

PRINT 'Part D Completed'
GO
-- ****************************
-- PART E
-- ****************************
-- Write statements below
PRINT 'Part E Completed'
GO
-- ****************************
-- Part F
-- DATA Population
-- If the table structures have been created correct, these data population
--statements will run without issue
-- ****************************
--Uncomment once Part B & C are created
DROP TRIGGER IF EXISTS trgAssignEmail 

GO

CREATE TRIGGER trgAssignEmail ON StudentInformation
FOR INSERT
AS
    SET NOCOUNT ON
    UPDATE s
    SET s.Email  =  LOWER(RTRIM(s.FirstName)) + '.' + LOWER(RTRIM(s.LastName))  + '@disney.com'
    FROM StudentInformation s
    WHERE s.email is null
GO

INSERT INTO StudentInformation
(FirstName,LastName)
VALUES
('Mickey', 'Mouse');
INSERT INTO StudentInformation
(FirstName,LastName)
VALUES
('Minnie', 'Mouse');
INSERT INTO StudentInformation
(FirstName,LastName)
VALUES
('Donald', 'Duck');
SELECT * FROM StudentInformation;

INSERT INTO CourseList
(CourseDescription)
VALUES
('Advanced Math');
INSERT INTO CourseList
(CourseDescription)
VALUES
('Intermediate Math');
INSERT INTO CourseList
(CourseDescription)
VALUES
('Beginning Computer Science');
INSERT INTO CourseList
(CourseDescription)
VALUES
('Advanced Computer Science');
select * from CourseList;
INSERT INTO Student_Courses
(StudentID,CourseID,CourseStartDate)
VALUES
(100, 10, '01/05/2018');
INSERT INTO Student_Courses
(StudentID,CourseID,CourseStartDate)
VALUES
(101, 11, '01/05/2018');
INSERT INTO Student_Courses
(StudentID,CourseID,CourseStartDate)
VALUES
(102, 11, '01/05/2018');
INSERT INTO Student_Courses
(StudentID,CourseID,CourseStartDate)
VALUES
(100, 11, '01/05/2018');
INSERT INTO Student_Courses
(StudentID,CourseID,CourseStartDate)
VALUES
(102, 13, '01/05/2018');
select * from Student_Courses;
INSERT INTO EmpJobPosition
(EmployeePosition)
VALUES
('Math Instructor');
INSERT INTO EmpJobPosition
(EmployeePosition)
VALUES
('Computer Science');
select * from EmpJobPosition
INSERT INTO Employees
(EmployeeName,EmployeePositionID)
VALUES
('Walt Disney', 1);
INSERT INTO Employees
(EmployeeName,EmployeePositionID)
VALUES
('John Lasseter', 2);
INSERT INTO Employees
(EmployeeName,EmployeePositionID)
VALUES
('Danny Hillis', 2);
select * from Employees;
INSERT INTO ContactType
(ContactType)
VALUES
('Tutor');
INSERT INTO ContactType
(ContactType)
VALUES
('Homework Support');
INSERT INTO ContactType
(ContactType)
VALUES
('Conference');
SELECT * from ContactType;
INSERT INTO StudentContacts
(StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
(100, 1, 1000, '11/15/2017', 'Micky and Walt Math Tutoring');
INSERT INTO StudentContacts
(StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
(101, 2, 1001, '11/18/2017', 'Minnie and John Homework support');
INSERT INTO StudentContacts
(StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
(100, 3, 1001, '11/18/2017', 'Micky and Walt Conference');
INSERT INTO StudentContacts
(StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
(102, 2, 1002, '11/20/2017', 'Donald and Danny Homework support');
SELECT * from StudentContacts;
-- Note for Part E, use these two inserts as examples to test the trigger
-- They will also be needed if youre using the examples for Part G
INSERT INTO StudentInformation
(FirstName,LastName,Email)
VALUES
('Porky', 'Pig', 'porky.pig@warnerbros.com');
INSERT INTO StudentInformation
(FirstName,LastName)
VALUES
('Snow', 'White');
--Remove comment when Part B and Part C are completed */
PRINT 'Part F Completed'
GO
-- ****************************
-- PART G
-- ****************************
-- Write statements below
DROP PROCEDURE IF EXISTS usp_addQuickContacts
GO
CREATE PROCEDURE usp_addQuickContacts
@StudEmail char(100),
@EmpName char(100),
@ContactDetails char(100),
@ContactType char(100)
AS
BEGIN
	
	DECLARE @ContactTypeID INT;
	DECLARE @StudentID INT;
	DECLARE @EmployeeID INT;

	  SELECT @StudentID = StudentID 
	  FROM StudentInformation
	  WHERE Email = @StudEmail

	  SELECT @EmployeeID = EmployeeID 
	  FROM Employees
	  WHERE EmployeeName = @EmpName

  SELECT @ContactTypeID = ContactTypeID
  FROM ContactType
  WHERE ContactType = @ContactType;


  IF @ContactTypeID IS NULL
  BEGIN
  INSERT INTO ContactType (ContactType)
  VALUES (@ContactType)
  SET @ContactTypeID = SCOPE_IDENTITY();
  END

  INSERT INTO StudentContacts
(ContactDetails,ContactTypeID,ContactDate,StudentID,EmployeeID)
VALUES
(@ContactDetails,@ContactTypeID,GETDATE(),@StudentID,@EmployeeID)

END

EXEC usp_addQuickContacts 'minnie.mouse@disney.com','John Lasseter','Minnie getting Homework Support from John','Homework Support' 
EXEC usp_addQuickContacts 'porky.pig@warnerbros.com','John Lasseter','Porky studying with John for Test prep','Test Prep'

PRINT 'Part G Completed'
GO
-- ****************************
-- PART H
-- ****************************
-- Write statements below
DROP PROCEDURE IF EXISTS usp_getCourseRosterByName
GO

CREATE PROCEDURE usp_getCourseRosterByName
@CourseDescription VARCHAR(100)
AS
BEGIN

	SELECT c.CourseDescription,si.FirstName,si.LastName
	FROM StudentInformation si
	FULL JOIN Student_Courses sc
	ON si.StudentID = sc.StudentID
	FULL JOIN CourseList c
	ON c.CourseID = sc.CourseID
	WHERE c.CourseDescription = 'Intermediate Math'

RETURN

END
GO
DECLARE @OutputCourseDesc1 VARCHAR(100)

EXEC usp_getCourseRosterByName @CourseDescription='Intermediate Math'


PRINT 'Part H Completed'

GO
-- ****************************
-- Part I
-- ****************************
-- Write statements below
DROP VIEW IF EXISTS vtutorContacts
GO

CREATE VIEW vtutorContacts
AS
SELECT e.EmployeeName, RTRIM(si.FirstName) + ' ' + RTRIM(si.LastName) as StudentName, sc.ContactDetails,sc.ContactDate
FROM Employees e
RIGHT OUTER JOIN StudentContacts sc 
ON e.EmployeeID = sc.EmployeeID
RIGHT OUTER JOIN StudentInformation si
ON si.StudentID = sc.StudentID
RIGHT OUTER JOIN ContactType c
ON c.ContactTypeID = sc.ContactTypeID
WHERE c.ContactType = 'Tutor';
 
 GO

PRINT 'Part I Completed'

