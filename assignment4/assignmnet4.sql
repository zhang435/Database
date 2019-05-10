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




-- Q2
-- (a) (10 points) Find the sid and sname of each student who bought a book that cites another book.
Select distinct S.Sid,S.Sname
from Student S,Buys B,Cites C
where S.Sid = B.Sid and B.BookNo = C.BookNo;

-- (b) (10 points) Find the sid and sname of each student who has at least two majors.
Select distinct StudentMajor.Sid, StudentMajor.Sname
from (Select * from Major NATURAL JOIN Student) StudentMajor, Major Major
where StudentMajor.Sid = Major.Sid and StudentMajor.major <> Major.Major Order BY StudentMajor.Sid ASC;

-- (c) (10 points) Find the sid of each student who bought exactly one book.
Select distinct Sid 
from Buys
Except
Select B1.Sid
from Buys B1, Buys B2
where B1.Sid = B2.Sid and B1.BookNo <> B2.BookNo;

-- (d) (10 points) Find the bookno and title of each book with the second to lowest price.
with 
cheapestBook as 
(
	Select distinct Price
	from Book
	Except
	Select B2.Price
	from Book B1,Book B2
	where B1.price < B2.price
)
Select Book.BookNo,Book.title
from Book
where Book.price > all(select * from cheapestBook)
Except
select distinct B2.BookNo,B2.title
from Book B1,Book B2
where B1.Price <> (select * from cheapestBook) and B1.price < B2.price;

-- (e) (10 points) Find the bookno and title of each book that was only bought by the student with sid = 1001.
-- the question is problematic, since the 1001 did not even bought 2004 & 2005, which question mentioend that only bought
select BookNo,title
from Book Q
Except
select distinct BookNo,title
from (Buys NATURAL JOIN book) Q
where Q.Sid <> 1001;

-- (f) (10 points) Find the sid and sname of each student who bought at least two books that cost less than $50.
with 
BoughtPrice as
(
select Sid,BookNo,Price
from Buys NATURAL JOIN Book
)
select distinct S.Sid,S.Sname
from BoughtPrice B1, BoughtPrice B2, Student S
where B1.Sid = B2.Sid and B1.BookNo <> B2.BookNo and
	  B1.Price < 50 and b2.Price < 50 and S.Sid = B1.Sid;

-- (g) (10 points) Find the bookno of each book that was not bought by all students who major in CS.
-- \pi_{BookNo}(\pi_{Sid,BookNo}(CSMajorStudent \times Book) - Buys)
with
CSMajorStudent as (select Sid from Major where Major = 'CS')
select distinct BookNo
from(
select distinct CSS.Sid, BB.BookNo
from CSMajorStudent CSS, Book BB
Except
select *
from Buys
) q;

-- (h) (10 points) Find the bookno of each book that is not cited by a book that cost more than $50.
select BookNo
from book
Except
select CitedBookNo
from Cites 
where BookNo in (select BookNo from Book where price > 50);

-- (i) (10 points) Find the sid of each student who not only bought books that cost less than $30.
-- let BookCostLessThan30 = \pi{BookNo}(\sigma_{Price < 30}Book)
-- \pi_{Sid}(Buys -  \pi_{Sid,BookNo} BookCostLessThan30 \times Student)
with
BookCostLessThan30 as (
select BookNo
from Book
where price < 30
)
select distinct Sid
from(
	select *
from Buys
Except
select Student.Sid, B30.BookNo
from Student Student , BookCostLessThan30 B30
) q;

-- (j) (10 point) Find each pair (s; b) such that s is the sid of a student who bought a book that does not cite the book with bookno b.
select distinct Sid, c
from
(
		select Buys.Sid,Buys.BookNo,Book.BookNo as c
		from Buys,Book
	Except
		select Sid,BookNo,CitedBookNo as c
		from Buys NATURAL JOIN Cites 
		where Buys.BookNo = Cites.BookNo
) q;

-- (k) (10 points) Find the pair of dierent booknos (b1; b2) that where bought by the same CS students.

-- select distinct B1.BookNo,B2.BookNo
-- from Book B1,Book B2
-- where
--     not exists(
--     select b.sid
--         from Buys b,Major major
--         where b.Sid = major.sid and major.major = 'CS' and B.BookNo = B1.BookNo
--     except
--         select b.Sid
--         from Buys b,Major major
--         where b.Sid = major.sid and major.major = 'CS' and B.BookNo = b2.BookNo
--     )
-- and 
-- not exists(
--     select b.sid
--     from Buys b,Major major
--     where b.Sid = major.sid and major.major = 'CS' and B.BookNo = b2.BookNo
--     except
--     select b.sid
--     from Buys b,Major major
--     where b.Sid = major.sid and major.major = 'CS' and B.BookNo = B1.BookNo
-- )  and B1.BookNo <> B2.BookNo;


