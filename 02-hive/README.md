# Tutorial big data CLEI 2019, Panamá
## Por: Edwin Montoya, Universidad EAFIT, Medellín-Colombia
## emontoya@eafit.edu.co

# HIVE

## TABLAS SENCILLAS EN HIVE

## 1. Conexión al cluster Hadoop via HUE

Hue Web

    http://emr1.emontoya.ml:8888
    

Usuarios: (entrar como admin/Clei2019* y crear cada uno su usuario)

    username: admin
    password: Clei2019*

## 2. Los archivos de trabajo hdi-data.csv y export-data.csv

```
/user/<username>/datasets/onu
```

## 3. Gestión (DDL) y Consultas (DQL)

### cada uno deberá crear su propia BD:

    CREATE DATABASE mybd

### Crear la tabla HDI en Hive:
```
use mydb;
CREATE TABLE HDI (id INT, country STRING, hdi FLOAT, lifeex INT, mysch INT, eysch INT, gni INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/<username>/datasets/onu/hdi-data.csv';
```

Nota: Esta tabla la crea en una BASE DE DATOS 'mydb'
```
use mydb;
show tables;
describe hdi;
```

### hacer consultas y cálculos sobre la tabla HDI:
```
select * from hdi;

select country, gni from hdi where gni > 2000;    
```

### EJECUTAR UN JOIN CON HIVE:

### Obtener los datos base: export-data.csv

usar los datos en 'datasets' de este repositorio.

### Iniciar hive y crear la tabla EXPO:

```
use mydb;
CREATE TABLE EXPO (country STRING, expct FLOAT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/<username>/datasets/onu/export-data.csv';
```

### EJECUTAR EL JOIN DE 2 TABLAS:
```
SELECT h.country, gni, expct FROM HDI h JOIN EXPO e ON (h.country = e.country) WHERE gni > 2000;
```


### WORDCOUNT EN HIVE:
```
use <MYDB>;
CREATE EXTERNAL TABLE docs (line STRING) STORED AS TEXTFILE LOCATION '/user/<username>/datasets/gutenberg-small/';
--- alternativa2:
CREATE EXTERNAL TABLE docs (line STRING) STORED AS TEXTFILE LOCATION 's3://emontoyapublic/datasets/gutenberg-small/';
```

// ordenado por palabra
```
SELECT word, count(1) AS count FROM (SELECT explode(split(line,' ')) AS word FROM docs) w GROUP BY word ORDER BY word DESC LIMIT 10;
```
// ordenado por frecuencia de menor a mayor
```
SELECT word, count(1) AS count FROM (SELECT explode(split(line,' ')) AS word FROM docs) w GROUP BY word ORDER BY count DESC LIMIT 10;
```

### RETO:

¿cómo llenar una tabla con los resultados de un Query? por ejemplo, como almacenar en una tabla el diccionario de frecuencia de palabras en el wordcount?

# Apache Sqoop

## Datos en MySQL

```
En database-1.cj1yhistqein.us-east-2.rds.amazonaws.com, se tiene Mysql con:
Base de datos: “cursodb”
Tabla: “employee” (ya existe una table llamada 'employee')
User: curso/curso
$ mysql –u curso -h database-1.cj1yhistqein.us-east-2.rds.amazonaws.com –p
Enter password: ******
mysql> use cursodb;

Base de datos: “retail_db”
Tabla: <varias>
User: retail_dba/retail_dba
$ mysql –u retail_dba -h database-1.cj1yhistqein.us-east-2.rds.amazonaws.com –p
Enter password: ******
mysql> use retail_db;


```

## Comandos Sqoop

//Transferir datos de una base de datos (tipo mysql) hacia HDFS:
```
$ sqoop import --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/cursodb --username curso -P --table employee --target-dir /user/<username>/mysqlOut -m 1
```

// listar archivos:
```
$ hdfs dfs -ls /user/username/mysqlOut
```

// Crear tabla HIVE a partir de definición tabla Mysql:
```
$ sqoop create-hive-table --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/cursodb --username curso -P --table employee --hive-database mydbhive --hive-table employee -m 1--mysql-delimiters
```

// Transferir datos de una base de datos (tipo mysql) hacia HIVE vía HDFS:

```
$ sqoop import --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/cursodb --username curso -P --table employee --hive-import --hive-database mydbhive --hive-table employee -m 1 --mysql-delimiters
```

// Transferir todas las tablas de una base de datos (tipo mysql) hacia HIVE vía HDFS:

```
sqoop import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --warehouse-dir /tmp/mysqlOut1 --mysql-delimiters -m 1

sqoop import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --warehouse-dir=/tmp/mysqlOut1 --hive-import --mysql-delimiters -m 1 

sqoop import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --hive-database mydbhive --create-hive-table --warehouse-dir=/tmp/mysqlOut1 --hive-import --mysql-delimiters -m 1 

sqoop import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --hive-database mydbhive --hive-overwrite --warehouse-dir=/tmp/mysqlOut1 --hive-import --mysql-delimiters -m 1 
```


// Poblar o llenar la tabla Hive Manualmente:
```
$ beeline
> use <username>;
> CREATE TABLE username_emps (empid INT, name  STRING, salary INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n' STORED AS TEXTFILE;
>
```
// Cargar datos a Hive Manualmente:
```
> load data inpath '/user/username/mysqlOut/part-m-00000' into table database.username_emps;
OK                          
> select * from username_emps;
OK
101 name1 1800
102 name2 1500
103 name3 1000
104 name4 2000
105 name5 1600
taken: 0.269 seconds, Fetched: 5 row(s) Time
> 
```

//Sqoop export hacia mysql:

// Crear una Tabla 'username_employee2' en Mysql con los mismos atributos de 'username_employee'
```
mysql> USE cursodb;
mysql> CREATE TABLE username_employee2 (  emp_id INT NOT NULL,  name VARCHAR(45),  salary INT,  PRIMARY KEY (emp_id));
```

// Asumiendo datos separados por ”,” en HDFS en:

/user/username/mysql_in/*

```
$ sqoop export --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/cursodb --username curso -P --table username_employee2 --export-dir /user/username/mysqlOut
```

## MySQL vs Hive

### consulta hecha en MySQL de Promedio de salario de Empleados:

    $ mysql -u -h database-1.cj1yhistqein.us-east-2.rds.amazonaws.com curso -p
    password: curso
    mysql> use cursodb;
    mysql> select AVG(salary) from employee;
    +-------------+                                                                    
    | AVG(salary) |                                                                    
    +-------------+                                                                    
    |   1580.0000 |                                                                    
    +-------------+                                                                    
    1 row in set (0.00 sec)                                                            
                                                                                   
    mysql>

### consulta hecha en HIVE de Promedio de salario de Empleados:

    Via HUE-Web> 

    # crear la tabla externa:

    use mydbhive;

    create external table employee (emp_id int, name string, salary float) 
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','  
    LINES TERMINATED BY '\n' 
    STORED AS textfile;

    select * from employee;

    select AVG(salary) from employee;