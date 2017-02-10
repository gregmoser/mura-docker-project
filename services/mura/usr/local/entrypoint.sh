#!/bin/bash

LUCEEPASS=${LUCEE_PASSWORD}

#LUCEESERVERSALT=$(uuidgen)
#LUCEESERVERSALT=${LUCEESERVERSALT^^}
LUCEESERVERSALT='4FDA588E-318A-445C-898736AA1F229A69'

#LUCEEWEBSALT=$(uuidgen)
#LUCEEWEBSALT=${LUCEEWEBSALT^^}
LUCEEWEBSALT='12FB74C3-69CD-4348-A839A29127ED8B7C'

LUCEESERVERPASS=$LUCEEPASS:$LUCEESERVERSALT
LUCEEWEBPASS=$LUCEEPASS:$LUCEEWEBSALT

for i in `seq 1 5`;
do
	LUCEESERVERPASS=($(echo -n $LUCEESERVERPASS | sha256sum))
	LUCEEWEBPASS=($(echo -n $LUCEEWEBPASS | sha256sum))
done

##### UPDATE LUCEE CONFIG FILES #####
# Update Lucee Server Admin Password
sed -i "s/\${SERVER-HSPW}/$LUCEESERVERPASS/g" /opt/lucee/server/lucee-server/context/lucee-server.xml
sed -i "s/\${SERVER-HSPW-SALT}/$LUCEESERVERSALT/g" /opt/lucee/server/lucee-server/context/lucee-server.xml

# Update Lucee Datasource Information
sed -i "s/\${MYSQL_USERNAME}/${MYSQL_USERNAME}/g" /opt/lucee/server/lucee-server/context/lucee-server.xml
sed -i "s/\${MYSQL_PASSWORD}/${MYSQL_PASSWORD}/g" /opt/lucee/server/lucee-server/context/lucee-server.xml
sed -i "s/\${MYSQL_HOST}/${MYSQL_HOST}/g" /opt/lucee/server/lucee-server/context/lucee-server.xml
sed -i "s/\${MYSQL_PORT}/${MYSQL_PORT}/g" /opt/lucee/server/lucee-server/context/lucee-server.xml
sed -i "s/\${MYSQL_DATABASE}/${MYSQL_DATABASE}/g" /opt/lucee/server/lucee-server/context/lucee-server.xml

# Update Lucee Web Admin Password
sed -i "s/\${WEB-HSPW}/$LUCEEWEBPASS/g" /opt/lucee/web/lucee-web.xml.cfm
sed -i "s/\${WEB-HSPW-SALT}/$LUCEEWEBSALT/g" /opt/lucee/web/lucee-web.xml.cfm

# Import key $ certificate into PKCS12 keystore
openssl pkcs12 -export -in /var/ssl_certs/55ff649a6cf963e3.crt -inkey /var/ssl_certs/mareacoffee.com.key -out /var/ssl_certs/tomcat.keystore -name tomcat -CAfile /var/ssl_certs/gd_bundle-g2-g1.crt -caname root -chain -password pass:securekeys

exec "$@"
