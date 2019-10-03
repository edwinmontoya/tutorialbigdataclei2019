$ mysql -u admin -h localhost -p <pass>

CREATE DATABASE cursodb;
USE cursodb;
CREATE TABLE `cursodb`.`employee` (  `emp_id` INT NOT NULL,  `name` VARCHAR(45),  `salary` INT,  PRIMARY KEY (`emp_id`));
CREATE USER 'curso'@'%' IDENTIFIED BY 'curso';
GRANT ALL PRIVILEGES ON cursodb.* TO 'curso'@'%';

