#problem 1
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20))
RETURNS DOUBLE

BEGIN
	DECLARE e_count DOUBLE;
    SET e_count := (SELECT COUNT(employee_id)
	FROM employees e
	INNER JOIN addresses a
	ON e.address_id = a.address_id
	INNER JOIN towns t
	ON a.town_id = t.town_id
	WHERE t.name = town_name);
    RETURN e_count;
END

#problem 2
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(20)) 
BEGIN
UPDATE employees e
JOIN departments d
ON e.`department_id` = d.`department_id`
SET e.`salary` = e.`salary` * 1.05
WHERE d.`name` = department_name;
END

#problem 3
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	START TRANSACTION;
    IF ((SELECT COUNT(employee_id)
		FROM employees
        WHERE employee_id like id) <> 1)
        THEN
        ROLLBACK;
	ELSE
		UPDATE employees
        SET salary = salary * 1.05
        WHERE employee_id LIKE id;
        COMMIT;
	END IF;
END

#problem 4
CREATE TABLE deleted_employees(
	`employee_id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
    `middle_name` VARCHAR(50),
    `job_title` VARCHAR(50),
    `department_id` INT,
    `salary` DOUBLE,
    PRIMARY KEY (`employee_id`)
);

CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees(`first_name`, `last_name`,
									`middle_name`, `job_title`,
									`department_id`, `salary`)
	VALUES (OLD.`first_name`, OLD.`last_name`,
			OLD.`middle_name`, OLD.`job_title`,
			OLD.`department_id`, OLD.`salary`);
END;

