CREATE DATABASE JZ;

--Switch to your new database
\c jz
CREATE TABLE A ( val INT PRIMARY KEY);


CREATE TABLE B ( val INT PRIMARY KEY);


CREATE TABLE C ( val INT PRIMARY KEY);


CREATE TABLE P ( val boolean);


CREATE TABLE Q ( val boolean);


CREATE TABLE R ( val boolean);


INSERT INTO A(
              VALUES (1), (2), (3) );


INSERT INTO B(
              VALUES (1), (3), (4), (5) );


INSERT INTO C(
              VALUES (1), (2), (3), (4), (5), (20) );

/**
t | t | t | t
t | t | f | f
t | t |   |
t | f |   | t
t |   | t | t
t |   | f |
t |   |   |
f | t | t | t
*/
INSERT INTO P (
               VALUES (TRUE),(TRUE),(TRUE),(TRUE),(TRUE),(TRUE),(TRUE),(FALSE));


INSERT INTO Q(
              VALUES (TRUE),(TRUE),(TRUE),(FALSE),(NULL),(NULL),(NULL),(TRUE));


INSERT INTO R(
              VALUES (TRUE),(FALSE),(NULL),(NULL),(TRUE),(FALSE),(NULL),(TRUE));


CREATE MATERIALIZED VIEW A_intersection_B AS
SELECT num1.num1
FROM
  (SELECT A.val AS num1
   FROM A) AS num1,
     B num2
WHERE num1 = num2.val;


-- SELECT *
-- FROM A_intersection_B;


CREATE MATERIALIZED VIEW A_except_B AS
SELECT num1.num1
FROM
  (SELECT A.val AS num1
   FROM A) AS num1
WHERE num1 NOT IN
    (SELECT tmp.val
     FROM B AS tmp);


-- SELECT *
-- FROM A_except_B;


CREATE MATERIALIZED VIEW B_except_A AS
SELECT num1.num1
FROM
  (SELECT B.val AS num1
   FROM B) AS num1
WHERE num1 NOT IN
    (SELECT tmp.val
     FROM A AS tmp);


CREATE MATERIALIZED VIEW B_except_C AS
SELECT num1.num1
FROM
  (SELECT B.val AS num1
   FROM B) AS num1
WHERE num1 NOT IN
    (SELECT tmp.val
     FROM C AS tmp);


-- SELECT *
-- FROM B_except_A;


CREATE MATERIALIZED VIEW A_union_B AS
SELECT *
FROM (
        (SELECT A.val
         FROM A)
      UNION
        (SELECT num2.val
         FROM B num2)) tmp;


-- SELECT *
-- FROM A_intersection_B;

-- Q1
SELECT A.val AS x,
       sqrt(A.val) AS squar_root_x,
       A.val * A.val AS squar_root_x,
       power(2,A.val) AS two_to_the_power_x,
       factorial(A.val) AS x_factorial,
       ln(A.val) AS logarithm_x
FROM A A;

-- Q2
SELECT NOT EXISTS
  (SELECT *
   FROM A_except_B) AS empty_a_minus_b,
  EXISTS(
      (SELECT *
          FROM A_except_B)
      UNION
      (SELECT *
       FROM B_except_A)) AS not_empty_symmetric_difference,
       NOT EXISTS
  (SELECT *
   FROM A_intersection_B) AS empty_a_intersection_b;

-- Q3
/**
Let Pair(x; y) be a relation of pairs (x; y). (The domain of x and
y is INTEGER.) Write a SQL query that produces a relation with
attributes (x1; y1; x2; y2) such that (1) (x1; y1) and (x2; y2) are dierent
pairs in the relation Pair, and (2) x1 + y1 = x2 + y2.
*/
SELECT DISTINCT num1.val AS x1,
                num2.val AS y1,
                num3.val AS x2,
                num4.val AS y2
FROM A num1,
     A num2,
     A num3,
     A num4
WHERE num1.val <> num3.val
  AND num2.val <> num4.val
  AND num1.val + num2.val = num3.val + num4.val;

