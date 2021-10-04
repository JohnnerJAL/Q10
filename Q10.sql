# DDL
CREATE DATABASE `Q10` DEFAULT CHARACTER SET utf8mb4;
USE `Q10`;

CREATE TABLE `Q10`.`Users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `alias` VARCHAR(20) NOT NULL UNIQUE,
  `key` BIGINT NOT NULL,
  `birthday` TIMESTAMP,
  `createdOn` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `Q10`.`Categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `Q10`.`Tests` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` LONGTEXT,
  `createdOn` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `Categories_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Tests_Categories_idx` (`Categories_id` ASC) VISIBLE,
  CONSTRAINT `Tests_Categories`
    FOREIGN KEY (`Categories_id`)
    REFERENCES `Q10`.`Categories` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

CREATE TABLE `Q10`.`Levels` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `description` TEXT,
  `prize` INT NOT NULL,
  `lvl` INT NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `Q10`.`Games` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `createdOn` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `finishedOn` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Levels_id` INT UNSIGNED NOT NULL,
  `Users_id` INT UNSIGNED NOT NULL,
  `Tests_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Games_Levels_idx` (`Levels_id` ASC) VISIBLE,
  INDEX `Games_Users_idx` (`Users_id` ASC) VISIBLE,
  INDEX `Games_Tests_idx` (`Tests_id` ASC) VISIBLE,
  CONSTRAINT `Games_Levels`
    FOREIGN KEY (`Levels_id`)
    REFERENCES `Q10`.`Levels` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
  CONSTRAINT `Games_Users`
    FOREIGN KEY (`Users_id`)
    REFERENCES `Q10`.`Users` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
  CONSTRAINT `Games_Tests`
    FOREIGN KEY (`Tests_id`)
    REFERENCES `Q10`.`Tests` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

CREATE TABLE `Q10`.`Questions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `description` LONGTEXT NOT NULL,
  `Levels_id` INT UNSIGNED NOT NULL,
  `Tests_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Questions_Levels_idx` (`Levels_id` ASC) VISIBLE,
  INDEX `Questions_Tests_idx` (`Tests_id` ASC) VISIBLE,
  CONSTRAINT `Questions_Levels`
    FOREIGN KEY (`Levels_id`)
    REFERENCES `Q10`.`Levels` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
  CONSTRAINT `Questions_Tests`
    FOREIGN KEY (`Tests_id`)
    REFERENCES `Q10`.`Tests` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

CREATE TABLE `Q10`.`Answers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `description` LONGTEXT NOT NULL,
  `correct` BOOLEAN NOT NULL,
  `Questions_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Answers_Questions_idx` (`Questions_id` ASC) VISIBLE,
  CONSTRAINT `Answers_Questions`
    FOREIGN KEY (`Questions_id`)
    REFERENCES `Q10`.`Questions` (`id`)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

# TestData
INSERT INTO `Q10`.`Users`
  (`alias`,`key`, `birthday`, `createdOn`)
  VALUES
    ('jal', '1234', '1992-08-09', CURRENT_TIMESTAMP())
;

INSERT INTO `Q10`.`Categories`
  (`name`)
  VALUES
    ('Mathematics')
;

INSERT INTO `Q10`.`Tests`
  (`name`, `description`, `createdOn`, `Categories_id`)
  VALUES
    ('Quizz de matematicas', 'Quizz de operaciones matematicas', CURRENT_TIMESTAMP(), 1)
;

INSERT INTO `Q10`.`Levels`
  (`description`, `prize`, `lvl`)
  VALUES
    ('Base', 0, 0),
    ('First level', 100, 1),
    ('Second level', 200, 2),
    ('Third level', 300, 3),
    ('Fourth level', 400, 4),
    ('Fifth level', 500, 5)
;

INSERT INTO `Q10`.`Games`
  (`createdOn`, `finishedOn`, `Levels_id`, `Users_id`, `Tests_id`)
  VALUES
    ('2021-10-02', '2021-10-02 00:10:40', 1, 1, 1),
    ('2021-10-02 00:10:50', '2021-10-02 00:21:02', 3, 1, 1)
;

