/* MVP */

/* Question 1.
Find all the employees who work in the ‘Human Resources’ department. */

SELECT *
FROM employees 
WHERE department = 'Human Resources'; --90 employees

/*Question 2.
Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.*/

SELECT
    first_name,
    last_name,
    country,
    department
FROM employees 
WHERE department = 'Legal'; --102 employees

/*Question 3.
Count the number of employees based in Portugal.*/

SELECT 
    count(*)
FROM employees
WHERE country = 'Portugal'; --29 employees

/*Question 4.
Count the number of employees based in either Portugal or Spain.*/

SELECT 
    count(*)
FROM employees
WHERE country = 'Portugal' OR country = 'Spain'; --35 employees

/*Question 5.
Count the number of pay_details records lacking a local_account_no.*/

SELECT 
    count(*)
FROM pay_details 
WHERE local_account_no IS NULL; --25 employees

/*Question 6.
Are there any pay_details records lacking both a local_account_no and iban number?*/

SELECT 
    count(*)
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL; --NO

/*Question 7.
Get a table with employees first_name and last_name ordered 
alphabetically by last_name (put any NULLs last).*/

SELECT
    first_name,
    last_name 
FROM employees 
ORDER BY 
    last_name ASC NULLS LAST;

/*Question 8.
Get a table of employees first_name, last_name and country, ordered alphabetically 
first by country and then by last_name (put any NULLs last).*/

SELECT
    first_name,
    last_name,
    country
FROM employees 
ORDER BY 
    country ASC,
    last_name ASC NULLS LAST;

/*Question 9.
Find the details of the top ten highest paid employees in the corporation.*/

SELECT *
FROM employees 
WHERE salary IS NOT NULL
ORDER BY salary DESC
LIMIT 10;

/*Question 10.
Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/

SELECT
    first_name,
    last_name,
    salary,
    country
FROM employees 
WHERE salary IS NOT NULL AND country = 'Hungary'
ORDER BY salary ASC
LIMIT 1;

/*Question 11.
How many employees have a first_name beginning with ‘F’?*/

SELECT
    count(*) AS starts_with_f
FROM employees 
WHERE first_name ~ 'F'; --30

SELECT
    first_name 
FROM employees 
WHERE first_name ~ 'F'; --Proof OF 30 names

/*Question 12.
Find all the details of any employees with a ‘yahoo’ email address?*/

SELECT *
FROM employees 
WHERE email ~ 'yahoo'; -- 5 email addresses

/*Question 13. Count the number of pension enrolled 
employees not based in either France or Germany.*/

SELECT *
FROM employees 
WHERE country NOT IN ('France', 'Germany') AND 
pension_enrol = TRUE;

/* Question 14.
What is the maximum salary among those employees in the ‘Engineering’ 
department who work 1.0 full-time equivalent hours (fte_hours)?*/

SELECT
    department,
    fte_hours,
    salary AS maximum_salary
FROM employees 
WHERE department = 'Engineering' AND 
    fte_hours = 1
ORDER BY salary DESC
LIMIT 1;               -- max salary 83,370

/*Question 15.
Return a table containing each employees first_name, last_name, 
full-time equivalent hours (fte_hours), salary, and a new column 
effective_yearly_salary which should contain fte_hours multiplied by salary.*/

SELECT 
    first_name,
    last_name,
    fte_hours,
    salary,
    fte_hours*salary as effective_yearly_salary
FROM employees;






