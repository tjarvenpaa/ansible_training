#!/bin/bash

# lisätään public key rootille, joka mahdollistaa SSH yhteydet MASTER kontista ilman salasanaa
cat /var/ans/master_key.pub >> /root/.ssh/authorized_keys

# käynnistetään SSH palvelin
/usr/sbin/sshd -D
