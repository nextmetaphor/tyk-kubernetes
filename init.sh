#!/usr/bin/env bash

TYK_DASHBOARD_USERNAME="admin@test.com"
TYK_DASHBOARD_PASSWORD="admin123"
DOCKER_IP=`minikube ip`


echo "Creating Organisation"
ORG_DATA=$(curl --silent --header "admin-auth: 12345" --header "Content-Type:application/json" --data '{"owner_name": "TestOrg5 Ltd.","owner_slug": "testorg", "cname_enabled":true}' http://$DOCKER_IP:30001/admin/organisations 2>&1)
ORG_ID=$(echo $ORG_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Meta"]')
echo "ORG ID: $ORG_ID"

echo "Adding new user"
USER_DATA=$(curl --silent --header "admin-auth: 12345" --header "Content-Type:application/json" --data '{"first_name": "John","last_name": "Smith","email_address": "'$TYK_DASHBOARD_USERNAME'","active": true,"org_id": "'$ORG_ID'"}' http://$DOCKER_IP:30001/admin/users 2>&1)
USER_AUTH=$(echo $USER_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Message"]')
USER_LIST=$(curl --silent --header "authorization: $USER_AUTH" http://$DOCKER_IP:30001/api/users 2>&1)
USER_ID=$(echo $USER_LIST | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["users"][0]["id"]')
echo "USER AUTH: $USER_AUTH"
echo "USER ID: $USER_ID"

echo "Setting password"
OK=$(curl --silent --header "authorization: $USER_AUTH" --header "Content-Type:application/json" http://$DOCKER_IP:30001/api/users/$USER_ID/actions/reset --data '{"new_password":"'$TYK_DASHBOARD_PASSWORD'"}')