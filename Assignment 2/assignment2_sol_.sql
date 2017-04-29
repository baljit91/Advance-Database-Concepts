﻿1. create table first(A integer);
   create table second(B integer);
   insert into first values(1),(2),(3);
   insert into second values(1),(3);


Query:
 select not exists(
select f."A"
from "first" f

except

select s."B"
from "second" s) as empty_a_minus_b,

not exists(
select s."B"
from "second" s

except

select f."A"
from "first" f) as empty_b_minus_a ,

not exists(
select f."A"
from "first" f

intersect

select s."B"
from "second" s) as empty_a_intersection_b

Result:
empty_a_minus_b | empty_b_minus_a | empty_a_intersection_b
-----------------+-----------------+------------------------
 f               | t               | f
(1 row)






2.

insert into first values(4),(5);

Query: 

select f."A" as x,sqrt(f."A") as square_root_x,f."A" * f."A" as x_squared, 2^ f."A" as two_to_the_power_x , f."A"! as x_factorial,ln(f."A") as logarithm_x
from "first" f

Result:
 x |  square_root_x   | x_squared | two_to_the_power_x | x_factorial |    logarithm_x
---+------------------+-----------+--------------------+-------------+-------------------
 1 |                1 |         1 |                  2 |           1 |                 0
 2 |  1.4142135623731 |         4 |                  4 |           2 | 0.693147180559945
 3 | 1.73205080756888 |         9 |                  8 |           6 |  1.09861228866811
 4 |                2 |        16 |                 16 |          24 |  1.38629436111989
 5 | 2.23606797749979 |        25 |                 32 |         120 |   1.6094379124341
(5 rows)





3.  create table P(p boolean);
    create table Q(q boolean);
    create table R(r boolean);
    
    insert into P values (true),(false),(null);
    insert into Q values (true),(false),(null);
    insert into R values (true),(false),(null);

Query: select P1.p, Q1.q, R1.r,(not( P1.p and not Q1.q) and not R1.r) as value 
       from P P1, Q Q1, R R1;

Result:
 p | q | r | value
---+---+---+-------
 t | t | t | f
 t | t | f | t
 t | t |   |
 t | f | t | f
 t | f | f | f
 t | f |   | f
 t |   | t | f
 t |   | f |
 t |   |   |
 f | t | t | f
 f | t | f | t
 f | t |   |
 f | f | t | f
 f | f | f | t
 f | f |   |
 f |   | t | f
 f |   | f | t
 f |   |   |
   | t | t | f
   | t | f | t
   | t |   |
   | f | t | f
   | f | f |
   | f |   |
   |   | t | f
   |   | f |
   |   |   |
(27 rows)




4.(a)create table first(A integer);
     create table second(B integer);
     insert into A values(1),(2);
     insert into B values(1),(4),(5);

using intersecrt:

select  exists(

select f."A"
from "first" f

intersect

select s."B"
from "second" s) as answer;

Result:
 answer
--------
 t
(1 row)



Without intersect:
 select  exists(

select f."A"
from "first" f

WHERE f."A" in(

select s."B"
from "second" s)) as answer;

Result
 answer
--------
 t
(1 row)


4.(b)using intersect:
 select  not exists(

select f."A"
from "first" f

intersect

select s."B"
from "second" s)  as answer;
 
Result:
answer
--------
 f
(1 row)



Without Intersect:

select  not exists(

select f."A"
from "first" f

WHERE f."A" in(

select s."B"
from "second" s))  as answer;

Result:
 answer
--------
 f
(1 row)



4.(c) Using Except:
select  not exists(

select f."A"
from "first" f

except

select s."B"
from "second" s)  as answer;
 
Result:
answer
--------
 f
(1 row)



Without except:
select  not exists(

select f."A"
from "first" f

WHERE f."A" not in(

select s."B"
from "second" s))  as answer;
 
Result:
answer
--------
 f
(1 row)


4.(d)Using Except:
select  not exists(

select f."A"
from "first" f

except

select s."B"
from "second" s) and not exists(

select s."B"
from "second" s

except

select f."A"
from "first" f)  as answer;
 
Result:
answer
--------
 f
(1 row)



Without Except:
select  not exists(

select f."A"
from "first" f

WHERE f."A" not in(

select s."B"
from "second" s))  and 

not exists(

select s."B"
from "second" s

WHERE s."B" not in(

select f."A"
from "first" f)) as answer;

Result:
 answer
--------
 f
(1 row)



