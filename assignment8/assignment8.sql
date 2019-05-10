CREATE DATABASE JZ;

--Switch to your new database
\c jz

DROP TABLE IF EXISTS A;
CREATE TABLE A
(
    num INT
);

INSERT INTO A(
VALUES
    (1),
    (2),
    (3),
    (4)
);

/**
Consider the relation schema A(x int) representing a schema for storing
a set of integers A.
Using arrays to represent sets, write a PostgreSQL program
superSetsOfSet(X int[])
that returns each subset of A that is a superset of X, i.e., each set Y such
thatX⊆ Y ⊆ A.
For example, if X = {}, then superSetsofSets(X) should return each
element of the powerset of A.
**/

create or replace function setdifference(A anyarray, B anyarray)
         returns anyarray as
     $$ select ARRAY(SELECT UNNEST(A)
                     EXCEPT
                     SELECT UNNEST(B)
                );
     $$ language sql;

/**
powersetof_A returns the powerset of A and insert them into PS_A;
**/
CREATE OR REPLACE FUNCTION powersetof_A()
    RETURNS VOID AS
    $$
        DECLARE
        x int;
        BEGIN
            DROP TABLE IF EXISTS PS_A;
            CREATE TABLE PS_A(sets integer[]);
            -- init the val
            insert INTO PS_A VALUES('{}');
            FOREACH x in ARRAY (select ARRAY(SELECT * from A))
                LOOP
                    INSERT INTO PS_A (
                        SELECT array_append(ls.sets,x)
                        from PS_A ls
                        where array_append(ls.sets,x) <> any(select * from PS_A)
                    );
            END LOOP;
        END;
    $$
        language plpgsql;

CREATE OR REPLACE FUNCTION superSetsOfSet(X int[])
    RETURNS table(sets int[]) AS
    $$
    BEGIN
    PERFORM powersetof_A();
    RETURN QUERY (
        SELECT *
        FROM ps_a ps
        WHERE CARDINALITY(setdifference(X,ps.sets)) = 0
    );
    END;

    $$
        language plpgsql;
SELECT * from superSetsOfSet('{}');

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
2. Consider the relation schema Graph(source int, target int) repre-
senting a schema for storing a directed graph G of edges.
A path in G is a sequence of vertices (v0,v1,...,vn) such that, for each i ∈ [0,n−1], (vi,vi+1) is an edge of G. We say that such as path connects v0 to vn via an n-length path.
(a) Write a PostgreSQL program connectedByEvenLengthPath() that returns the pairs of vertices (s,t) of G that are connected via an even-length path in G.
(b) Write a PostgreSQL program connectedByOddLengthPath() that returns the pairs of vertices (s,t) of G that are connected via an odd-length path in G.

test graph:
    1 -> 2 -> 4
    |         |
    3 -------->
**/



