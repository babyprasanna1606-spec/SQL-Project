--CREATE 4 TABLES--

--(1)DEPARTMENTS

CREATE TABLE cwm_departments_2026 (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL
);

--(2)EMPLOYEES

CREATE TABLE cwm_employees_2026 (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50) NOT NULL,
    salary NUMBER(10,2),
    hire_date DATE,
    dept_id NUMBER,
    CONSTRAINT cwm_fk_dept_2026
    FOREIGN KEY (dept_id)
    REFERENCES cwm_departments_2026(dept_id)
);

--(3)PROJECTS

CREATE TABLE cwm_projects_2026 (
    project_id NUMBER PRIMARY KEY,
    project_name VARCHAR2(50),
    budget NUMBER(12,2)
);

--(4)EMPLOYEES PROJECT

CREATE TABLE cwm_emp_projects_2026 (
    emp_id NUMBER,
    project_id NUMBER,
    PRIMARY KEY(emp_id, project_id),
    FOREIGN KEY(emp_id)
        REFERENCES cwm_employees_2026(emp_id),
    FOREIGN KEY(project_id)
        REFERENCES cwm_projects_2026(project_id)
);

--INSERT RECORDS IN EACH TABLE--

--(1)--

INSERT INTO cwm_departments_2026 VALUES (1,'IT');
INSERT INTO cwm_departments_2026 VALUES (2,'HR');
INSERT INTO cwm_departments_2026 VALUES (3,'Finance');
INSERT INTO cwm_departments_2026 VALUES (4,'Marketing');

SELECT * FROM cwm_departments_2026;

--(2)--

INSERT INTO cwm_employees_2026
VALUES (101,'Ravi',50000,DATE '2023-01-10',1);

INSERT INTO cwm_employees_2026
VALUES (102,'Priya',60000,DATE '2023-02-15',2);

INSERT INTO cwm_employees_2026
VALUES (103,'Kiran',70000,DATE '2023-03-20',1);

INSERT INTO cwm_employees_2026
VALUES (104,'Sneha',55000,DATE '2023-04-25',3);

INSERT INTO cwm_employees_2026
VALUES (105,'Arjun',65000,DATE '2023-05-10',4);

SELECT * FROM cwm_employees_2026;

--(3)--

INSERT INTO cwm_projects_2026
VALUES (201,'ERP System',500000);

INSERT INTO cwm_projects_2026
VALUES (202,'HR Portal',300000);

INSERT INTO cwm_projects_2026
VALUES (203,'Marketing Dashboard',250000);

SELECT * FROM cwm_projects_2026;

--(4)--

INSERT INTO cwm_emp_projects_2026 VALUES (101,201);
INSERT INTO cwm_emp_projects_2026 VALUES (102,202);
INSERT INTO cwm_emp_projects_2026 VALUES (103,201);
INSERT INTO cwm_emp_projects_2026 VALUES (104,203);
INSERT INTO cwm_emp_projects_2026 VALUES (105,203);

SELECT * FROM cwm_emp_projects_2026;

--COMMIT DATA--

COMMIT;

--CREATE VIEWS--

--(1)--

CREATE VIEW bs26_dept_master_view AS
SELECT *
FROM cwm_departments_2026;

SELECT * FROM bs26_dept_master_view;

--(2)--

CREATE VIEW bs26_emp_master_view AS
SELECT *
FROM cwm_employees_2026;

SELECT * FROM bs26_emp_master_view;

--(3)--

CREATE VIEW bs26_project_master_view AS
SELECT *
FROM cwm_projects_2026

SELECT * FROM bs26_project_master_view;

--(4)--

CREATE VIEW bs26_emp_projects_master_view AS
SELECT *
FROM cwm_emp_projects_2026;

SELECT * FROM bs26_emp_projects_master_view;

--CREATE INDEXES--

--(1)--

CREATE INDEX bs_dept_name_idx_2026
ON cwm_departments_2026(dept_name);

--(2)--

