-- Student Records Database Management System
-- Created by: CHIEMEKE IZO
-- Date: 2024-01-15

-- Create the database
DROP DATABASE IF EXISTS student_management_system;
CREATE DATABASE student_management_system;
USE student_management_system;

-- Table: Departments
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(10) UNIQUE NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    department_head VARCHAR(100),
    established_date DATE,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table: Programs
CREATE TABLE Programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_code VARCHAR(10) UNIQUE NOT NULL,
    program_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    duration_years INT NOT NULL CHECK (duration_years BETWEEN 1 AND 6),
    total_credits INT NOT NULL,
    program_type ENUM('Undergraduate', 'Graduate', 'Doctorate', 'Diploma') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);

-- Table: Students
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    country VARCHAR(50) DEFAULT 'USA',
    enrollment_date DATE NOT NULL,
    graduation_date DATE,
    program_id INT NOT NULL,
    current_semester INT CHECK (current_semester BETWEEN 1 AND 12),
    status ENUM('Active', 'Inactive', 'Graduated', 'Suspended', 'Withdrawn') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES Programs(program_id) ON DELETE RESTRICT
);

-- Table: Faculty
CREATE TABLE Faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    office_location VARCHAR(50),
    office_hours TEXT,
    department_id INT NOT NULL,
    position ENUM('Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer', 'Instructor') NOT NULL,
    specialization VARCHAR(100),
    hire_date DATE NOT NULL,
    status ENUM('Active', 'Inactive', 'On Leave', 'Retired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);

-- Table: Courses
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    course_level ENUM('100', '200', '300', '400', '500', '600') NOT NULL,
    description TEXT,
    prerequisites TEXT,
    is_core BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);

-- Table: Classes (Many-to-Many between Courses and Faculty with additional attributes)
CREATE TABLE Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    faculty_id INT NOT NULL,
    semester ENUM('Fall', 'Spring', 'Summer') NOT NULL,
    academic_year YEAR NOT NULL,
    section VARCHAR(10) NOT NULL,
    class_schedule TEXT NOT NULL,
    classroom VARCHAR(50),
    max_capacity INT DEFAULT 30,
    current_enrollment INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_class (course_id, semester, academic_year, section),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE
);

-- Table: Enrollments (Many-to-Many between Students and Classes)
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    enrollment_status ENUM('Enrolled', 'Dropped', 'Completed', 'Withdrawn') DEFAULT 'Enrolled',
    final_grade VARCHAR(2) CHECK (final_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'W', 'I')),
    grade_points DECIMAL(3,2),
    attendance_percentage DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_enrollment (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE CASCADE
);

-- Table: Assignments
CREATE TABLE Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    assignment_name VARCHAR(100) NOT NULL,
    assignment_type ENUM('Homework', 'Quiz', 'Project', 'Exam', 'Presentation') NOT NULL,
    description TEXT,
    max_score DECIMAL(5,2) NOT NULL,
    due_date DATETIME NOT NULL,
    weight_percentage DECIMAL(5,2) NOT NULL CHECK (weight_percentage BETWEEN 0 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE CASCADE
);

-- Table: Grades
CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    assignment_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    submission_date DATETIME,
    feedback TEXT,
    is_late BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_grade (enrollment_id, assignment_id),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id) ON DELETE CASCADE
);