CREATE OR REPLACE FUNCTION newConnectedPairsWithPathLen()
RETURNS TABLE (source integer, target integer,pathlen INTEGER) AS
$$
    BEGIN
        RETURN QUERY(
            select C.source, G.target,C.pathlen+1
            FROM Connected C
            INNER JOIN graph G ON(
                c.target = G.SOURCE
            )
            WHERE NOT EXISTS(
                SELECT *
                FROM CONNECTED C2
                WHERE C.SOURCE = C2.SOURCE and G.target = C2.target AND mod(C.pathlen+1,2) = MOD(C2.pathlen,2)
            )
            EXCEPT
            (SELECT * FROM CONNECTed)
        );
    END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION connectedByEvenLengthPath()
    RETURNS table (source integer, target integer) AS
    $$  
        DECLARE
            numNode int := (SELECT count(1) from (SELECT DISTINCT * from (SELECT graph.source from graph UNION SELECT graph.target from graph) p) q);

        BEGIN
            DROP TABLE IF EXISTS connected;
            DROP TABLE IF EXISTS Visited;
            CREATE TABLE connected(source INTEGER, target INTEGER,pathlen INTEGER);
            CREATE TABLE Visited(source INTEGER, target INTEGER,pathlen INTEGER);
            INSERT INTO connected SELECT Graph.SOURCE,Graph.target,1 FROM Graph;
            INSERT INTO connected SELECT tmp.x,tmp.x,0 FROM (select graph.target as x from graph UNION select graph.SOURCE as x from graph) as tmp;
            WHILE EXISTS
            (select * from newConnectedPairsWithPathLen() as tmp)
            
                LOOP
                    RAISE NOTICE 'len %',CARDINALITY(ARRAY(SELECT DISTINCT(connected.SOURCE,connected.target) from connected));
                    RAISE NOTICE 'len % %',CARDINALITY(ARRAY(SELECT DISTINCT(connected.SOURCE,connected.target) from connected)),numnode* numnode;
                    INSERT INTO connected SELECT * FROM newConnectedPairsWithPathLen();
                    INSERT INTO Visited SELECT tmp.SOURCE,tmp.target,mod(tmp.pathlen,2) FROM new_connected_pairs_with_path_len() as tmp;
                END LOOP;

            RETURN QUERY select distinct c.source,c.target from connected c where mod(c.pathlen,2) = 0;
        END;
    $$
        LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION connectedByOddLengthPath()
    RETURNS table (source integer, target integer) AS
    $$  
        DECLARE
            numNode int := (SELECT count(1) from (SELECT DISTINCT * from (SELECT graph.source from graph UNION SELECT graph.target from graph) p) q);

        BEGIN
            DROP TABLE IF EXISTS connected;
            DROP TABLE IF EXISTS Visited;
            CREATE TABLE connected(source INTEGER, target INTEGER,pathlen INTEGER);
            INSERT INTO connected SELECT Graph.SOURCE,Graph.target,1 FROM Graph;
            INSERT INTO connected SELECT tmp.x,tmp.x,0 FROM (select graph.target as x from graph UNION select graph.SOURCE as x from graph) as tmp;
            WHILE EXISTS
            (select * from newConnectedPairsWithPathLen() as tmp)
            
                LOOP
                    -- RAISE NOTICE 'len %',CARDINALITY(ARRAY(SELECT DISTINCT(connected.SOURCE,connected.target) from connected));
                    -- RAISE NOTICE 'len % %',CARDINALITY(ARRAY(SELECT DISTINCT(connected.SOURCE,connected.target) from connected)),numnode* numnode;
                    INSERT INTO connected SELECT * FROM newConnectedPairsWithPathLen();
                    -- INSERT INTO Visited SELECT tmp.SOURCE,tmp.target,mod(tmp.pathlen,2) FROM new_connected_pairs_with_path_len() as tmp;
                END LOOP;

            RETURN QUERY select distinct c.source,c.target from connected c where mod(c.pathlen,2) = 1;
        END;
    $$
        LANGUAGE plpgsql;

DROP table IF EXISTS Graph;

CREATE TABLE Graph
(
    Source INT,
    Target INT
);

INSERT INTO Graph(
VALUES
    (1,2),
    (2,1)
);

select * from connectedByEvenLengthPath();         
select * from connectedByOddLengthPath();

-- test1
DROP table IF EXISTS Graph;

CREATE TABLE Graph
(
    Source INT,
    Target INT
);

INSERT INTO Graph(
VALUES
    (1,2),
    (2,3),
    (3,4),
    (4,5)
);

select * from connectedByEvenLengthPath();         
select * from connectedByOddLengthPath();

-- test2
DROP table IF EXISTS Graph;

CREATE TABLE Graph
(
    Source INT,
    Target INT
);

INSERT INTO Graph(
VALUES
(       1,      2 ),
(       2,      3 ),
(       3,      1 )
);

select * from connectedByEvenLengthPath();         
select * from connectedByOddLengthPath();

-- test3
DROP table IF EXISTS Graph;

CREATE TABLE Graph
(
    Source INT,
    Target INT
);

INSERT INTO Graph(
VALUES
(       1,      2 ),
(       2,      3 ),
(       3,      1 ),
(       0,      1 ),
(       3,      4 ),
(       4,      5 ),
(       5,      6 )
);

select * from connectedByEvenLengthPath();         
select * from connectedByOddLengthPath();
DROP table IF EXISTS Graph;

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
3. Consider the relation schema Graph(source int, target int) repre- senting the schema for storing a directed graph G of edges.
Now let G be a directed graph that is acyclic, a graph without cycles.1
A topological sort of a graph is a list (array) of all its vertices (v1, v2, . . . , vn) such that for each edge (s, t) in G, vertex s occurs before vertex t in this list.
Write a PostgresQL program topologicalSort() that returns a topolog- ical sort of G.

**/

DROP table IF EXISTS Graph;
CREATE TABLE Graph
(
    Source INT,
    Target INT
);

INSERT INTO Graph(
VALUES
(       1,      2 ),
(       1,      3 ),
(       2,      3 ),
(       2,      4 ),
(       3,      7 ),
(       7,      4 ),
(       4,      5 ),
(       4,      6 ),
(       7,      6 )
);
create or REPLACE FUNCTION getChildrenOf(s int)
    RETURNS int[] AS
    $$
        DECLARE
        res int[] = '{}';
        BEGIN
            res := array(select e.target from Graph e where e.SOURCE = s);
            RETURN res;
        END;
    $$ LANGUAGE plpgsql;