INSERT INTO `Q10`.`Questions`
  (`description`, `Levels_id`, `Tests_id`)
  VALUES
    ('¿Cuanto es 1 + 2*5/10?', '2', 1),
    ('¿Cuanto es 3*5/20?', '2', 1),
    ('¿Cuanto es 4/2 - 2?', '2', 1),
    ('¿Cuanto es 1/2 - 3/4?', '2', 1),
    ('¿Cuanto es 5/4 + 2*5/10?', '2', 1),
    ('¿Cuanto es 1/0?', '3', 1),
    ('¿Cuanto es -1/0?', '3', 1),
    ('¿Cuanto es 27/3 -0.4?', '3', 1),
    ('¿Cuanto es 32-2/5 + 5/10 -2.5?', '3', 1),
    ('¿Cuanto es 12-16/2 * 2?', '3', 1),
    ('¿Que es una derivada?', '4', 1),
    ('¿Que es una integral?', '4', 1),
    ('¿Como se define el algebra lineal?', '4', 1),
    ('¿Cual es el limite de 1/x cuando x tiende a 0?', '4', 1),
    ('¿Cual es el limite de 1/x cuanto x tiende a infinito?', '4', 1),
    ('Hay 5 estuches en la mesa. Cada uno contiene como mínimo 10 lápices y como máximo 14. ¿Cuál de estos podría ser el total de lápices?', '5', 1),
    ('Si X es menor que Y por una diferencia de 6 e Y es el doble de Z, ¿cuál es el valor de X cuando Z es igual a 2?', '5', 1),
    ('Si David tiene el doble de monedas de 5 céntimos que Tomás y Tomás tiene 15 monedas de 5 céntimos más que Juan, ¿cuántos euros tiene David si Juan tiene 6 monedas de cinco céntimos?', '5', 1),
    ('Lisa recibió un cheque regalo de 100 euros por su cumpleaños. Se compró unas deportivas que costaban 30 euros, un vestido de 23 euros y dos libros de 17 euros. ¿Cuánto dinero le quedó en el cheque regalo?', '5', 1),
    ('Cada estudiante puede elegir entre 4 tipos de sudadera y tres tipos de pantalones en su uniforme, ¿cuántas combinaciones posibles existen?', '5', 1),
    ('3 (x-4) = 18. ¿Cuál es el valor de X?', '6', 1),
    ('Cecilia, Roberto y Braulio han comprado sellos. El total de sellos de Cecilia es de un solo dígito. Solo uno de los chicos tiene un número de sellos divisible por tres. Solo uno ha adquirido un número de sellos par. ¿Cuál de estas respuestas puede indicar la cantidad correcta de sellos de cada uno?', '6', 1),
    ('Fran ha comprado varias cometas y cada una costaba 16 euros. Ricardo compró otras distintas y gastó 20 euros en cada una. Si el ratio en la cantidad de cometas entre las de Fran y las de Ricardo es de 3 a 2, ¿cuál es el coste medio de una cometa de las compradas por los dos?', '6', 1),
    ('4 x 4 - 4 + 4 x 4 = ¿...?', '6', 1),
    ('Si x+3= y, ¿cuánto es 2x + 6?', '6', 1)
;