-- Q4
/**
SQL uses 3-valued logic where it concerns the treatment of NULL val-
ues. (Read your textbook or search the web for relevant information.)
Consider 3 unary relation schemas p(value), q(value), and r(value)
where the type of the attribute value is boolean. Populate each of
these 3 unary relations with the values true, false, and NULL.
Write a SQL statement that generates the 3-valued truth table for the
Propositional Logic statement
neg (negP V Q)
*/
SELECT DISTINCT p.val AS p,
                q.val AS q,
                r.val AS r,
                NOT ((NOT p.val)
                     OR q.val)
OR r.val AS not_not_p_or_q_or_r
FROM P p,
     Q q,
     R r;

-- Q5
/**
Determine the truth-value of A \ B 6= ;. For example, if A =
f1; 2g and B = f1; 4; 5g then the result of your SQL statements
should be
answer
--------
t
(1 row)
If, however, A = f1; 2g and B = f3; 4g then the result of your
statement should be
answer
--------
f
(1 row)
*/ -- a A interect B

SELECT exists
  ( SELECT *
   FROM A_intersection_B) AS answer;


SELECT exists
  ( SELECT *
   FROM A num1
   WHERE EXISTS
       ( SELECT *
        FROM B num2
        WHERE num1.val = num2.val ) ) AS answer;

-- b A belongs to B

SELECT NOT exists(
                    (SELECT *
                     FROM A)
                  EXCEPT
                    (SELECT *
                     FROM B)) AS answer;


SELECT NOT exists
  ( SELECT *
   FROM A num1
   WHERE num1.val NOT IN
       ( SELECT tmp.val
        FROM B tmp ) ) AS ans;

-- c A and B = B
-- -> A = B

SELECT NOT exists(
                    (SELECT *
                     FROM A_union_B)
                  EXCEPT
                    (SELECT *
                     FROM A_intersection_B)) AS ans;


SELECT NOT exists
  ( SELECT *
   FROM A num1, B num2
   WHERE num1.val NOT IN
       (SELECT val
        FROM B)
     OR num2.val NOT IN
       (SELECT val
        FROM A) ) AS ans;

-- d A is not B

SELECT exists(
                (SELECT *
                 FROM A_union_B)
              EXCEPT
                (SELECT *
                 FROM A_intersection_B)) AS ans;


SELECT exists
  ( SELECT *
   FROM A num1, B num2
   WHERE num1.val NOT IN
       (SELECT val
        FROM B)
     OR num2.val NOT IN
       (SELECT val
        FROM A) ) AS ans;

--  e Determine the truth-value of len(A interesect B) <= 2

SELECT NOT exists
  ( SELECT *
   FROM A_intersection_B X1, A_intersection_B X2, A_intersection_B X3
   WHERE X1.num1 != X2.num1
     AND X1.num1 != X3.num1
     AND X2.num1 != X3.num1 ) AS ans;


SELECT NOT exists
  ( SELECT *
   FROM A_intersection_B X1, A_intersection_B X2, A_intersection_B X3
   WHERE X1.num1 != X2.num1
     AND X1.num1 != X3.num1
     AND X2.num1 != X3.num1 ) AS ans;

-- f (A union B) belongs to C

SELECT NOT exists(
                    (SELECT *
                     FROM A_union_B)
                  EXCEPT
                    (SELECT *
                     FROM C)) AS ans;


SELECT NOT exists
  ( SELECT *
   FROM A_union_B smaller
   WHERE smaller.val NOT IN
       (SELECT val
        FROM C) ) AS ans;

-- g |(A - B) U (B - C)| = 1

CREATE VIEW A_minus_B_UNION_B_minus_C AS
SELECT *
FROM (
        (SELECT *
         FROM A_except_B)
      UNION
        (SELECT *
         FROM B_except_C)) tmp;


SELECT *
FROM A_minus_B_UNION_B_minus_C;


SELECT NOT exists
  ( SELECT *
   FROM A_minus_B_UNION_B_minus_C s1, A_minus_B_UNION_B_minus_C s2
   WHERE s1.num1 != s2.num1 ) AS ans;


SELECT NOT exists
  ( SELECT *
   FROM A_minus_B_UNION_B_minus_C s1, A_minus_B_UNION_B_minus_C s2
   WHERE s1.num1 != s2.num1 ) AS ans;