create or REPLACE FUNCTION getUnvisitedChildrenOf(s int)
    RETURNS int[] AS
    $$

        BEGIN
        RETURN ARRAY(
            SELECT * from UNNEST(getChildrenOf(s))
            EXCEPT
            select * from visited
        );
        END;
    $$ LANGUAGE plpgsql;

create or replace function memberof(x anyelement, A anyarray)
        returns boolean as
$$
  select x = SOME(A);
$$ language sql;

/**
sudo code
for node in graph:
    stack = [node]
    while stack:
        tmp = stack.pop()
        cs = gitunvisitedchidlrenfor(tmp)
        visited.add(tmp)
        if cs == []:
            res.append(tmp)
        stack.append(cs)

test graph:
    1 -> 2 -> 4
    |         |
    3 -------->
**/

CREATE or REPLACE FUNCTION topologicalSort()
    RETURNS int[] AS
    $$
        DECLARE
        stack int[] = '{}';
        children int[] = '{}';
        res int[] = '{}';
        vs int[] := ARRAY((SELECT SOURCE from Graph) union (SELECT Target from Graph));
        v int;
        pointer int;

        BEGIN
            DROP TABLE IF EXISTS Visited;
            CREATE TABLE Visited(v INTEGER);

            FOREACH v in ARRAY vs
            LOOP
                -- RAISE NOTICE 'value of Graph : %', v;
                -- RAISE NOTICE 'visited : % ', ARRAY(select * from Visited);
                IF not memberof(v,ARRAY(select * from Visited))
                THEN
                    -- RAISE NOTICE '    % not visited',v;
                    stack := array_append('{}',v);

                    while CARDINALITY(stack) <> 0
                    loop
                            pointer := stack[1];
                            -- RAISE NOTICE '        pointer:% ',pointer;
                            -- RAISE NOTICE '        stack  :% ',stack;
                            INSERT INTO Visited values(pointer);
                            children := getUnvisitedChildrenOf(pointer);
                            RAISE NOTICE '        children :%',children;
                            IF cardinality(children) = 0
                                THEN
                                    -- RAISE NOTICE '            % has no children',pointer;
                                    -- RAISE NOTICE '            insert % into res',pointer;
                                    res := array_append(res,pointer);
                                    -- RAISE NOTICE '            inserted res: %',res;
                                    stack := array_remove(stack,pointer);
                                    
                            END IF;

                            IF  cardinality(children) <> 0
                                THEN 
                                    stack := array_cat(children,stack);

                            END IF;
                    end loop;
                END IF;
            END LOOP;

            RETURN res;
        DROP TABLE IF EXISTS Visited;
        END;
    $$  LANGUAGE plpgsql;

select topologicalSort();

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
4. Consider the relation schema Graph(source int, target int) repre- senting the schema for storing a directed graph G of edges.
Let ‘red’, ‘green’, and ‘blue’ be 3 colors. We say that G is 3-colorable if it is possible to assign to each vertex of G one of
these 3 colors provided that, for each edge (s, t) in G, the color assigned to s is different than the color assigned to t.
1
 
Write a PostgresQL program threeColorable() that returns true if G is 3-colorable, and false otherwise.
(Hint: use a backtracking algorithm that finds a 3-color assignment to the vertices of G if such an assignment exists.)
**/

/**
doe children in child(x):
    res =  False
    for color in [1,2,3] other than parent's color:
        if child,color in res and p.color = child.color
            continue
        color(children,color)
        res = rec(children,)

**/
/**
1 -> 

**/
DROP TABLE Edge;
CREATE TABLE Edge
(
    Source INT,
    Target INT
);

INSERT INTO Edge(
    -- this will not pass threecolorable
VALUES
    (1,2),
    (1,3),
    (1,4),
    (4,3),
    (3,2)
    -- , (4,2)

    
);


