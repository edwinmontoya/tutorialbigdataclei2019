# Tutorial big data clei 2019, Panamá
## Por: Edwin Montoya, Universidad EAFIT, Medellín-Colombia
## emontoya@eafit.edu.co

# Laboratorio HDFS

## ACTIVIDAD DE LA SEMANA:

### * Realizar el tutorial presente en este documento
### * Cargar datos al HDFS vía Ambari (algunos directorios y archivos)
### * Cargar datos al HDFS vía Terminal (todos los datasets a cada usuario)

## 1 CONECTARSE AL CLUSTER HORTONWORKS:

## Por Terminal o Ambari Web:

* con VPN terminal: 192.168.10.76 -p 2222 y ambari-web: 192.168.10.76:8080
* sin VPN terminal-web: https://hdp1shell.dis.eafit.edu.co y ambari-web: https://hdp1.dis.eafit.edu.co 

## 2. GESTIÓN DE ARCHIVOS EN HDFS VÍA TERMINAL

1. Cargar los datos de los datasets de trabajo del curso en HDFS 
2. Cada alumno creara en hdfs un directorio 'datasets' en su 'home'
3. En 'datasets' los archivos ya deben estar descomprimidos para ser procesables.
4. Datasets: [DATASETS](../datasets)

### Listar archivos HDFS

Para efectos de esta guia, es equivalente el comando "hadoop fs" y "hdfs dfs". La diferencia es que "hdfs dfs" es solo para sistemas de archivos HDFS, pero "hadoop fs" soporta otros adicionales como S3.

    user@master$ hdfs dfs -ls /
    user@master$ hdfs dfs -ls /user
    user@master$ hdfs dfs -ls /user/<username>
    user@master$ hdfs dfs -ls /datasets

### Crear tu propio directorio de 'datasets' en HDFS

    user@master$ hdfs dfs -mkdir /user/<username>/datasets

Nota: reemplace '<username>' por aca usuario asignado

### Copiar archivos locales (al servidor gateway) hacia HDFS

Se asume que tiene los datos LOCALES se encuentran en /datasets en el gateway
Tambien están en este github, y por terminal debería copiarlos por SSH/SCP al servidor Gateway por la VPN.

Lo podrá hacer desde su PC vía Ambari Web 


    user@master$ hdfs dfs -mkdir /user/<username>/datasets
    user@master$ hdfs dfs -mkdir /user/<username>/datasets/gutenberg-small

    user@master$ hdfs dfs -put /datasets/gutenberg/gutenberg-small.zip /user/<username>/datasets/

    (realmente los archivo .zip en hdfs no son procesables, deberán subir los archivos descomprimidos, como lo hacen?)

otro comando para copiar:

    Descomprima los datos .zip en un dir local (al GATEWAY), clone el repo.

    user@master$ cd ~$HOME/datasets/gutenberg/
    user@master$ unzip gutenberg-small.zip

    En general, descomprima todos los archivos del dataset que quiera procesar en Hadoop/Spark.
    
    user@master$ hdfs dfs -copyFromLocal /datasets/* /user/<username>/datasets/

listar archivos: 

    user@master$ hdfs dfs -ls /user/<username>/datasets
    user@master$ hdfs dfs -ls /user/<username>/datasets/gutenberg-small/

### Copiar archivos de HDFS hacia el servidor local (gateway)

    user@master$ hdfs dfs -get /user/<username>/datasets/gutenberg/gutenberg-small.zip ~<username>/mis_datasets/    (el directorio 'mis_datasets' debe estar creado)

otro comando para traer:

    user@master$ hdfs dfs -copyToLocal /user/<username>/datasets/gutenberg/gutenberg-small.zip ~<username>/mis_datasets/

    user@master$ ls -l mis_datasets

### Probar otros commandos

Se aplica los siguientes comandos a:

    user@master$ hdfs dfs -<command>

comandos:

    du <path>             uso de disco en bytes
    mv <src> <dest>       mover archive(s)
    cp <src> <dest>       copiar archivo(s)
    rm <path>             borrar archive(s)
    put <localSrc> <dest-hdfs> copiar local a hdfs
    cat <file-name>       mostrar contenido de archivo
    chmod [-R] mode       cambiar los permisos de un archivo
    chown <username> files   cambiar el dueño de un archivo
    chgrp <group> files      cambiar el grupo de un archivo

## 3. GESTIÓN DE ARCHIVOS VÍA HUE

* Login

![login](hue-hdfs/hue-01-login.png)

![filemenu](hue-hdfs/hue-02-Files.png)

* explorar archivos

![explorar](hue-hdfs/hue-03-FileBrowser.png)

* Crear un directorio

![Crear directorio](hue-hdfs/hue-04-FileNew.png)

![Crear directorio](hue-hdfs/hue-05-FileNewDir1.png)

![Crear directorio](hue-hdfs/hue-06-FileNewDir2.png)

* Subir (upload) archivos

![Subir archivos](hue-hdfs/hue-07-FileUpload1.png)

![Subir archivos](hue-hdfs/hue-08-FileUpload2.png)

![Subir archivos](hue-hdfs/hue-09-FileUpload3.png)

![Subir archivos](hue-hdfs/hue-10-FileBrowser.png)

* Ver contenido de un archivo

![Ver archivo](hue-hdfs/hue-11-FileOpen.png)