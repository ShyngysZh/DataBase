-- =========================================================
-- Лабораторная работа №2: Продвинутые операции DDL
-- Имя файла: lab2_advanced_ddl.sql
-- =========================================================

-- ---------------------------------------------------------
-- Часть 1.1: Создание баз данных с параметрами
-- ---------------------------------------------------------

-- 1. Создание базы данных university_main

CREATE DATABASE university_main
    WITH
    OWNER = postgres
    TEMPLATE = template0
    ENCODING = 'UTF8';

-- 2. Создание базы данных university_archive
CREATE DATABASE university_archive
    WITH
    CONNECTION LIMIT = 50
    TEMPLATE = template0;

-- 3. Создание базы данных university_test
-- Сделать шаблоном (istemplate = true), лимит подключений: 10
CREATE DATABASE university_test
    WITH
    IS_TEMPLATE = true
    CONNECTION LIMIT = 10;



-- 1.2: Операции с табличными пространствами (Tablespaces)


-- 1. Создание student_data
CREATE TABLESPACE student_data
    LOCATION '/Users/olzhasospanov/Desktop/data/students';

-- 2. Создание course_data
CREATE TABLESPACE course_data
    OWNER postgres
    LOCATION '/Users/olzhasospanov/Desktop/data/courses';

-- 3. Создание базы данных university_distributed
CREATE DATABASE university_distributed
    WITH
    TABLESPACE = student_data
    ENCODING = 'UTF8';

-- =========================================================
-- Part 2: Complex Table Creation
-- Task 2.1: University Management System
-- =========================================================

-- 1. Table: students
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone CHAR(15),
    date_of_birth DATE,
    enrollment_date DATE,
    gpa NUMERIC(3, 2),
    is_active BOOLEAN,
    graduation_year SMALLINT
);

CREATE table professors(
    professor_id SERIAL primary key ,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    office_number VARCHAR(20),
    hire_date DATE,
    salary NUMERIC(12, 2),
    is_tenured BOOLEAN,
    years_experience INTEGER
)

Create table courses(
    course_id SERIAL primary key,
    course_code CHAR(8),
    course_title varchar(100),
    description TEXT,
    credits smallint,
    max_enrollment INTEGER,
    course_fee NUMERIC(10,2),
    is_online BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE
)


-- =========================================================
-- Task 2.2: Time-based and Specialized Tables
-- =========================================================

-- 1. Table: class_schedule
CREATE TABLE class_schedule (
    schedule_id SERIAL PRIMARY KEY,
    course_id INTEGER,
    professor_id INTEGER,
    classroom VARCHAR(20),
    class_date DATE,
    start_time TIME WITHOUT TIME ZONE,
    end_time TIME WITHOUT TIME ZONE,
    duration INTERVAL
);

-- 2. Table: student_records
CREATE TABLE student_records (
    record_id SERIAL PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    semester VARCHAR(20),
    year INTEGER,
    grade CHAR(2),
    attendance_percentage NUMERIC(4, 1),
    submission_timestamp TIMESTAMP WITH TIME ZONE,
    last_updated TIMESTAMP WITH TIME ZONE
);


-- Part 3: Advanced ALTER TABLE Operations
-- Task 3.1: Modifying Existing Tables

ALTER TABLE students
    ADD COLUMN middle_name VARCHAR(30),
    ADD COLUMN student_status VARCHAR(20),
    ALTER COLUMN phone TYPE VARCHAR(20),
    ALTER COLUMN student_status SET DEFAULT 'ACTIVE',
    ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
    ADD COLUMN department_code CHAR(5),
    ADD COLUMN research_area TEXT,
    ALTER COLUMN years_experience TYPE smallint,
    Alter Column is_tenured SET DEFAULT false,
    ADD COLUMN last_promotion_date date;


ALTER TABLE courses
    ADD COLUMN prerequisite_course_id INTEGER,
    ADD COLUMN difficulty_level SMALLINT,
    ALTER COLUMN course_code TYPE VARCHAR(10),
    ALTER COLUMN credits SET DEFAULT 3,
    ADD COLUMN lab_required BOOLEAN DEFAULT false;


-- Task 3.2: Column Management Operations

ALTER TABLE class_schedule
    ADD COLUMN room_sapacity INT,
    DROP COLUMN duration,
    ADD COLUMN session_type VARCHAR(15),
    ALTER COLUMN classroom type VARCHAR(30),
    ADD COLUMN equipment_needed TEXT;

ALTER TABLE student_records
    ADD COLUMN extra_credit_points NUMERIC(3,1)
    alter column grade type varchar(5),
    alter column extra_credit_points SET DEFAULT 0.0,
    ADD COLUMN final_exam_date date,
    Drop column last_updated;



-- Part 4: Table Relationships and Management
-- Task 4.1: Additional Supporting Tables


-- 1. Table: departments
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    department_code CHAR(5),
    building VARCHAR(50),
    phone VARCHAR(15),
    budget NUMERIC(15, 2),
    established_year INTEGER
);

-- 2. Table: library_books
CREATE TABLE library_books (
    book_id SERIAL PRIMARY KEY,
    isbn CHAR(13),
    title VARCHAR(200),
    author VARCHAR(100),
    publisher VARCHAR(100),
    publication_date DATE,
    price NUMERIC(10, 2),
    is_available BOOLEAN,
    acquisition_timestamp TIMESTAMP WITHOUT TIME ZONE
);

-- 3. Table: student_book_loans
CREATE TABLE student_book_loans (
    loan_id SERIAL PRIMARY KEY,
    student_id INTEGER,
    book_id INTEGER,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount NUMERIC(8, 2),
    loan_status VARCHAR(20)
);

-- Task 4.2: Table Modifications for Integration
ALTER TABLE professors
    ADD COLUMN department_id int;
ALTER TABLE students
    ADD COLUMN advisor_id int;
ALTER TABLE courses
    ADD COLUMN department_id int;

CREATE TABLE grade_scale(
    grade_id serial primary key,
    letter_grade char(2),
    min_percentage numeric(3,1),
    max_percentage numeric(3,1),
    gpa_points numeric(3,2)
);
CREATE TABLE semester_calendar(
    semester_id serial primary key,
    semester_name varchar(20),
    academic_year int,
    started_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);

-- Part 5: Table Deletion and Cleanup
-- Task 5.1: Conditional Table Operations
DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale(
    grade_id serial primary key,
    letter_grade char(2),
    min_percentage numeric(3,1),
    max_percentage numeric(3,1),
    gpa_points numeric(3,2),
    description text
);
DROP TABLE IF EXISTS semester_calendar CASCADE;
CREATE TABLE semester_calendar(
    semester_id serial primary key,
    semester_name varchar(20),
    academic_year int,
    started_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);


UPDATE pg_database
   SET datistemplate = false
 WHERE datname = 'university_test';


DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup TEMPLATE university_main;

