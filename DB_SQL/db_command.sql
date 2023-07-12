CREATE DATABASE study CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE study;   study 데이터베이스 사용

show databases;     데이터베이스 확인

CREATE USER leoni@localhost IDENTIFIED BY "password";

GRANT ALL PRIVILEGES ON study.* TO leoni@localhost;      study 데이터베이스 내 모든 테이블에 권한 부여

SHOW GRANTS FOR leoni@localhost;

SELECT GRANTEE, PRIVILEGE_TYPE, IS_GRANTABLE FROM INFORMATION_SCHEMA.USER_PRIVILEGES;

CREATE TABLE Person(
    PersonID INT,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255)
);

show tables;    테이블 확인

CREATE TABLE Person(
    PersonID INT NOT NULL AUTO_INCREMENT,      
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    PRIMARY KEY(PersonID)
);

 NULL값 허용 X / 자동으로 1씩 증가

INSERT INTO Person(FirstName, LastName, Address, City)
        VALUES ("JUNHYUN", "SON", "KOREA", "SEOUL");

TRUNCATE TABLE Person;          테이블 내 데이터 모두 삭제

DROP TABLE Person;              테이블 삭제

ALTER TABLE Person ADD Email VARCHAR(255);

실습. 아래 테이블 두 개 만들어 보세요.

1. 테이블명: Students
StudentID - 학번 (빈 값 허용 안함, 자동 증가)
Name - 이름
Age - 나이
Address - 주소

CREATE TABLE Students(
    StudentID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(32),
    Age INT,
    Address VARCHAR(255),
    PRIMARY KEY(StudentID)
);


2. 테이블명: Grades
StudentID - 학번
Math - 수학 점수
English - 영어 점수
Science - 과학 점수

CREATE TABLE Grades(
    GradeID INT NOT NULL AUTO_INCREMENT,
    StudentID INT,
    Math INT,
    English INT,
    Science INT,
    PRIMARY KEY(GradeID)
);

INSERT INTO Students (Name, Age, Address)
    VALUES ("손준현", 27, "서울");

UPDATE Students SET Age=26 WHERE StudentID=1;

실습.
Q. 각 테이블에 데이터를 입력해주세요.
테이블명: Students

Name: 홍길동, Age: 30, Address: 인천
Name: 이연걸, Age: 60, Address: 서울
Name: 이몽룡, Age: 42, Address: 대전
Name: 성춘향, Age: 27, Address: 경기

INSERT INTO Students (Name, Age, Address)
    VALUES ("홍길동", 30, "인천"),
            ("이연걸", 60, "서울"),
            ("이몽룡", 42, "대전"),
            ("성춘향", 27, "경기");

테이블명: Grades

StudentID: 홍길동의 StudentID(숫자), Math: 90, English: 80, Science: 50
StudentID: 이연걸의 StudentID(숫자), Math: 69, English: 76, Science: 65
StudentID: 이몽룡의 StudentID(숫자), Math: 98, English: 87, Science: 97
StudentID: 성춘향의 StudentID(숫자), Math: 87, English: 67, Science: 79

INSERT INTO Grades (StudentID, Math, English, Science)
    VALUES (1, 90, 80, 50),
            (2, 69, 76, 65),
            (3, 98, 87, 97),
            (4, 87, 67, 79);

SELECT 실습

SELECT CASE
            WHEN Price < 30 THEN "저",
            WHEN Price BETWEEN 30 AND 50 THEN "중",
            ELSE "고"
        END AS "Level"
FROM Products

SELECT CustomerName, Address
FROM (
			SELECT *
			FROM Customers
			WHERE Country = "UK"
) Customers
WHERE City = "London";

SELECT Country, SUM(CustomerID), (SUM(CustomerID) / (SELECT SUM(CustomerID)
                                                    FROM Customers) * 100) AS CustomerPercentage
FROM Customers
GROUP BY Country

-- Students, Grades
SELECT *
FROM Students
INNER JOIN Grades
ON Students.StudentID = Grades.StudentID;

INSERT INTO Students(Name, Age, Address) VALUES ("JASON", 36, "서울")

SELECT *
FROM Students
LEFT JOIN Grades
ON Students.StudentID = Grades.StudentID;

SELECT *
FROM Students
RIGHT JOIN Grades
ON Students.StudentID = Grades.StudentID;

SELECT *
FROM Students
LEFT OUTER JOIN Grades      -- LEFT JOIN과 동일
ON Students.StudentID = Grades.StudentID;

SELECT *
FROM Students
RIGHT OUTER JOIN Grades     -- RIGHT JOIN과 동일
ON Students.StudentID = Grades.StudentID;

