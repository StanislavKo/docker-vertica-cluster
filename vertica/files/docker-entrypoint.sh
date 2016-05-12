#!/bin/bash
set -e

/usr/sbin/sshd

export this_ip=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }') 

# Vertica should be shut down properly
function shut_down() {
  echo "Shutting Down"
  gosu dbadmin /opt/vertica/bin/admintools -t stop_db -d user01schema -i
  exit
}

trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

chown -R dbadmin:verticadba "$VERTICADATA"

function get_host_ip() {
  cluster_nodes=`getent hosts $1 | awk '{ print $1 }'`
  cluster_nodes_array=($cluster_nodes)
  cluster_node=${cluster_nodes_array[0]}
  eval "$2='$cluster_node'";
}

if [[ $1 = "-cluster" || $2 = "-cluster" ]]; then
  get_host_ip "vertica2" cluster_node2
  get_host_ip "vertica3" cluster_node3
  sleep 10;
  echo "Vertica is installing"
  /opt/vertica/sbin/install_vertica --license CE --accept-eula --hosts $this_ip,$cluster_node2,$cluster_node3 --dba-user-password-disabled --failure-threshold NONE --no-system-configuration --ssh-password root
  echo "Creating database"
  gosu dbadmin /opt/vertica/bin/admintools -t create_db --hosts $this_ip,$cluster_node2,$cluster_node3 -d user01schema -c /home/dbadmin/user01db/catalog -D /home/dbadmin/user01db/data
  echo "Database created"
  /opt/vertica/bin/vsql -f "/home/dbadmin/create_user01schema.sql" --host $cluster_node2 -U dbadmin
  echo "Schema created"

#  /opt/vertica/packages/kafka/bin/vkconfig shutdown
#  echo "kafka integration 01"
#  /opt/vertica/packages/kafka/bin/vkconfig scheduler --add --config-schema myKafkaScheduler --username dbadmin --password dbadmin --operator user01 --brokers kafka1:9092,kafka2:9092
#  echo "kafka integration 02"
#  /opt/vertica/packages/kafka/bin/vkconfig topic --add --target storm_kafka_vertica.kafka_tgt --username dbadmin --password dbadmin --rejection-table storm_kafka_vertica.kafka_rej --parser KafkaJSONParser --topic test-topic --config-schema myKafkaScheduler
#  echo "kafka integration 03"
#  /opt/vertica/packages/kafka/bin/vkconfig launch --username dbadmin --password dbadmin --config-schema myKafkaScheduler --instance-name myKafkaScheduler &
#  sleep 30;
#  echo "kafka integration 04"
fi
if [[ $1 = "-mc" || $2 = "-mc" ]]; then
  dpkg -i /tmp/vertica-console.deb
  echo "Vertica MC is installed"
fi

while true; do
  sleep 1
done


