# Apache2-palvelimen käyttöönotto Ansiblella

Tämä playbook asentaa Apache2-palvelimen, määrittää uuden virtuaalihostin ja julkaisee webbisivun kyseiselle hostille.

## Playbookin vaiheet

1. **Apache2-palvelimen asennus**
   - Asentaa `apache2`-paketin.
   - Varmistaa, että palvelu on käynnissä ja käynnistyy automaattisesti.

2. **Virtuaalihostin määrittäminen**
   - Kopioi virtuaalihostin konfiguraatiotiedoston palvelimelle.
   - Aktivoi uusi virtuaalihostin (esim. `a2ensite`).
   - Lataa Apache2-palvelin uudelleen, jotta muutokset tulevat voimaan.

3. **Webbisivun julkaisu**
   - Kopioi sivuston tiedostot (esim. `index.html`) virtuaalihostin juureen.

## Esimerkkirakenne

```yaml
- name: Ota Apache2 käyttöön ja julkaise sivu
  hosts: web
  become: yes
  tasks:
    - name: Asenna Apache2
      apt:
        name: apache2
        state: present
        update_cache: yes

    - name: Kopioi virtuaalihostin konfiguraatio
      template:
        src: templates/apache.conf.j2
        dest: /etc/apache2/sites-available/my-site.conf

    - name: Aktivoi virtuaalihost
      command: a2ensite my-site.conf
      notify: Reload Apache

    - name: Kopioi index.html
      copy:
        src: files/index.html
        dest: /var/www/my-site/index.html

  handlers:
    - name: Reload Apache
      service:
        name: apache2
        state: reloaded
``` 

## Käyttöohjeet
Lisää tarvittavat tiedostot (esim. apache.conf.j2, index.html) playbookin hakemistoon.
Muokkaa inventaariotiedostoa, jotta web-hostit ovat mukana.
## Aja playbook komennolla:
Vinkkejä
Voit lisätä useampia sivutiedostoja kopioimalla ne copy-moduulilla.
Muista varmistaa, että polut ja nimet vastaavat omia asetuksiasi.
Käytä become: yes, jos tarvitset root-oikeuksia palvelimen asetuksiin.
