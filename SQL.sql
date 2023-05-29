##Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        /* Write your T-SQL query statement below. */
    SELECT MAX(salary) FROM(
      SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) as row_number
      FROM Employee)sub
    Where row_number=@N
    );
END

CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
SET N = N-1;
  RETURN (
      SELECT DISTINCT(salary) from Employee order by salary DESC
      LIMIT 1 OFFSET N
  );
END
--------------------------------------------------------------------------------------
SELECT COALESCE(
    (SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT 1 OFFSET 1),
    'null'
) AS SecondHighestSalary;
--------------------------------------------------------------------------------------
SELECT
  MAX(salary) AS SecondHighestSalary
FROM
  Employee
WHERE
  salary < (SELECT MAX(salary) FROM Employee);
--------------------------------------------------------------------------------------
SELECT  ROUND(score, 2) AS score, DENSE_RANK() OVER (ORDER BY score DESC) as rank
FROM Scores
--------------------------------------------------------------------------------------  
/* Write your T-SQL query statement below */

SELECT Department, Employee, Salary 
FROM
(
    SELECT d.name AS Department, 
    e.name AS Employee, 
    e.salary AS Salary,
    DENSE_RANK() OVER(PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rank_salary
    FROM 
    Employee e 
    JOIN Department d ON e.departmentId = d.id
)sub
Where rank_salary<=3
--------------------------------------------------------------------------------------
With p as (
SELECT DISTINCT product_id 
FROM
products
),
t as (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY change_date DESC) as cd_rk
FROM
products
WHERE 
change_date <= '2019-08-16' 
)

SELECT p.product_id, 
ISNULL(t.new_price, 10) as price 
FROM p
LEFT JOIN t ON p.product_id = t.product_id AND cd_rk = 1
--------------------------------------------------------------------------------------
/* Write your T-SQL query statement below */

SELECT 
t.request_at AS Day,
ROUND((CAST(SUM(CASE WHEN status != 'completed' THEN 1 ELSE 0 END) AS float)/CAST(COUNT(DISTINCT id))AS float),2) AS 'Cancellation Rate'
FROM 
Trips t 
JOIN Users c_u ON t.client_id = c_u.users_id
JOIN Users d_u ON t.driver_id = d_u.users_id
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
AND c_u.banned = 'No' AND d_u.banned = 'No'

--------------------------------------------------------------------------------------
SELECT
    request_at AS Day
    ,ROUND(CAST(SUM(CASE WHEN status != 'completed' THEN 1 ELSE 0 END) AS float)/CAST(COUNT(DISTINCT id) AS float), 2) AS 'Cancellation Rate'
FROM Trips
WHERE request_at BETWEEN '2013-10-01'
AND '2013-10-03'
AND client_id NOT IN (
    SELECT
        users_id
    FROM Users
    WHERE banned = 'Yes'
)
AND driver_id NOT IN (
    SELECT
        users_id
    FROM Users
    WHERE banned = 'Yes'
)
GROUP BY request_at;
--------------------------------------------------------------------------------------
/* Write your T-SQL query statement below */
select request_at as Day,
 Round(Avg(CASE WHEN t.status LIKE 'cancelled%' THEN 1.0 else 0 END),2) as 'Cancellation Rate'
 from Trips t 
 join Users u on t.client_id = u.users_id and u.banned = 'No' 
 join Users u2 on t.driver_id = u2.users_id and u2.banned = 'No' 
 WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03' 
 group by request_at
--------------------------------------------------------------------------------------
WITH a AS(
    SELECT 
    *,
    id-ROW_NUMBER() OVER(ORDER BY visit_date ASC) AS grp
    FROM
    Stadium 
    Where people>=100
    )

SELECT id,
visit_date,
people
FROM 
a
WHERE 
grp in (select grp from a group by grp having count(*) > 2)
order by visit_date
--------------------------------------------------------------------------------------
SELECT year, quarter,
  LAG(bonus,4) OVER(ORDER BY year,quarter) AS previous_bonus,
 bonus AS current_bonus,
  LEAD(bonus,4) OVER(ORDER BY year,quarter) AS next_bonus
FROM employee
WHERE employee_id=1;
--------------------------------------------------------------------------------------
SELECT
salary,
(ROW_NUMBER() OVER(ORDER BY salary) -1) % 5 AS mod_5
FROM
Employee
