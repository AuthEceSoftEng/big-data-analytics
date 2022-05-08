####### INSTALL PACKAGES #######

install.packages(c('DBI', 'RPostgres'))


####### INITIALIZE CONNECTION #######

con <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = '<add the respective string here>',
  host = '<add the respective string here>',
  port = 0000, # add the respective number here 
  user = '<add the respective string here>',
  password = '<add the respective string here>'
)


####### SIMPLE QUERIES #######

# Get employees collection
employees = DBI::dbGetQuery(con, 'SELECT * FROM employees;')

# Get specific columns from employees collection
employeesSpecific = DBI::dbGetQuery(con,
'SELECT 
    employee_id, 
    first_name, 
    last_name, 
    hire_date
FROM
    employees;')

# Update column values
employeesNewSalary = DBI::dbGetQuery(con,
'SELECT 
    first_name, 
    last_name, 
    salary, 
    salary * 1.05
FROM
    employees;')

# Update column values and rename column
employeesNewSalaryAs = DBI::dbGetQuery(con,
'SELECT 
    first_name, 
    last_name, 
    salary, 
    salary * 1.05 AS new_salary
FROM
    employees;')


####### ORDER BY #######

# Get all employees
employees = DBI::dbGetQuery(con,
'SELECT
	employee_id,
	first_name,
	last_name,
	hire_date,
	salary
FROM
	employees;')

# Sort employees by first name
employeesSorted = DBI::dbGetQuery(con,
'SELECT
	employee_id,
	first_name,
	last_name,
	hire_date,
	salary
FROM
	employees
ORDER BY
	first_name;')

# Sort employees by first name and last name descending
employeesSortedFirstLast = DBI::dbGetQuery(con,
'SELECT
	employee_id,
	first_name,
	last_name,
	hire_date,
	salary
FROM
	employees
ORDER BY
	first_name,
	last_name DESC;')

# Sort employees by salary descending
employeesSortedSalary = DBI::dbGetQuery(con,
'SELECT
	employee_id,
	first_name,
	last_name,
	hire_date,
	salary
FROM
	employees
ORDER BY
	salary DESC;')


####### FILTERING #######

# Get all unique salary values
salariesUnique = DBI::dbGetQuery(con,
'SELECT 
    DISTINCT salary
FROM
    employees
ORDER BY salary DESC;')

# Get all unique salary and job id values
salariesIDsUnique = DBI::dbGetQuery(con,
'SELECT DISTINCT
	job_id,
	salary
FROM
	employees
ORDER BY
	job_id,
	salary DESC;')

# Limit results
employees = DBI::dbGetQuery(con,
'SELECT 
    employee_id, 
    first_name, 
    last_name
FROM
    employees
ORDER BY 
	first_name
LIMIT 5;')

# Limit results with offset
employeesOffset = DBI::dbGetQuery(con,
'SELECT 
    employee_id, first_name, last_name
FROM
    employees
ORDER BY first_name
LIMIT 5 OFFSET 3;')

# Top 5 employees with highest salaries
employeesHighSalaries = DBI::dbGetQuery(con,
'SELECT 
    employee_id, 
    first_name, 
    last_name, 
    salary
FROM
    employees
ORDER BY 
	salary DESC
LIMIT 5;')

# Filter employees with salary
employeesHighSalaries = DBI::dbGetQuery(con,
'SELECT
	employee_id,
	first_name,
	last_name,
	salary
FROM
	employees
WHERE
	salary > 14000
ORDER BY
	salary DESC;')

# Filter employees with department
employeesDepartment = DBI::dbGetQuery(con,
'SELECT
	employee_id,
	first_name,
	last_name,
	department_id
FROM
	employees
WHERE
	department_id = 5
ORDER BY
	first_name;')

# Filter employees with last name
employeesLastName = DBI::dbGetQuery(con,
"SELECT
	employee_id,
	first_name,
	last_name
FROM
	employees
WHERE
	last_name = 'Chen';")

# Filter employees that do not belong to department
employeesOutDepartment = DBI::dbGetQuery(con,
"SELECT 
    employee_id, first_name, last_name, department_id
FROM
    employees
WHERE
    department_id <> 8
ORDER BY first_name , last_name;")

# Filter employees that do not belong to departments
employeesOutDepartments = DBI::dbGetQuery(con,
"SELECT 
    employee_id, first_name, last_name, department_id
FROM
    employees
WHERE
    department_id <> 8
        AND department_id <> 10
ORDER BY first_name , last_name; ")

# Filter employees with salary between range
employeesSalaryRange = DBI::dbGetQuery(con,
"SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    salary > 5000 AND salary < 7000
ORDER BY salary;")

employeesSalaryRange2 = DBI::dbGetQuery(con,
"SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    salary BETWEEN 5000 AND 7000
ORDER BY salary; ")


####### JOIN #######

# Combine employees with department info - Inner Join
employeesDepartment = DBI::dbGetQuery(con,
'SELECT 
    first_name,
    last_name,
    employees.department_id,
    departments.department_id,
    department_name
FROM
    employees
        INNER JOIN
    departments ON departments.department_id = employees.department_id
WHERE
    employees.department_id IN (1 , 2, 3);')

# Combine employees with department and job info - Inner Join
employeesDepartmentJob = DBI::dbGetQuery(con,
'SELECT
	first_name,
	last_name,
	job_title,
	department_name
FROM
	employees e
INNER JOIN departments d ON d.department_id = e.department_id
INNER JOIN jobs j ON j.job_id = e.job_id
WHERE
	e.department_id IN (1, 2, 3);')

# Combine countries with location info - Left Join
countriesLocation = DBI::dbGetQuery(con,
"SELECT
	c.country_name,
	c.country_id,
	l.country_id,
	l.street_address,
	l.city
FROM
	countries c
LEFT JOIN locations l ON l.country_id = c.country_id
WHERE
	c.country_id IN ('US', 'UK', 'CN')")

# Combine employees with managers - Self Join
employeesManagers = DBI::dbGetQuery(con,
"SELECT 
    e.first_name || ' ' || e.last_name AS employee,
    m.first_name || ' ' || m.last_name AS manager
FROM
    employees e
        INNER JOIN
    employees m ON m.employee_id = e.manager_id
ORDER BY manager;")


####### GENERAL #######

# Group data by department
employeesDepartment = DBI::dbGetQuery(con,
'SELECT
	department_id,
	COUNT(employee_id) headcount
FROM
	employees
GROUP BY
	department_id;')

# Group data by department and display min salary per department
employeesDepartmentSalary = DBI::dbGetQuery(con,
'SELECT 
    department_name, MIN(salary) min_salary
FROM
    employees
        INNER JOIN
    departments USING (department_id)
GROUP BY department_name
ORDER BY department_name;')
