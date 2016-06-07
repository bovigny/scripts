#!/bin/bash

AMBARI_USER='toto'
AMBARI_PASSWORD='toto1234'
AMBARI_HOST='daplab-wn-12.fri.lan'
CLUSTER_NAME='DAPLAB02'
MOVE_FROM='daplab-wn-34.fri.lan'
MOVE_TO='daplab-wn-32.fri.lan'

# Tell to ambari we want to install this component on new_host
curl -u $AMBARI_USER:$AMBARI_PASSWORD -H "X-Requested-By:ambari" -i -X POST http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/hosts/$MOVE_TO/host_components/JOURNALNODE

# Trigger installation
curl -u $AMBARI_USER:$AMBARI_PASSWORD -H "X-Requested-By:ambari" -i -X PUT -d '{"RequestInfo": {"context": "Install JournalNode","query":"HostRoles/component_name.in('JOURNALNODE')"}, "Body":{"HostRoles": {"state": "INSTALLED"}}}' http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/hosts/$MOVE_TO/host_components

# Start JournalNode on new host 
curl -u $AMBARI_USER:$AMBARI_PASSWORD -H "X-Requested-By:ambari" -i -X PUT -d '{"RequestInfo": {"context": "Start JournalNode","query":"HostRoles/component_name.in('JOURNALNODE')"}, "Body":{"HostRoles": {"state": "STARTED"}}}' http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/hosts/$MOVE_TO/host_components/JOURNALNODE

# Stop JournalNode on old host 
curl -u $AMBARI_USER:$AMBARI_PASSWORD -H "X-Requested-By:ambari" -i -X PUT -d '{"RequestInfo": {"context": "Stop JournalNode","query":"HostRoles/component_name.in('JOURNALNODE')"}, "Body":{"HostRoles": {"state": "INSTALLED"}}}' http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/hosts/$MOVE_FROM/host_components/JOURNALNODE

# Remove the old component
curl -u $AMBARI_USER:$AMBARI_PASSWORD -H "X-Requested-By:ambari" -i -X DELETE http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/hosts/$MOVE_FROM/host_components/JOURNALNODE
