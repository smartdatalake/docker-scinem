FROM adoptopenjdk:11-jre-hotspot


RUN apt update
RUN apt install default-jdk scala git wget software-properties-common jq build-essential autoconf libtool pkg-config -y

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update


# Get python Version 3.7
RUN apt install python3.7 python3.7-dev python3-pip -y
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1


################################# Make Spark ##########################################
RUN mkdir /spark
RUN cd /spark
# RUN wget https://mirror.klaus-uwe.me/apache/spark/spark-3.0.2/spark-3.0.2-bin-hadoop3.2.tgz
RUN wget https://mirror.klaus-uwe.me/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
RUN tar zxvf  spark-*
RUN mkdir /opt/spark
RUN mv spark-*/* /opt/spark
RUN echo "export SPARK_HOME=/opt/spark" >> ~/.profile
RUN echo "export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> ~/.profile
RUN echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.profile

ENV SPARK_HOME /opt/spark/
ENV PATH $PATH:$SPARK_HOME/bin



################################### Make Hadoop ########################################

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openjdk-8-jdk \
    net-tools \
    curl \
    netcat \
    gnupg \
    libsnappy-dev \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

RUN gpg --import KEYS

ENV HADOOP_VERSION 3.2.2
# ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_URL https://mirror.klaus-uwe.me/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_ASC https://downloads.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz.asc

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_ASC" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH
###########################################################################


RUN pip install pydoop
RUN pip install pandas pyspark
