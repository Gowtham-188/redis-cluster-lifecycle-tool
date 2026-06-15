#!/bin/bash

INVENTORY="ansible/inventory/hosts.ini"

echo "Cluster State:"
ansible redis-node-1 -i $INVENTORY -m shell -a \
"redis-cli cluster info | grep cluster_state"

echo ""
echo "Node Details"

for node in redis-node-1 redis-node-2 redis-node-3 redis-node-4 redis-node-5 redis-node-6
do
  echo "--------------------------------"

  ansible $node -i $INVENTORY -m shell -a '
IP=$(hostname -I | cut -d" " -f1)
ROLE=$(redis-cli info replication | sed -n "s/^role://p" | xargs)
VERSION=$(redis-cli info server | sed -n "s/^redis_version://p" | xargs)
MEM=$(redis-cli info memory | sed -n "s/^used_memory_human://p" | xargs)

if [ "$ROLE" = "master" ]; then
  KEYS=$(redis-cli dbsize)
  echo "$IP:6379 [master] v$VERSION keys:$KEYS mem:$MEM"
else
  MASTER=$(redis-cli info replication | sed -n "s/^master_host://p" | xargs)
  echo "$IP:6379 [replica] v$VERSION replicating:$MASTER mem:$MEM"
fi
'
done
