# MASTER image - Luodaan hallinta kontti, MASTER

# käytetään itse käännettyä ansible_base kuvaa (määritelty ../base/Dockerfile) lähtökohtana
FROM ansible_base:latest

# asennetaan viimeisin ansible
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
    ansible 

# kopioidaan esimerkkiscriptit
COPY ansible /var/ans/

# vaihdetaan working directory volumelle
WORKDIR /var/ans

# Luodaan RSA avain pari SSH kommunikaatiota varten 
# Määritellään privaattiavaimelle salasana '12345', älä käytä tuotannossa 
RUN ssh-keygen -t rsa -N 12345 -C "master key" -f master_key