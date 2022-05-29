CREATE DATABASE Bookland

use Bookland


CREATE TABLE Books(
 Id int primary key identity,
 [Name] nvarchar(30) constraint CK_Name check(len([Name])<100 and len([Name])>2),
  AuthorId int ,
 [PageCount] int constraint CK_Count check([PageCount]>10)
)

CREATE TABLE Authors(
 AutId int primary key identity,
 [Name] nvarchar(50) not null,
 Surname nvarchar(30) not null
)

ALTER TABLE Books
add Authors_Id int foreign key references Authors(AutId)

INSERT INTO Books(Name,PageCount)
values('Da vinci Code', 552),
('İnferno', 416),
('The Lost Symbol', 624),
('Origin', 536),
('Angels and Demons', 740),
('Digital Fortress', 552),
('Deception Point', 660)
('The Kite Runner', 355),
('A Thousand Splendid Suns', 410),
('Fobi', 419),
('Schizophrenic', 397),
('Psychiatrist', 477).


INSERT INTO Authors(Name,Surname)
VALUES ('Dan', 'Brown'),
('Khalid', 'Hosseyni'),
('Wulf', 'Dorn')


SELECT (A.Name + ' ' + Surname) as Fullname, B.name as Books, B.PageCount as AllPage from Books as B
 join Authors as A
on B.AuthorId = B.Id

CREATE VIEW vw_Library
AS
SELECT * FROM
(
SELECT (A.Name + ' ' + Surname) as Fullname, B.name as Books, B.PageCount as AllPage from Books as B
inner join Authors as A
on B.AuthorId = A.AutId
) as AllBooks

SELECT * FROM vw_Library 

CREATE PROCEDURE usp_SearchByAllAuthorsAndBooks
@BookName nvarchar(40),
@PageCount int,
@AuthorFullname nvarchar(50)
as
SELECT * from vw_Library as L
where L.Fullname=@AuthorFullname and L.Books = @BookName and L.AllPage = @PageCount 

exec usp_SearchByAllAuthorsAndBooks @AuthorFullname='Dan Brown',@BookName= 'Inferno',@PageCount= 416

CREATE PROCEDURE usp_InsertAuthor
@Name nvarchar(30),
@Surname nvarchar(30),
@Books nvarchar(30),
@PageCount int
as
insert into Authors(Name,Surname)
Values(@Name, @Surname)
Insert into Books(Name,PageCount)
Values(@Books, @PageCount)

exec usp_InsertAuthor 'George','Orwell', '1984',452


CREATE PROCEDURE usp_UpdateByAllAuthor
@Id int,
@Name nvarchar(30),
@Surname nvarchar(30),
@Books nvarchar(30),
@PageCount int
as
Update Authors
SET Name=@Name, Surname=@Surname where AutId=@Id


exec usp_UpdateByAllAuthor 3, 'Ray','Bradbury', 'Fahrenheit 451', 512 

CREATE PROCEDURE usp_DeleteAuthor
@Id int
as 
DELETE FROM Authors where AutId=@Id 

exec usp_DeleteAuthor 4


CREATE VIEW vw_LibraryMaxCount
AS
SELECT * FROM
(
SELECT A.AutId,(A.Name + ' ' + a.Surname) as Fullname, count(B.Id) as CountBooks, 
MAX(B.PageCount) as CountPage, count(B.PageCount) as AllPage from Books as B
join Authors as A
on B.AuthorId = a.AutId
group by A.AutId,A.Name
) as MaxBooks

SELECT * FROM vw_LibraryMaxCount

select distinct [Name] as books from Books

