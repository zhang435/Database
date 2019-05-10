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


/**
Consider following function setunion which computes 
the set union of two sets represented as arrays.
Notice that this function is defined poly- morphically.
**/

create or replace function setunion(A anyarray, B anyarray)
         returns anyarray as
     $$ select ARRAY(select unnest(A)
                     union
                     select unnest(B));
     $$ language sql;

-- Q1.a
-- Inthestyleofthesetunionfunction,writeafunctionsetintersection that computes the intersection of two sets.
create or replace function setintersection(A anyarray, B anyarray)
         returns anyarray as
     $$ select ARRAY(select unnest(A)
                     INTERSECT
                     select unnest(B));
     $$ language sql;

-- Q1.b
-- Inthestyleofthesetunionfunction,writeafunctionsetdifference that computes the difference of two sets.
create or replace function setdifference(A anyarray, B anyarray)
         returns anyarray as
     $$ select ARRAY(SELECT UNNEST(A)
                     EXCEPT
                     SELECT UNNEST(B)
                );
     $$ language sql;

create or replace function memberof(x anyelement, A anyarray)
        returns boolean as
$$
  select x = SOME(A);
$$ language sql;

-- 
create or replace view student_books as
     select s.sid as student, array(select t.bookno
                                from   buys t
                                where  t.sid = s.sid
                                order by bookno) as books
     from   student s
     order by sid;


-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Q2.a
/**
 Define a view book_students(bookno,students) which associates with each book
 the set of students who bought that book. Observe that there may be books that
 are not bought by any student.
**/
CREATE OR REPLACE view book_students AS
    SELECT b.bookno, ARRAY(
                SELECT t.sid
                FROM buys t
                where t.bookno = b.bookno
                ORDER BY sid
            )
        as students
    from book b
    ORDER BY bookno;

-- Q2.b
/**
Define a view book citedbooks(bookno,citedbooks) which asso- ciates
with each book the set of books that are cited by that book.
Observe that there may be books that cite no books.
**/
CREATE OR REPLACE VIEW cited_books AS
    SELECT b.bookno as book,ARRAY(
        SELECT c.CitedBookNo
        from Cites c
        where C.bookno = b.bookno
        ORDER BY CitedBookNo
    ) as citedbooks
    from book b
    ORDER BY bookno;

-- Q2.c
/**
Define a view book citingbooks(bookno,citingbooks) which associates with each boo
the set of books that cite that book. Observe that there may be books that are not cited.
**/
CREATE OR REPLACE VIEW citing_books AS
    SELECT b.bookno as bookno,ARRAY(
        SELECT c.bookno
        from Cites c
        where C.CitedBookNo = b.bookno
        ORDER BY CitedBookNo
    ) as citedbooks
    from book b
    ORDER BY bookno;

-- Q2.d
/**
Define a view major students(major,students) which associates with each major the set of
students who have that major. (You can assume that each major has at least one student.)
**/
CREATE OR REPLACE VIEW major_students AS
    SELECT distinct m.major as major, ARRAY(
        SELECT mx.sid
        FROM major mx
        WHERE mx.major = m.major
        ORDER BY sid
    ) as students
    FROM major m
    ORDER BY major;

-- Q2.e
/**
Define a view student_majors(sid,majors) which associates with each student the set of his or
her majors. Observe that there can be students who have no major.
**/
CREATE OR REPLACE VIEW student_majors AS
    SELECT distinct s.sid as student, ARRAY(
        SELECT mx.major
        FROM major mx
        WHERE mx.sid = s.sid
        ORDER BY major
    ) as majors
    FROM student s
    ORDER BY sid;

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Q3.a
/**
(a) Find the sid of each student who bought precisely 2 books.
**/
SELECT student
from student_books sb
where cardinality(sb.books) = 2;

-- Q3.b
/**
Find the sid of each student who bought all the books bought by the student with sid 1001.
**/
SELECT sb1.student
FROM student_books sb1,student_books sb2
where sb2.student = 1001 and cardinality(setdifference(sb2.books,sb1.books)) = 0;

-- Q3.C
/**
Find the bookno of each book that cites fewer than 2 books that each cost more than $30.
**/
SELECT cb.book
from cited_books cb
where CARDINALITY(setintersection(cb.citedbooks,(SELECT ARRAY_AGG(bookno) from book WHERE price > 30))) < 2;

-- Q3.d
/**
Find the bookno and title of each book that was not only bought by students who major both in ‘CS’ and in ‘Math’.
-- neg the question
find the bookno and title of each book tht was only bought by students who major in CS and MATH
**/
with
students_only_major_in_CS_Computer as(
    select sm.student as sid
    from student_majors sm
    where CARDINALITY(sm.majors) = 2 and
    memberof('Math',sm.majors) and
    memberof('CS',sm.majors)
)
SELECT distinct bs.bookno
from book_students as bs,
    student_majors as sm
where 
    memberof(sm.student, bs.students) and
    CARDINALITY(setdifference(bs.students,(select ARRAY_AGG(sid) from students_only_major_in_CS_Computer))) > 0;