/**
6. Repeat Problem 5 by using the COUNT aggregate function. For each
sub-problem, you only need to provide one answer and you are allowed
to use the set operations UNION, INTERSECT, and EXCEPT.
*/ -- A N B not empty

SELECT count(1) > 0
FROM A_intersection_B;

-- A belongs to B

SELECT count(1) = 0
FROM A_except_B;

-- A N B = B

SELECT count(1) = 0
FROM (
        (SELECT *
         FROM A_union_B)
      EXCEPT
        (SELECT *
         FROM A_intersection_B)) tmp;

-- A not euqal to be B

SELECT count(1) <> 0
FROM (
        (SELECT *
         FROM A_union_B)
      EXCEPT
        (SELECT *
         FROM A_intersection_B)) tmp;

-- A N B <= 2

SELECT count(1) < 3
FROM A_intersection_B;

-- A U B belongs to C

SELECT count(1) = 0
FROM (
        (SELECT *
         FROM A_union_B)
      EXCEPT
        (SELECT *
         FROM C)) tmp;

-- A

SELECT count(1) = 1
FROM (
        (SELECT *
         FROM A_except_B)
      UNION
        (SELECT *
         FROM B_except_C)) tmp;

/**
7, 
Let W(A;B) be a relation schema. The domain of A is INTEGER
and the domain of B is VARCHAR(5).
Write a SQL query with returns the A-values of tuples in W if A is
a primary key of W. Otherwise, i.e., if A is not a primary key, then
your query should return the A-values of tuples in W for which the
primary key property is violated. (In this query you should consider
creating views for intermediate results.)
*/

create table W(
  A int,B VARCHAR(15)
);

INSERT INTO W(
  VALUES
  (1,'A'),
  (2,'B'),
  (3,'C')
);

INSERT INTO W(
  VALUES
  (2,'D'),
  (3,'E'),
  (4,'F')
);

select q.A from (
  (select w1.A
  from W w1 ,W w2 
  where w1.A = w2.A and w1.B != w2.B)
  union
  (
    select w1.A
    from W W1, W W2
    where not exists (
      select w1.A
      from W w1 ,W w2 
      where w1.A = w2.A and w1.B != w2.B
    )
  ) 
) q;

/**
8.
Use the same les student.txt, majors.txt, book.txt, and buys.txt from
Assignment 2.
Consider the following relation schemas about students and books.
Student(Sid; Sname)
Major(Sid;Major)
Book(BookNo; Title; Price)
Buys(Sid;BookNo)
The relation Major stores students and their majors. A student can
have multiple majors but we also allow that a student has no major.
Assume the following domains for the attributes:
*/


CREATE TABLE Student ( Sid INT PRIMARY KEY,
                                       Sname VARCHAR(15));

-- Book(BookNo; Title; Price)

CREATE TABLE Book ( BookNo INT PRIMARY KEY,
                                       Title VARCHAR(30),
                                             Price INT);


CREATE TABLE Major ( Sid INT REFERENCES Student(Sid),
                                        Major VARCHAR(15));

-- Buys(Sid;BookNo)

CREATE TABLE Buys ( Sid INT REFERENCES Student(Sid),
                                       BookNo INT REFERENCES Book(BookNo));


INSERT INTO Book(
                 VALUES (2001, 'Databases', 40), (2002, 'OperatingSystems', 25), (2003, 'Networks', 20), (2004, 'AI', 45), (2005, 'DiscreteMathematics', 20), (2006, 'SQL', 25), (2007, 'ProgrammingLanguages', 15), (2008, 'DataScience', 50), (2009, 'Calculus', 10), (2010, 'Philosophy', 25), (2012, 'Geometry', 80), (2013, 'RealAnalysis', 35), (2011, 'Anthropology', 50), (2014, 'Topology', 70));


INSERT INTO Student(
                    VALUES (1001, 'Jean'), (1002, 'Maria'), (1003, 'Anna'), (1004, 'Chin'), (1005, 'John'), (1006, 'Ryan'), (1007, 'Catherine'), (1008, 'Emma'), (1009, 'Jan'), (1010, 'Linda'), (1011, 'Nick'), (1012, 'Eric'), (1013, 'Lisa'), (1014, 'Filip'), (1015, 'Dirk'), (1016, 'Mary'), (1017, 'Ellen'), (1020, 'Greg'), (1022, 'Qin'), (1023, 'Melanie'), (1040, 'Pam'));


