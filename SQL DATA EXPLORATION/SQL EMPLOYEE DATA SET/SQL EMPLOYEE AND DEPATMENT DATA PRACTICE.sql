use database demo;

Create or Replace Table Emp(
  EMPNO int not null primary key,
  Ename varchar(30),
  JOB char(30),
  MGR_ID int,
  HIREDATE date,
  Salary int,
  Commission int,
  DEPTNO int
    );

select * from emp;

create or replace table Department(
  DEPTNO int,
  D_Name char(20),
  LOC char(20)
);



select * from Department;
------setting all the NULL values in Commision colum to 0

UPDATE emp 
set Commission = 0
where Commission is NULL;

select * from emp;

-- **************  ASSIGNMENT ON OPERATIONS  ************************

-- Q1 - Display all the employees who are getting 2500 and above in salaries in department 20

select Ename,Job, Salary
from emp
where (salary >= 2500 and DEPTNO = 20)
order by 3 desc;



-- Q2  DSPLAY ALL THE MANAGER WORKINGIN DEPT NO 20 & 30.


select Ename, Job, Salary, DEPTNO as Department
from emp
where (Job = 'MANAGER' and DEPTNO in (20,30));



-- Q3 DISPLAY ALL THE MANAGERS WHO DO NOT HAVE A MANAGER


SELECT Ename, EMPNO,Job, MGR_ID
from emp
where (Job = 'MANAGER' and MGR_ID is NULL);

--- here output gives Null as every manager in our datase have a manager


-- Q4 DISPLAY ALL THE EMLOYEES WHO ARE GETTING SOME COMMISSION AND DESGNATION IS NOT 'MANAGER' NOR 'ANALYST'

Select * from emp
Where Commission > 0 
AND Job NOT IN ('MANAGER','ANALYST');



-- Q5 DISPLAY ALL THE ANAYSTs WHOSE NAME DOESN'T ENDS WITH 'S'


Select Ename, Job, DEPTNO
From emp
where Job = 'ANALYST' and  Ename not like '%S' ;



--Q6 Display all the epmloyees whose Name is having letter 'E' as the last but one character before


Select Ename, Job, DEPTNO
From emp
where  Ename like '%E_' ;



-- Q7 Display all the employees whose total salary is more than 2000 TOTAL_SALARY(Salary + Commission)

Select Ename, Job, Salary, Commission, Salary + Commission as Total_Salary
From emp
Where Total_Salary > 2000
order by Total_Salary;




-- Q8 Display all the emplyess who ae getting commission in department number 20 and 30


Select * from emp
Where Commission > 0 
AND DEPTNO IN (20, 30);




-- Q9 Display all the managers whose name doesn't start with A and S.

Select *
From emp
where Job = 'MANAGER' and 
(Ename not like 'S%' and Ename not like 'A%');



-- Q10 Display all the employees who earning salary not in rangeof 2500 and 5000 also deptno should be 10 & 20.

Select * 
From emp
Where Salary NOT Between 2500 AND 5000 
AND
DEPTNO IN (10, 20);





-- ************* Assignment on Grouping  *******************

-- Q1 Display job wise max salary

Select Job, max(Salary) as Max_Salary
From emp
Group by 1
Order by 2 desc;


-- Q2 Dispay the departments who are having more than  employees under it

Select DEPTNO, COUNT(*) as Count_of_Emp
From emp
Group by 1
Having Count_of_Emp > 3;


-- Q3 Display JOB-WISE avereage salaries for the employees whose employee number is not from 7788 to 7790
Select Job, Avg(salary) as Avg_Salary
From emp
Where EMPNO not between 7788 and 7790
Group by 1
Order by 2;


-- Q4 Display dept wise avg salaries for the manager and analyst onl if their avg salary is greater than 3000.


Select Job, Avg(salary) as Avg_Salary
From emp
Where Job in ('MANAGER', 'ANALYST')
Group by 1
Having Avg_Salary >= 3000
Order by 2;


Create or Replace Table Skills(
    ID int,
    Name Varchar
);

Select * From Skills;


-- Q5 Select only the duplicat record with their counts

Select *, count(*) as count_total
From Skills
Group by 1,2
Having count_total > 1;

-- Q6 Select only non-duplicate records


Select *, count(*) as count_total
From Skills
Group by 1,2
Having count_total = 1;


-- Q7 SELECT THE RECORDS THAT ARE DUPLICATED ONLY ONCE


Select *, count(*) as count_total
From Skills
Group by 1,2
Having count_total = 2;




-- Q8 SELET DUPLICATED RECORDS WHERE ID IS NOT 101

Select *, count(*) as count_total
From Skills
Where ID != 101
Group by 1,2
Having count_total > 1;



-- ******************** ASSINMNMENT ON SUB QUERIES *******************

