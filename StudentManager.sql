CREATE DATABASE StudentManager;
USE StudentManager;

-- create table
CREATE TABLE Department(
	departmentId VARCHAR(10) PRIMARY KEY,
    departmentName VARCHAR(30),
    location VARCHAR(30)
    );


CREATE TABLE Class(
	classId VARCHAR(10) PRIMARY KEY,
    className VARCHAR(30),
    numberOfStudents INT,
    departmentId VARCHAR(10),
	CONSTRAINT FK_Class_Department FOREIGN KEY(departmentId)
		REFERENCES Department(departmentId)
    );
    
CREATE TABLE Student(
	studentId VARCHAR(10) PRIMARY KEY,
    fullName VARCHAR(30),
    birthday DATE,
    gender VARCHAR(10),
    classId VARCHAR(10),
    CONSTRAINT FK_Student_Class FOREIGN KEY(classId)
		REFERENCES Class(classId)
	);
    
-- insert data
INSERT INTO Department VALUES
('D001','Information Technology','A5'),
('D002','Electrical','A4'),
('D003','Law','A1');

INSERT INTO Class VALUES
('C001','Information System', 70, 'D001'),
('C002','Economic law', 65, 'D003'),
('C003','Thermal engineering', 70, 'D002');

INSERT INTO Student VALUES
('S001','Nguyen Van A', '2003-09-01','Nam','C001'),
('S002','Nguyen Thi B', '2003-07-01','Nu','C001'),
('S003','Nguyen Van C', '2003-08-01','Nam','C002'),
('S004','Nguyen Thi D', '2003-09-11','Nu','C001'),
('S005','Nguyen Van E', '2003-10-23','Nam','C002'),
('S006','Nguyen Van F', '2003-09-12','Nam','C003');

SELECT * FROM Department;
SELECT * FROM Class;
SELECT * FROM Student;

delimiter //
CREATE PROCEDURE insertStudent(
	IN studentId VARCHAR(10),
    IN fullName VARCHAR(30),
    IN birthday DATE,
    IN gender VARCHAR(10),
    IN classId VARCHAR(10),
    INOUT test INT
    
    )
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    -- DECLARE CONTINUE HANDLER FOR 1062
	BEGIN
-- 		SELECT CONCAT('Duplicate key(',studentId,',',fullName,',',birthday,',',gender,',',classId,')') AS message;
        -- SET test = 1;
    END;
	IF birthday > CURDATE() THEN
    SELECT 1 AS error_code, CONCAT('Birthday not invalid!!') AS error_message;
    SET test = 1;
    ELSE 
		INSERT INTO Student 
        VALUES(studentId, fullName,birthday, gender,classId);
        SELECT 0 AS error_code, CONCAT('Insert completed!!') AS message;
        
        SET test = 1;
	END IF;
END//
DELIMITER ;

DROP PROCEDURE insertStudent;

SET @test = 2;
CALL insertStudent('S0012', 'Nguyen Van H', '2022-09-01', 'Nam', 'C003', @test);
SELECT @test AS error_code;

SHOW PROCEDURE STATUS LIKE '%Student';


-- function
DELIMITER //
CREATE FUNCTION FindStudentById(
	id VARCHAR(10)
    )
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
	DECLARE studentFullName VARCHAR(30);
    SET StudentFullName = (SELECT fullName FROM Student WHERE Student.studentId = id);
    RETURN StudentFullName;
END//
DELIMITER ;

DROP FUNCTION FindStudentById;
SELECT FINDSTUDENTBYID('S005');


SET GLOBAL log_bin_trust_function_creators = 0;
DELIMITER //
CREATE FUNCTION RandomStudent(
	)
RETURNS VARCHAR(30)
NOT DETERMINISTIC
BEGIN
    DECLARE randomFullName VARCHAR(30);
    SELECT fullName INTO randomFullName
    FROM Student
    ORDER BY RAND()
    LIMIT 1;
    RETURN randomFullName;
END//
DELIMITER ;


SELECT RANDOMSTUDENT();




-- Trigger
DELIMITER //
CREATE TRIGGER before_Student_Update
BEFORE UPDATE ON Student
FOR EACH ROW
BEGIN
	IF OLD.studentId <> NEW.studentId THEN
		BEGIN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Do not change the column';
        END;
	ELSEIF OLD.classId <> NEW.classId THEN
    
		UPDATE Class
        SET numberOfStudents = numberOfStudents - 1
        WHERE classId = OLD.classId;


        UPDATE Class
        SET numberOfStudents = numberOfStudents + 1
        WHERE classId = NEW.classId;
	END IF;
END//
DELIMITER ;

DROP TRIGGER before_Student_Update;

UPDATE Student
SET classId = 'C003'
WHERE studentId = 'S001';

UPDATE Student
SET studentId = 'S0020'
WHERE studentId = 'S003';

delimiter \\
Create trigger before_Student_Insert
before insert on Student
for each row
begin
	declare currentNumberOfClass int;
    select numberOfStudents into currentNumberOfClass
    from Class
    where New.classId = Class.classId;
    if currentNumberOfClass >= 70 then
		signal sqlstate '45000'
        set message_text = 'The class has reached its size limit';
	end if;
end\\
delimiter ;

-- drop trigger before_Student_Insert;
select * from Student;
select * from Class;
INSERT INTO Student VALUES('S0022','Nguyen Van A', '2003-09-01','Nam','C001');


DELIMITER \\
CREATE TRIGGER after_Student_Insert
AFTER INSERT ON Student
FOR EACH ROW
FOLLOWS before_Student_Insert
BEGIN
    -- Tìm lớp mà học sinh mới vừa được chèn vào
    DECLARE newClassId VARCHAR(10);
    SET newClassId = NEW.classId;
    
    -- Tăng số lượng học sinh trong lớp tương ứng
    UPDATE Class
    SET numberOfStudents = numberOfStudents + 1
    WHERE classId = newClassId;
END \\
DELIMITER ;


drop trigger after_Student_Insert;

SELECT 
    trigger_name, 
    action_order
FROM
    information_schema.triggers
WHERE
    trigger_schema = 'studentmanager'
ORDER BY 
    event_object_table , 
    action_timing , 
    event_manipulation;
    
Show triggers from studentmanager;





	



	


 



    