INSERT INTO Buys(
                 VALUES (1023, 2012), (1023, 2014), (1040, 2002), (1001, 2002), (1001, 2007), (1001, 2009), (1001, 2011), (1001, 2013), (1002, 2001), (1002, 2002), (1002, 2007), (1002, 2011), (1002, 2012), (1002, 2013), (1003, 2002), (1003, 2007), (1003, 2011), (1003, 2012), (1003, 2013), (1004, 2006), (1004, 2007), (1004, 2008), (1004, 2011), (1004, 2012), (1004, 2013), (1005, 2007), (1005, 2011), (1005, 2012), (1005, 2013), (1006, 2006), (1006, 2007), (1006, 2008), (1006, 2011), (1006, 2012), (1006, 2013), (1007, 2001), (1007, 2002), (1007, 2003), (1007, 2007), (1007, 2008), (1007, 2009), (1007, 2010), (1007, 2011), (1007, 2012), (1007, 2013), (1008, 2007), (1008, 2011), (1008, 2012), (1008, 2013), (1009, 2001), (1009, 2002), (1009, 2011), (1009, 2012), (1009, 2013), (1010, 2001), (1010, 2002), (1010, 2003), (1010, 2011), (1010, 2012), (1010, 2013), (1011, 2002), (1011, 2011), (1011, 2012), (1012, 2011), (1012, 2012), (1013, 2001), (1013, 2011), (1013, 2012), (1014, 2008), (1014, 2011), (1014, 2012), (1017, 2001), (1017, 2002), (1017, 2003), (1017, 2008), (1017, 2012), (1020, 2001), (1020, 2012), (1022, 2014));


INSERT INTO Major(
                  VALUES (1001, 'Math'), (1001, 'Physics'), (1002, 'CS'), (1002, 'Math'), (1003, 'Math'), (1004, 'CS'), (1006, 'CS'), (1007, 'CS'), (1007, 'Physics'), (1008, 'Physics'), (1009, 'Biology'), (1010, 'Biology'), (1011, 'CS'), (1011, 'Math'), (1012, 'CS'), (1013, 'CS'), (1013, 'Psychology'), (1014, 'Theater'), (1017, 'Anthropology'), (1022, 'CS'), (1015, 'Chemistry'));

-- ai
-- @param: student.Sid
-- get book bought by this student
-- return (BookNo INT,Price INT)

CREATE FUNCTION booksboughtbystudent(id int) 
returns TABLE (bookno int , title varchar , price int) AS $$ 
SELECT book.bookno, 
       book.title, 
       book.price 
FROM   buys buys, 
       book book 
WHERE  book.bookno = buys.bookno 
AND    buys.sid = id $$ language sql;

-- aii

SELECT DISTINCT *
FROM booksBoughtbyStudent(1001) tmp
ORDER BY tmp.BookNo ASC;


SELECT DISTINCT *
FROM booksBoughtbyStudent(1015) tmp
ORDER BY tmp.BookNo ASC;

-- aiii
-- A. Find the sids and names of students who bought exactly one book that cost less than $50.

SELECT S.Sid,
       S.Sname
FROM Student S
WHERE
    ( SELECT count(1)
     FROM booksBoughtbyStudent(S.Sid) booksBoughtbyStudent
     WHERE booksBoughtbyStudent.Price < 50) = 1;

-- aiii
-- B. Find the pairs of different student sids (s1,s2) such that student s1 and student s2 bought the same books.

SELECT DISTINCT S1.Sid,
                S2.Sid
FROM Student S1,
     Student s2
WHERE S1.Sid <>S2.Sid
  AND NOT exists( ( (
                       (SELECT BookNo
                        FROM booksBoughtbyStudent(S1.Sid))
                     UNION
                       (SELECT BookNo
                        FROM booksBoughtbyStudent(S2.Sid)) )
                   EXCEPT (
                             (SELECT BookNo
                              FROM booksBoughtbyStudent(S1.Sid)) INTERSECT
                             (SELECT BookNo
                              FROM booksBoughtbyStudent(S2.Sid)) ) ));

