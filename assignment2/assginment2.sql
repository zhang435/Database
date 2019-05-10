CREATE DATABASE JZ;

--Switch to your new database
\c jz

CREATE TABLE Student
(
    Sid INT PRIMARY KEY,
    Sname VARCHAR(15)
);

-- Book(BookNo; Title; Price)
CREATE TABLE Book
(
    BookNo INT PRIMARY KEY,
    Title VARCHAR(30),
    Price INT
);

CREATE TABLE Major
(
    Sid INT REFERENCES Student(Sid),
    Major VARCHAR(15)
);

-- Cites(BookNo;CitedBookNo)
CREATE TABLE Cites
(
    BookNo INT REFERENCES Book(BookNo),
    CitedBookNo INT REFERENCES Book(BookNo)
);

-- Buys(Sid;BookNo)
CREATE TABLE Buys
(
    Sid INT REFERENCES Student(Sid),
    BookNo INT REFERENCES Book(BookNo)
);

INSERT INTO Book(
VALUES
    (2001, 'Databases', 40),
    (2002, 'OperatingSystems', 25),
    (2003, 'Networks', 20),
    (2004, 'AI', 45),
    (2005, 'DiscreteMathematics', 20),
    (2006, 'SQL', 25),
    (2007, 'ProgrammingLanguages', 15),
    (2008, 'DataScience', 50),
    (2009, 'Calculus', 10),
    (2010, 'Philosophy', 25),
    (2012, 'Geometry', 80),
    (2013, 'RealAnalysis', 35),
    (2011, 'Anthropology', 50),
    (2014, 'Topology', 70)
);

INSERT INTO Student(
VALUES
    (1001, 'Jean'),
    (1002, 'Maria'),
    (1003, 'Anna'),
    (1004, 'Chin'),
    (1005, 'John'),
    (1006, 'Ryan'),
    (1007, 'Catherine'),
    (1008, 'Emma'),
    (1009, 'Jan'),
    (1010, 'Linda'),
    (1011, 'Nick'),
    (1012, 'Eric'),
    (1013, 'Lisa'),
    (1014, 'Filip'),
    (1015, 'Dirk'),
    (1016, 'Mary'),
    (1017, 'Ellen'),
    (1020, 'Greg'),
    (1022, 'Qin'),
    (1023, 'Melanie'),
    (1040, 'Pam')
);
INSERT INTO Buys(
VALUES
    (1023, 2012),
    (1023, 2014),
    (1040, 2002),
    (1001, 2002),
    (1001, 2007),
    (1001, 2009),
    (1001, 2011),
    (1001, 2013),
    (1002, 2001),
    (1002, 2002),
    (1002, 2007),
    (1002, 2011),
    (1002, 2012),
    (1002, 2013),
    (1003, 2002),
    (1003, 2007),
    (1003, 2011),
    (1003, 2012),
    (1003, 2013),
    (1004, 2006),
    (1004, 2007),
    (1004, 2008),
    (1004, 2011),
    (1004, 2012),
    (1004, 2013),
    (1005, 2007),
    (1005, 2011),
    (1005, 2012),
    (1005, 2013),
    (1006, 2006),
    (1006, 2007),
    (1006, 2008),
    (1006, 2011),
    (1006, 2012),
    (1006, 2013),
    (1007, 2001),
    (1007, 2002),
    (1007, 2003),
    (1007, 2007),
    (1007, 2008),
    (1007, 2009),
    (1007, 2010),
    (1007, 2011),
    (1007, 2012),
    (1007, 2013),
    (1008, 2007),
    (1008, 2011),
    (1008, 2012),
    (1008, 2013),
    (1009, 2001),
    (1009, 2002),
    (1009, 2011),
    (1009, 2012),
    (1009, 2013),
    (1010, 2001),
    (1010, 2002),
    (1010, 2003),
    (1010, 2011),
    (1010, 2012),
    (1010, 2013),
    (1011, 2002),
    (1011, 2011),
    (1011, 2012),
    (1012, 2011),
    (1012, 2012),
    (1013, 2001),
    (1013, 2011),
    (1013, 2012),
    (1014, 2008),
    (1014, 2011),
    (1014, 2012),
    (1017, 2001),
    (1017, 2002),
    (1017, 2003),
    (1017, 2008),
    (1017, 2012),
    (1020, 2001),
    (1020, 2012),
    (1022, 2014)
);

