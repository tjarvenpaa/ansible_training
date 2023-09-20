# HOST image - luodaan hallittavat kohde kontit

# käytetään itse käännettyä pohjakuvaa (määritelty ../base/Dockerfile) lähtökohtana
FROM ansible_base:latest

# Kopioidaan ajoscripti hostilta konttiin
COPY run.sh /var/

# Määritellään ajooikeudet kopioidulle scriptille
RUN chmod 755 /var/run.sh