-- bi
/***
i. Write a function
studentsWhoBoughtBook(bookno int)
returns table(sid int, sname VARCHAR(15))
*/ -- @param: Book.BookNo
-- get student who bought this book
-- return (sid int, sname VARCHAR(15))

CREATE FUNCTION studentsWhoBoughtBook(bn INT) RETURNS TABLE (Sid INT,Sname VARCHAR) AS $$
SELECT distinct Buys.Sid, student.Sname
FROM Buys Buys,Student student
WHERE Buys.Sid = student.Sid and Buys.BookNo = bn;
    $$ LANGUAGE SQL;

/**
find all the major student take
-- @param : get the Sid
-- return subquery with all major
**/
CREATE FUNCTION studentmajor(id int) 
returns TABLE (maj varchar) AS $$ 
SELECT major.major 
FROM   major major 
WHERE  major.sid = id; 

$$ language sql;

-- @param: Major
-- get the student major in given major
-- return (Student.Sid, Student.Sname)
CREATE FUNCTION studentsmajorin(maj varchar) 
returns TABLE (sid int , sname varchar) AS $$ 
SELECT s.sid, 
       s.sname 
FROM   student s 
WHERE  s.sid IN 
       ( 
              SELECT major.sid 
              FROM   major major 
              WHERE  major.major = maj); 

$$ language sql;
-- @param: BookNo
-- get the price of the Book
-- return (Student.Sid, Student.Sname)

CREATE FUNCTION priceOf(bookid INT) RETURNS bigint AS $$
SELECT SUM(Price)
FROM Book Book
where Book.BookNo = bookid
$$ LANGUAGE SQL;

/**
-- @param: student.Sid
-- totoal money spend by student in book
-- return int total spend\
*/
CREATE FUNCTION moneySpendOnBooksOfStudent (id int) RETURNS bigint AS $$
SELECT sum(price)
FROM   booksboughtbystudent(id) $$ LANGUAGE SQL;

/**
-- @param: student.Sid,student.Sid
-- the number of book that bought by student A but not bought by student B
-- return bigint the number book A-B
*/
CREATE FUNCTION BookBoughtByAButNotByB(aid int,bid int) RETURNS bigint AS $$
select count(1)
from (
    (select * from booksBoughtbyStudent(aid))
    except
    (select * from booksBoughtbyStudent(bid))
) tmp $$ LANGUAGE SQL;

-- bii. Test your function on the book with bookno 2001 and that with bookno 2010.

SELECT *
FROM studentsWhoBoughtBook(2001);


SELECT *
FROM studentsWhoBoughtBook(2010);

-- biii
/**
Using this function and the booksBoughtbyStudent function
from problem 8(a)i write the query \Find the booknos of
books bought by a least two CS students who each bought
at least one book that cost more that $30."
*/
SELECT book.bookno
FROM book Book
WHERE EXISTS
    (SELECT *
     FROM Studentswhoboughtbook(book.bookno) S1,
          Studentswhoboughtbook(book.bookno) S2
     WHERE S1.sid <> S2.sid
       AND 'CS' IN
         (SELECT *
          FROM Studentmajor(S1.sid))
       AND 'CS' IN
         (SELECT *
          FROM Studentmajor(S2.sid))
       AND 30 < ANY
         (SELECT BookBought.price
          FROM Booksboughtbystudent(S1.sid) BookBought)
       AND 30 < ANY
         (SELECT BookBought.price
          FROM Booksboughtbystudent(S2.sid) BookBought))
ORDER BY book.bookno; -- c

/***
Write the following queries in SQL by using aggregate functions
and user-dened functions. You can not use the EXISTS and
NOT EXISTS predicates.
*/ -- c i. Find the sid and major of each student who bought at least 4 books that cost more than $30.

SELECT DISTINCT student.sid,
                major.major
FROM student Student,
     major Major
WHERE student.sid = major.sid
  AND
    (SELECT Count(1)
     FROM Booksboughtbystudent(student.sid) B1
     WHERE B1.price > 30) > 3; -- c ii Find the pairs (s1; s2) of different students who spent the same amount of money on the books they bought.

SELECT DISTINCT S1.sid,
                S2.sid
FROM student S1,
     student S2
