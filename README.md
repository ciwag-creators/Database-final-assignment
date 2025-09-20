This comprehensive database management system includes:

Database Structure:
12 well-structured tables with proper relationships

Auto-increment primary keys and appropriate data types

Comprehensive constraints (NOT NULL, UNIQUE, CHECK, ENUM types)


Key Relationships:
One-to-Many: Departments → Programs, Departments → Faculty, Programs → Students

Many-to-Many:

Programs ↔ Courses (via Program_Courses)

Students ↔ Classes (via Enrollments)

Courses ↔ Faculty (via Classes)


Features Included:
Student information and academic records

Faculty and department management

Course catalog and program requirements

Class scheduling and enrollment

Grade management and assignments

Attendance tracking

Financial records

Timestamps for auditing


Constraints Applied:
Primary and foreign key constraints

Unique constraints on critical fields

Check constraints for valid ranges

ENUM types for predefined values

Cascade delete where appropriate

The system is ready for use and includes sample data for demonstration purposes.

