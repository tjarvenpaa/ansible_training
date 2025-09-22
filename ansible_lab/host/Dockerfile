# HOST image - luodaan hallittavat kohde kontit

# käytetään itse käännettyä pohjakuvaa (määritelty ../base/Dockerfile) lähtökohtana
FROM tjarvenpaa/ansible_base:latest

# Kopioidaan ajoscripti hostilta konttiin
COPY run.sh /var/
COPY master_key.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && service ssh restart

# Määritellään ajooikeudet kopioidulle scriptille
RUN chmod 755 /var/run.sh