INSERT INTO Grades(StudentID, Math, English, Science) VALUES (8, 86, 43, 72);

실습.
Q. Tokyo에 위치한 공급자(Supplier)가 생산한 상품(Products) 목록 조회 (Table: Suppliers, Products)
SELECT Products.*, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.City = "Tokyo";

Q. 분류(CategoryName)가 Seafood 인 상품명(ProductName) 조회 (Table: Categories, Products)
SELECT ProductName
FROM Products
INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
WHERE CategoryName = "Seafood"

Q. 공급자(Supplier)가 공급한 상품의 공급자 국가(Country), 카테고리별로 상품 건수와 평균 가격 조회   (Table: Suppliers, Products, Categories)
SELECT Country, C.CategoryID, COUNT(*) AS NumCount, AVG(Price) AS AvgPrice
FROM Products P
INNER JOIN Categories C
ON P.CategoryID = C.CategoryID
INNER JOIN Suppliers S
ON P.SupplierID = S.SupplierID
GROUP BY Country, C.CategoryID;

Q. 주문별 주문자명(CustomerName), 직원명(LastName), 배송자명(ShipperName), 주문상세갯수 (Table: Orders, OrderDetails, Customers, Employees, Shippers)
SELECT O.OrderID, C.CustomerName, E.LastName, S.ShipperName, COUNT(OD.Quantity)
FROM Orders O, Customers C, Employees E, Shippers S
INNER JOIN OrderDetails OD
ON O.OrderID = OD.OrderID
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID
INNER JOIN Employees E
ON O.EmployeeID = E.EmployeeID
INNER JOIN Shippers S
ON O.ShipperID = S.ShipperID
GROUP BY O.OrderID

Q. 판매량(Quantity) 상위 TOP 3 공급자(supplier) 목록 조회   (Table: Suppliers, Products, OrderDetails)
SELECT S.SupplierID, S.SupplierName, P.ProductID, SUM(OD.Quantity) AS SalesAmount
FROM Products P
INNER JOIN Suppliers S
ON P.SupplierID = S.SupplierID
INNER JOIN OrderDetails OD
ON P.ProductID = OD.ProductID
GROUP BY P.SupplierID
ORDER BY SalesAmount DESC LIMIT 3

Q. 상품분류(Category)별, 고객지역별(City) 판매량 많은 순 정렬   (Table: Order, OrderDetails, Customers, Categories, Products)
SELECT CA.CategoryName, CU.City, SUM(OD.Quantity) AS SalesAmount
FROM Orders O
INNER JOIN OrderDetails OD
ON O.OrderID = OD.OrderID
INNER JOIN Customers CU
ON O.CustomerID = CU.CustomerID
INNER JOIN Products P
ON OD.ProductID = P.ProductID
INNER JOIN Categories CA
ON P.CategoryID = CA.CategoryID
GROUP BY CA.CategoryName, CU.City
ORDER BY SalesAmount DESC

Q. 고객국가(Country)가 USA이고, 상품별 판매량(Quantity)의 합이 많은순으로 정렬  (Table: Customers, Products, Orders, OrderDetails)
SELECT P.ProductName, SUM(OD.Quantity) AS SalesAmount
FROM Orders O
	INNER JOIN OrderDetails OD
	ON O.OrderID = OD.OrderID
	INNER JOIN Products P
	ON OD.ProductID = P.ProductID
	INNER JOIN Customers C
	ON O.CustomerID = C.CustomerID
WHERE C.Country = "USA"
GROUP BY P.ProductName
ORDER BY SalesAmount DESC;

-- Foreign Key 실습
ALTER TABLE Students ADD CONSTRAINT fk_student_grade FOREIGN KEY()
    REFERENCES Grades.GradeID;       -- GradeID가 없기 때문에 Foreign Key로 추가 불가능! --> 부모 테이블이 아닌 자식 테이블에 설정해야 함.

ALTER TABLE Grades MODIFY COLUMN StudentID INT NOT NULL;    -- Grades의 StudentID 칼럼 INT & NOT NULL로 수정
ALTER TABLE Grades ADD CONSTRAINT fk_grade_student FOREIGN KEY(StudentID)
    REFERENCES Students(StudentID);

ALTER TABLE Grades DROP FOREIGN KEY fk_grade_student;

CREATE TABLE Users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(32) UNIQUE,
    password VARCHAR(64),
    PRIMARY KEY(id)
);

CREATE INDEX idx_username ON Users(username);     -- username의 중복 검사를 위해 인덱스 지정

INSERT INTO Users(username, password) VALUES("leoni", "1234");
INSERT INTO Users(username, password) VALUES("leoni", "1234");      -- username에 unique 지정 시 중복 검사 시행