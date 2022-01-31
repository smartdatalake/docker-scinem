# Docker Deployment of SciNem #

"Minimal" wrapper for setting up SciNeM using a single Docker stack deployment. 


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

Prepare a Hadoop/Spark enabled image for the SciNeM environment:
```
cd sdl-docker-base
docker build -t smartdatalake/docker-base  .
cd ../
```

Build a SciNeM enabled Spark deployment which installs the relevant Python dependencies into the container: 

```
cd spark
./build.sh
cd ..
```

Make sure to run (we assume that SciNeM is in the parent directory, relative to this repository):

``` 
git clone --recursive https://github.com/schatzopoulos/SciNeM.git
cd ./SciNeM/
git submodule update --recursive --remote
```

The default configuration needs a few alternation, in order to work inside of the docker environment, copy the files from here, or adjust manually throughout:

```
cd <this-repo>
cp scinem/Constants.java ../SciNeM/src/main/java/athenarc/imsi/sdl/config/Constants.java  # To spcify the data locations
cp scinem/pom.xml ../SciNeM/ # To use the above created image as a base Docker image
cp scinem/.dockerignore ../SciNeM/ # Optional, but reduces the context slightly. 
```

Build a dockerized image of SciNem:
```
cd ../SciNeM
./mvnw -Dmaven.test.skip -Pprod verify jib:dockerBuild
```
Optionally, specify an custom temp folder with the `-Djava.io.tmpdir=` flag, using an absolute folder in the command above.

Point the ```docker-compose.yaml``` to the appropriate location for SciNeM-workflows.

**Make sure to adjust the memory and core commands (by editing the docker-compose.yaml under 'spot-app') accordingly to what the host is providing (check in Spark UI on port 8080) later on when Spark is running**

Prepare the sample data:

```
mkdir sample_data
cd sample_data
wget http://scinem.imsi.athenarc.gr/content/DBLP_sample.zip
unzip DBLP_sample.zip 
```

Create a folder to store the results:
```
mkdir results
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
docker exec -it SDL_scinem_app /bin/bash hadoop fs -fs hdfs://namenode:9000 -mkdir -p /data/SciNeM/SciNeM-data
docker exec -it SDL_scinem_app /bin/bash hadoop fs -fs hdfs://namenode:9000 -put /data/SciNeM/SciNeM-data /data/SciNeM/
```

### (Working) Sample Query ###
```
Author - Paper - Author, filtered for Paper.year > 2000
```

## Open Points ## 
- Streamline the dockerization of SciNem 
- Host the pre-built images in a repository
- Evaluate if the different Docker images may be further harmonized. Eventually, create one or a few slim versions.

## Notes ## 
- analysis.sh has been modified to reflect the dockerized Spark host as well as reduced the memory requirements of the worker to fit with the defaults
- Constants.java has been modified to reflect the dockerized hostnames. 


## Debugging ##
In case the UI fails, a given query can be debugged using:
```
docker exec -it SDL_scinem_app /bin/bash
bash /data/SciNeM/SciNeM-workflows/analysis/analysis.sh /data/SciNeM/SciNeM-results/<query hash>/config.json 

```
