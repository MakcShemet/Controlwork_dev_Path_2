CREATE DATABASE `Друзья_человека`;
USE `Друзья_человека`;

DROP TABLE IF EXISTS main_classes;
CREATE TABLE main_classes (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
    ) COMMENT "Основные классы животных";
    
INSERT INTO `main_classes` (name) VALUES ("Домашние животные"), ("Вьючные животные");

DROP TABLE IF EXISTS animals_classes;
CREATE TABLE animals_classes (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    main_id INT NOT NULL,
    name_class VARCHAR(120) NOT NULL UNIQUE,
    
    FOREIGN KEY(main_id) REFERENCES main_classes(id)
    ) COMMENT "Подклассы животных";
    
INSERT INTO `animals_classes` (main_id, name_class) 
VALUES (1, "Собака"), (1, "Кошка"), (1, "Хомяк"), (2, "Лошадь"), (2, "Верблюд"), (2, "Осел");

Select * FROM animals_classes;

DROP TABLE IF EXISTS animals_list;
CREATE TABLE animals_list (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    animal_class_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    birthday DATE,
    
    FOREIGN KEY(animal_class_id) REFERENCES animals_classes(id)
) COMMENT "Реестр животных";

INSERT INTO `animals_list` (animal_class_id, name, birthday) VALUES 
(1, "Джек", "2018-01-23"), (1, "Белка", "2019-03-07"),
(2, "Барсик", "2020-11-03"), (2, "Багира", "2016-10-18"),
(3, "Тыква", "2022-02-13"), (3, "Хома", "2021-11-11"), 
(4, "Лорд", "2017-07-08"), (4, "Искра", "2015-06-02"),
(5, "Раджа", "2012-08-16"), (5, "Инди", "2022-07-17"),
(6, "Иа", "2022-09-01"), (6, "Юка", "2022-01-16");

Select * from animals_list;

DROP TABLE IF EXISTS commands_list;
CREATE TABLE commands_list (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    command_name VARCHAR(120) NOT NULL
);

INSERT INTO `commands_list` (command_name) VALUES 
("Идти"), ("Стоять"), ("Сидеть"), ("Лежать"), ("Голос"), ("Аппорт"),
("Лапу"), ("Ко мне");

DROP TABLE IF EXISTS animal_commands;
CREATE TABLE animal_commands (
	animal_id INT NOT NULL,
    command_id INT NOT NULL,
    
    FOREIGN KEY(animal_id) REFERENCES animals_list(id),
    FOREIGN KEY(command_id) REFERENCES commands_list(id)
);

INSERT INTO `animal_commands` (animal_id, command_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), 
(2, 4), (2, 5),(2, 6), (2, 7), (2, 8), (3, 3), (3, 4), (3, 5),
(4, 3), (4, 4), (4, 5), (5, 1), (5, 4), (6, 1), (6, 4), 
(7, 1), (7, 2), (7, 4), (8, 1), (8, 2), (8, 4),
(9, 1), (9, 2), (9, 4), (10, 1), (10, 2), (10, 4),
(11, 1), (11, 2), (11, 5), (12, 1), (12, 2), (12, 5);

DROP FUNCTION IF EXISTS delete_animal;
DELIMITER //
CREATE FUNCTION `delete_animal` (delete_animal_class INT)
RETURNS INT reads sql data
BEGIN
	DELETE animal_commands
    FROM animal_commands
    JOIN animals_list ON animals_list.id = animal_id
    WHERE animals_list.animal_class_id = delete_animal_class;
    
    DELETE
	FROM animals_list
    WHERE animal_class_id = delete_animal_class;
	    
RETURN delete_animal_class;
END//
DELIMITER ;

SELECT delete_animal(5) AS delete_animal;

SELECT * 
FROM animals_list 
ORDER BY id;


SELECT 
	animals_list.id as ID, 
	animals_classes.name_class as 'Подкласс животного', 
    animals_list.name as 'Имя', 
    animals_list.birthday as 'Дата рождения' 
FROM animals_list
JOIN animals_classes
	on (animal_class_id = animals_classes.id)
WHERE animal_class_id = 4 or animal_class_id = 6;

DROP TABLE IF EXISTS `Молодые животные`;
CREATE TABLE `Молодые животные` (
	Select *, TIMESTAMPDIFF(month, animals_list.birthday, CURRENT_DATE()) as `month`
    from animals_list
    WHERE TIMESTAMPDIFF(month, animals_list.birthday, CURRENT_DATE()) >= 12 and TIMESTAMPDIFF(month, animals_list.birthday, CURRENT_DATE()) < 36
);

SELECT *
FROM `Молодые животные`;

Select *
FROM animals_list
JOIN animals_classes
	on animals_classes.id = animals_list.animal_class_id
JOIN main_classes
	on animals_classes.main_id = main_classes.id
JOIN animal_commands
	on animal_id = animals_list.id
JOIN commands_list
	on commands_list.id = animal_commands.command_id;