--- Q2 Display all the emplyoees who are earnig more than all the managers

Select Ename, Salary, Job
From emp
Where Salary > 
(Select sum(Salary)
From emp
Where Job = 'MANAGER');




--Q2 Display all the emplyoees who are earnig more than any of the managers

Select Ename, Salary, Job
From emp
Where Salary > 
ALL(Select Salary
From emp
Where Job = 'MANAGER');



-- Q3 Display Emp NO, Job, Salary who are earning moe than any of the manager and their Job is analyst

Select EMPNO, Ename, Salary, Job
From emp
Where Salary > 
ALL(    Select Salary
    From emp
   Where Job = 'MANAGER') 
AND Job = 'ANALYST';




-- Q4 Select all the employees who work in DALLAS

Select * from Department;

Select * from emp
Where DEPTNO = (    Select DEPTNO 
                    From Department
                    Where LOC = 'DALLAS');



--Q5 Display all the LOCATION and DEPT name for the employees who are working for clark 

Select D_Name, LOC
From Department
Where DEPTNO = (Select DEPTNO 
                From emp
                where MGR_ID = (Select EMPNO from emp where Ename = 'CLARK'));



--Q6 Select all the departental information for all the managers

Select D_Name, LOC
From Department
Where DEPTNO in (Select DEPTNO 
                From emp
                where Job = 'MANAGER');


-- Q7 Display the 1st MAX salary 


select Ename,job,Salary From (
select Ename,job,Salary, ROW_NUMBER() over(partition by job order by Salary desc) as rank from emp)
Where rank = 1;


-- Q8 Display the 2nd MAX salary


select Ename,job,Salary From (
select Ename,job,Salary, ROW_NUMBER() over(partition by job order by Salary desc) as rank from emp)
Where rank = 2;



-- Q9 Display the 3rd MAX salary



select Ename,job,Salary From (
select Ename,job,Salary, ROW_NUMBER() over(partition by job order by Salary desc) as rank from emp)
Where rank = 3;


-- Q10 Display all the managers and clerk who works in Accounts and Markting Department



Select Ename, Job, Salary
From emp
Where DEPTNO in (   Select DEPTNO
                   From Department
                   Where D_NAME in ('ACCOUNTING', 'SALES'))
And Job in ('MANAGER','CLERK');


-- Q11 Display all the SALESMAN who ARE NOT LOCATD IN DALLAS



Select Ename, Job, Salary, DEPTNO
From emp
Where DEPTNO in (   Select DEPTNO
                   From Department
                   Where LOC != 'DALLAS')
And Job in ('SALESMAN');



-- Q12 All the employess who works in a same department as SCOTT


Select Ename, Job, Salary, DEPTNO
From emp
Where DEPTNO = (   Select DEPTNO
                   From emp
                   Where Ename = 'SCOTT');


-- Q13 All the employees who are earning same as smith


Select Ename, Job, Salary, DEPTNO
From emp
Where Salary = (   Select Salary
                   From emp
                   Where Ename = 'SMITH');



--Q14 Display Employees who earn sopme commission and have hired on a weekday


--Select * from emp;
--SELECT DAYOFWEEK(to_date('2023-05-21')) AS WEEK_FROM_DATE; --sunday is 0

Select Ename, Job, hiredate, Salary, Commission
From emp
Where DAYOFWEEK(hiredate) between 1 and 5 
And Commission > 0;




-- Q15 Employees That are getting salary more than AVG salary of all employses



Select Ename, Job, Salary
From emp
Where Salary > (select AVG(Salary) from emp);



---  *******************  ASSIGNMENT ON JOINS **********************



--Q1 ALL THE MANAGERS AND CLERKS WHO WORKS IN ACCOUNTING AND SALES DEPARTMENT


SELECT ENAME, JOB, SALARY, D.D_NAME
FROM EMP AS E JOIN 
DEPARTMENT AS D USING(DEPTNO)
WHERE JOB IN ('MANAGER', 'CLERK') AND D_NAME IN ('ACCOUNTING', 'SALES');



-- Q2 ALL SALESMEN WHO ARE NOT LOCATED IN DALLAS


SELECT ENAME, JOB, SALARY, D.D_NAME, D.LOC
FROM EMP AS E JOIN 
DEPARTMENT AS D USING(DEPTNO)
WHERE JOB IN ('SALESMAN') AND LOC != 'DALLAS';


--Q3 SELECT DEPARTMENT NAME AND LOCATION OF ALL THE EMPLOYEES


SELECT ENAME, JOB, SALARY, D.D_NAME, D.LOC
FROM EMP JOIN
DEPARTMENT AS D USING(DEPTNO);


-- Q4 SELECT ALL THE DEPARTMENTAL INFORMATION FOR ALL THE MANAGERS