-- Table: Program_Courses (Many-to-Many between Programs and Courses)
CREATE TABLE Program_Courses (
    program_course_id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    course_id INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    recommended_semester INT CHECK (recommended_semester BETWEEN 1 AND 12),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_program_course (program_id, course_id),
    FOREIGN KEY (program_id) REFERENCES Programs(program_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Table: Financial_Records
CREATE TABLE Financial_Records (
    financial_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    transaction_type ENUM('Tuition', 'Fee', 'Payment', 'Refund', 'Scholarship') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    payment_method ENUM('Credit Card', 'Debit Card', 'Bank Transfer', 'Cash', 'Check') DEFAULT 'Credit Card',
    status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- Table: Attendance
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    class_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_attendance (enrollment_id, class_date),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_students_program ON Students(program_id);
CREATE INDEX idx_students_status ON Students(status);
CREATE INDEX idx_faculty_department ON Faculty(department_id);
CREATE INDEX idx_courses_department ON Courses(department_id);
CREATE INDEX idx_classes_course ON Classes(course_id);
CREATE INDEX idx_classes_faculty ON Classes(faculty_id);
CREATE INDEX idx_enrollments_student ON Enrollments(student_id);
CREATE INDEX idx_enrollments_class ON Enrollments(class_id);
CREATE INDEX idx_grades_enrollment ON Grades(enrollment_id);
CREATE INDEX idx_financial_student ON Financial_Records(student_id);
CREATE INDEX idx_attendance_enrollment ON Attendance(enrollment_id);

-- Insert sample data for demonstration
INSERT INTO Departments (department_code, department_name, department_head, established_date, contact_email, contact_phone)
VALUES 
('CS', 'Computer Science', 'Dr. John Smith', '2000-01-15', 'cs@university.edu', '555-0101'),
('MATH', 'Mathematics', 'Dr. Alice Johnson', '1995-08-20', 'math@university.edu', '555-0102'),
('PHYS', 'Physics', 'Dr. Robert Brown', '1998-03-10', 'physics@university.edu', '555-0103');

INSERT INTO Programs (program_code, program_name, department_id, duration_years, total_credits, program_type, description)
VALUES
('CS-BS', 'Bachelor of Science in Computer Science', 1, 4, 120, 'Undergraduate', 'Comprehensive computer science program'),
('MATH-BS', 'Bachelor of Science in Mathematics', 2, 4, 120, 'Undergraduate', 'Mathematics degree program'),
('PHYS-MS', 'Master of Science in Physics', 3, 2, 60, 'Graduate', 'Graduate physics program');

INSERT INTO Students (student_number, first_name, last_name, date_of_birth, gender, email, phone_number, address, city, state, zip_code, enrollment_date, program_id, current_semester, status)
VALUES
('S1001', 'Emily', 'Davis', '2002-05-15', 'Female', 'emily.davis@student.university.edu', '555-1001', '123 Main St', 'Boston', 'MA', '02115', '2023-09-01', 1, 2, 'Active'),
('S1002', 'Michael', 'Chen', '2001-08-22', 'Male', 'michael.chen@student.university.edu', '555-1002', '456 Oak Ave', 'Cambridge', 'MA', '02138', '2023-09-01', 1, 2, 'Active'),
('S1003', 'Sarah', 'Wilson', '2000-12-10', 'Female', 'sarah.wilson@student.university.edu', '555-1003', '789 Pine Rd', 'Boston', 'MA', '02116', '2022-09-01', 2, 4, 'Active');

INSERT INTO Faculty (faculty_number, first_name, last_name, date_of_birth, gender, email, phone_number, office_location, office_hours, department_id, position, specialization, hire_date)
VALUES
('F1001', 'David', 'Miller', '1975-03-15', 'Male', 'david.miller@university.edu', '555-2001', 'CS-101', 'MWF 10-12', 1, 'Professor', 'Artificial Intelligence', '2010-08-15'),
('F1002', 'Jennifer', 'Taylor', '1980-07-22', 'Female', 'jennifer.taylor@university.edu', '555-2002', 'MATH-201', 'TTh 2-4', 2, 'Associate Professor', 'Calculus', '2015-01-10'),
('F1003', 'Richard', 'Anderson', '1972-11-30', 'Male', 'richard.anderson@university.edu', '555-2003', 'PHYS-301', 'MW 3-5', 3, 'Professor', 'Quantum Mechanics', '2008-06-01');

INSERT INTO Courses (course_code, course_name, department_id, credits, course_level, description, is_core)
VALUES
('CS101', 'Introduction to Programming', 1, 4, '100', 'Fundamentals of programming using Python', TRUE),
('CS201', 'Data Structures', 1, 4, '200', 'Data structures and algorithms', TRUE),
('MATH101', 'Calculus I', 2, 4, '100', 'Differential calculus', TRUE),
('PHYS301', 'Quantum Physics', 3, 3, '300', 'Introduction to quantum mechanics', TRUE);

-- Insert sample program courses relationships
INSERT INTO Program_Courses (program_id, course_id, is_required, recommended_semester)
VALUES
(1, 1, TRUE, 1),
(1, 2, TRUE, 2),
(2, 3, TRUE, 1),
(3, 4, TRUE, 1);

-- Display success message
SELECT 'Student Management System database created successfully!' AS Message;