INSERT INTO Major(
VALUES
    (1001, 'Math'),
    (1001, 'Physics'),
    (1002, 'CS'),
    (1002, 'Math'),
    (1003, 'Math'),
    (1004, 'CS'),
    (1006, 'CS'),
    (1007, 'CS'),
    (1007, 'Physics'),
    (1008, 'Physics'),
    (1009, 'Biology'),
    (1010, 'Biology'),
    (1011, 'CS'),
    (1011, 'Math'),
    (1012, 'CS'),
    (1013, 'CS'),
    (1013, 'Psychology'),
    (1014, 'Theater'),
    (1017, 'Anthropology'),
    (1022, 'CS'),
    (1015, 'Chemistry')
);
INSERT INTO Cites(
VALUES
    (2012, 2001),
    (2008, 2011),
    (2008, 2012),
    (2001, 2002),
    (2001, 2007),
    (2002, 2003),
    (2003, 2001),
    (2003, 2004),
    (2003, 2002),
    (2010, 2001),
    (2010, 2002),
    (2010, 2003),
    (2010, 2004),
    (2010, 2005),
    (2010, 2006),
    (2010, 2007),
    (2010, 2008),
    (2010, 2009),
    (2010, 2011),
    (2010, 2013),
    (2010, 2014)
);

-- table for CS major student
CREATE MATERIALIZED VIEW CSMajorStudent
AS
SELECT S.Sid, S.Sname
FROM Student S
WHERE S.Sid IN 
(SELECT Major.Sid
FROM Major Major
WHERE Major.Major = 'CS');

-- @param: student.Sid
-- get book bought by this student
-- return (BookNo INT,Price INT)
CREATE FUNCTION bookBoughtBy(id INT)
RETURNS TABLE
(BookNo INT , Title VARCHAR , Price INT) AS
    $$
SELECT book.BookNo, Book.Title, book.Price
FROM Buys Buys, book book
WHERE book.BookNo = buys.BookNo AND Buys.Sid = id
$$
LANGUAGE SQL;


-- @param: Book.BookNo
-- get student who bought this book
-- return list Sid
CREATE FUNCTION everyonewhoBought(bn INT)
RETURNS TABLE
(Sid INT)  AS
    $$
SELECT Buys.Sid
FROM Buys Buys
WHERE Buys.BookNo = bn;
    $$
LANGUAGE SQL;

--@param: BookNo INT
-- get he set of book that cite the source
-- @return: (BookNo INT, Price INT)
CREATE FUNCTION Citedby(source INT)
RETURNS TABLE
(BookNo INT, Price INT) AS
    $$
select Book.BookNo,Book.price
from Book Book,Cites cites
where Book.BookNo = cites.BookNo
and source = cites.CitedBookNo
$$
LANGUAGE SQL;

-- @param : BookNo int
-- get all the book A sites

CREATE FUNCTION Cite(A INT)
RETURNS TABLE
(BookNo INT, title VARCHAR, Price INT) AS
    $$
select Book.BookNo,book.title,Book.price
from Book Book,Cites cites
where Book.BookNo = cites.CitedBookNo
and A = cites.BookNo
$$
LANGUAGE SQL;

-- @param: Major
-- get the student major in given major
-- return (Student.Sid, Student.Sname)
CREATE FUNCTION studentMajorIn(maj VARCHAR)
RETURNS TABLE
(Sid INT , Sname VARCHAR) AS
    $$
SELECT S.Sid, S.Sname
FROM Student S
WHERE S.Sid IN 
(SELECT Major.Sid
FROM Major Major
WHERE Major.Major = maj);
$$
LANGUAGE SQL;

/**
find all the major student take
-- @param : get eh Sid 
-- return subquery with all major
**/
CREATE FUNCTION studentMajor(id INT)
RETURNS TABLE
(maj VARCHAR) AS
    $$
