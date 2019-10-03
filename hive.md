CREATE EXTERNAL TABLE docs (line STRING) STORED AS TEXTFILE LOCATION 's3://emontoyapublic/datasets/gutenberg-small/'

SELECT word, count(1) AS count FROM (SELECT explode(split(line,' ')) AS word FROM docs) w GROUP BY word ORDER BY count DESC LIMIT 10


// wordcount en scala
import sqlContext.implicits._
val linesDF = sc.textFile("s3://emontoyapublic/datasets/gutenberg-small/").toDF("line")
val wordsDF = linesDF.explode("line","word")((line: String) => line.split(" "))
val wordCountDF = wordsDF.groupBy("word").count()
// cualquiera de las 2 siguientes formas:
//wordCountDF.orderBy($"count".desc).show(10)
wordCountDF.sort($"count".desc).show(10)



%pyspark
input_file = sc.textFile("s3://emontoyapublic/datasets/gutenberg-small/")
map = input_file.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1))
counts = map.reduceByKey(lambda a, b: a + b)
output = counts.sortBy(lambda a: -a[1])
for (w, c) in output.take(10):
        print (w, c)
output.coalesce(1).saveAsTextFile("/tmp/salida11")

import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/retail_db --username=retail_dba --password=retail_dba --warehouse-dir=/tmp/retail_db -m 1 --mysql-delimiters


import-all-tables --connect jdbc:mysql://database-1.cj1yhistqein.us-east-2.rds.amazonaws.com:3306/cursodb --username=curso --password=curso --warehouse-dir=/tmp/cursodb -m 1 --mysql-delimiters
