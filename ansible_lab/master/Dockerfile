# MASTER image - Luodaan hallinta kontti, MASTER

# käytetään ansible_base kuvaa (määritelty ../base/Dockerfile) lähtökohtana
FROM tjarvenpaa/ansible_base:latest

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
#RUN ssh-keygen -t rsa -N 12345 -C "master key" -f master_key
COPY master_key /root/.ssh/id_rsa
COPY master_key.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_rsa /root/.ssh/authorized_keys
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]