WHERE S1.sid <> S2.sid
  AND
    (SELECT Sum(price)
     FROM Booksboughtbystudent(S1.sid)) =
    (SELECT Sum(price)
     FROM Booksboughtbystudent(S2.sid)); -- iii. Find the sid and name of each student who spent more money on the books he or she bought than the average cost that was spent on books by students who major in `CS'.

SELECT student.sid,
       student.sname
FROM student
WHERE moneySpendOnBooksOfStudent(student.sid) >
    (SELECT avg(moneySpendOnBooksOfStudent(s.sid))
     FROM student s,
          major major
     WHERE s.sid = major.sid
       AND major = 'CS');

-- iv. Find the booknos and titles of the third most expensive books.

SELECT book.bookno,
       book.title
FROM book Book
WHERE book.price =
    (SELECT Max(E3.price)
     FROM book E3
     WHERE E3.price <
         (SELECT Max(E2.price)
          FROM book E2
          WHERE E2.price <
              (SELECT Max(price)
               FROM book))); -- v. Find the bookno and title of each book that is only bought by students who major in `CS'.


SELECT book.bookno,
       book.title
FROM book Book
WHERE
    (SELECT Count(1)
     FROM (
             (SELECT tmp.sid
              FROM Studentswhoboughtbook(book.bookno) tmp)
           EXCEPT
             (SELECT student.sid
              FROM student Student,
                   major Major
              WHERE student.sid = major.sid
                AND major.major = 'CS')) q) = 0; -- vi. Find the sid and name of each student who did not only buy books that were bought by at least two `CS' students.

SELECT student.sid,
       student.sname
FROM student Student
WHERE
    (SELECT Count(1)
     FROM (
             (SELECT Book.bookno
              FROM Booksboughtbystudent(student.sid) Book)
           EXCEPT
             (-- book bought by at leat two CS Major student
 SELECT book.bookno
              FROM book Book
              WHERE
                  (SELECT Count(1)
                   FROM (
                           (SELECT Student.sid
                            FROM Studentsmajorin('CS') Student) INTERSECT
                           (SELECT Students.sid
                            FROM Studentswhoboughtbook(book.bookno) students)) q) > 1)) q) > 0; -- vii. Find each (s; b) pair where s is the sid of a student and where b is the bookno of a book bought by that student whose price is strictly below the average price of the books bought by that student.


SELECT DISTINCT (student.sid,
                 buys.bookno)
FROM student student,
     buys buys
WHERE student.sid = buys.sid
  AND priceof(buys.bookno) <
    (SELECT avg(price)
     FROM booksboughtbystudent(student.sid));

-- viii. Find each pair (s1; s2) where s1 and s2 are the sids of different students who have a common major and who bought the same number of books.

SELECT (S1.Sid,
        S2.Sid)
FROM Student S1,
     Student S2
WHERE S1.Sid != S2.Sid
  AND
    (SELECT count(1)
     FROM (
             (SELECT *
              FROM Studentmajor(S1.Sid)) INTERSECT
             (SELECT *
              FROM Studentmajor(S2.Sid)) ) q) > 0
  AND -- bought same number of book

    (SELECT count(1)
     FROM booksBoughtbyStudent(S1.Sid)) =
    (SELECT count(1)
     FROM booksBoughtbyStudent(S2.Sid));

-- ix. Find the triples (s1; s2; n) where s1 and s2 are the sids of two students who share a major and where n is the number of books that was bought by student s1 but not by student s2.

SELECT (S1.Sid,
        S2.Sid,
        BookBoughtByAButNotByB(S1.Sid, S2.Sid))
FROM Student S1,
     Student S2
WHERE S1.Sid != S2.Sid
  AND
    (SELECT count(1)
     FROM (
             (SELECT *
              FROM Studentmajor(S1.Sid)) INTERSECT
             (SELECT *
              FROM Studentmajor(S2.Sid))) q) > 0;

-- x. Find the bookno of each book that was bought buy all-but- one student who majors in `CS'.

SELECT book.bookno
FROM book Book 
WHERE 
    (SELECT Count(1)
     FROM (
             (SELECT sid
              FROM Studentsmajorin('CS'))
           EXCEPT
             (SELECT sid
              FROM Studentswhoboughtbook(book.bookno))) q) = 1 
              order by Book.BookNo ASC;



