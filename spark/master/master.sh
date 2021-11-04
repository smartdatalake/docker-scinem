#!/bin/bash

export SPARK_HOME=/opt/spark

# export SPARK_MASTER_HOST=`hostname`
export SPARK_MASTER_HOST=spark-master
export PYSPARK_PYTHON=python3


. "/opt/spark/sbin/spark-config.sh"

. "/opt/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_MASTER_LOG

ln -sf /dev/stdout $SPARK_MASTER_LOG/spark-master.out

cd /opt/spark/bin && /opt/spark/sbin/../bin/spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG/spark-master.out