-- select distinct B1.BookNo,B2.BookNo
-- from Book B1,Book B2
-- where
--     not exists(
--         select b.sid
--         from Buys b,Major major
--         where b.Sid = major.sid and major.major = 'CS' and B.BookNo = B1.BookNo
--     except
--         select b.Sid
--         from Buys b,Major major
--         where b.Sid = major.sid and major.major = 'CS' and B.BookNo = b2.BookNo
--     )

(select distinct B1.BookNo,B2.BookNo
    from Book B1,Book B2
    where B1.BookNo <> B2.BookNo
    except
    select distinct bno1,bno2
        from (
                select b.sid, B1.BookNo as bno1,B2.BookNo as bno2
                from Buys b,Major major,Book B1,Book B2
                where b.Sid = major.sid and major.major = 'CS' and B.BookNo = B1.BookNo
            except
                select b.sid,B1.BookNo as bno1,B2.BookNo as bno2
                from Buys b,Major major,Book B1,Book B2
                where b.Sid = major.sid and major.major = 'CS' and B.BookNo = b2.BookNo
            ) q
        where q.bno1 <> q.bno2)
intersect  
(select distinct B1.BookNo,B2.BookNo
    from Book B1,Book B2
    where B1.BookNo <> B2.BookNo
    except
    select distinct bno1,bno2
        from (
                select b.sid, B1.BookNo as bno1,B2.BookNo as bno2
                from Buys b,Major major,Book B1,Book B2
                where b.Sid = major.sid and major.major = 'CS' and B.BookNo = B2.BookNo
            except
                select b.sid,B1.BookNo as bno1,B2.BookNo as bno2
                from Buys b,Major major,Book B1,Book B2
                where b.Sid = major.sid and major.major = 'CS' and B.BookNo = B1.BookNo
            ) q
where q.bno1 <> q.bno2);

    



-- (l) (10  points)  Find  the  pairs  of  dierent  sid  (s1,s2)  of students  such  that  all  books  bought  by  student  s1were also bought by student s2.

select S1.Sid,S2.Sid
from Student S1, Student s2
where S1.Sid <> S2.Sid
and
not exists (
select BookNo
from Buys
where Sid = S1.Sid

Except
select BookNo
from Buys
where Sid = S2.Sid
);

-- transform to RA Layout
select distinct q.sid1,q.sid2
from (
 select S1.Sid as Sid1, s2.Sid as Sid2
 from Student S1, Student s2
 where S1.Sid <> S2.Sid
 except
 (select Sid1,Sid2 from (
select b.BookNo,S1.Sid as Sid1, s2.Sid as Sid2
 from Buys B,Student S1, Student s2
 where B.Sid = S1.Sid
 except
 select BookNo,S1.Sid as Sid1, s2.Sid as Sid2
	from Buys B,Student S1, Student s2
	where B.Sid = S2.Sid
 	) q )
) q;

-- (m) (10 points) Find the bookno of each book that is cited by all but one book.
-- find the bookno of each book that is not cited by at least two book
with
notCite as ((select c1.BookNo,c2.BookNo as notCited from Cites c1,Cites c2) except (select * from Cites))
select BookNo
from notCite nc1 ,notCite nc2
where nc1.bookno <> nc2.bookno and nc1.notCited = nc2.notCited,
-------------------------------------------------------
-------------------------------------------------------
-- 3
-- (a) Find the sid and major of each student who bought a book that cost less than $20.

select m.sid, m.major
from major m
where m.sid in (
	select t.sid
	from buys t, book b
	where t.bookno = b.bookno and b.price < 20);


-- in -> exits
select m.sid, m.major
from major m
where exists(
	select *
	from buys t, book b
	where t.bookno = b.bookno and b.price < 20 and m.sid = t.sid);

-- exits -> one row
select distinct m.sid, m.major
from major m,buys t, book b 
where t.bookno = b.bookno and b.price < 20 and m.sid = t.sid;



-- (b) Find each (s; b) pair where s is the sid of a student and where b is the bookno of a book whose price is the cheapest among the books bought by that student.
select distinct t.sid, b.bookno
from buys t, book b
where t.bookno = b.bookno and
b.price <= ALL (
	select b1.price
	from buys t1, book b1
	where t1.bookno = b1.bookno and t1.sid = t.sid);

-- ALL -> except
select distinct t.sid, b.bookno
from buys t, book b
where t.bookno = b.bookno
except
select distinct t.sid, b.bookno
from buys t, book b,buys t1, book b1
where  t.bookno = b.bookno and t1.bookno = b1.bookno and t.Sid = t1.Sid and not b.price <= b1.price;

-- (c) Find the bookno and title of each book that cost between $20 and $40 and that is cited by another book.

select b.bookno, b.title
from book b
where 20 <= b.price and b.price <= 40 and
b.bookno in (
	select c.citedbookno
	from cites c);
-- in to exists

select b.bookno, b.title
from book b
where 20 <= b.price and b.price <= 40 and
exists (
	select *
	from cites c
	where c.citedbookno = b.bookno);

-- convert exists
select distinct b.bookno, b.title
from book b,cites c
where 20 <= b.price and b.price <= 40 and c.citedbookno = b.bookno;