CREATE OR REPLACE FUNCTION colorOf(node int)
    RETURNS int AS
    $$
        select c.color
        from colors c
        where c.v = node
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION threeColorable()
    RETURNS BOOLEAN AS
    $$
        DECLARE
        startV int;
        BEGIN
            DROP TABLE IF EXISTS colors;
            CREATE TABLE colors(v INTEGER,color INTEGER);
            startV = (select * from ((SELECT SOURCE from Edge) EXCEPT (SELECT Target from Edge)) p);
            INSERT INTO colors VALUES(startV,1);
            RETURN rec(startV,1);
        END
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rec(parent int,pcolor int)
    RETURNS BOOLEAN AS
    $$
        DECLARE
            res BOOLEAN := TRUE;
            color int;
            child int;
            v int;
            vs int[] := ARRAY((SELECT SOURCE from Edge) union (SELECT Target from Edge));
        BEGIN
            -- RAISE NOTICE 'parent % pcolor % children % ',parent,pcolor,getChildrenOf(parent);
            IF CARDINALITY(getChildrenOf(parent)) = 0
            THEN RETURN TRUE;
            end if;

            FOREACH child in ARRAY getChildrenOf(parent)
            loop
                -- RAISE NOTICE 'parent % child % ',parent,child;
                -- RAISE NOTICE '    node % ',ARRAY(select c.v from colors c);
                -- RAISE NOTICE '    color % ',ARRAY(select c.color from colors c);
                -- RAISE NOTICE '    child has color but not conflit % ',EXISTS (select c.color from colors c where c.v = child) AND pcolor <> colorOf(child);
                -- RAISE NOTICE '    child has color and     conflit % ',EXISTS (select c.color from colors c where c.v = child) AND pcolor = colorOf(child);
                CONTINUE WHEN EXISTS (select c.color from colors c where c.v = child) AND pcolor <> colorOf(child);
                res := FALSE;
                exit WHEN EXISTS (select c.color from colors c where c.v = child) AND pcolor = colorOf(child);

                FOREACH color in ARRAY array_remove('{"1","2","3"}',pcolor)
                loop
                    -- if child has no color yet, then we should assign a color
                    INSERT INTO colors VALUES(child,color);
                    res := rec(child,color);
                    IF res
                    THEN
                        EXIT;
                    end if;
                    DELETE FROM colors c where c.v = child;
                    
                end loop;
            
            end loop;
            -- RAISE NOTICE '    end all chidl for  % ',parent;
            -- if the color can not fit into this node
        RETURN res;
        END;
    $$ LANGUAGE plpgsql;

select threeColorable();   

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**

5. Consider the relation schema Graph(source int, target int) repre- senting the schema for storing a directed graph G of edges.
We say that G is Hamiltonian if there exists a permutation (v1,...,vn) of all the vertices of G such that (a) for each i ∈ [1,n−1], (vi,vi+1) is an edge of G and (b) (vn,v1) is an edge in G. Such a permutation is called an Hamiltonian cycle of G.
Write a PostgresQL program Hamiltonian() that returns true if G is Hamiltonian, and false otherwise.
(Hint: use a backtracking algorithm that finds an Hamiltonian cycle of G if such a cycle exists.)

def foo():
    visited = []
    s = startV
    return rec(s)
def rec(s):
    if visited - edges = 0:
        return True
    for child in children(s) - visited:
        visited + child
        if rec(child):
            return True
        visited - child
    return False
**/

DROP TABLE IF EXISTS Edge;
CREATE TABLE Edge
(
    Source INT,
    Target INT
);

INSERT INTO Edge(
    -- this will not pass threecolorable
VALUES
    (1,2),
    (2,3),
    (3,4)
);


CREATE OR REPLACE FUNCTION Hamiltonian()
    RETURNS BOOLEAN AS $$
        DECLARE
            startV int := (select * from ((SELECT SOURCE from Edge) EXCEPT (SELECT Target from Edge)) p);
        BEGIN
        
            DROP TABLE IF EXISTS Visited;
            CREATE TABLE Visited(v int);
            RAISE NOTICE 'start from % ',startV;
            INSERT INTO visited values(startV);
            RETURN rec_Hamiltonian(startV);
        END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rec_Hamiltonian(node int)
    RETURNS BOOLEAN AS $$
        DECLARE
         Vertex int[] := ARRAY(select  DISTINCT * from ((SELECT SOURCE from Edge) union (SELECT Target from Edge)) q);
         child int;
        BEGIN
            RAISE NOTICE 'visited : % ', ARRAY(select * from Visited);
            if CARDINALITY(Vertex) = CARDINALITY(ARRAY(SELECT DISTINCT * from Visited))
                THEN RETURN TRUE;
            END if;
            
            foreach child in ARRAY getUnvisitedChildrenOf(node)
            loop
                INSERT INTO visited values(child);
                IF rec_Hamiltonian(child)
                THEN RETURN TRUE;
                END IF;
                DELETE FROM Visited as V where V.v = child;
            end loop;
            RETURN FALSE;
        END;
    $$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
