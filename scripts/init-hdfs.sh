  hdfs-init:
    <<: *hadoop-common
    container_name: hdfs-init
    restart: "no"
    depends_on:
      - namenode
      - datanode1
      - datanode2
      - datanode3
    entrypoint: ["/bin/bash", "-c"]
    command: >
      export HADOOP_HOME=/opt/hadoop &&
      export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin &&
      echo 'Waiting for HDFS...' &&
      until hdfs dfsadmin -report >/dev/null 2>&1; do
        echo 'HDFS not ready yet...';
        sleep 5;
      done &&
      hdfs dfs -mkdir -p /user/hive/warehouse || true &&
      hdfs dfs -mkdir -p /tmp/hive || true &&
      hdfs dfs -chmod -R 777 /user || true &&
      hdfs dfs -chmod -R 777 /tmp || true &&
      echo 'HDFS INIT DONE'
    environment:
      <<: *common-env