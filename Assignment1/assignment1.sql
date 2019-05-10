-- creat database with with your int
CREATE DATABASE JZ;

--Switch to your new database
\c JZ;

/**
 1. Create a database in PostgreSQL that stores these relations. Make sure
to specify primary and foreign keys.
 **/

CREATE DATABASE name;
CREATE TABLE Sailor
(
    Sid INTEGER PRIMARY KEY,
    Sname VARCHAR(20),
    Rating INTEGER,
    Age INTEGER
);

CREATE TABLE Boat
(
    Bid INTEGER PRIMARY KEY,
    Bname VARCHAR(15),
    Color VARCHAR(15)
);
CREATE TABLE Reserves
(
    Sid INTEGER REFERENCES Sailor(Sid),
    Bid INTEGER REFERENCES Boat(Bid),
    Day VARCHAR(10)
);
-- inject value
--
INSERT INTO Sailor
VALUES
    (22, 'Dustin', 7, 45),
    (29, 'Brutus', 1, 33),
    (31, 'Lubber', 8, 55),
    (32, 'Andy', 8, 25),
    (58, 'Rusty', 10, 35),
    (64, 'Horatio', 7, 35),
    (71, 'Zorba', 10, 16),
    (74, 'Horatio', 9, 35),
    (85, 'Art', 3, 25),
    (95, 'Bob', 3, 63);

INSERT INTO Boat
VALUES
    (101, 'Interlake', 'blue'),
    (102, 'Sunset', 'red'),
    (103, 'Clipper', 'green'),
    (104, 'Marine', 'red');

INSERT INTO Reserves
VALUES
    (22, 101, 'Monday'),
    (22, 102, 'Tuesday'),
    (22, 103, 'Wednesday'),
    (31, 102, 'Thursday'),
    (31, 103, 'Friday'),
    (31, 104, 'Saturday'),
    (64, 101, 'Sunday'),
    (64, 102, 'Monday'),
    (74, 102, 'Saturday');

/**
2. Provide examples that illustrate how the presence or absence of primary
and foreign keys aects insert and deletes in these relations. To solve
this problem, you will need to experiment with the relation schemas. For
example, you should consider altering primary keys and foreign key con-
straints and then consider various sequences of insert and delete opera-
tions. Certain inserts and deletes should succeed but other should create
error conditions. (Consider the lecture notes about keys, foreign keys, and
inserts and deletes.)
**/
-- DELETE FROM Sailor WHERE Sailor.Sid = 22;

/**
update or delete on table "sailor" violates foreign key constraint "reserves_sid_fkey" on table "reserves"
it will stop table from delete becuase there is constaint

the way to solve this problem is drop table constraint 
**/

/**
3. Write SQL statements for the following queries:
**/
-- a Find the rating of each sailor.
SELECT Sid, Rating
FROM Sailor;

-- b Find the bid and color of each boat.
SELECT Bid, Color
FROM Boat;

-- c Find the name of each sailor whose age is in the range [15; 30]
SELECT Sname
FROM Sailor
WHERE Age BETWEEN 15 AND 30;

-- d Find the name of each boat that was reserved during a weekend (i.e.,Saturday or Sunday).
SELECT Boat.Bname
FROM Boat, Reserves
WHERE (Boat.Bid = Reserves.Bid) AND (Reserves.Day = 'Saturday' OR Reserves.Day = 'Sunday');

-- e Find the name of each sailor who reserved both a red boat and a green boat.
SELECT DISTINCT S.Sname
FROM Sailor S, Boat B1, boat B2, Reserves R1, Reserves R2
WHERE B2.Bid = R1.Bid AND B1.Bid = R2.Bid AND (S.Sid = R1.Sid AND S.Sid = R2.Sid) AND (B1.Color = 'red' AND B2.color = 'green');

-- f Find the name of each sailor who reserved a red boat but neither a green nor a blue boat.
SELECT SA.Sname
FROM
    (                                        (
                SELECT S.Sid
        FROM Sailor S, Reserves R, Boat B
        WHERE S.Sid = R.Sid AND B.Bid = R.Bid AND B.color = 'red'
        )
    EXCEPT
        (SELECT S.Sid
        FROM Sailor S, Reserves R, Boat B
        WHERE S.Sid = R.Sid AND B.Bid = R.Bid AND (B.color = 'green' OR B.color = 'blue'))) S,
    Sailor SA
WHERE
    S.Sid = SA.Sid;



-- g Find the name of each sailor who reserved two diefferent boats.
SELECT DISTINCT T1.Sname, COUNT(T1.Bid)
FROM
    (SELECT S.Sname, R.Bid
    FROM Sailor S, Reserves R
    WHERE S.Sid = R.Sid
) T1
GROUP BY T1.Sname
HAVING COUNT(T1.Bid) >= 2;

-- h Find the sid of each sailor who did not reserve any boats.
    (SELECT S.Sid
    from Sailor S)
EXCEPT
    (SELECT S.Sid
    from Sailor S, Reserves R
    WHERE S.Sid = R.Sid);

-- i Find the pairs of sids (s1; s2) of dierent sailors who both reserved a boat on a Saturday.

SELECT DISTINCT T1.Sid AS id1, T2.Sid as id2
FROM
    (SELECT tmps.Sid
    FROM Sailor tmps, Reserves tmpr
    WHERE tmps.Sid = tmpr.Sid AND tmpr.day = 'Saturday') T1,

    (SELECT tmps.Sid
    FROM Sailor tmps, Reserves tmpr
    WHERE tmps.Sid = tmpr.Sid AND tmpr.day = 'Saturday') T2
WHERE T1.Sid <> T2.Sid;

-- j Find the bids of boats that where reserved by only one sailor. (You should write this query without using the COUNT aggregate function.)
-- get the boat been reserved by more than one person

    (SELECT R.bid
    FROM Reserves R)
EXCEPT
    (SELECT R1.bid
    FROM Reserves R1 , Reserves R2
    WHERE R1.Sid != R2.Sid AND R1.bid = R2.bid);

\c postgres;
DROP DATABASE JZ;