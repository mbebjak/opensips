#!/bin/bash
# creates a database with openserdbctl and deletes it again

# Needs a mysql database, the root user password must be given
# in the file 'dbrootpw'

if [ ! -f dbrootpw ] ; then
	echo "no root password, not run"
	exit 0
fi ;

source dbrootpw

tmp_name=""$RANDOM"_openserdb_tmp"

cd ../scripts

# setup config file
cp openserctlrc openserctlrc.bak
sed -i "s/# SIP_DOMAIN=openser.org/SIP_DOMAIN=sip.localhost/g" openserctlrc
sed -i "s/# DBENGINE=MYSQL/DBENGINE=MYSQL/g" openserctlrc
sed -i "s/# INSTALL_EXTRA_TABLES=ask/INSTALL_EXTRA_TABLES=yes/g" openserctlrc
sed -i "s/# INSTALL_PRESENCE_TABLES=ask/INSTALL_PRESENCE_TABLES=yes/g" openserctlrc
sed -i "s/# INSTALL_SERWEB_TABLES=ask/INSTALL_SERWEB_TABLES=yes/g" openserctlrc

# set the mysql root password
cp openserdbctl.mysql openserdbctl.mysql.bak
sed -i "s/#PW=""/PW="$PW"/g" openserdbctl.mysql

./openserdbctl create $tmp_name > /dev/null
ret=$?

if [ "$ret" -eq 0 ] ; then
	./openserdbctl drop $tmp_name > /dev/null
	ret=$?
fi ;

# cleanup
mv openserctlrc.bak openserctlrc
cp openserdbctl.mysql.bak openserdbctl.mysql

cd ../test
exit $ret