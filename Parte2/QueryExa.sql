/* Ejercicio de SQL Mercado Libre

Comenzamos creando la base de datos con el que trabajaremos
*/ 
Drop database IF exists DBPRUEBA; -- Linea que borra la base de datos si existe
CREATE database IF NOT exists DBPRUEBA; -- Linea que crea la base de datos si no existe

use DBPRUEBA; -- Seleccionamos  la base de datos

create table Carrier( -- Creamos la table Carrier
CarrierID int  primary  key auto_increment not null, -- El campo Carrier es nuestro Primary key
Name varchar(20) not null ,
Capacity int not null
);

create table Costos( -- tabla Costo
CarrierID int not null , -- Es el Foreign key
Zona Varchar(20), 
Costo float not null,
Tiempodentrega int not null,
FOREIGN KEY (CarrierID ) REFERENCES Carrier(CarrierID)
on delete CASCADE -- Query que ejecuta una accion al BORRAR un valor 
on update no action -- Query que ejecuta una accion al ACTUALIZAR un valor
);

create table CantDenvios ( -- tabla de Cantidad de Envios
Zona Varchar(10)  not null ,
Mes int not null ,
CEnvios int not null -- cantidad de envios
);

  
  /*Muy Bien pasamos a completar las tablas con los datos*/
  
  -- tabla  Carrier 
  insert INTO Carrier  (Name , Capacity) 
  Values ('Carrier A' , 10000), 
         ('Carrier B' , 10000),
         ('Carrier C' , 3000);
  

-- TABLA COSTOS
 Insert Into Costos ( CarrierID, Zona,Costo,Tiempodentrega) 
 Values ((SELECT CarrierID from Carrier where CarrierID = 1),'AMBA',10, 3),  -- En el VALUES SELECCIONAMOS el foreign key para llenar los campos
         ((SELECT CarrierID from Carrier where CarrierID = 1),'Bs as',20, 5),
         ((SELECT CarrierID from Carrier where CarrierID = 1),'Resto',50, 7);
 
  Insert Into Costos ( CarrierID, Zona,Costo,Tiempodentrega) 
 Values ((SELECT CarrierID from Carrier where CarrierID = 2),'AMBA',15, 2), 
         ((SELECT CarrierID from Carrier where CarrierID = 2),'Bs as',19, 4), -- y Repetimos
         ((SELECT CarrierID from Carrier where CarrierID = 2),'Resto',55, 6);
   
 Insert Into Costos ( CarrierID, Zona,Costo,Tiempodentrega) 
 Values ((SELECT CarrierID from Carrier where CarrierID = 3),'AMBA',20, 1);
 
-- TABLA CANTIDAD DE ENVIOS
Insert Into CantDenvios ( Zona,Mes,Cenvios) -- Repetimos mismos procesos
 Values ('AMBA', 1, 40000),
		 ('Bs as', 1, 50000),
         ('Resto', 1, 60000);
         
Select * from Carrier ; -- Visualizamos cada una de las tablas
Select * from Costos ;
Select * from CantDenvios ;
         
/*  C o n t e s t a n d o       P r e g u n t a s    d e l      e x a m e n       */


-- Primera Pregunta


 DELIMITER $$
 
CREATE PROCEDURE CostoTotal (ID INT) -- Creamos un Store Procedure, Pedimos el parametro ID para ver el coste de cada carrier
 
begin -- Iniciamos el metodo
 
   INSERT Into CostoEn (Capacidad,Costo,Total) values -- Insertamos los valores 
 ( (SELECT Capacity FROM Carrier WHERE CarrierID = ID) , (SELECT Costo FROM Costos Where CarrierID =ID and Zona = 'AMBA'), null),
 ((SELECT Capacity FROM Carrier WHERE CarrierID = ID), (SELECT Costo FROM Costos Where CarrierID =ID and Zona = 'Bs as'), null),
 ((SELECT Capacity FROM Carrier WHERE CarrierID = ID), (SELECT Costo FROM Costos Where CarrierID =ID and Zona = 'Resto'), null);

SELECT * FROM CostoEn;
END$$
DELIMITER ;

drop table IF exists CostoEn; -- Borramos la tabla para cada vez que queramos consultar los precio de cada carrier
Create  TABLE CostoEn (ID int primary key auto_increment,Capacidad INT, Costo INT, Total INT); -- creamos la tabla
 
DROP TRIGGER IF EXISTS multiplica_campo -- Borramos el Trigger 

 DELIMITER $$
 
CREATE
   TRIGGER multiplicar BEFORE INSERT
    ON CostoEn
    FOR EACH ROW 
    BEGIN
     SET new.Total = new.Capacidad * new.Costo;  -- El trigger es una accion que se dispara al momento de insertar un campo en la tabla CostoEN
    END$$ -- En este caso multiplicamos los campos para obtener el total 
DELIMITER ;


CALL CostoTotal(2); -- LLamamos el Store Procedure y enviamos como INPUT el ID del carrier al que queremos calcular
Select Sum(Total) from CostoEn -- Total de Gasto para cada Carrier