SELECT major.major
FROM major major
WHERE major.Sid = id;
$$
LANGUAGE SQL;

/**
return if bookno bought by student 
*/
create or replace function bought(student INT,
                    BookNo int) RETURNS BOOLEAN as
$$
BEGIN
    IF (student,BookNo) in (select * from Buys) then
        return true;
    else
        return false;
    END IF;
END;
$$
LANGUAGE plpgsql;

/**
return is student is major in major
*/
create or replace function isMajorIn(student INT,
                    Major VARCHAR) RETURNS BOOLEAN as
$$
BEGIN
    IF (student,Major) in (select * from Major) then
        return true;
    else
        return false;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- 1. Find the sid and major of each student who bought a book that cost less than $20.
/**
for every student who bought book:
    for b in bought and price < 20:
        if student.boughtBook == b:
            keep
**/
SELECT DISTINCT M.Sid, M.Major
FROM Major M,
    (SELECT Buy.Sid
    FROM
        Buys Buy,
        (SELECT Book.BookNo
        FROM Book Book
        WHERE Book.Price < 20) subBook
    WHERE Buy.BookNo = subBook.BookNo) subBuy
WHERE M.Sid = SubBuy.Sid
ORDER BY M.Sid ASC;

-- 2. Find the bookno and title of each book that cost between $20 and $40 and that is cited by another book.
/**
set = set(cited)
keep every book cost between 20 40 and in set
**/
SELECT subBook.BookNo , subBook.title
FROM
    (SELECT *
    FROM
        Book Book
    WHERE Book.price BETWEEN 20 AND 40
) subBook
WHERE subBook.BookNo IN
(SELECT C.CitedBookNo
FROM Cites C)
ORDER BY subBook.BookNo ASC;

-- 3. Find the sid and name of each student who majors in `CS' and who bought a book that is cited by a lower priced book.
/**
for every student major in CS:
    for every book studnet bought:
        for every book cite the book studnet :
            keep 
**/

SELECT CSStudent.Sid , CSStudent.Sname
FROM
    CSMajorStudent CSStudent
WHERE
 EXISTS (
     SELECT *
FROM bookBoughtBy(CSStudent.Sid) book
WHERE EXISTS 
     (SELECT *
FROM Citedby(book.BookNo) citesOfBook
WHERE citesOfBook.Price < Book.Price
     )
 )
ORDER BY CSStudent.Sid ASC;

-- 4, Find the bookno and title of each cited book that is itself cited by another book.
-- Find the bookno and title of each book that is cited by a book that is itself cited another book.
/**
Here is a clarification of that problem:   

Find the bookno and title of each book "b" that is cited by a book "b1" that is cited by book "b2".
So book b2 cites book b1 and book b1 cites book b
*/

select distinct book1.bookNo, book1.title
from book book1,book book2, book book3
where (book1.BookNo in (select tmp.BookNo from Cite(book2.BookNo) tmp))
    and
    (book2.BookNo in (select tmp.BookNo from Cite(book3.BookNo) tmp ))
order by Book1.BookNo ASC;

-- 5, Use the SQL ALL predicate to find the booknos of the cheapest books.

/**
for every book:
    if the price of book is <= all(price)

**/
SELECT Book.BookNo
FROM Book Book
WHERE 
    Book.Price <=
    ALL(SELECT Book.price
FROM Book Book);

-- 6, Without using the SQL ALL or SOME predicates, find the booknos and titles of the most expensive books.
/**
for every book:
    if the price of book is >= all(price)

**/
SELECT Book.BookNo, Book.title
FROM Book Book
WHERE NOT EXISTS(
    SELECT *
FROM Book tmp
WHERE tmp.Price > Book.Price);

-- 7, Find the booknos and titles of the second most expensive books.
/**
get the most expensive book
for every book other than most expensice book,
    if this book's price is greater than all book(except most exp)
    keep


**/
SELECT secondMostExpensiceBook.BookNo, secondMostExpensiceBook.title
FROM Book secondMostExpensiceBook,
    (
SELECT Book.BookNo, Book.title, Book.Price
    FROM Book Book
    WHERE NOT EXISTS(
    SELECT *
    FROM Book tmp
    WHERE tmp.Price > Book.Price)) mostExpBook

WHERE secondMostExpensiceBook.price >= ALL(
    SELECT tmp.Price
    FROM Book tmp
    WHERE tmp.BookNo <> mostExpBook.BookNo
)
    AND
    secondMostExpensiceBook.BookNo != mostExpBook.BookNo;

-- 8. Find the bookno and price of each book which, if it is cited by another book, cites a book that cost more than $20. (Note that each book which is not cited also satises the condition of the query and must therefore also be included in the answer.)
select book.bookNo,Book.price
from book
where not exists (
    (select tmp.BookNo from Citedby (Book.BookNo) tmp
    where 20 >= all(
        select t.price
        from cite(Book.BookNo) t)));

-- 9. Find the bookno and title of each book that is bought by a student who majors in `Biology' or in `Psychology'.
/**
final all the book bought by Biology student / Psychology student
**/
SELECT Book.BookNo, Book.title
FROM
    Book Book
