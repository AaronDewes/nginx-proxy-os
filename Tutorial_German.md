# NGINX-Proxy auf dem Raspberry Pi

Du möchtest eine Umbrel-App, wie beispielweise BTCPay-Server, über HTTPS auf deiner Domain anbieten?
Dann ist dieses Tutorial genau richtig, um mit einem zweiten Raspberry-Pi exakt das zu erreichen.

1. Auf dem zweiten Raspberry Pi das [für diesen Zweck optimierte Betriebssystem](https://umbrel.tech/nginx-proxy-manager-os) installieren.
2. Auf deinem Router eine feste IP für den Raspi UND Umbrel-Node vergeben. (Kein DHCP)
3. Über Umbrel –> Apps die gewünschte App installieren und einrichten.
    Beim Aufrufen in der Adresszeile des Browsers die Portnummer
        merken (192.168.XXX.XXX:YYYY)
4. Sobald alles installiert ist, kannst du lokal auf den Nginx Proxy-Server zugreifen: http://192.168.XXX.XXX:81 (lokale IP des 2. Pi’s)
      Der Benutzername ist `admin@example.com`, das Passwort `changeme`. Nach dem Login wirst du aufgefordert, diese Zugangsdaten zu ändern.
5. Auf dem Router die Portfreigabe für den 2. Pi aktivieren: Port 80 und 443. Nicht für die Umbrel-Node!
6. SSL-Zertifikate:
      * Anhand einer festen IP
        * Beim Domain-Provider eine neue Subdomain erstellen
        * Beim A-Record (DNS) der Subdomain die feste IP deines
                Internet-Providers (Telekom, Vodafone etc.) (nicht die
                192.168.XXX.XXX) eintragen
      * Anhand eines DynDNS Service
        * Beim Domain-Provider eine neue Subdomain erstellen
        * Beim CName die Adresse deines DynDNS Accounts
            eintragen
      * Sofern du ein SSL-Zertifikat für deine Domain hast, lade die
         Zertifikats-Dateien herunter. Diese kannst du gleich bei Nginx
         installieren, das ist der beste und einfachste Weg. Es sind 3
         Dateien:
        * Certificate Key
        * Certificate
        * Intermediate Certificate
         Ggf. musst du vorhandene Zertifikate neu erstellen, um sie
         herunterladen zu können. So geht es zumindest bei Ionos.
7. Zurück auf dem Pi in Nginx –> SSL Certificates –> Add SSL Certificate
      a. Custom für die Zertifikate deiner Webseite und lade die 3
         Zertifikatsdateien hoch. Benenne das Projekt.
      b. ODER Let’s Encrypt – die Subdomain eintragen.

8. Im Menü auf „Hosts“ klicken -> Add Proxy Host
      a. Daten wie auf dem Bild eintragen. Port ist YYYY aus Punkt 3. http
         ausgewählt lassen, block common exploits anklicken.
      b. Im Dropdown das eben erstellte SSL-Certificate auswählen. Force
          SSL und http/2 Support anklicken.

9. Rufe die Internetadresse im Browser auf. Sofern alles funktioniert hat,
   siehst du die Startseite der App. In der Adresszeile sollte https stehen.

Für Nutzer vom BTCPay-Server:

10. Richtest du den Pay-Button vom BTCPAY-Server local ein, musst du im
        HTML-Code die beiden Local-IP-Adressen durch die Subdomain ersetzen.
        Richtest du den Button über die Subdomain ein, wird die Adresse
        automatisch eingesetzt und du kannst den Code einfach kopieren.


---

Wenn alles funktioniert hat, würde ich mich über eine kleine Spende freuen:
                        https://tinyurl.com/5cxxpc3n

---

Credits gehen an
- https://www.crypto-check.net
- ApfelCast auf YouTube: https://www.youtube.com/watch?v=JgrPcQIQuF8
- WunderTech https://www.wundertech.net/
