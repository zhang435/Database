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


-- Q1
-- find the book boughtby Eric or Anna that cost more than 20
select distinct s.sid,s.sname, b.bookno, b.title 
from student s cross join 
        book b inner join 
        buys t
on 
((s.sname = 'Eric' or s.sname = 'Anna') and
    s.sid = t.sid and
    b.price > 20 and 
    t.bookno = b.bookno);

-- convert to RA sql
select distinct s.sid,s.sname, b.bookno, b.title 
from student s , book b ,buys t
where (s.sname = 'Eric' or s.sname = 'Anna') and
    s.sid = t.sid and
    b.price > 20 and 
    t.bookno = b.bookno;

-- move student sigma to inner
select distinct s.sid,s.sname, b.bookno, b.title 
from 
(select * from student s where (s.sname = 'Eric' or s.sname = 'Anna')) s,
book b ,buys t
where 
    s.sid = t.sid and
    b.price > 20 and 
    t.bookno = b.bookno;

-- moce book price sigma to inner 
select distinct s.sid,s.sname, b.bookno, b.title 
from 
(select * from student s where (s.sname = 'Eric' or s.sname = 'Anna')) s,
(select * from book b where b.price > 20) b,buys t
where 
    s.sid = t.sid and
    t.bookno = b.bookno;

-- \ltimes book and buys
select s.sid,s.sname, t.bookno, t.title 
from (select * from student s where (s.sname = 'Eric' or s.sname = 'Anna')) s,
         (select * from buys t natural join Book b where b.price > 20) t
where 
    s.sid = t.sid;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Q2
select distinct s.sid
from student s cross join 
        book b inner join 
        buys t
on 
((s.sname = 'Eric' or s.sname = 'Anna') and
    s.sid = t.sid and
    b.price > 20 and 
    t.bookno = b.bookno);

-- move student and price to inner query
select distinct s.sid
from 
(select * from student s where (s.sname = 'Eric' or s.sname = 'Anna')) s,
(select * from book b where b.price > 20) b,buys t
where 
    s.sid = t.sid and
    t.bookno = b.bookno;

-- convert base on RA
select sid
from student s
    where (s.sname = 'Eric' or s.sname = 'Anna')
intersect
select sid
from buys t 
    natural join
    (select * from book b where b.price > 20) b;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Q3
select distinct s.sid, b1.price as b1_price, b2.price as b2_price
from (select s.sid from student s where s.sname <> 'Eric') s
    cross join book b2
    inner join book b1 on (b1.bookno <> b2.bookno and b1.price > 60 and b2.price >= 50)
    inner join buys t1 on (t1.bookno = b1.bookno and t1.sid = s.sid)
    inner join buys t2 on (t2.bookno = b2.bookno and t2.sid = s.sid);

select distinct s.sid, b1.price as b1_price, b2.price as b2_price
from (select s.sid from student s where s.sname <> 'Eric') s
    cross join (select * from book b2 where b2.price >= 50) b2
    inner join (select * from book b2 where b2.price > 60) b1
    on (b1.bookno <> b2.bookno)
    inner join buys t1 on (t1.bookno = b1.bookno and t1.sid = s.sid)
    inner join buys t2 on (t2.bookno = b2.bookno and t2.sid = s.sid);


select distinct *
from 
    (select s.sid from student s where s.sname <> 'Eric') s
        natural join
    (select b1.Sid,b1.price,b2.price
        from
        (select * from buys t2
                natural join
            (select * from book b1 where b1.price > 60) b1) b1
        inner join
        (select * from buys t1
                natural join
            (select * from book b2 where b2.price >= 50) b2) b2

        on (b1.sid = b2.sid and b1.bookno <> b2.bookno)
        ) t;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Q4
select q.sid
from (
    select s.sid, s.sname
    from student s
    except
    select s.sid, s.sname
    from student s
        inner join buys t on (s.sid = t.sid)
        inner join book b on (t.BookNo = b.bookno and b.price > 50)) q;

-- K(KNA - KNB) -> KA -KB
select s.sid
from student s
except
select s.sid
from student s
    inner join buys t on (s.sid = t.sid)
    inner join book b on (t.BookNo = b.bookno and b.price > 50);

-- rmove stuent, since sname is not need, and sid is in buys
select s.sid
from student s
except
select t.sid
from buys t
    inner join book b on (t.BookNo = b.bookno and b.price > 50);

-- move price > 50 into book
select s.sid
from student s
except
select t.sid
from buys t
    natural join (select bookno from book b where b.price > 50) q;
     -- on (t.BookNo = q.bookno);

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Q5
select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
        from student s
             cross join book b
        intersect
        select s.sid, s.sname, b.BookNo
        from student s
        cross join book b
        inner join buys t on 
        (s.sid = t.sid and t.bookno = b.bookno and b.price < 25)) q;

select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
        from student s
            intersect
      select s.sid, s.sname, b.BookNo
        from student s
        cross join book b
        inner join buys t on 
        (s.sid = t.sid and t.bookno = b.bookno and b.price < 25)) q;

-- remove outter pi, move filter into table 
select s.sid, s.sname
    from student s
intersect
select s.sid, s.sname
    from student s
    cross join (select * from book b where bookno = 2007 and  b.price < 25) b
    inner join buys t on 
    (s.sid = t.sid and t.bookno = b.bookno);

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Q6
select distinct q.BookNo
from (select s.sid, s.sname,b.BookNo,b.title
        from student s
             cross join book b
        except
        select s.sid, s.sname, b.BookNo,b.title
        from student s
            cross join book b
            inner join buys t on 
            (s.sid = t.sid and t.bookno = b.bookno and b.price < 20)) q;

-- move filter into inner 
select distinct q.BookNo
from (select s.sid, s.sname,b.BookNo,b.title
        from student s
             cross join book b
        except
        select s.sid, s.sname, b.BookNo,b.title
        from student s
            cross join (select * from book where price < 20) b
            inner join buys t on 
            (s.sid = t.sid and t.bookno = b.bookno)) q;


select distinct q.BookNo
from (select s.sid,b.BookNo
        from book b, student s
        except
        select t.sid,t.BookNo
        from (select * from book where price < 20) b
            natural join buys t) q;


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Q7
select s.sid
from student s
except
(select s1.sid
 from student s1
    inner join student s2 on (S1.sid <> s2.sid)
    inner join buys t1 on (s1.sid = t1.sid)
 union

(select s1.sid
from student s1
    inner join student s2 on (S1.sid <> s2.sid)
    inner join buys    t1 on (S1.sid = s2.sid)
    inner join buys    t2 on (t1.bookno = t2.bookno and t2.sid = s2.sid)
    inner join book    b  on (t2.bookno = b.bookno and price = 80))
);

-- since subset union with set, we can just use bigger set
select s.sid
from student s
except
select s1.sid
 from student s1
    inner join student s2 on (S1.sid <> s2.sid)
    inner join buys t1 on (s1.sid = t1.sid);

-- remove student1, student 2

select s.sid
from student s
except
select sid
from buys;


\c postgres;
DROP DATABASE jz;