WHERE Book.BookNo IN
(SELECT Buys.BookNo
FROM Buys Buys
WHERE  buys.sid IN ((
        SELECT bioStudent.sid
    FROM Studentmajorin('Biology') bioStudent
    )
UNION
    (SELECT psyStudent.sid
    FROM Studentmajorin('Psychology') psyStudent)))
ORDER BY Book.BookNo ASC;

-- 10， Find the bookno and title of each book that is not bought by all students who major in `CS'.
/**
for every student ,Book
    all cs student - for all student who bought that book
    keep if there is cs student remain,
    which means there is cs student did not bought that book
**/

SELECT  DISTINCT Book.BookNo, Book.Title
FROM
    Student Student, Book Book
WHERE EXISTS
(
        (SELECT S.Sid
        FROM CSMajorStudent S
        ORDER BY S.Sid ASC)

    EXCEPT
        (SELECT B.Sid
        FROM Buys B
        WHERE
        B.BookNo = Book.BookNo
        ORDER BY B.Sid ASC)
);

-- 11. Find the bookno of each book that was only bought by students who major in `Biology'.
select DISTINCT Book.BookNo, Book.Title
from Book Book
where not exists (
    (select S.Sid from  everyonewhoBought(Book.BookNo) S)
    except
    (select S.Sid from studentMajorIn('Biology') s)
)
ORDER BY Book.BookNo ASC;

-- 12. Find the bookno and title of each book that is bought by all students who major in both `CS' and in `Math'.

SELECT DISTINCT Book.BookNo, Book.Title
FROM
    Student Student, Book Book
WHERE NOT EXISTS
(
        (SELECT S.Sid
        FROM CSMajorStudent S
        where isMajorIn(S.Sid,'Math'))
    EXCEPT
        (SELECT B.Sid
        FROM Buys B
        WHERE
        B.BookNo = Book.BookNo)
)
order by Book.BookNo ASC;