4.(e) Using Except:
select   exists(

select f."A"
from "first" f

except

select s."B"
from "second" s) or  exists(

select s."B"
from "second" s

except

select f."A"
from "first" f)  as answer;
 
Result:
answer
--------
 t
(1 row)



Without using except:
select   exists(

select f."A"
from "first" f

WHERE f."A" not in(

select s."B"
from "second" s))  or 

 exists(

select s."B"
from "second" s

WHERE s."B" not in(

select f."A"
from "first" f)) as answer;

Result:
 answer
--------
 t
(1 row)




4.(f)Using Intersect:
select   exists(

select f."A"
from "first" f, "first" f2

where f."A" <> f2."A" and exists (select f3."A" from "first" f3 where f3."A" = f."A" intersect 

select s."B"
from "second" s ) and exists (  select   f4."A" from "first" f4 where f4."A" = f2."A" intersect 

select s."B"
from "second" s )) as answer;
 
Result:
answer
--------
 f
(1 row)




Without Intersect:

select   exists(

select f."A"
from "first" f, "first" f2

where f."A" <> f2."A" and exists (select f3."A" from "first" f3 where f3."A" = f."A" and f."A"in (

select s."B"
from "second" s )) and exists (  select   f4."A" from "first" f4 where f4."A" = f2."A" and f2."A" in 

(select s."B"
from "second" s ))) as answer;
 
Result:
answer
--------
 f
(1 row)




4.(g) select   

  not exists(
select f."A"
from "first" f, "first" f2

where f."A" <> f2."A" and exists (select f3."A" from "first" f3 where f3."A" = f."A" intersect 

select s."B"
from "second" s ) and exists (  select   f4."A" from "first" f4 where f4."A" = f2."A" intersect 

select s."B"
from "second" s )) and   exists(  select f."A"
from "first" f WHERE f."A"  in(

select s."B"
from "second" s) ) as answer;
 
Result:
answer
--------
 t
(1 row)



4.(h)create table third(C integer);
     insert into C values(1),(2),(3),(4);

Query:  select not exists(select t.”C” from “third” t except(select f.”A” from ”first” f union select s.”B” from “second” s)) as answer;
 
Result:
answer
--------
 f
(1 row)


4.(i)

create view ABCRn as ((select f."A" from "first" f except select s."B" from "second" s) union (select s."B" from "second" s intersect select t."C" from "third" t));

Query: select ((exists (select a1."A", a2."A" from "ABCRn" a1, "ABCRn" a2 where a1."A"<>a2."A" 

           and a1."A" in (select * from "ABCRn" ) and a2."A" in (select * from "ABCRn" )))  and    
            (not exists(select a3."A", a4."A", a5."A" from "ABCRn" a3, ABCRn a4, "ABCRn" a5 
             where a3."A"<>a4."A" and a4."A"<>a5."A" and a3."A"<>a5."A" 
             and a3."A" in (select * from "ABCRn" ) and a4."A" in (select * from "ABCRn") and a5."A" in (select * from "ABCRn")))) as answer;

Result:
 answer
--------
 f
(1 row)




5.(a) create table point(pid integer not null, x float, y float, primary key(pid));
      insert into point values (1,0,0),(2,0,1),(3,1,0),(4,1,1);


      create function distance(x1 float, y1 float , x2 float , y2 float) returns float as $$ select sqrt(power(x1-x2,2)+ power(y1-y2,2)); $$ language sql;

Query: select p1.pid, p2.pid from point p1, point p2  
       where distance(p1.x, p1.y, p2.x, p2.y)>=all(select distance(p3.x, p3.y, p4.x, p4.y ) from point p3, point p4);
 
Result:
pid | pid
-----+-----
   1 |   4
   2 |   3
   3 |   2
   4 |   1
(4 rows)



5.(b) select p1.pid, p2.pid from point p1, point p2 where 
      not exists 
      ((select p3.pid, p4.pid from point p3 , point p4 where 
      distance (p3.x, p3.y, p4.x, p4.y)>distance(p1.x, p1.y, p2.x, p2.y)) 

      except (select p5.pid, p6.pid from point p5, point p6  where 

      distance(p5.x, p5.y, p6.x, p6.y)>=all(select distance(p7.x, p7.y, p8.x, p8.y ) from point p7, point p8))) 
      except (select p5.pid, p6.pid from point p5, point p6  

      where distance(p5.x, p5.y, p6.x, p6.y)>=all(select distance(p7.x, p7.y, p8.x, p8.y ) from point p7, point p8));
 

Result:
 pid | pid
