# Pewlett-Hackard-Analysis

# Brief Summary

For Mentorship program  total = 691 candidates are on verge of retiring with their most recent titles and these current employees are also eligible for mentorship programand.
In that major mentorship members are either senior staff or seior engineer 283 & 279 respectively. 
Also - 60% are male and 40% are female members eligible for mentorship (404 and 287) respectively. 
From departments point of view alot of folks are from Development and Production with 185 and 146 repectivel and followed by sales division with 119 members



## Code to get the info above.
# Below query is used to get the employees that are eligible for retirement.
-- Challenge
-- Number of [titles] Retiring
SELECT  emp.emp_no,
		emp.first_name,
		emp.last_name,
		tl.title,
		emp.birth_date,
		tl.from_date,
		tl.to_date,
		s.salary
INTO Title_Retiring
from employees as emp
INNER JOIN titles  as tl
ON tl.emp_no = emp.emp_no
INNER JOIN salaries as s
ON (s.emp_no = emp.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

## This query returns the most recent titles held by the employee while removing the duplicates.
## Only the Most Recent Titles

with titles_unique as 
(
SELECT tmp.emp_no, tmp.first_name, tmp.last_name, tmp.title, tmp.birth_date, tmp.from_date, tmp.to_date FROM
  (SELECT emp_no, first_name, last_name, title, birth_date, from_date, to_date,
     ROW_NUMBER() OVER (PARTITION BY (first_name, last_name) ORDER BY from_date DESC) as rn FROM Title_Retiring
  ) as tmp WHERE rn = 1
)
SELECT emp_no, first_name, last_name, birth_date, title, from_date, to_date INTO Unique_Titles From  titles_unique ;


## this query returns how many employees share the same title)
SELECT title, count(title) AS Total_Titles FROM Unique_Titles
GROUP BY title

## Below query to to find current retiring employees who can be mentors.
 --In descending order (by date), list the frequency count of employee titles (i.e., how many employees share the same title)
with title_counts as 
(
SELECT title, count(title) AS count_Titles FROM mentor_info
GROUP BY title
)
select sum (count_Titles) from title_counts

## Find out the gender of people elgible.
SELECT gender, count(gender)
     FROM mentor_info
	 GROUP BY (gender) 