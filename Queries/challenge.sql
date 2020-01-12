-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no)	
);

CREATE TABLE titles (
   	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
	
	);

-- Challenge
-- Number of [titles] Retiring
SELECT  de.dept_no,
		emp.emp_no,
		emp.first_name,
		emp.last_name,
		tl.title,
		emp.birth_date,
		emp.gender,
		tl.from_date,
		tl.to_date,
		s.salary
INTO Title_Retiring
from employees as emp
INNER JOIN titles  as tl
ON tl.emp_no = emp.emp_no
INNER JOIN salaries as s
ON (s.emp_no = emp.emp_no)
INNER JOIN dept_emp as de
ON (emp.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE Title_Retiring CASCADE;

SELECT * FROM Title_Retiring

-- Only the Most Recent Titles

with titles_unique as 
(
SELECT tmp.dept_no, tmp.emp_no, tmp.first_name, tmp.last_name, tmp.title, tmp.birth_date, tmp.gender, tmp.from_date, tmp.to_date FROM
  (SELECT dept_no, emp_no, first_name, last_name, title, birth_date, gender, from_date, to_date,
     ROW_NUMBER() OVER (PARTITION BY (first_name, last_name) ORDER BY from_date DESC) as rn FROM Title_Retiring
  ) as tmp WHERE rn = 1
)
SELECT dept_no, emp_no, first_name, last_name, birth_date, gender, title, from_date, to_date INTO Unique_Titles From  titles_unique ;

DROP TABLE Unique_Titles CASCADE;

SELECT * FROM Unique_Titles

--In descending order (by date), list the frequency count of employee titles (i.e., how many employees share the same title)
SELECT title, count(title) AS Total_Titles FROM Unique_Titles
GROUP BY title

DROP TABLE mentor_info CASCADE;

 --- Who’s Ready for a Mentor?
SELECT dep.dept_name, UT.emp_no,UT.first_name, UT.last_name, UT.birth_date, UT.gender, UT.title, UT.from_date, UT.to_date
INTO mentor_info
FROM Unique_Titles as UT
INNER JOIN departments as dep
ON (dep.dept_no = UT.dept_no)
WHERE (to_date BETWEEN '9999-01-01' AND '9999-01-01')
ORDER BY from_date Asc;

SELECT * FROM mentor_info


 --In descending order (by date), list the frequency count of employee titles (i.e., how many employees share the same title)
with title_counts as 
(
SELECT title, count(title) AS count_Titles FROM mentor_info
GROUP BY title
)
select sum (count_Titles) from title_counts

SELECT gender, count(gender)
     FROM mentor_info
	 GROUP BY (gender) 
 
 
SELECT dept_name, count(dept_name)
     FROM mentor_info
	 GROUP BY (dept_name) 