6. Consider the relation schema document(doc int, words text[]) rep- resenting a relation of pairs (d,W) where d is a unique id denoting a document and W denotes the set of words that occur in d.
Let W denote the set of all words that occur in the documents and let t be a positive integer denoting a threshold.
Let X ⊆ W. We say that X is t-frequent if
count({d|(d, W ) ∈ document and X ⊆ W }) ≥ t
In other words, X is t-frequent if there are at least t documents that contain all the words in X.
Write a PostgreSQL program frequentSets(t int) that returns each t-frequent set.
In a good solution for this problem, you should use the following rule: if X is not t-frequent then any set Y such that X ⊆ Y is not t-frequent either. In the literature, this is called the Apriori rule of the frequent itemset mining problem.
**/

/**
convert doc -> words
for word -> docs
**/
DROP TABLE if EXISTS document;
CREATE TABLE document
(
    Source INT,
    word text[]
);

INSERT INTO document(
    -- this will not pass threecolorable
VALUES
    (  1 , '{"A","B","C"}' ),
    (  2 , '{"B","C","D"}' ),
    (  3 , '{"A",E}' ),
    (  4 , '{"B","B","A","D"}' ),
    (  5 , '{E,F}' ),
    (  6 , '{"A","D",G}' ),
    (  7 , '{"C","B","A"}' ),
    (  8 , '{"B","A"}' )
);

CREATE OR REPLACE FUNCTION powersetof_word()
    RETURNS VOID AS
    $$
        DECLARE
        x TEXT;
        BEGIN
            DROP TABLE IF EXISTS PSWord;
            CREATE TABLE PSWord(sets text[]);
            -- init the val
            insert INTO PSWord VALUES('{}');
            FOREACH x in ARRAY (select ARRAY(select distinct k from document D,unnest(D.word) as k))
                LOOP
                    INSERT INTO PSWord (
                        SELECT array_append(ls.sets,x)
                        from PSWord ls
                        where array_append(ls.sets,x) <> any(select * from PSWord)
                    );
            END LOOP;
        END;
    $$
        language plpgsql;

create or replace function setdifference(A anyarray, B anyarray)
         returns anyarray as
     $$ select ARRAY(SELECT UNNEST(A)
                     EXCEPT
                     SELECT UNNEST(B)
                );
     $$ language sql;

CREATE OR REPLACE FUNCTION frequentSets(t int)
RETURNS TABLE (res TEXT[]) AS
$$
    BEGIN
        PERFORM powersetof_word();

        RETURN QUERY(
            SELECT psw.sets
            from PSWord psw
            WHERE (SELECT COUNT(1)
                FROM document D
                where CARDINALITY(setdifference(psw.sets,D.word)) = 0
            ) >= t
        );
    END;
$$ LANGUAGE plpgsql;
select * from frequentsets(1);
select * from frequentsets(2);
select * from frequentsets(3);
select * from frequentsets(4);
select * from frequentsets(5);
-- select distinct array(select distinct * from unnest(array[a,b]) as x order by x asc) from tmp;

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
7. For this problem, first read about the k-means clustering problem in
  http://stanford.edu/~cpiech/cs221/handouts/kmeans.html

Additionally, look at the k-means algorithm there described. Your task is to implement this algorithm in PostgreSQL for a dataset that consists of a set points in a 2-dimensional space.
Assume that the dataset is stored in a ternary relation with schema
                 dataSet(p int, x float, y float)
2
  
where p is an integer uniquely identifying a point (x, y).
Write a PostgreSQL program kMeans(k integer) that returns a set of k points that denote the centroids for the points in dataSet. Note that k is an input parameter to the kMeans function.
You will need to reason about how to determine when the algorithm ter- minates. (For hints, consider the above website.)
**/

-- CREATE TABLE dataSet(p int, x float, y float);


CREATE or REPLACE FUNCTION createSampleData(k int)
RETURNS void AS
$$
    DECLARE
        id int := 0;
        x int;
        y int;
    BEGIN 
        WHILE k <> 0
        LOOP
            x := floor(random() * 100 + 1);
            y := floor(random() * 100 + 1);
            INSERT INTO dataSet VALUES (id,x,y);
            id := id + 1;
            k  := k  - 1;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION findCloestCentroids()
RETURNS void AS
$$ 
    DECLARE
        dataRec RECORD;
        centriodRec RECORD;
        min_label int := 0;
        min_dis float := 0;
        dis     FLOAT;
    BEGIN
        -- for every row, find the cloest centriod
        for dataRec in (SELECT * from dataset)
        LOOP
            -- maxin 4 bytes
            min_dis = 2147483647;
            for centriodRec in (SELECT * from Centroids)
            LOOP
                dis = SQRT(POWER((dataRec.x - centriodRec.x ),2)+ POWER((dataRec.y - centriodRec.y),2));
                if dis < min_dis
                THEN
                    min_dis   := dis;
                    min_label := centriodRec.cid;
                END IF;
            END LOOP;
            -- remove the row from data.
            DELETE FROM Labels L where L.p = dataRec.p;
            INSERT INTO Labels VALUES (dataRec.p,min_label);
            -- raise notice '1 % 1',ARRAY(select cid from labels);
        END loop;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getCentroids()
