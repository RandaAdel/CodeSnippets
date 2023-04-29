CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
    SELECT salary FROM(
      SELECT salary, ROW_NUMBER() OVER (ORDER BY salary ASC) as row_number
      FROM Employee)sub
    Where row_number=@N
  );
END


