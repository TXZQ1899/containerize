for id in $(seq 1 3); \
do \
   docker stop mysql-${id} 
   docker rm mysql-${id} 
done
