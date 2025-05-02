
-- Create a new database named "CompanyDB"
CREATE DATABASE CompanyDB;

-- 2.	Create a schema named "Sales" within the "CompanyDB" database.
CREATE SCHEMA Sales;

-- 3.	Create a table named "employees" with columns: 
--	employee_id (INT) - use sequence instead of identity,
--	first_name (VARCHAR),
--	last_name (VARCHAR),
--	salary (DECIMAL)
--	Within the "Sales" schema.


CREATE TABLE Sales.employees (
    employee_id INT PRIMARY KEY identity,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    salary DECIMAL
);

--4.	Alter the "employees" table to add a new column named "hire_date" with the data type DATE.
ALTER TABLE Sales.employees ADD hire_date DATE;

-- 5.	Add mock data to this table using Mockaroo.

-- 1.	Select all columns from the "employees" table.
SELECT * FROM Sales.employees;

--2.	Retrieve only the "first_name" and "last_name" columns from the "employees" table.
SELECT first_name, last_name FROM Sales.employees;

--3.	Retrieve "full name" as a one column from "first_name" and "last_name" columns from the "employees" table.
select first_name+' '+last_name as full_name from Sales.employees;

-- 4.	Show the average salary of all employees. (Use AVG() function)
select AVG(salary)  from Sales.employees;

--5.	Select employees whose salary is greater than 50000.
select * from Sales.employees where salary>50000
--6.	Retrieve employees hired in the year 2020.
select * from Sales.employees where YEAR(hire_date) = 2020;
-- 7.	List employees whose last names start with 'S'.
select * from Sales.employees where last_name like 'S%'

-- 8.	Display the top 10 highest-paid employees.
select * 
from Sales.Employees 
order by salary DESC 
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
-- 9.	Find employees with salaries between 40000 and 60000.
select * from Sales.employees where salary BETWEEN 40000 AND 60000;

--10.	Show employees with names containing the substring 'man'.
select * from Sales.employees where first_name LIKE '%man%' OR last_name LIKE '%man%';

-- 11.	Display employees with a NULL value in the "hire_date" column.
select * from Sales.employees where hire_date = NULL;

--12.	Select employees with a salary in the set (40000, 45000, 50000).
select * from Sales.employees where salary IN (40000, 45000, 50000);

--13.	Retrieve employees hired between '2020-01-01' and '2021-01-01'.
select * from Sales.employees where hire_date BETWEEN '2020-01-01' AND '2021-01-01';

-- 14.	List employees with salaries in descending order.
select * from Sales.employees ORDER BY salary DESC;

--15.	Show the first 5 employees ordered by "last_name" in ascending order.
select * 
from Sales.Employees 
ORDER BY last_name ASC 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- 16.	Display employees with a salary greater than 55000 and hired in 2020.
select * from Sales.employees where salary > 55000 AND YEAR(hire_date) = 2020;

--17.	Select employees whose first name is 'John' or 'Jane'.
select * from Sales.employees where first_name IN ('John', 'Jane');

-- 18.	List employees with a salary ≤ 55000 and a hire date after '2022-01-01'.
select * from Sales.employees 
WHERE salary <= 55000 AND hire_date > '2022-01-01'

--19.	Retrieve employees with a salary greater than the average salary.
select * from Sales.employees 
WHERE salary > (SELECT AVG(salary) FROM Sales.employees)

-- 20.	Display the 3rd to 7th highest-paid employees. (Use OFFSET and FETCH)
select * from Sales.employees 
ORDER BY salary DESC OFFSET 3 ROWS FETCH NEXT 7 ROWS ONLY;

--21.	List employees hired after '2021-01-01' in alphabetical order.
select * from Sales.employees where hire_date > '2021-01-01' ORDER BY first_name, last_name;

-- 22.	Retrieve employees with a salary > 50000 and last name not starting with 'A'.
select * from Sales.employees WHERE salary > 50000 AND last_name NOT LIKE 'A%';

--23.	Display employees with a salary that is not NULL.
SELECT * FROM Sales.employees WHERE salary IS NOT NULL;

--24.	Show employees with names containing 'e' or 'i' and a salary > 45000.
select * from Sales.employees
where(first_name like '%e%' or last_name like '%e%' 
or first_name like '%i%' or last_name like '%i%') and salary > 45000

-- 25.	Create a new table named "departments" with columns:
	--department_id (Primary Key, INT),
	--department_name (VARCHAR),
	--manager_id (INT, references "employees".employee_id).

CREATE TABLE Sales.departments (
    department_id INT PRIMARY KEY identity,
    department_name VARCHAR(60),
    manager_id INT,
    foreign KEY (manager_id) REFERENCES Sales.employees(employee_id)
	
);

-- 26.	Assign each employee to a department by creating a "department_id" column in "employees" and making it a 
--foreign key referencing "departments".department_id.
ALTER TABLE Sales.employees ADD department_id INT;
ALTER TABLE Sales.employees ADD foreign key (department_id) references Sales.departments(department_id);

-- 27.	Retrieve all employees with their department names (Use INNER JOIN).
SELECT e.*, d.department_name
FROM Sales.employees e
INNER JOIN Sales.departments d ON e.department_id = d.department_id;

-- 28.	Retrieve employees who don’t belong to any department (Use LEFT JOIN and check for NULL).
SELECT e.*
FROM Sales.employees e
LEFT JOIN Sales.departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- 29.	Show all departments and their employee count (Use JOIN and GROUP BY).
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM Sales.departments d
LEFT JOIN Sales.employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 30.	Retrieve the highest-paid employee in each department (Use JOIN and MAX(salary)).
SELECT d.department_name, e.first_name, e.last_name, e.salary
FROM Sales.employees e
JOIN Sales.departments d ON e.department_id = d.department_id
WHERE (e.salary) IN (
    SELECT MAX(salary)
    FROM Sales.employees
    GROUP BY department_id
);

-- 31. Group employees by their department and calculate the average 
--salary for each department.
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM Sales.employees e
JOIN Sales.departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

--32. Insert a new employee into the "employees" 
--table with a salary and hire date.
INSERT INTO Sales.employees (first_name, last_name, salary, hire_date)
VALUES ('Ali', 'Hassan', 48000, '2023-03-01');

-- 33. Update the salary of employees who earn less than 45000 to 46000.
UPDATE Sales.employees SET salary = 46000 WHERE salary < 45000;

-- 34. Delete employees who have a NULL hire date.
DELETE FROM Sales.employees WHERE hire_date IS NULL;

-- 35. Create an index on the salary column in the "employees"
--table to optimize queries filtering by salary.
CREATE INDEX idx_salary ON Sales.employees(salary);