-- Q9
CREATE DATABASE JZ2;
\c jz2;

CREATE TABLE Student ( Sid INT PRIMARY KEY,
                                       Sname VARCHAR(15));
CREATE TABLE Course (cno INT PRIMARY KEY,Sname VARCHAR(30),total INT, max INT);

CREATE TABLE Prerequisite (cno INT REFERENCES Course(cno),
                            prereq INT REFERENCES Course(cno));

CREATE TABLE HasTaken(sid INT REFERENCES Student(Sid) ,cno int REFERENCES Course(Cno));

CREATE TABLE Enroll(sid INT REFERENCES student(Sid),cno int REFERENCES Course(Cno));

CREATE TABLE Waitlist(sid int REFERENCES student(Sid),cno int REFERENCES Course(Cno), position int);

INSERT INTO Course (
    VALUES
    (201,'Programming',0,3),
    (202,'Calculus',0,3),
    (203,'Probability',0,3),
    (204,'AI',0,2),
    (301,'DiscreteMathematics',0,2),
    (302,'OS',0,2),
    (303,'Databases',0,2),
    (401,'DataScience',0,2),
    (402,'Networks',0,2),
    (403,'Philosophy',0,2));


INSERT INTO Prerequisite(
    VALUES
    (301,201),
    (301,202),
    (302,201),
    (302,202),
    (302,203),
    (401,301),
    (401,204),
    (402,302));
INSERT INTO Student(
    VALUES
    (1,'Jean'),
    (2,'Eric'),
 (3,'Ahmed'),
 (4,'Qin'),
 (5,'Filip'),
 (6,'Pam'),
 (7,'Lisa'));


INSERT INTO Hastaken(
    VALUES
    (1,201),
    (1,202),
    (1,301),
    (2,201),
    (2,202),
    (3,201),
    (4,201),
    (4,202),
    (4,203),
    (4,204),
    (5,201),
    (5,202),
    (5,301),
    (5,204));

/**
 A student can only enroll in a course if he or she has taken all
the prerequisites for that course. If the enrollment succeeds, the
total enrollment for that course needs to be incremented by 1.

 A student can only enroll in a course if his or her enrollment does
not exceed the maximum enrollment for that course. However,
the student must then be placed at the next available position on
the waitlist for that course.

 A student can drop a course. When this happens and if there are
students on the waitlist for that course, then the student who is
at the rst position gets enrolled and removed from the waitlist.
If there are no students on the waitlist, then the total enrollment
for that course needs to decrease by 1.

 A student may remove himself or herself from the waitlist for a
course. When this happens, the positions of the other students
who are waitlisted for that course need to be adjusted.
*/

-- @param: cno
-- Prerequisite need by for given class
-- return cno
CREATE FUNCTION Prerequisite(courseno int) 
returns TABLE (cno int) AS $$ 
select Prerequisite.prereq
from Prerequisite Prerequisite
where Prerequisite.cno = courseno
$$ language sql;

-- select * from Prerequisite(301);

-- @param: Sid
-- course the student took
-- return cno
CREATE FUNCTION allTheCourseTookBy(studentid int) 
returns TABLE (cno int) AS $$ 
select Hastaken.cno
from Hastaken Hastaken
where Hastaken.Sid = studentid
$$ language sql;

-- select * from allTheCourseTookBy(1);

-- @param : Sid Cno
-- checkif student can take given course
-- return boolean 
CREATE FUNCTION IfStudentCanEnrollIntoCourse(studentid int,courseno int) 
returns Boolean AS $$ 
select not exists(
    (select * from Prerequisite(courseno))
    except
    (select * from allTheCourseTookBy(studentid))
)
$$ language sql;

-- @param : Sid
-- get all the course enroll by student 
-- return cn s 
CREATE FUNCTION courseEnrolledIn(studentid int) 
returns TABLE (cno int) AS $$ 
select enroll.cno
from enroll enroll
where enroll.Sid = studentid
$$ language sql;

-- @param : cno
-- get the number of student enroll in the class 
-- return number of student
CREATE or replace FUNCTION numberofStudentEnroll(courseNum int)
returns bigint AS $$ 
select SUM(Course.total)
from Course Course
where Course.cno = courseNum
$$ language sql;

