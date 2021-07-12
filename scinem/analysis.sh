#!/bin/bash
cd "$(dirname "$0")"
config="$1"

function clean_exit() {
# 	hadoop dfs -rm -r `cat "$config" | jq -r .hdfs_out_dir` > /dev/null
	exit $1
}

# performs HIN transformation and ranking (if needed)
# spark-submit --master local[*] --conf spark.sql.shuffle.partitions=32 --driver-memory=40G --packages graphframes:graphframes:0.8.0-spark3.0-s_2.12 --py-files=../hminer/sources.zip ../hminer/Hminer.py "$config"
spark-submit \
 --master spark://spark-master:7077 \
 --conf spark.sql.shuffle.partitions=120 \
 --executor-cores 6 \
 --total-executor-cores 60 \
 --executor-memory 6G \
 --num-executors 8 \
 --packages graphframes:graphframes:0.8.0-spark3.0-s_2.12 \
 --py-files=../hminer/sources.zip ../hminer/Hminer.py "$config"
ret_val=$?
if [ $ret_val -ne 0 ]; then
   	echo "Error: HIN Transformation"
   	clean_exit $ret_val
fi

analyses=`cat "$config" | jq -r .analyses`

# format ranking ouput
if [[ " ${analyses[@]} " =~ "Ranking" ]]; then
	ranking_out=`cat "$config" | jq -r .ranking_out`
	ranking_final=`cat "$config" | jq -r .final_ranking_out`

	if ! python3 ../add_names.py -c "$config" "Ranking" "$ranking_out" "$ranking_final"; then 
         echo "Error: Finding node names in Ranking output"
         clean_exit 2
	fi
fi

if [[ " ${analyses[@]} " =~ "Similarity Join" ]]; then

#	# find hin folder from json config 
#	join_hin=`cat "$config" | jq -r .join_hin_out`
#	local_hin=`cat "$config" | jq -r .local_out_dir`/LOCAL_HIN
	
#	# copy HIN file from hdfs
#	hadoop dfs -copyToLocal "$join_hin/part-"* "$local_hin"
	
#	if ! java -Xmx40G -jar ../similarity/EntitySimilarity-1.0-SNAPSHOT.jar -c "$config" "Similarity Join" "$local_hin"; then
#	        echo "Error: Similarity Join"
#	        clean_exit 2
#	fi
#	rm "$local_hin"
	
	if ! python3 ../similarity/add_names_sim.py -c "$config" "Similarity Join"; then 
         echo "Error: Finding node names in Similarity Join output"
         clean_exit 2
	fi
fi

if [[ " ${analyses[@]} " =~ "Similarity Search" ]]; then

#	# find hin folder from json config 
#	join_hin=`cat "$config" | jq -r .join_hin_out`
#	local_hin=`cat "$config" | jq -r .local_out_dir`/LOCAL_HIN
	
#	# copy HIN file from hdfs
#	hadoop dfs -copyToLocal "$join_hin/part-"* "$local_hin"
	
#	if ! java -Xmx40G -jar ../similarity/EntitySimilarity-1.0-SNAPSHOT.jar -c "$config" "Similarity Search" "$local_hin"; then
#	        echo "Error: Similarity Search"
#	        clean_exit 2
#	fi
	
#	rm "$local_hin"
	
	if ! python3 ../similarity/add_names_sim.py -c "$config" "Similarity Search"; then 
         echo "Error: Finding node names in Similarity Search output"
         clean_exit 2
	fi
fi
	
# perform Community Detection
if [[ " ${analyses[@]} " =~ "Community Detection" ]]; then

	# find hin folder from json config 
# 	hin=`cat "$config" | jq -r .hin_out`
	communities_out=`cat "$config" | jq -r .communities_out`
	final_communities_out=`cat "$config" | jq -r .final_communities_out`
# 	local_hin=`cat "$config" | jq -r .local_out_dir`/LOCAL_HIN
	
# 	current_dir=`pwd`

# 	# call community detection algorithm
# 	cd ../louvain/

# 	if ! bash ./bin/louvain -m "local[8]" -p 8 -i "$hin/part-"* -o "$communities_out" 2>/dev/null; then
# 		echo "Error: Community Detection"
# 		clean_exit 3
# 	fi
		
# 	cd $current_dir

	if ! python3 ../add_names.py -c "$config" "Community Detection" "$communities_out" "$final_communities_out"; then 
         echo "Error: Finding node names in Community Detection output"
         clean_exit 2
	fi
fi

# both ranking & community detection have been executed, merge their results
if [[ " ${analyses[@]} " =~ "Ranking - Community Detection" ]]; then

	if ! python3 ../merge_results.py -c "$config"; then 
         echo "Error: Combining Ranking with Community Detection"
         clean_exit 2
	fi
fi

clean_exit 0