-- (d) Find the sid and name of each student who majors in `CS' and who bought a book that is cited by a lower priced book.
select s.sid, s.sname
from student s
where s.sid in (select m.sid from major m where m.major = 'CS')
 AND
exists (select 1
from buys t, cites c, book b1, book b2
where s.sid = t.sid and t.bookno = c.citedbookno and
c.citedbookno = b1.bookno and c.bookno = b2.bookno and
b1.price > b2.price);

-- in to one row
select s.sid, s.sname
from student s,major m
where s.sid = m.sid and m.major = 'CS'
 AND
exists (select 1
from buys t, cites c, book b1, book b2
where s.sid = t.sid and t.bookno = c.citedbookno and
c.citedbookno = b1.bookno and c.bookno = b2.bookno and
b1.price > b2.price);


-- exists to one row

select distinct s.sid, s.sname
from student s,major m, buys t, cites c, book b1, book b2
where s.sid = m.sid and m.major = 'CS' AND s.sid = t.sid and t.bookno = c.citedbookno and c.citedbookno = b1.bookno and c.bookno = b2.bookno and b1.price > b2.price;


-- (e) Find the bookno and title of each book that is not bought by all students who major in `CS'.
select b.bookno, b.title
from book b
where exists (select m.sid
			  from major m
			  where m.major = 'CS' and
					  m.sid not in(select t.sid
								   from buys t
								   where t.bookno = b.bookno));

-- convert inner not in 
select m.sid
from major m,buys t
where m.major = 'CS' and
	  m.sid not in(select t.sid
					from buys t
					where t.bookno = b.bookno);


select m.sid
from major m
where m.major = 'CS'
except
select m.mid
from major m, buys t
where m.major = 'CS'
and m.sid = t.sid and t.bookno = b.bookno;




select b.bookno, b.title
from book b
where exists (
	select m.sid
	from major m
	where m.major = 'CS'
		except
	select m.sid
	from major m, buys t
	where m.major = 'CS'
	and m.sid = t.sid and t.bookno = b.bookno);

-- exists to one row
select distinct q.BookNo,q.title
from (
	select m.sid,b.BookNo,b.title
	from major m,Book b
	where m.major = 'CS'
	except
	select m.sid,B.BookNo,b.title
	from major m, buys t,book b
	where m.major = 'CS'
	and m.sid = t.sid and t.bookno = b.bookno
) q;

-- (f) Find the bookno and title of each book that is bought by all students who major in both `CS' and in `Math'.

select b.bookno, b.title
from book b
where not exists 
	(select s.sid
	from student s
	where s.sid in 
		(select m.sid from major m
		where m.major = 'CS') and
		s.sid in (select m.sid from major m
				where m.major = 'Math') and
			s.sid not in (select t.sid
							from buys t
						where t.bookno = b.bookno)) ;


-- convert subquery
select s.sid
	from student s
	where s.sid in 
		(select m.sid from major m
		where m.major = 'CS') and
		s.sid in (select m.sid from major m
				where m.major = 'Math') and
			s.sid not in (select t.sid
							from buys t
						where t.bookno = b.bookno);

-- convert in 
select s.sid
	from student s,major m,major m2
	where s.sid = m.sid  and  m.major = 'CS'   and
		  s.sid = m2.sid and m2.major = 'Math' and
		  s.sid not in (select t.sid
							from buys t
						where t.bookno = b.bookno);

-- convert not in
select s.sid
	from student s,major m,major m2
	where s.sid = m.sid  and  m.major = 'CS'   and
		  s.sid = m2.sid and m2.major = 'Math'
Except
select s.sid
	from student s,major m,major m2,buys t
	where s.sid = m.sid  and  m.major = 'CS'   and
		  s.sid = m2.sid and m2.major = 'Math' and
		  s.sid =  t.sid and t.bookno = b.bookno;

-- repalce back
select b.bookno, b.title
from book b
where not exists 
	(select s.sid
		from student s,major m,major m2
		where s.sid = m.sid  and  m.major = 'CS'   and
			  s.sid = m2.sid and m2.major = 'Math'
	Except
	select s.sid
		from student s,major m,major m2,buys t
		where s.sid = m.sid  and  m.major = 'CS'   and
			  s.sid = m2.sid and m2.major = 'Math' and
		  	s.sid =  t.sid and t.bookno = b.bookno
);

-- replace not exists

select q.bookno, q.title
from 
(select BookNo,title
	from book b
 except
(select Bookno,title
	from(
		select s.sid,b.Bookno,b.title
		from student s,major m,major m2,book b
		where s.sid = m.sid  and  m.major = 'CS'   and
			  s.sid = m2.sid and m2.major = 'Math'
		Except
		select s.sid, b.BookNo, b.title
		from student s,major m,major m2,buys t,book b
		where s.sid = m.sid  and  m.major = 'CS'   and
			  s.sid = m2.sid and m2.major = 'Math' and
		  	  s.sid =  t.sid and t.bookno = b.bookno
	) q)
) q;