-- 13. Find the sid and name of each student who not only bought books that were bought by at least two `CS' students.
select Student.Sid,Student.Sname
from Student Student
where exists
(
        (select book.BookNo from bookBoughtBy(Student.Sid) book)
        except
        (
         select book.BookNo
         from bookBoughtBy(Student.Sid) book
         where exists (
            select *
            from CSMajorStudent S1,CSMajorStudent s2
            where S1.Sid != S2.Sid
            and
            S1.Sid in (select * from everyonewhoBought(book.BookNo))
            and
            S2.Sid in (select * from everyonewhoBought(book.BookNo))
         )
        )
);

--14. Find the sid and name of each student who bought at most one book that cost more than $20.
-- neg of at leat two

select Student.Sid , Student.Sname
from student Student
WHERE not exists (
    select *
    from Book B1,Book B2
    where
    B1.BookNo != B2.BookNo
    and
    bought(student.Sid,B1.BookNo)
    and
    bought(student.Sid,B2.BookNo)
    and
    b1.price >= 20
    and
    b2.price >=20
);

-- 15. Find each (s; b) pair where s is the sid of a student and where b is the bookno of a book whose price is the cheapest among the books bought by that student.

select (Student.Sid,Book.BookNo)
from Student Student,Book Book
where Bought(student.Sid,Book.BookNo)
and Book.price <= all(
    select DISTINCT
    tmp.price
    from
    bookBoughtBy(Student.Sid) tmp);

-- 16 Find each pair (s1; s2) where s1 and s2 are the sids of students who have a common major but who did not buy the same books.

select (S1.Sid,S2.Sid)
from student S1,Student S2
where 
S1.Sid != S2.sid
-- common major
and
exists 
    (select *
    from
    studentMajor(S1.Sid) s1major
    where
    s1major in (select * from studentMajor(S2.Sid))
    )
and
-- did not buy same book
exists
((select *
  from bookBoughtBy(S1.Sid) s1Books
  where s1Books.BookNo not in (select s2Books.BookNo from bookBoughtBy(S2.Sid) s2Books))
  union
  (select *
  from bookBoughtBy(S2.Sid) s2Books
  where s2Books.BookNo not in (select s1Books.BookNo from bookBoughtBy(S1.Sid) s1Books))
  );


-- 17 Find the triples (s1; s2; b) where s1 and s2 are the sids of students and where b is the bookno of a book that was bought by student s1 but not by student s2.

select distinct  student1.Sid,Student2.Sid,Book.BookNo
from student student1,student student2,book Book
where
student1.Sid != student2.Sid
and book.BookNo in (
    (select tmp.BookNo
    from bookBoughtBy(Student1.Sid) tmp)
    except
    (select tmp.BookNo
    from bookBoughtBy(Student2.Sid) tmp)
);

-- 18. Find each pair (s1; s2) where s1 and s2 are the sids of two dierent students and such that student s1 and student s2 bought exactly one book in common.
select * from (
    -- bought at least two book in common
    (select distinct Student1.Sid as A1,Student2.Sid as A2
    from Student Student1,Student Student2

    where
        student1.Sid != student2.Sid
        and
        not exists (
            
            select *
            from bookBoughtBy(Student1.Sid) s1book1,bookBoughtBy(Student1.Sid) s1book2,bookBoughtBy(Student2.Sid) s2book1,bookBoughtBy(Student2.Sid) s2book2
    
            where 
            s1book1.BookNo != s1book2.BookNo 
            and
            s2book1.BookNo != s2book2.BookNo 
            and
            ((s1book1.BookNo = s2book1.bookNo and s1book2.BookNo = s2book2.bookNo) 
            or
            (s1book1.BookNo = s2book2.bookNo and s1book2.BookNo = s2book1.bookNo))
)
)
except
-- bought no book in common
    (select distinct Student1.Sid,Student2.Sid
    from Student Student1,Student Student2
    where
    student1.Sid != student2.Sid
    and
        not exists(
            (select tmp.BookNo from bookBoughtBy(Student1.Sid) tmp)
            intersect
            (select tmp.BookNo from bookBoughtBy(Student2.Sid) tmp)
)
)) tmp
order By tmp.a1 ASC
;

-- 19. Find the bookno of each book that was bought buy all-but-one student who majors in `CS'.

select distinct Book.BookNo
from Book Book, CSMajorStudent Student
WHERE
-- not all cs major student bought this book
exists (
    (select S.Sid
    from CSMajorStudent S)
    except
    (select * 
    from everyonewhoBought(Book.BookNo) tmp)
)
and
-- cs Student who bought that book union we a cs major student  -  all cs student  -> null
not exists(
    
    (
        (select S.Sid
    from CSMajorStudent S)
    )
    except
    (
        ((select * 
        from everyonewhoBought(Book.BookNo) tmp)
        intersect
        (select S.Sid
        from CSMajorStudent S))
    union
        (select Student.Sid
        from Student S
        where Student.Sid = S.Sid)
    )
);

\c postgres;
DROP DATABASE jz;

-- select * from everyonewhoBought(2011);