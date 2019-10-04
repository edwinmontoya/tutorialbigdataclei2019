# Tutorial big data CLEI 2019, Panamá
## Por: Edwin Montoya, Universidad EAFIT, Medellín-Colombia
## emontoya@eafit.edu.co

#
-- Scripts de HIVE
#

-- datos de conexión:

Mysql
host: database-1.cj1yhistqein.us-east-2.rds.amazonaws.com
Database: retail_db
Username: retail_dba
Password: retail_dba

-- importar datos via sqoop por Terminal:

$ sqoop import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --hive-database retail_db --hive-overwrite --hive-import --warehouse-dir=/tmp/retail_dbtmp -m 1 --mysql-delimiters

-- importar datos via sqoop por HUE:

import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --hive-database retail_db --hive-overwrite --hive-import --warehouse-dir=/tmp/retail_dbtmp -m 1 --mysql-delimiters

-- CATEGORIAS MÁS POPULARES DE PRODUCTOS

SELECT c.category_name, count(order_item_quantity) as count
FROM order_items oi
inner join products p on oi.order_item_product_id = p.product_id
inner join categories c on c.category_id = p.product_category_id
group by c.category_name
order by count desc
limit 10

-- top 10 de productos que generan ganancias

SELECT p.product_id, p.product_name, r.revenue
FROM products p inner join
(select oi.order_item_product_id, sum(cast(oi.order_item_subtotal as float)) as revenue
from order_items oi inner join orders o
on oi.order_item_order_id = o.order_id
where o.order_status <> 'CANCELED'
and o.order_status <> 'SUSPECTED_FRAUD'
group by order_item_product_id) r
on p.product_id = r.order_item_product_id
order by r.revenue desc
limit 10

-- SUBIR LOS LOGS AL HDFS:
$ hdfs dfs -put datasets/retail_logs/access.log /user/<username>/datasets/retail_logs/

USE <username>;
CREATE EXTERNAL TABLE tmp_access_logs (
        ip STRING,
        fecha STRING,
        method STRING,
        url STRING,
        http_version STRING,
        code1 STRING,
        code2 STRING,
        dash STRING,
        user_agent STRING)
    ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
    WITH SERDEPROPERTIES (
        'input.regex' = '([^ ]*) - - \\[([^\\]]*)\\] "([^\ ]*) ([^\ ]*) ([^\ ]*)" (\\d*) (\\d*) "([^"]*)" "([^"]*)"',
        'output.format.string' = "%1$$s %2$$s %3$$s %4$$s %5$$s %6$$s %7$$s %8$$s %9$$s")
    LOCATION '/user/<username>/datasets/retail_logs/';

-- CREAR DIRECTORIO PARA TABLA EXTERNA CON ETL

$ hdfs dfs -mkdir /user/<username>/warehouse/access_logs_etl

CREATE EXTERNAL TABLE etl_access_logs (
        ip STRING,
        fecha STRING,
        method STRING,
        url STRING,
        http_version STRING,
        code1 STRING,
        code2 STRING,
        dash STRING,
        user_agent STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/user/<username>/warehouse/access_logs_etl/';


ADD JAR /usr/lib/hive/lib/hive-contrib.jar;

INSERT OVERWRITE TABLE etl_access_logs SELECT * FROM tmp_access_logs;

--- MUESTRE LOS PRODUCTOS MÁS VISITADOS

SELECT count(*) as contador,url FROM etl_access_logs
WHERE url LIKE '%\/product\/%'
GROUP BY url ORDER BY contador DESC LIMIT 10;