RETURNS void AS
$$
    DECLARE
        centriodRec RECORD;
    BEGIN
    for centriodRec in (SELECT * from Centroids)
    LOOP
        -- DELETE FROM Centroids C where C.cid = centriodRec.cid;
        UPDATE Centroids
        SET x = v2,
        y = v3
        from 
        (
            SELECT centriodRec.cid as v1,AVG(D.x) as v2,AVG(D.y) as v3
            from   dataset D,Labels L
            where
            D.p = L.p AND
            L.cid = centriodRec.cid
        ) tmp
        where cid = tmp.v1;
    END  loop;
    END;
$$  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getRandomCentroids(k int)
RETURNS void AS
    $$
        DECLARE
            count int := k;
            cid   int := 0;
            x_val int;
            y_val int;
        BEGIN
            WHILE k <> 0
            LOOP
                x_val := floor(random() * 100 + 1);
                y_val := floor(random() * 100 + 1);

                if not EXISTS(select * from Centroids C where C.x = x_val and C.y = y_val)
                THEN
                    INSERT INTO centroids VALUES (cid,y_val,y_val);
                    cid := cid + 1;
                    k   := k   - 1;
                END IF;
            end LOOP;
        END;
    $$LANGUAGE plpgsql;


-- select createSampleData(20);
-- select * from dataSet;

CREATE OR REPLACE FUNCTION kMeans(k INT)
RETURNS TEXT[] AS
    $$
    DECLARE
        iterations int := 100;
    BEGIN
        DROP TABLE IF EXISTS dataSet CASCADE;
        DROP TABLE IF EXISTS Centroids CASCADE;
        DROP TABLE IF EXISTS Labels CASCADE;

        -- create dataset table
        CREATE TABLE dataSet(p int PRIMARY KEY, x float, y float);
        CREATE TABLE Centroids(cid int PRIMARY KEY, x FLOAT, y FLOAT);
        -- the labels refers to the correspding Centroids
        CREATE TABLE Labels(p int  REFERENCES dataSet(p) ON DELETE CASCADE, cid int REFERENCES Centroids(cid) ON DELETE CASCADE);
        -- Initialize centroids randomly
        PERFORM getRandomCentroids(k);

        -- Initialize random DATA
        PERFORM createSampleData(20);
        
        -- decide the stop condition
        -- to simplfy the process, we just going to stop once the iterations reachs
        WHILE iterations <> 0
        LOOP
            -- Assign labels to each datapoint based their distance to centriods
            PERFORM findCloestCentroids();

            -- find the new location for all the centriod
            PERFORM getCentroids();
            iterations := iterations -1;
        END LOOP;

        return array(SELECT (C.x,C.y) from Centroids C);

    END;
    $$ LANGUAGE plpgsql;

select * from kMeans(3);


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
8. Consider the following relational schemas. (You can assume that the do- main of each of the attributes in these relations is int.)
                  partSubpart(pid,sid,quantity)
                  basicPart(pid,weight)
A tuple (p,s,q) is in partSubPart if part s occurs q times as a direct subpart of part p. For example, think of a car c that has 4 wheels w and 1 radio r. Then (c, w, 4) and (c, r, 1) would be in partSubpart. Further- more, then think of a wheel w that has 5 bolts b. Then (w, b, 5) would be in partSubpart.
A tuple (p, w) is in basicPart if basic part p has weight w. A basic part is defined as a part that does not have subparts. In other words, the pid of a basic part does not occur in the pid column of partSubpart.
(In the above example, a bolt and a radio would be basic parts, but car and wheel would not be basic parts.)
We define the aggregated weight of a part inductively as follows:
(a) If p is a basic part then its aggregated weight is its weight as given
in the basicPart relation
(b) If p is not a basic part, then its aggregated weight is the sum of the aggregated weights of its subparts, each multiplied by the quantity with which these subparts occur in the partSubpart relation.
Example tables: The following example is based on a desk lamp with pid 1. Suppose a desk lamp consists of 4 bulbs (with pid 2) and a frame (with pid 3), and a frame consists of a post (with pid 4) and 2 switches (with pid 5). Furthermore, we will assume that the weight of a bulb is 5, that of a post is 50, and that of a switch is 3.
Then the partSubpart and basicPart relation would be as follows:
  partSubPart