-----+-----
   1 |   2
   1 |   3
   2 |   1
   2 |   4
   3 |   1
   3 |   4
   4 |   2
   4 |   3
(8 rows)





6. create table rel(A integer not null, B varchar(5));
   insert into rel values(1,'John'),(2,'Ellen'),(3, 'Ann'),(2, 'Linda'),(4,'Ann'),(4,'Nick'),(4,'Lisa'),(4,'Vince');



create view repeated_entires as

select distinct r."A"

from "rel" r,"rel" r1

where r."A" = r1."A" and r."B" <> r1."B";



select r."A"

from  "rel" r

Where not Exists (Select v1."A" from "repeated_entires" v1)

union

Select v1."A" from "repeated_entires" v1



Result:
 a
---
 2
 4
(2 rows)




























/*  creating Database  */
create database student_record;
\c student_record;
create table Student(Sid integer not null, Sname varchar(15), primary key(Sid));
create table Major(Sid integer not null, Major varchar(15), primary key(Sid, major), foreign key(Sid) references Student(Sid));
create table Book(BookNo integer not null, Title varchar(30), price integer not null, primary key(BookNo));
create table Cites(BookNo integer not null, CitedBookNo integer, primary key(BookNo, CitedBookNo), foreign key(BookNo) references Book(BookNo), foreign key(CitedBookNo) references Book(BookNo));
create table Buys(Sid integer not null, BookNo integer not null, primary key(Sid, BookNo), foreign key(Sid) references student(Sid), foreign key(BookNo) references Book(BookNo));



7. 

SELECT 
  B."Title"
FROM 
  "Book" B
WHERE 	B."price" <= 40

Except

SELECT 
  B1."Title" 
FROM 
  "Book" B1
WHERE 	B1."price" < 20;




8.

SELECT distinct
  S."Sid", S."Sname"
FROM 
  "Student" S,"Buys" B
WHERE 	
   S."Sid" = B."Sid"  and

EXISTS

(SELECT distinct
   BN."BookNo"
FROM
   "Book" BN
WHERE   
   BN."BookNo" = B."BookNo" and    BN."BookNo" IN (

SELECT distinct
   B2."BookNo"
FROM
   "Book" B1, "Book" B2 ,"Cites" C
WHERE
    (C."CitedBookNo" = B1."BookNo" and C."BookNo" = B2."BookNo" and (B1."price" < (B2."price")))
    )
);




9.


SELECT distinct
   C1."CitedBookNo"
FROM
    "Cites" C1,"Cites" C2
WHERE
    C1."BookNo" = C2."CitedBookNo";




10.

SELECT distinct
   B."BookNo"
FROM
    "Book" B
WHERE
    B."BookNo" NOT IN ( SELECT C."CitedBookNo" FROM "Cites" C );




11.

SELECT distinct
   S."Sid",S."Sname"
FROM
    "Student" S,"Major" M1, "Major" M2
WHERE
       S."Sid" = M1."Sid" and S."Sid" = M2."Sid" and M1."Major" <> M2."Major" and
NOT EXISTS
(
SELECT 
   BK."BookNo"
FROM
   "Book" BK, "Buys" B 
WHERE
   S."Sid" = B."Sid" and B."BookNo" NOT IN ( Select C."CitedBookNo" FROM  "Cites" C));




12.


SELECT distinct
   S."Sid",M."Major"
FROM
    "Student" S,"Major" M
WHERE
       S."Sid" = M."Sid" and 
NOT EXISTS
(
SELECT 
   BK."BookNo"
FROM
   "Book" BK, "Buys" B 
WHERE
   S."Sid" = B."Sid" and B."BookNo" = BK."BookNo" and Bk."price" < 30);




13.

SELECT distinct
   S"Sid", B."BookNo"
FROM
    "Student" S,"Buys" B
WHERE
    S."Sid" = B."Sid"  and
EXISTS(
SELECT 
    B1."BookNo"
FROM
    "Book" BK2,"Buys" B1
WHERE
   B."BookNo" = BK2."BookNo"  and BK2."price" <= all( SELECT BK1."price" 
FROM
    "Book" BK1 ,"Buys" B1
WHERE
    S."Sid" = B1."Sid" and B1."BookNo" = BK1."BookNo"
   )
);




14.

SELECT distinct
    B."BookNo"
FROM
    "Book" B 
WHERE
    
NOT EXISTS(
SELECT 
    B1."BookNo"
FROM
    "Book" B1
WHERE
   B1."price" < B."price"
);