INSERT INTO `Q10`.`Answers`
  (`description`, `correct`, `Questions_id`)
  VALUES
    ('1', false, 1),
    ('4', false, 1),
    ('3', false, 1),
    ('2', true, 1),
    ('0.2', false, 2),
    ('0.65', false, 2),
    ('0.9', false, 2),
    ('0.75', true, 2),
    ('1', false, 3),
    ('3', false, 3),
    ('4', false, 3),
    ('0', true, 3),
    ('1/4', false, 4),
    ('1/2', false, 4),
    ('-1/2', false, 4),
    ('-1/4', true, 4),
    ('3/2', false, 5),
    ('7/3', false, 5),
    ('-4/5', false, 5),
    ('9/4', true, 5),
    ('No se puede operar', false, 6),
    ('Indefinido', false, 6),
    ('1', false, 6),
    ('Infinito', true, 6),
    ('No se puede operar', false, 7),
    ('Indefinido', false, 7),
    ('-1', false, 7),
    ('- Infinito', true, 7),
    ('5', false, 8),
    ('4.4', false, 8),
    ('9.4', false, 8),
    ('8.6', true, 8),
    ('29', false, 9),
    ('5/10', false, 9),
    ('0', false, 9),
    ('29.6', true, 9),
    ('0', false, 10),
    ('19', false, 10),
    ('-12', false, 10),
    ('-4', true, 10),
    ('Es algo que esta a la deriva', false, 11),
    ('Representa el area bajo una curva', false, 11),
    ('Es la inversa del reciproco de un numero', false, 11),
    ('La derivada de una función en un punto es la pendiente de la recta tangente a dicha recta en dicho punto. Físicamente, miden la rapidez con la que cambia una variable con respecto a otra', true, 11),
    ('Es el inverso de un numero', false, 12),
    ('Es la pendiente de un recta', false, 12),
    ('Es cuando una persona es muy integral', false, 12),
    ('La integral es la operación inversa a la diferencial de una función. El cálculo integral, encuadrado en el cálculo infinitesimal, es una rama de las matemáticas en el proceso de integración o antiderivación.', true, 12),
    ('Es el algebra aplicada a geometria lineal', false, 13),
    ('Algebra con el que se representan lineas', false, 13),
    ('Es una rama de la fisica', false, 13),
    ('Matemáticas que estudia conceptos tales como vectores, matrices, espacio dual, sistemas de ecuaciones lineales', true, 13),
    ('El limite es indefinido', false, 14),
    ('El limite es 1', false, 14),
    ('El limite es cero', false, 14),
    ('El limite es infinito', true, 14),
    ('El limite es infinito', false, 15),
    ('El limite es 1', false, 15),
    ('El limite es indefinido', false, 15),
    ('El limite es cero', true, 15),
    ('45', false, 16),
    ('75', false, 16),
    ('35', false, 16),
    ('65', true, 16),
    ('5', false, 17),
    ('8', false, 17),
    ('10', false, 17),
    ('-2', true, 17),
    ('42', false, 18),
    ('21', false, 18),
    ('14', false, 18),
    ('2.1', true, 18),
    ('18', false, 19),
    ('45', false, 19),
    ('70', false, 19),
    ('13', true, 19),
    ('10', false, 20),
    ('24', false, 20),
    ('7', false, 20),
    ('12', true, 20),
    ('6', false, 21),
    ('14/3', false, 21),
    ('20/3', false, 21),
    ('10', true, 21),
    ('7 9 17', false, 22),
    ('6 9 12', false, 22),
    ('5 15 18', false, 22),
    ('9 10 13', true, 22),
    ('16.8', false, 23),
    ('18', false, 23),
    ('17.8', false, 23),
    ('17.6', true, 23),
    ('64', false, 24),
    ('-4', false, 24),
    ('-16', false, 24),
    ('28', true, 24),
    ('y', false, 25),
    ('No se puede determinar', false, 25),
    ('4y', false, 25),
    ('2Y', true, 25)
;

# Users
DELIMITER &&
CREATE PROCEDURE createUser(IN alias_in VARCHAR(20), IN key_in BIGINT, IN birthday_in TIMESTAMP)
BEGIN
INSERT INTO `Q10`.`Users`
  (`alias`, `key`, `birthday`)
  VALUES
    (alias_in, key_in, birthday_in);
END &&

# Games
DELIMITER &&
CREATE PROCEDURE createGame(IN Levels_id_in INT, IN Users_id_in INT, IN Tests_id_in INT)
BEGIN
INSERT INTO `Q10`.`Games`
  (`Levels_id`, `Users_id`, `Tests_id`)
  VALUES
    (Levels_id_in, Users_id_in, Tests_id_in);
END &&

DELIMITER &&
CREATE PROCEDURE updateGame(IN Games_id_in INT, IN Levels_id_in INT)
BEGIN
  UPDATE `Q10`.`Games`
  SET Levels_id = Levels_id_in
  WHERE Games_id = Games_id_in
  LIMIT 1;
END &&

# Tests
DELIMITER &&
CREATE PROCEDURE readTest(IN Tests_id_in INT)
BEGIN
  SELECT `T`.`name` AS `Test`, `T`.`description` AS `desTest`, `C`.`name` AS `Category`,
  `L`.`lvl`, `L`.`description` AS `desLvl`, `L`.`prize`, `Q`.`description` AS `Question`,
  `Q`.`id` AS `Q_id`, `A`.`description` AS `Option`, `A`.`correct`
  FROM `Q10`.`Answers` AS `A`
  INNER JOIN `Q10`.`Questions` AS `Q` ON `Q`.`id`=`A`.`Questions_id`
  INNER JOIN `Q10`.`Levels` AS `L` ON `L`.`id`=`Q`.`Levels_id`
  INNER JOIN `Q10`.`Tests` AS `T` ON `T`.`id`=`Q`.`Tests_id`
  INNER JOIN `Q10`.`Categories` AS `C` ON `C`.`id`=`T`.`Categories_id`
  WHERE `T`.`id` = Tests_id_in;
END &&