-- @param : cno
-- get the cap of a class
-- return cap
CREATE or replace FUNCTION capOfClass(courseNum int)
returns bigint AS $$ 
select SUM(Course.max)
from Course Course
where Course.cno = courseNum
$$ language sql;

-- enroll into course course
-- if he took all prerequeste
-- the class has enough space
-- if the class is full, add student into waitlist
create or replace function enrollIntoCourse() RETURNS trigger as
$$
begin
if(
    -- if all prerequire satfisy
    IfStudentCanEnrollIntoCourse(NEW.Sid,NEW.Cno) and
    -- if he is not already enrolled in the class
    (NEW.Cno not in (select tmp.cno from courseEnrolledIn(NEW.Sid) tmp))
)
    then if(numberofStudentEnroll(NEW.Cno) < capOfClass(NEW.Cno))
            THEN INSERT INTO enroll VALUES(NEW.sid, NEW.cno);
            UPDATE Course set total = total + 1
                    where Course.cno  = NEW.cno;
    else
        --  add to waitlist
        INSERT INTO waitlist VALUES(NEW.Sid,New.Cno, (select count(1) from waitlist waitlist where waitlist.cno = new.cno) + 1);
    end if;
END IF;
return NULL;
end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER enrollIntoCourse
BEFORE INSERT ON Enroll
    FOR EACH ROW
    WHEN (pg_trigger_depth() = 0)
        EXECUTE PROCEDURE enrollIntoCourse();

/**
-- trigger function that allow drop student from waitlist
*/
create or replace function updateResWaitList() returns trigger as
$$
    begin
    -- raise notice 'OLD: %', OLD.position;
    if ((select max(w.position) from waitlist w where w.cno = OLD.cno) <>  (select count(1) from waitlist w where w.cno = OLD.cno) and ((select count(1) from waitlist w where w.cno = OLD.cno) <> 0))
        THEN UPDATE Waitlist set position = OLD.position
            where position = OLD.position  + 1;
    end if;
    return NULL;
    end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER updateResWaitList
AFTER UPDATE OR DELETE ON waitlist
    FOR EACH ROW
        EXECUTE PROCEDURE updateResWaitList();

/**
trigger function that allow student to drop from the course
-- remove the total by 1
-- drop a student from wailist
-- add a student into enroll
*/

create or replace function dropFromEnroll() returns trigger as
$$
begin
    UPDATE Course set total = (total - 1) where Cno = OLD.Cno;
    if (select count(1) from waitlist w where w.Cno = OLD.Cno) != 0
      THEN
        insert into Enroll VALUES((select sum(w.Sid) from waitlist w where w.Cno = OLD.Cno and position = 1), OLD.Cno);
        delete from waitlist where position = 1 and Cno = OLD.Cno;
    
    end if;
    return NULL;
end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER DropClass
AFTER DELETE ON Enroll
    FOR EACH ROW
        EXECUTE PROCEDURE dropFromEnroll();


-- -- individual test

-- insert into Enroll VALUES(2,401);
-- insert into Enroll VALUES(1,401);
-- insert into Enroll VALUES(4,401);
-- insert into Hastaken VALUES(1,204);
-- insert into Enroll VALUES(1,401);
-- insert into Hastaken VALUES(2,204);
-- insert into Hastaken VALUES(2,301);
-- insert into Enroll VALUES(2,401);
-- insert into Hastaken VALUES(4,301);
-- insert into Enroll VALUES(4,401);

-- -- test waitlist 
-- insert into Hastaken VALUES(5,204);
-- insert into Enroll VALUES(5,401);
-- insert into waitlist VALUES(6,401,3);
-- insert into waitlist VALUES(7,401,4);

-- select * from waitlist;
-- delete from waitlist where position = 1;
-- delete from enroll where Sid = 2;
-- drop table enroll cascade;
-- drop function enrollIntoCourse cascade;
-- drop trigger enrollIntoCourse in enroll;


DROP DATABASE JZ2;
DROP DATABASE JZ;
\c postgres;

--  INSERT INTO waitlist VALUES(4,401, (select count(1) from waitlist waitlist where waitlist.cno = 401 and waitlist.Sid = 4) + 1);