-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/EiCVva
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "departments" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(4)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title" VARCHAR(5)   NOT NULL,
    "birth_date" VARCHAR(10)   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- 1.List the employee number, last name, first name, sex, and salary of each employee.

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
LEFT JOIN salaries AS s
ON e.emp_no = s.emp_no
ORDER BY emp_no
;

--2.List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986'
ORDER BY hire_date;

--3.List the manager of each department along with their department number, 
--department name, employee number, last name, and first name

SELECT mng.dept_no, dept.dept_name, mng.emp_no, e.last_name, e.first_name
FROM dept_manager AS mng
LEFT JOIN departments AS dept
ON mng.dept_no = dept.dept_no
LEFT JOIN employees AS e
ON mng.emp_no=e.emp_no
ORDER BY dept_no
;

--4. List the department number for each employee along with that employee’s employee number, 
--last name, first name, and department name.

SELECT d_e.dept_no, d_e.emp_no, e.last_name, e.first_name, dept.dept_name
FROM dept_emp AS d_e
LEFT JOIN employees AS e
ON d_e.emp_no = e.emp_no
LEFT JOIN departments AS dept
ON d_e.dept_no=dept.dept_no
ORDER BY dept_no
;

--5. List first name, last name, and sex of each employee 
--whose first name is Hercules and whose last name begins with the letter B.

SELECT first_name, last_name, sex
FROM employees
WHERE first_name='Hercules' AND last_name LIKE 'B%'
ORDER BY last_name
;

--6. List each employee in the Sales department, 
--including their employee number, last name, and first name.

SELECT d_e.emp_no, e.last_name, e.first_name, dept.dept_name
FROM dept_emp AS d_e
LEFT JOIN employees AS e
ON d_e.emp_no = e.emp_no
LEFT JOIN departments AS dept
ON d_e.dept_no=dept.dept_no
WHERE dept.dept_name='Sales'
ORDER BY d_e.emp_no
;

--7.List each employee in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

SELECT d_e.emp_no, e.last_name, e.first_name, dept.dept_name
FROM dept_emp AS d_e
LEFT JOIN employees AS e
ON d_e.emp_no = e.emp_no
LEFT JOIN departments AS dept
ON d_e.dept_no=dept.dept_no
WHERE dept.dept_name='Sales'
OR dept.dept_name='Development'
ORDER BY d_e.emp_no
;

--8.List the frequency counts, in descending order, 
--of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT(last_name) AS freq_counts
FROM employees
GROUP BY last_name
ORDER BY freq_counts DESC;