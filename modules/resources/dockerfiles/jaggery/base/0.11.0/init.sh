#!/usr/bin/env bash
# ------------------------------------------------------------------------
#
# Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
#   WSO2 Inc. licenses this file to you under the Apache License,
#   Version 2.0 (the "License"); you may not use this file except
#   in compliance with the License.
#   You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing,
#   software distributed under the License is distributed on an
#   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#   KIND, either express or implied.  See the License for the
#   specific language governing permissions and limitations
#   under the License.
#
# ------------------------------------------------------------------------

#remove default java opts
CARBON_HOME_DIR="/home/wso2user/wso2as-5.3.0"

sed -i '/-Xms256m/d' $CARBON_HOME_DIR/bin/wso2server.sh

sed -i "/port=\"9763\"/a    proxyPort=\"80\"" $CARBON_HOME_DIR/repository/conf/tomcat/catalina-server.xml
sed -i "/port=\"9443\"/a    proxyPort=\"443\"" $CARBON_HOME_DIR/repository/conf/tomcat/catalina-server.xml
sed -i '/<WebContextRoot>/c\\t<WebContextRoot>/as</WebContextRoot>' $CARBON_HOME_DIR/repository/conf/carbon.xml

#Changing admin password
if [ -z ${ADMIN_PASSWORD+x} ]; then
    echo "ADMIN_PASSWORD is not set.";
    echo "Generating admin password.";
    ADMIN_PASSWORD=${ADMIN_PASS:-$(pwgen -s 12 1)}
    echo "========================================================================="
    echo "Credentials for the instance:"
    echo
    echo "    user name: admin"
    echo "    password : $ADMIN_PASSWORD"
    echo "========================================================================="
    sed -i "s/.*<Password>admin<\/Password>.*/<Password>$ADMIN_PASSWORD<\/Password>/" $CARBON_HOME_DIR/repository/conf/user-mgt.xml
else
    echo "ADMIN_PASSWORD set by user.";
fi

#Remove bundles from plugins dir and the bundles.info to minimize jaggery runtime
PLUGINS_DIR_PATH="$CARBON_HOME_DIR/repository/components/plugins/"
DEFAULT_PROFILE_BUNDLES_INFO_FILE="$CARBON_HOME_DIR/repository/components/default/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info"
LIST_OF_BUNDLES_FILE="removed-bundles.txt"

while read in; do rm -rf "$PLUGINS_DIR_PATH""$in" && sed -i "/$in/d" "$DEFAULT_PROFILE_BUNDLES_INFO_FILE"; done < $LIST_OF_BUNDLES_FILE

#Remove sample
rm -rf $CARBON_HOME_DIR/repository/deployment/server/axis2services/*
rm -rf $CARBON_HOME_DIR/repository/deployment/server/webapps/*

#Calculate max heap size and the perm size for Java Opts
#Check whether TOTAL_MEMORY env variable defined or and not empty
if [[ $TOTAL_MEMORY && ${TOTAL_MEMORY-_} ]]; then
    let MAX_HEAP_SIZE=$TOTAL_MEMORY/2
    let PERM_SIZE=$TOTAL_MEMORY/8
    JAVA_OPTS="-Xms128m -Xmx"$MAX_HEAP_SIZE"m -XX:PermSize="$PERM_SIZE"m"
    export JAVA_OPTS=$JAVA_OPTS
fi

$CARBON_HOME_DIR/bin/wso2server.sh