3
Parts
pid
sid
quantity
1 1 3 3
2 3 4 5
4 1 1 2
pid
weight
2 4 5
5 50 3
Then the aggregated weight of a lamp is 4×5+1×(1×50+2×3) = 76. Write a PostgreSQL function aggregatedWeight(p integer) that re-
turns the aggregated weight of a part p.

**/

-- think the databse as the tree struvcture, where the basic part is the leaf of the node

DROP TABLE IF EXISTS partSubpart;

CREATE TABLE partSubpart
(
    pid int,
    sid int,
    quantity int
);

DROP TABLE IF EXISTS basicPart;
CREATE TABLE basicPart
(
    pid int PRIMARY KEY,
    weight int
);

INSERT INTO partSubpart(
VALUES
    (    1,   2,        4 ),
    (    1,   3,        1 ),
    (    3,   4,        1 ),
    (    3,   5,        2 ),
    (    3,   6,        3 ),
    (    6,   7,        2 ),
    (    6,   8,        3 )
);

INSERT INTO basicPart(
VALUES
    (    2,      5 ),
    (    4,     50 ),
    (    5,      3 ),
    (    7,      6 ),
    (    8,     10 )

);

CREATE OR REPLACE FUNCTION isleaf(node int)
RETURNS BOOLEAN AS
$$
    BEGIN
        RETURN node in (SELECT pid from basicPart);
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION weightOf(node int)
RETURNS int AS
$$
    BEGIN
        RETURN (select (SELECT weight from basicPart BP where BP.pid = node));
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION quantityOf(parent int,child int)
RETURNS int AS
$$
    BEGIN
        RETURN (select (SELECT PSP.quantity from partSubpart PSP where PSP.pid = parent and PSP.sid = child));
    END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION aggregatedWeight(node int)
RETURNS INT AS
$$
    DECLARE
        acc int := 0;
        child int;
        quantity int;
        
    BEGIN
        -- reach the leaf
        IF isleaf(node)
        THEN
            RETURN weightof(node);
        END IF;
        -- iterate through all the child branch
        for child in (select PSP.sid from partSubpart PSP where PSP.pid = node)
        LOOP
            quantity := quantityOf(node,child);
            acc := acc + quantity * aggregatedWeight(child);
        END LOOP;
        RETURN acc;
    END;

$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/**
Suppose you have a weighted undirected graph G stored in a ternary table
with schema
            Graph(source int, target int, weight int)
A triple (s, t, w) in Graph indicates that Graph has an edge (s, t) whose edge weight is w. (In this problem, we will assume that each edge weight is a positive integer.)
Since the graph is undirected, whenever there is an weighted edge (s, t, w) in G, then (t, s, w) is also a weighted edge in the G. Below is an example of a graph G.
**/

DROP TABLE IF EXISTS Graph;

CREATE TABLE Graph
(
    source int,
    target int,
    weight int
);

INSERT INTO Graph(
VALUES
    ( 0,1,2 ),
    ( 1,0,2 ),
    ( 0,4, 10),
    ( 4,0, 10),
    ( 1,3,3 ),
    ( 3,1,3 ),
    ( 1,4,7 ),
    ( 4,1,7 ),
    ( 2,3,4 ),
    ( 3,2,4 ),
    ( 3,4,5 ),
    ( 4,3,5 ),
    ( 4,2,6 ),
    ( 2,4,6 )
);

CREATE OR REPLACE FUNCTION neighborOf(s int)
RETURNS int[] AS
$$
    BEGIN
    return ARRAY(
        select target
        from   Graph
        where source = s
    );
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Q9WeightOf(s int,t int)
RETURNS INT AS
$$
    BEGIN
        RETURN (SELECT weight from Graph where source = s and target = t);
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION initlizeDistance()
RETURNS void AS
$$
    BEGIN
    INSERT INTO Distance(
        SELECT distinct target,2147483647
        FROM Graph
    );

    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isAllVisited()
RETURNS boolean AS
    $$
        BEGIN
            RETURN CARDINALITY(ARRAY((select DISTINCT source from Graph))) = CARDINALITY(ARRAY((select DISTINCT node from visited)));
        END;
    $$ LANGUAGE plpgsql;