15.

 SELECT distinct
          S1."Sid" ,S2."Sid",B1."BookNo"
 FROM    "Student" S1,"Student" S2,"Buys" B1
 WHERE 
        S1."Sid" <> S2."Sid" and S1."Sid" = B1."Sid"
UNION

 SELECT distinct
          S1."Sid" ,S2."Sid",B1."BookNo"
 FROM    "Student" S1,"Student" S2,"Buys" B1
 WHERE 
        S1."Sid" <> S2."Sid" and S2."Sid" = B1."Sid"

EXCEPT

 SELECT distinct
          S1."Sid" ,S2."Sid",B1."BookNo"
 FROM    "Student" S1,"Student" S2,"Buys" B1
 WHERE 
        S1."Sid" <> S2."Sid" and S1."Sid" = B1."Sid" and B1."BookNo" IN (

        SELECT B1."BookNo"
        FROM "Buys" B1
        Where S2."Sid"=B1."Sid"
        )




16.

SELECT distinct
          S1."Sid" ,S2."Sid"
 FROM    "Student" S1,"Student" S2
 WHERE 
        S1."Sid" <> S2."Sid" and 

        NOT EXISTS(
        SELECT B1."BookNo"
        FROM "Buys" B1 ,"Buys" B2
        WHERE B1."BookNo" <> B2."BookNo" and S1."Sid" = B1."Sid" and S1."Sid" = B2."Sid"  and (B1."BookNo")  IN (

        SELECT B3."BookNo"
        FROM "Buys" B3,"Buys" B4
        Where  B3."BookNo" <> B4."BookNo" and S2."Sid"=B3."Sid" and S2."Sid"=B4."Sid" 
        ) 

        and (B2."BookNo")  IN (

        SELECT B4."BookNo"
        FROM "Buys" B3,"Buys" B4
        Where  B3."BookNo" <> B4."BookNo" and S2."Sid"=B3."Sid" and S2."Sid"=B4."Sid" 
        ) 
        );




17.

 SELECT distinct
          B."BookNo" 
          
 FROM    "Buys" B 
 
 WHERE  

 NOT EXISTS

     (SELECT BK."BookNo"

     FROM   "Buys" BK ,"Student" S1 ,"Major" M

     where M."Major" = 'Biology' and S1."Sid" = M."Sid" and B."BookNo" = BK."BookNo" and B."BookNo" NOT IN (SELECT B2."BookNo" 

                              FROM "Buys" B2 
                              WHERE B2."Sid" = S1."Sid"  ))




18.

SELECT distinct
   BK."BookNo"
FROM
    "Book" BK
WHERE 
       BK."BookNo" NOT IN 
       ( SELECT BK1."BookNo" 
       FROM "Student" S,"Book" BK1, "Buys" B
       WHERE 
       S."Sid" = B."Sid" and B."BookNo" = BK1."BookNo");




19.

 SELECT distinct
          B."BookNo"          
 FROM    "Buys" B 
 WHERE   
 NOT EXISTS

     (SELECT BK."BookNo"

     FROM   "Buys" BK ,"Student" S2 ,"Student" S1 

     WHERE  S1."Sid"<>S2."Sid" and B."BookNo" = BK."BookNo" and  B."BookNo" NOT IN (SELECT B2."BookNo" 

                              FROM "Buys" B2 
                              WHERE B2."Sid" = S2."Sid")   and B."BookNo" NOT IN (SELECT B2."BookNo" 

                              FROM "Buys" B2 
                              WHERE B2."Sid" = S1."Sid")  ) 

 EXCEPT

 SELECT distinct
      B."BookNo"          
 FROM "Buys" B 
 WHERE   
 NOT EXISTS

     (SELECT BK."BookNo"

     FROM   "Buys" BK ,"Student" S2

     WHERE  B."BookNo" = BK."BookNo" and  B."BookNo" NOT IN (SELECT B2."BookNo" 

                              FROM "Buys" B2 
                              WHERE B2."Sid" = S2."Sid"))




20.

 SELECT distinct
          S1."Sid" ,S2."Sid"
 FROM    "Student" S1,"Student" S2
 WHERE 
        S1."Sid" <> S2."Sid" and 

        NOT EXISTS(
        SELECT B."BookNo"
        FROM "Buys" B
        WHERE S1."Sid" = B."Sid" and B."BookNo" NOT IN (

        SELECT B1."BookNo"
        FROM "Buys" B1
        Where S2."Sid"=B1."Sid"
        )
        );


