create database advanced_lab;

create table employees (
    empl_id serial primary key ,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100),
    salary int,
    hire_date date,
    status VARCHAR(50) DEFAULT 'Active'
);

create table departments(
    dept_id serial primary key ,
    dept_name VARCHAR(50),
    budget int,
    meneger_id int
);

create table projects(
    projects_id serial primary key,
    project_name VARCHAR(50),
    dept_id int,
    start_date date,
    end_date date,
    budget int
);

INSERT INTO employees (first_name, last_name, department)
VALUES ('Zhanatuly','Shyngys','developer');

INSERT INTO employees (first_name, last_name, department, hire_date)
VALUES ('Zhanatuly','Bekzat','IT', CURRENT_DATE);

INSERT INTO departments (dept_name, budget, manager_id)
VALUES ('developer', 500000, 1),
        ('Marketing', 450000, 2),
        ('HR', 250000, 3);

insert into employees (first_name, last_name, department,salary, hire_date)
values ('Ospanov', 'Olzhas', 'HR', 50000*1.1,CURRENT_DATE);

create temp table temp_empoloyees AS
    SELECT * from employees WHERE department ='IT';

--PART C
update employees
    set salary=salary *1.1;

UPDATE employees
    set status ='Senior',
    WHERE salary >60000,
    AND hire_date < '2020-01-01';

UPDATE employees
    set department =
        CASE
            When salary>80000 then 'Management'
            when salary between 50000 and 80000 then 'Senior'
            else 'Junior'
        END;


UPDATE employees
    set department=DEFAULT
    WHERE status = 'Inactive';

update departments d
    set budget=(
        select avg(salary) *1.2 FROM employees e
        where e.department = d.dept_name
        );

UPDATE employees
    SET salary = salary * 1.15,
        status = 'Promoted'
    WHERE  department = 'Sales';

--PART D
delete from employees WHERE  status ='Terminated';

DELETE FROM employees where salary <40000 AND hire_date>'2023-01-01' AND department is NULL;

DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT  DISTINCT department FROM employees
            WHERE   department IS NOT NULL
    );

DELETE FROM projects
    WHERE  end_date < '2023-01-01'
    RETURNING *;

-- PART E

INSERT INTO employees(FIRST_NAME, LAST_NAME, DEPARTMENT, SALARY, HIRE_DATE)
    VALUES ('Joshua', 'Kreig', Null, Null, current_date);

UPDATE employees
    SET department = 'Unassigned'
    WHERE department IS NULL;


DELETE FROM employees
WHERE salary IS NULL
    OR department IS NULL;

--PART F


    INSERT INTO employees(FIRST_NAME, LAST_NAME, DEPARTMENT, SALARY, HIRE_DATE)
    VALUES ('Valentin', 'Strykalo', 'HR',65000,current_date )
    returning empl_id , first_name || ' ' || last_name as full_name;
-- 21
    UPDATE employees
    SET salary = salary + 5000
    WHERE department = 'IT'
    RETURNING  empl_id, salary - 5000 AS old_salary, salary AS new_salary;
-- 22
    delete from employees
    where hire_date < '2020-01-01'
    returning *;
-- part g
-- 23
    INSERT INTO employees(first_name, last_name, department)
    SELECT 'Kukuruza', 'Vanil', 'IT'
    WHERE NOT EXISTS(SELECT 1 FROM employees
                              WHERE first_name = 'Kukuruza' and last_name = 'Vanil');
-- 24
    UPDATE employees e
        SET salary = salary * CASE
            WHEN (SELECT budget FROM departments d
                        WHERE d.dept_name = e.department) > 100000
                        THEN 1.10
            ELSE 1.05
        END;
-- 25
    INSERT INTO employees(FIRST_NAME, LAST_NAME, DEPARTMENT, salary)
    VALUES ('Miras', 'Ibraev', 'IT', 600000),
           ('Dulat', 'Amangeldiev', 'HR', 75000),
           ('Yerassyl', 'Amangeldi', 'Sales',55000),
           ('Daniyal', 'Amangeldiev', 'Marketing', 70000),
           ('Kenzhebek', 'Talgatov', 'IT', 95000);
    UPDATE employees
        SET salary = salary * 1.10
        WHERE department = 'IT';
-- 26
    CREATE TABLE employee_archive (LIKE employees INCLUDING ALL);
    INSERT INTO employee_archive
    SELECT * FROM employees;
    DELETE FROM employees
    WHERE status = 'Inactive';
-- 27
    UPDATE projects p
    SET end_date = end_date + interval '30 days'
    where budget > 5000 and
          (SELECT COUNT(*) FROM employees e
                           JOIN departments d ON e.department = d.dept_name
                           WHERE d.dept_id = p.dept_id) > 3;




-- test

    INSERT INTO employees(first_name, last_name, department)
    SELECT 'Alice','Brown','IT'
    WHERE NOT EXISTS (SELECT 1 FROM employees WHERE first_name = 'Alice' and last_name = 'Brown');


    UPDATE employees
    SET salary = salary * 1.15,
        status = 'Promoted'
    WHERE department = 'sales'

    DELETE FROM departments d
    WHERE  (SELECT * FROM employees d
                     WHERE D)