CREATE INDEX bs_emp_name_idx_2026
ON cwm_employees_2026(emp_name);

--(3)--

CREATE INDEX bs_project_name_idx_2026
ON cwm_projects_2026(project_name);

--(4)--

CREATE INDEX bs_emp_proj_idx_2026
ON cwm_emp_projects_2026(project_id);

--AGGREGRATE QUERIES--

--Total Salary by Department--

SELECT d.dept_name,
       SUM(e.salary) total_salary
FROM cwm_employees_2026 e
JOIN cwm_departments_2026 d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

--Average Salary--

SELECT AVG(salary)
FROM cwm_employees_2026;

--Maximum Salary--

SELECT MAX(salary)
FROM cwm_employees_2026;

--Minimum Salary--

SELECT MIN(salary)
FROM cwm_employees_2026;

--SUB QUERY--

--Highest-paid employee--

SELECT *
FROM cwm_employees_2026
WHERE salary =
(
    SELECT MAX(salary)
    FROM cwm_employees_2026
);

--CREATE ADDITIONAL VIEW--

CREATE VIEW cwm_project_details_2026 AS
SELECT e.emp_name,
       p.project_name,
       p.budget
FROM cwm_employees_2026 e
JOIN cwm_emp_projects_2026 ep
ON e.emp_id = ep.emp_id
JOIN cwm_projects_2026 p
ON ep.project_id = p.project_id;

SELECT * FROM cwm_project_details_2026;

--TEST INDEX--

SELECT *
FROM cwm_employees_2026
WHERE emp_name='Ravi';

--EXPLAIN PLAN FOR--

EXPLAIN PLAN FOR

SELECT *
FROM cwm_employees_2026
WHERE emp_name='Ravi';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--UPDATE RECORDS--

UPDATE cwm_employees_2026
SET salary = 75000
WHERE emp_id = 103;

SELECT *
FROM cwm_employees_2026;

--DELETE RECORDS--

DELETE FROM cwm_emp_projects_2026
WHERE emp_id = 105;

SELECT *
FROM cwm_emp_projects_2026;

--FINAL PROJECT QUERIES FOR INTERVIEW--

--Top Paid Employee--

SELECT *
FROM cwm_employees_2026
ORDER BY salary DESC;

--Employee Count by Department--

SELECT dept_id,
       COUNT(*)
FROM cwm_employees_2026
GROUP BY dept_id;

--Employees Earning Above Average Salary--

SELECT *
FROM cwm_employees_2026
WHERE salary >
(
SELECT AVG(salary)
FROM cwm_employees_2026
);

--GROUP BY--

--Total Salary by Department--

SELECT dept_id,
       SUM(salary)
FROM cwm_employees_2026
GROUP BY dept_id;

--Employee Count by Department--

SELECT dept_id,
       COUNT(*)
FROM cwm_employees_2026
GROUP BY dept_id;

--HAVING--

--Departments with salary above 60000--

SELECT dept_id,
       SUM(salary)
FROM cwm_employees_2026
GROUP BY dept_id
HAVING SUM(salary) > 60000;

--PL/SQL--

--1. Sequence--

CREATE SEQUENCE bs_emp_seq_2026
START WITH 106
INCREMENT BY 1;

SELECT bs_emp_seq_2026.NEXTVAL
FROM dual;

--2. Trigger--

CREATE OR REPLACE TRIGGER bs_emp_trg_2026
BEFORE INSERT ON cwm_employees_2026
FOR EACH ROW
BEGIN
   :NEW.emp_id := bs_emp_seq_2026.NEXTVAL;
END;
/

--3. Stored Procedure--

CREATE OR REPLACE PROCEDURE bs_salary_hike_2026
(
   p_emp_id NUMBER,
   p_percent NUMBER
)
AS
BEGIN
   UPDATE cwm_employees_2026
   SET salary = salary + (salary * p_percent/100)
   WHERE emp_id = p_emp_id;

   COMMIT;
END;
/

EXEC bs_salary_hike_2026(101,10);