-- Node with the least distance
CREATE OR REPLACE FUNCTION minPathLenNode()
RETURNS INT[] AS
$$
    BEGIN
        RETURN(
            array(select D.node
            from Distance D
            where D.weight <= ALL(select D1.weight FROM Distance D1 where D1.node not in (SELECT * from visited))
            AND D.node not in (SELECT * from visited))
        );
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION pathLenOf(nde int)
RETURNS INT AS
$$
    BEGIN
        RETURN(
            select D.weight
            from Distance D
            where D.node = nde
        );
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Dijkstra(s int)
RETURNS TABLE(target int,distance int) AS
$$  
    DECLARE
        min_node int;
        path_len int;
        neighbor int;
    BEGIN
        DROP table IF EXISTS Distance;
        DROP table IF EXISTS Visited;
        CREATE TABLE Distance (node int, weight int);
        CREATE TABLE Visited (node int);
        -- initlize the distance to inif except itself, the ditance to itself is 
        PERFORM initlizeDistance();
        -- initlize the firs node, distance to itself is smallest 
        UPDATE Distance set weight = 0 where node = s;
        while not isAllVisited()
        LOOP
            -- RAISE NOTICE 'visited : %', ARRAY(select DISTINCT * from Visited);
            min_node := (minPathLenNode())[1];
            path_len := pathLenOf(min_node);
            INSERT INTO Visited VALUES (min_node);

            FOREACH neighbor in array neighborOf(min_node)
            LOOP
                if neighbor <> any(SELECT * from Visited) AND (pathLenOf(neighbor) > path_len + Q9WeightOf(min_node,neighbor))
                THEN
                    UPDATE Distance set weight = path_len + Q9WeightOf(min_node,neighbor) WHERE node = neighbor;
                END IF;
            END LOOP;
        END LOOP;


        RETURN QUERY (select * from Distance);
    END;    
$$ LANGUAGE plpgsql;

select * from Dijkstra(1);



/**
10. Consider the document Introduction to MapReduce in the Lecture Notes on MapReduce.
 In that document, you can find in Sections 2.3.3-2.3.7 how certain relational algebra operations
  can be implemented in MapRe- duce. In particular, look at the map and reduce functions for various RA operators.

In the following problems, you are asked to write simulations of MapRe- duce in PostgreSQL.
To do this, you should follow the strategy described in the document word count mapreduce.pdf.2
**/

-- a
/**
Write a simulation in PostgreSQL of a MapReduce program that implements πA(R) where R(A, B) is a relation.
You can assume that the domains of A and B are integer. (Recall that in a projection, duplicates are eliminated.)
**/

DROP TABLE IF EXISTS R;
CREATE TABLE R(
    A INT,
    B INT
);


INSERT INTO R (
    VALUES
    (1,2),
    (3,4),
    (4,5)
);

WITH 
    MAP AS(
        SELECT A,1 as one
        FROM R),
    GR AS(
        SELECT A,ARRAY_AGG(one)
        FROM MAP
        GROUP BY A),
    -- ),

    reduce AS(
        SELECT A from GR)
    
    SELECT  *
    FROM  reduce;

-- b
/**
Write a simulation in PostgreSQL of a MapReduce program that implements the set difference of two unary relations R(A) and S(A),
 i.e., the relation R(A) − S(A). You can assume that the domain of A is integer.
**/
DROP TABLE IF EXISTS R;
CREATE TABLE R(
    A INT
);


INSERT INTO R (
    VALUES
    (1),
    (2),
    (3)
);


DROP TABLE IF EXISTS S;
CREATE TABLE S(
    A INT
);


INSERT INTO S (
    VALUES
    (2),
    (3),
    (4)
);

WITH MAP AS(
    SELECT R.A as A,S.A as B
    FROM R,S
    ),

    GR AS(
        SELECT MAP.A,ARRAY_AGG(MAP.B) as B
        FROM MAP
        GROUP BY MAP.A
    ),

    reduce as(
        SELECT GR.A
        FROM GR
        WHERE not memberof(GR.A,GR.B)
    )

    SELECT * FROM reduce;

/**
(c) Write a simulation in Postgres of a MapReduce program that imple- ments the natural
join R ◃▹ S of two relations R(A, B) and S(B, C). You can assume that the domains of A, B, and C are integer.
**/

DROP TABLE IF EXISTS R;
CREATE TABLE R(
    A INT,
    B1 INT
);


INSERT INTO R (
    VALUES
    (1,2),
    (2,3),
    (3,4)
);


DROP TABLE IF EXISTS S;
CREATE TABLE S(
    B2 INT,
    C INT
);


INSERT INTO S (
    VALUES
    (2,3),
    (3,4),
    (4,5),
    (5,6)
);

WITH MAP AS(
    SELECT *
    FROM R,S
    ),
    GR AS(
        SELECT MAP.A as HEAD,ARRAY_AGG(ARRAY[MAP.A,MAP.B1,MAP.C]) as RES
        FROM MAP
        WHERE MAP.B1 = MAP.B2
        GROUP BY MAP.A
    ),

    reduce as (
        SELECT GR.res[1][1],GR.res[1][2],GR.res[1][3]
        FROM GR
    )

    SELECT * from reduce;


\c postgres;
DROP DATABASE jz;