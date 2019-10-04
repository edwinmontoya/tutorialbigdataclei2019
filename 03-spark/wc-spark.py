from pyspark import SparkContext
import sys

sc = SparkContext("yarn", "Simple WC")

inputdir = "hdfs:///user/<username>/datasets/gutenberg-small/*.txt"
outputdir = "hdfs:///tmp/misalida"

text_file = sc.textFile(inputdir)
counts = text_file.flatMap(lambda line: line.split(" ")) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b)
# multiples archivos de salida    
# counts.saveAsTextFile(outputdir)
# un solo archivo de salida:
counts.coalesce(1).saveAsTextFile(outputdir)