SELECT E.ENAME, D.*
FROM DEPARTMENT AS D
JOIN EMP AS E USING(DEPTNO)
WHERE E.JOB = 'MANAGER';



-- Q5 SELECT ALL THE EMPLOYEES WHO WORK IN DALLAS


SELECT E.ENAME, JOB, D.*
FROM DEPARTMENT AS D
JOIN EMP AS E USING(DEPTNO)
WHERE D.LOC = 'DALLAS';



-- Q6 DISPLAY ALL THE DEPARTMENTAL INFORMATION FOR EMPLOYEES AND IF NO EMPLOYEE IS THERE MENTION IT AS NO EMPLOYEE

SELECT LOCATION, DEPARTMENT_NUBER, CASE WHEN COUNT_TOTAL = 0 THEN 'NO EMPLOYEE' ELSE TO_CHAR(COUNT_TOTAL) END AS TOTAL_EMP
FROM
(
SELECT D.LOC AS LOCATION, D.DEPTNO AS DEPARTMENT_NUBER, COUNT(EMP.EMPNO) AS COUNT_TOTAL  FROM EMP 
FULL JOIN DEPARTMENT AS D USING(DEPTNO)
GROUP BY 1,2);



-- Q7 DISPLAY ALL THE RECORDS FROM BOTH THE TABLES WHETHER ITS MATCHING OR NOT MATCHING


SELECT EMP.*,D.LOC AS LOCATION, D.DEPTNO AS DEPARTMENT_NUBERFROM FROM EMP 
FULL JOIN DEPARTMENT AS D USING(DEPTNO);



--Q8 GET ONLY NON MATCHING RECORDS DEARTMENT TABLE

SELECT LOCATION, DEPARTMENT_NUMBER
FROM(
    SELECT D.LOC AS LOCATION, D.DEPTNO AS DEPARTMENT_NUMBER,  COUNT(EMP.EMPNO) AS COUNT_TOTAL FROM EMP 
    FULL JOIN DEPARTMENT AS D USING(DEPTNO) 
    GROUP BY 1,2)
WHERE COUNT_TOTAL = 0;



-- Q10  SELECT ALL THE EMPLOYEES NAME ALONG WITH THEIR MANAGER NAME AND IF EMPLOYEE DOES NOT HAVE A MANAGER, DISPLAY IT AS "CEO"
SELECT * FROM EMP;


SELECT E2.ENAME AS EMPLOYEE, E1.ENAME AS MANAGER, E1.EMPNO
FROM EMP AS E1, EMP AS E2
WHERE E1.ENAME <> E2.ENAME 
AND E1.EMPNO = E2.MGR_ID ;


-- Q11 DISPLAY ALL THE EMPLOYEES WHO HAVE JOINED BEFORE THEIR MANAGERS



SELECT E2.ENAME AS EMPLOYEE, E1.ENAME AS MANAGER, E2.HIREDATE 
FROM EMP AS E1, EMP AS E2
WHERE E1.ENAME <> E2.ENAME 
AND E1.EMPNO = E2.MGR_ID
AND E2.HIREDATE < E1.HIREDATE;



--Q12 EMPLOYEES WHO ARE EARNING MORE THAN THEIR MANAGERS


SELECT E2.ENAME AS EMPLOYEE, E1.ENAME AS MANAGER, E2.SALARY 
FROM EMP AS E1, EMP AS E2
WHERE E1.ENAME <> E2.ENAME 
AND E1.EMPNO = E2.MGR_ID
AND E2.SALARY > E1.SALARY;



-- Q13 EMPLOYEES WHO ARE EARNING SAME SALARIES


SELECT DISTINCT E2.ENAME AS EMPLOYEE, E1.ENAME AS EMPLOYEE_2, E2.SALARY, E1.SALARY 
FROM EMP AS E1, EMP AS E2
WHERE E1.EMPNO > E2.EMPNO 
AND E1.SALARY = E2.SALARY;




-- Bonus Question - Find the AVG salary per department and sort them in desc order


select DEPTNO, D.D_NAME, ROUND(AVG(SALARY),2) AS AVG_SALARY 
FROM emp 
JOIN DEPARTMENT AS D USING(DEPTNO)
GROUP BY 1, 2
ORDER BY 3;

--- NOW DISPLAY THE STADARD DEVIATION OF SALARY FOR EACH DEPARTMENT TO KNOW THE DATA VARIIES/DISPERSED


select DEPTNO, D.D_NAME, ROUND(AVG(SALARY),2) AS AVG_SALARY, ROUND(STDDEV(SALARY),2) AS STD_SALARY  
FROM emp 
JOIN DEPARTMENT AS D USING(DEPTNO)
GROUP BY 1, 2
ORDER BY 3;







