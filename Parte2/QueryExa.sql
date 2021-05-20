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
 Values ((SELECT CarrierID from Carrier where CarrierID = 2),'AMBA ',15, 2), 
         ((SELECT CarrierID from Carrier where CarrierID = 2),'Bs as',19, 4), -- y Repetimos
         ((SELECT CarrierID from Carrier where CarrierID = 2),'Resto',55, 6);
   
 Insert Into Costos ( CarrierID, Zona,Costo,Tiempodentrega) 
 Values ((SELECT CarrierID from Carrier where CarrierID = 3),'AMBA',20, 1);
 
-- TABLA CANTIDAD DE ENVIOS
Insert Into CantDenvios ( Zona,Mes,Cenvios) -- Repetimos mismos procesos
 Values ('AMBA', 1, 40000),
		 ('Bs as', 1, 50000),
         ('Resto', 1, 60000);
         
Select * from Carrier ;
Select * from Costos ;
Select * from CantDenvios ;
         
/*  C o n t e s t a n d o       P r e g u n t a s    d e l      e x a m e n       */


-- Primera Pregunta
DELIMITER //
Create function Costo[ ID int]
return Int
BEGIN
declare done INT DEFAULT 0;
declare ViajesRea int
declare result varchar(4000);

declare cur CURSOR FOR SELECT Cenvios FROM CantDenvios WHERE CarrierID = ID;

declare CAP = SELECT Capacity FROM Carrier WHERE CarrierID = ID;
declare Cost = Select Costo from Costos WHERE 
declare Counter int
declare result float

set counter = 0;

S: While counter > select COUNT(Zona) from CantDenvios Do
   
   Set result = (CAP/)*Cost
   Set counter = counter++
   END While

END;
DELIMITER ;