-- Q3.e
/**
Find the sid-bookno pairs (s, b) pairs such student s bought book b and such that book b is cited by at least
two books that cost less than $50.
**/
with
    book_cost_less_than_50 as(
        select bookno
        from book
        where price < 50
    ),
    cited_books_least_2_less_50 as(
        select cb.bookno
        from citing_books cb
        where CARDINALITY(setintersection(ARRAY(select * from book_cost_less_than_50), cb.citedbooks)) > 1
    )
SELECT s.sid,b.bookno
from student s, book b,student_books sb
where s.sid = sb.student and
       b.bookno in (SELECT * from cited_books_least_2_less_50) and
       memberof(b.bookno,sb.books)
;

-- Q3.f
/**
Find the tuple (students) where students is the set of students who major in ‘CS’ and in ‘Math’.
TODO: unable to solve the (x,y), (y,x) issue
**/
with student_who_major_in_both_math_cs as(
    SELECT UNNEST(setintersection( (select students from major_students where major = 'CS') ,  (select students from major_students where major = 'Math')))
)
select (s1.sid,s2.sid)
from student s1, student s2
where
memberof(s1.sid,array(select * from student_who_major_in_both_math_cs)) and
memberof(s2.sid,array(select * from student_who_major_in_both_math_cs)) and
s1.sid <> s2.sid;

-- Q3.g
/**
Find each pair (s, majors) where s is the sid of a student who bought none of the books bought by
student with sid 1001 and where majors is the set of majors of the student s.
**/
select sm.student,sm.majors
from student_majors sm
where
    CARDINALITY(setintersection(
        (select books from student_books where student = sm.student),
        (select books from student_books where student = 1001)
        )) = 0;

-- Q3.h
/**
Find the tuple (books) where books is the set of books bought by ‘CS’ students.
**/
select ARRAY(
    select  distinct unnest(sb.books) as tmp
    from student_books sb
    where memberof(sb.student,(select students from major_students where major = 'CS'))
    ORDER by tmp
);

-- Q3.i
/**
(i) Find the tuple (students) where students is the set of students who bought books that cites at least two books.
**/
with book_cites_at_least_two_other_books AS(
    select book
    from cited_books
    where CARDINALITY(citedbooks) > 1
)
SELECT ARRAY(
    select DISTINCT unnest(students) as tmp
    from book_students
    where bookno in (select * from book_cites_at_least_two_other_books)
    order by tmp
);

-- Q3.j
/**
Find the pairs (b, students) where b is a bookno and students is the set CS students who bought that book.
**/
with CS_Major_Student As(
    select UNNEST(students) as tmp
    from major_students
    where Major = 'CS'
)
SELECT bs.bookno,
    array(SELECT UNNEST(
        setintersection((select ARRAY_AGG(tmp) from CS_Major_Student), bs.students)
    ))
from book_students bs
order by bs.bookno;

-- Q3.k
/**
Find the sids of students who major in ‘CS’ and who did not buy any of the books bought by the students who major in ‘Math’.”
**/
with
    book_bought_by_math_student as(
        SELECT UNNEST(sb.books)
        from student_books sb
        where memberof(sb.student, (select students from major_students where major = 'Math'))
    ),
    student_bought_book_bought_by_math_students as(
        SELECT sb.student
        from student_books sb
        where CARDINALITY (setintersection(sb.books,(select ARRAY(select * from book_bought_by_math_student)))) = 0
    )
SELECT UNNEST(ms.students)
from major_students ms
where major = 'CS'
INTERSECT
SELECT *
from student_bought_book_bought_by_math_students;

-- Q3.l
/**
Find the pairs (b1,b2) of different booknos of books that are bought by the same students.
**/
SELECT distinct (bs1.bookno,bs2.bookno)
from book_students bs1, book_students bs2
where bs1.bookno <> bs2.bookno and
        (CARDINALITY(setintersection(bs1.students,bs2.students)) = CARDINALITY(bs1.students)) and 
        (CARDINALITY(bs1.students) =  CARDINALITY(bs2.students));

-- Q3.m
/**
Find the pairs (b1,b2) of different booknos of books such that there are fewer
Math students who bought book b1 than there are ‘CS’ students who bought book b2.
**/
with
    mathstudents AS(
        select UNNEST(students) mathstudent
        from major_students
        where major = 'Math'),
    csstudents AS(
        select UNNEST(students) csstudents
        from major_students
        where major = 'CS')
SELECT DISTINCT (bs1.bookno,bs2.bookno)
from book_students bs1,
     book_students bs2
where bs1.bookno <> bs2.bookno and
    --   CARDINALITY(setintersection(bs1.students,ARRAY(select * from mathstudents))) > 0 and
    --   CARDINALITY(setintersection(bs2.students,ARRAY(select * from csstudents))) > 0 and 
      CARDINALITY(setintersection(bs1.students,ARRAY(select * from mathstudents))) < CARDINALITY(setintersection(bs2.students,ARRAY(select * from csstudents)));

-- Q3.n
/**
Find the sid of each student who bought all but one book that cost more than $50.
**/
with book_cost_more_than_50 as (
    SELECT bookno
    from book
    where price > 50
)
SELECT sb.student
from student_books sb
where (CARDINALITY(
        setdifference(
            ARRAY(select * from book_cost_more_than_50),
            sb.books
        )
)) = 1;



\c postgres;
DROP DATABASE jz;