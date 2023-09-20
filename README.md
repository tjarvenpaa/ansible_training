# Ansible_training - Intro

Tämän labran tarkoituksena on asettaa [Ansible](https://www.ansible.com/)-koulutusympäristö [Docker](https://www.docker.com/)-konttien avulla. Tämän labran päätyttyä sinulla on Docker-pääkontti, joka voi hallita viittä isäntäkonttia (voit helposti laajentaa hallittujen isäntien määrää tarpeitasi vastaavaksi).

Miksi Docker kontteja perinteisen virtualisoinnin, kuten [VirtualBoxin](https://www.virtualbox.org), sijasta? Docker kontit kuluttavat paljon vähemmän resursseja, joten voit rakentaa suurempia testiympäristöjä kannettavalle tietokoneellesi. Docker-säilön käynnistäminen / sammuttaminen on paljon nopeampaa kuin tavallisen virtuaalikoneen, joka mahdollistaa nopean uudelleenkäynnistys tapahtuman asetuksien muutoksen yhteydessä. Käytin [Docker Compose](https://docs.docker.com/compose/overview/) -sovellusta laboratorion asennuksen automatisoimiseksi jotta ympäristössä kutakin säiliötä ei tarvitse muodostaa erikseen. 
Tämä ei ole Ansible- tai Docker-opetusohjelma (vaikka selitän joitain peruskäsitteitä). Tarkoituksena on yksinomaan laboratorioympäristön asettaminen, jotta kokeet voidaan tehdä paikallisella koneella.

**TÄRKEÄÄ**: Tämän labran seuraamiseksi sinun on asennettava Docker CE (Community Edition) ympäristöösi. Asennus on dokumentoitu hyvin [Docker käyttööotto oppaassa](https://docs.docker.com/engine/installation/#supported-platforms), eikä näin ole oleellinen tämän työn ohjeeksi. Lyhyt kuvaus Ansible ja Docker ympäristöistä :

## Ansible
Ansible on IT-automaatiojärjestelmä. Se käsittelee kokoonpanon hallintaa, sovellusten käyttöönottoa, pilvien tarjoamista, tapauskohtaista tehtävien suorittamista ja moniodista orkestrointia - mukaan lukien trivialisoivat asiat, kuten ns. zero downtime rolling updates with load balancers. Voit lukea lisää osoitteesta [www.ansible.com](https://www.ansible.com/)

Ansible getting started ohje löytyy [täältä](https://docs.ansible.com/ansible/latest/getting_started/index.html)

## Docker
Docker on maailman johtava ohjelmistokonttialusta. Kehittäjät käyttävät Dockeria "toimii minun ympäristössäni" -ongelmien poistamiseksi. Operaattorit käyttävät Dockeria ohjaamaan ja hallitsemaan sovelluksia vierekkäin eristetyissä ajoympäristöissä (isolated containers) paremman laskentatiheyden saamiseksi. Yritykset käyttävät Dockeria rakentaakseen ketteriä ohjelmistojen toimitusputkia uusien  ominaisuudet nopeampaan, turvallisempaan ja luotettavaan tuottamiseen molemmille Linuxille sekä Windows Server ja Linux-on-mainframe-sovelluksille. Voit lukea lisää osoitteesta [www.docker.com](https://www.docker.com/)

# Aloitus

## Cloonaan repo

Kloonaan tämä git repository omalle koneellsi:

`git clone https://github.com/tjarvenpaa/ansible_training.git`

## Luo paikalliset imaget ja aja labra ylös

Siirry hakemistoon **ansible_lab** joka sisältää [docker-compose.yml](./ansible_lab/docker-compose.yml) tiedoston:

`cd ansible_lab`

Käännä docker kuvat ja aja labra pystyyn taustalle (labran rakenne on kuvattau [docker-compose.yml](./ansible_lab/docker-compose.yml) tiedostossa.):

`docker compose up -d --build`

Ota yhteyttä muodostuneeseen **master node** konttiin:

`docker exec -it master01 bash`

Varmista verkon toiminta ja  yhteydet master kontin ja hallinnoitavien host konttien välillä:

`for i in host01 host02 host03 host04 host05; do ping -c 2 $i; done`

Käynnistä [SSH Agent](https://man.openbsd.org/ssh-agent) **master nodella** jotta yksinkertaistetaan ssh avaimen käyttöä:

`ssh-agent bash`

Lataa käyttöön private key SSH Agentille, jolloin yhteydet voidaan muodostaa ilman salasanojen syöttöä:

`ssh-add master_key`

    Syötä avain master_keytä varten:
käytä **passphrase** syötteenä: `12345`

Oletusavaimen voit vaihtaa [ansible_lab/master/Dockerfile](./ansible_lab/master/Dockerfile)

## Ansible playbook esimerkit

Testaa ansible ympäristön toimivuus ajamalla ping pyyntö host koneille. Käytä playbookia [ping_all](./ansible_lab/master/ansible/ping_all.yml):

`ansible-playbook -i inventory ping_all.yml`

Hyväksy kaikki uudet yhteydet syötämällä sana `yes` viidesti:

    ECDSA key fingerprint is SHA256:OEv0LxgWG0qaHKDKYfnqESJWJSHIRQYx/nJML0wNJaE.
    Are you sure you want to continue connecting (yes/no)?

Asennetaan php web **inventory ryhmälle**:

Jotta hostien käsittely olisi helppoa, määritellään ansible työkalulle host [ryhmiä](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html).

Esimerkkinä tästä on php asennus [playbook](./ansible_lab/master/ansible/install_php.yml):

`ansible-playbook -i inventory install_php.yml`

Asennetaan [Nginx](https://www.nginx.org/) palvelin nginx ryhmälle:

Esimerkki asentaa nginx palvelimen hosteille 04 ja 05, ottaa käyttöön kustomoidun webbisivuston ja siellä index.html sisällön.

Ajetaan playbook [install_nginx.yml](./ansible_lab/master/ansible/install_nginx.yml):

`ansible-playbook -i inventory install_nginx.yml`

Playbook suorittaa useita toimintoa, joista ensimmäinen tarkistaa on nginx asennettu, ja asentaa jollei ole. Tämän jälkeen nginx käynnistetään, kopioidaan ja otetaan käyttöön uusi site konfiguraatio ja kopioidaan sivuston sisältö palvelimelle.

Toiminnallisuuden voi tarkistaa kontista selvittämällä auenneen portin:

`docker ps`

Tämän tuottaa listauksen järjestelmässä ajossa olevista konteista

    CONTAINER ID   IMAGE                           COMMAND               CREATED          STATUS          PORTS                                                      NAMES
    d0ee6b73dfa4   ansible_host                    "/var/run.sh"         18 minutes ago   Up 18 minutes   0.0.0.0:43831->80/tcp                                      host04
    96599c91d6c3   ansible_host                    "/var/run.sh"         18 minutes ago   Up 18 minutes   0.0.0.0:43832->80/tcp                                      host05
    263608f9756c   ansible_host                    "/var/run.sh"         18 minutes ago   Up 18 minutes                                                              host03
    6d10bffd0215   ansible_host                    "/var/run.sh"         18 minutes ago   Up 18 minutes                                                              host02
    b5f7b4f3e899   ansible_host                    "/var/run.sh"         18 minutes ago   Up 18 minutes                                                              host01
    1e2ce146187e   ansible_master                  "/usr/sbin/sshd -D"   18 minutes ago   Up 18 minutes                                                              master01

Näistä host04 ja host05 ovat saaneet avoimet localhost portit 43831 ja 43832. Webbipalvelimen voi siis käydä tarkistamassa linux komentorivillä käskyllä:

`curl http://localhost:43831`

Jos teet työtä Windows ympäristössä esim. wsl2 koneella, voit myös käyttää graafista selainta osoitteessa `http://localhost:43831`
Muutoin webpalvelin vastaa linux koneen ip:ssä, eli host koneelta.
## Labran päättäminen

Kun olet saanut labran tehtyä, tai haluat aloittaa alusta, voi ympäristön tuhota seuraavilla komennoilla:

Konttien pysäyttäminen:

`docker compose kill`

Voi myös hallitusti ajaa alas ympäristön käyttämällä:

`docker compose down`

Konttien poistaminen järjestelmästä:

`docker compose rm`

Tallennussijainin, volumen poistaminen:

`docker volume rm ansible_lab_ansible_vol`

Ja jos tahdot poistaa Docker kuvat (imaget), joskin tämä ei ole tarpeellista labran käynnistämiksi 'puhtaana':

`docker rmi ansible_host ansible_master ansible_base`

