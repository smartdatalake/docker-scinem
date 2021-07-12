# Docker Deployment of SciNem #

"Minimal" wrapper for setting up SciNeM using a single Docker stack deployment. 

Work in progress

# Getting started

In this readme, we brifely go through;
- creating a SciNem enabled dockerized Spark environment
- dockerizing the SciNeM application and adding the relevant Python dependencies
- configuring the sample data
- running the SciNeM stack



Get this repository
```
git clone https://github.com/smartdatalake/docker-scinem
```

Build a SciNeM enabled Spark deployment which installs the relevant Python dependencies into the container: 

```
cd spark
./build.sh
```

Checkout the official SciNeM repository (see instructions here https://github.com/schatzopoulos/SciNeM), and apply the following changes, which are needed to ensure that the various hosts are changed to their dockerized equivalents:


```
cd <this-repo>
cp scinem/Constants.java <path-to-scinem-repo>/src/main/java/athenarc/imsi/sdl/config/Constants.java
cp scinem/Dockerfile <path-to-scinem-repo>/Dockerfile
cp scinem/anaylsis.sh <path-to-scinem-repo>/libs/SciNeM-workflows/analysis/analysis.sh
```

and follow the original build instructions, followed by:

```
cd <path-to-repo>
docker build -t smartdatalake/my_app  # Or whatever name you prefer, just replace it in the docker-compose file as well. 
```

The second build command installs the Python dependences as well as adding the Hadoop and Spark binaries. 

Link or copy SciNeM-workflows to ```./libs/SciNeM-workflows``` (or point the ```docker-compose.yaml``` to the appropriate location.)

```
ln -s ../SciNeM/libs ./libs
```

Prepare the sample data:
 

```
mkdir sample_data
cd sample_data
wget http://scinem.imsi.athenarc.gr/content/DBLP_sample.zip
unzip DBLP_sample.zip 
```

Modify the ```docker-compose.yaml``` volume configurations according to the local setup. In order to test out with the sample data provided by Athena, the pre-configured local structure may be applied. Generally, the configuration can stay as is. 



Finally, start the full stack with

```
cd <this-repo>
docker-compose up 
```



Now the SciNeM UI is available on <host/IP>:8181

If everything is running, then the sample data needs to be loaded into HDFS:
```
docker exec -it SDL_app /bin/bash
hadoop fs -fs hdfs://namenode:9000 -put /data /

```


## Open Points ## 
- Streamline the dockerization of SciNem 
- Host the pre-built images in a repository

## Notes ## 
- analysis.sh has been modified to reflect the dockerized Spark host as well as reduced the memory requirements of the worker to fit with the defaults
- Constants.java has been modified to reflect the dockerized hostnames. 


## Debugging ##
In case the UI fails, a given query can be debugged using:
```
docker exec -it SDL_app /bin/bash
 bash /data/SciNeM/SciNeM-workflows/analysis/analysis.sh /data/SciNeM/SciNeM-results/<query hash>/config.json 

```