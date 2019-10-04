# Tutorial big data CLEI 2019, Panamá
## Por: Edwin Montoya, Universidad EAFIT, Medellín-Colombia
## emontoya@eafit.edu.co


# abre zeppelin y crea tu propio notebook:

    http://emr1.emontoya.ml:8888
    
## card1:

// wordcount en scala
val linesDF = sc.textFile("s3://emontoyapublic/datasets/gutenberg-small/").toDF("line")
val wordsDF = linesDF.explode("line","word")((line: String) => line.split(" "))
val wordCountDF = wordsDF.groupBy("word").count()
// cualquiera de las 2 siguientes formas:
//wordCountDF.orderBy($"count".desc).show(10)
wordCountDF.sort($"count".desc).show(10)

## card2:

%pyspark
input_file = sc.textFile("s3://emontoyapublic/datasets/gutenberg-small/")
map = input_file.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1))
counts = map.reduceByKey(lambda a, b: a + b)
output = counts.sortBy(lambda a: -a[1])
for (w, c) in output.take(10):
        print (w, c)
output.coalesce(1).saveAsTextFile("/tmp/salida11")

## card3:

%sql
show databases

## card4:

%sql
use mydbhive

## card5:

%sql
SELECT word, count(1) AS count FROM (SELECT explode(split(line,' ')) AS word FROM docs) w GROUP BY word ORDER BY count DESC LIMIT 10
