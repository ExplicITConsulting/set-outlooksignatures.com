---
layout: "page"
lang: "de"
locale: "de"
title: "Implementierungs-Ansatz"
subtitle: "Einführung in einer komplexen Umgebung mit zehntausenden Postfächern"
description: "Erfahren Sie unseren Implementierungs-Ansatz für komplexe Multi-Client-Umgebungen mit zehntausenden Postfächern – praxisnah und effizient."
page_id: "implementationapproach"
permalink: "/implementationapproach"
redirect_from: "/implementationapproach/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<!-- omit in toc -->
## Welchen Ansatz für die Implementierung der Software empfehlen wir? {#recommended-approach}

Für die meisten Unternehmen ist die <a href="/quickstart">Schnellstart-Anleitung</a> der effizienteste Einstieg. Sie ermöglicht eine eigenständige Implementierung von Set-OutlookSignatures und dem Benefactor Circle Add-On in kürzester Zeit. Eine vollständige <a href="/support#professional-support">Implementierungsunterstützung</a> benötigt selten mehr als einen halben Tag.

<p>
  <div class="buttons">
    <a href="/quickstart" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Schnellstart-Anleitung</a>
    <a href="/support#professional-support" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Support</a>
  </div>
</p>

Dieses Dokument richtet sich an Organisationen, die neben Effizienz auch formelle Prozesse und Nachvollziehbarkeit sicherstellen müssen. Es enthält ein strukturiertes Beispiel dafür, wie die Implementierung in Umgebungen angegangen werden kann, in denen Rückverfolgbarkeit und Compliance unerlässlich sind, z. B. in Hochsicherheits- oder stark regulierten Umgebungen. Es zeigt, wie sich schnelle Implementierung mit strengen Governance-Anforderungen verbinden lässt.

Der Inhalt basiert auf praktischen Erfahrungen mit der Bereitstellung der Lösung in Multi-Tenant-Umgebungen mit zehntausenden Postfächern. Das Dokument richtet sich an IT-Dienstleister, interne IT-Teams und Fachabteilungen, die für E-Mail- und Client-Systeme verantwortlich sind.

Die behandelten Themen umfassen den gesamten Lebenszyklus, von der ersten Beratung und Planung über Tests, Pilotphasen und Rollout. Anschließend folgen Betrieb, Verwaltung, Support und Schulung. Das Ziel ist es, eine praktische Referenz bereitzustellen, die Unternehmen dabei hilft, die Lösung effektiv zu implementieren und gleichzeitig strenge Anforderungen zu erfüllen.

## 1. Auftrag {#task}

Als multinationaler Konzern sind wir gefordert, eine flexible Lösung zur automatischen Verwaltung von Signaturen zu suchen. Die Anforderungen dazu stammen aus mehreren Bereichen:

- Das Marketing möchte sicherstellen, dass die Corporate Identity und das Corporate Design auch in E-Mails eingehalten wird. Signaturen sollen dabei rasch vom Marketing selbst aktualisiert werden können, damit auch kurzfristig Kampagnen gestartet und beendet werden können. Technisches Wissen darf dafür nicht erforderlich sein.
- Die Rechtsabteilung pocht darauf, die in vielen Ländern geltende Vorgabe eines Impressums für E-Mails in Form einer Signatur umzusetzen.
- Das Management aller Ebenen unterstützt die Wünsche der anderen Abteilungen, solange dies nicht zu zusätzlichen Aufwänden für ihre Mitarbeiter führt, sondern diese nach Möglichkeit entlastet und mehr Zeit für ihre Aufgaben schafft..
- Die CISOs wollen sichergestellt wissen, dass alle Vorschriften zu Datenschutz und Informationssicherheit eingehalten werden, und dass Daten ihre angestammten Systeme möglichst in den angestammten Systemen verbleiben..
- Die IT-Verantwortlichen wollen sich nicht um die Inhalte von Signaturen und deren Aktualisierung kümmern müssen. Auch sollen keine neuen Abhängigkeiten zu unserem Mailsystem geschaffen werden, da diese unweigerlich die Komplexität des Gesamtsystems und die Betriebskosten steigern.

Dazu kommen diverse Rahmenbedingungen:

- Die Lösung muss aus finanzieller Sicht einen klaren Mehrwert bieten. Eine Anschaffung kommt nur bei einer positiven Kosten-Nutzen-Rechnung in Frage.
- Als Konzern sind wir einer gewissen Dynamik unterworfen. Manche Tochtergesellschaften sind organisatorisch und technisch sehr eng an den Konzern gebunden, andere sehr locker. In allen Konstellationen kann es intensive Zusammenarbeit geben. Im Rahmen von Fusionen und Übernahmen müssen einzelne Gesellschaften oder Gruppen von Gesellschaften rasch integriert bzw. aus dem Verbund entfernt werden können.
- Dem entsprechend ist die technische Umsetzung sehr vielfältig: Mehrere voneinander unabhängige Exchange-Umgebungen in on-prem-, hybrid- und cloud-only-Konfigurationen, mehrere AD-Forests in unterschiedlichen Trust-Konfigurationen, mehrere M365/Entra-ID-Tenants mit und ohne Anbindung untereinander.

Dieses Dokument soll klären, ob die gewünschten Anforderungen bezüglich Signaturen erfüllbar sind und wie eine praktische Umsetzung aussehen könnte.

Das Wort "Signatur" ist in diesem Dokument immer als textuelle Signatur zu verstehen und nicht mit einer digitalen Signatur zu verwechseln, die der Verschlüsselung von E-Mails und der Legitimierung des Absenders dient.

## 2. Möglichkeiten zur Wartung von Signaturen {#signature-maintenance-options}

### 2.1. Manuelle Wartung von Signaturen {#manual-signature-maintenance}

Bei der manuellen Wartung wird dem Benutzer z. B. über das Intranet eine Vorlage für die textuelle Signatur zur Verfügung gestellt. Zentral gewartet wird nur diese Vorlage, es gibt keine weitere Automatisierung.

Jeder Benutzer richtet sich die Signatur selbst ein. Je nach technischer Konfiguration des Clients wandern Signaturen bei einem Wechsel des verwendeten Computers mit oder sind neu einzurichten.

Falls das Postfach nicht in der Cloud liegt oder "roaming signatures" deaktiviert wurden, muss der Benutzer seine Signatur zusätzlich in Outlook Web warten.

Ohne Einsatz von Dritthersteller-Software sind die Signaturen zudem auch auf Android, iOS und macOS separat manuell zu warten.

### 2.2. Automatische Wartung von Signaturen {#automatic-signature-maintenance}

Bei der automatischen Wartung von Signaturen fallen keine Tätigkeiten für den Endbenutzer an. Alle Vorgaben werden zentral definiert, Signaturen aktualisieren sich auf allen Geräten und Systemen automatisch.

<!-- omit in toc -->
#### 2.2.1. Serverbasierte Lösungen {#server-based-signature-solutions}

Der größte Vorteil einer serverbasierten Lösung ist, dass an Hand eines definierten Regelsatzes jedes E-Mail erfasst wird, ganz gleich, von welcher Applikation oder welchem Gerät es verschickt wurde.

Da die Signatur erst am Server angehängt wird, sieht der Benutzer während der Erstellung eines E-Mails nicht, welche Signatur verwendet wird.

Die Definition der Regeln wird schnell komplex, und Benutzer haben praktisch keinen Einfluss auf die verwendete Signatur.

Nachdem die Signatur am Server angehängt wurde, muss das nun veränderte E-Mail vom Client neu heruntergeladen werden, damit es im Ordner "Gesendete Elemente" korrekt angezeigt wird. Das erzeugt zusätzlichen Netzwerkverkehr.

Wird eine Nachricht schon bei Erstellung digital signiert oder verschlüsselt, kann die textuelle Signatur serverseitig nicht hinzugefügt werden, ohne die digitale Signatur und die Verschlüsselung zu brechen. Alternativ wird die Nachricht so angepasst, dass der Inhalt nur aus der textuellen Signatur besteht und unveränderte ursprüngliche Nachricht als Anhang mitgeschickt wird.

Es wird eine neue Abhängigkeit des Mail-Systems zur Signaturlösung erzeugt, und es werden kaum noch passende Lösungen für den on-prem-Betrieb von Exchange angeboten.

Cloud-basierte Lösungen setzen voraus, dass alle internen und externen E-Mails sowie Daten aus Entra ID zur Analyse der Regeln und Anbringung der Signatur in das Rechenzentrum eines Drittanbieters umgeleitet werden.

Wir raten daher von serverbasierten Lösungen ab.

<!-- omit in toc -->
#### 2.2.2. Clientbasierte Signaturen {#client-based-signature-solutions}

Bei clientbasierten Lösungen erfolgt die Definition der Vorlagen und optional auch deren Verteilung zentral, das Hinzufügen der Signaturen zu einer E-Mail erfolgt am Client.

Der größte Nachteil clientbasierter Lösungen im Gegensatz zu serverbasierten Lösungen ist die Bindung an bestimmte E-Mail-Clients. In der Praxis ist dies wenig relevant, da aus Gründen der Wartbarkeit und Einheitlichkeit zumeist Microsoft Outlook genutzt wird. Outlook ist für Android, iOS, macOS und Windows verfügbar, und darüber hinaus auf praktisch allen anderen Plattform als Web-Applikation.

Der Benutzer sieht die Signatur bereits während der Erstellung des E-Mails und kann mitentscheiden, welche Signatur zum Einsatz kommt.

Die Verschlüsselung und das digitale Signieren von Nachrichten stellen weder client- noch serverseitig ein Problem dar.

Im Gegensatz zu serverbasierten Lösungen gibt es hier Alternativen, die keine Übertragung von E-Mails und Daten aus Entra ID in Rechenzentren Dritter benötigen.

Wir raten daher zur Nutzung einer clientbasierten Lösung.

## 3. Benötigter Funktionsumfang {#required-feature-set}

Aus den zuvor genannten Rahmenbedingungen und Gesprächen mit allen involvierten Parteien leitet sich folgender Katalog benötigter Funktionen ab:

Signaturen und Abwesenheitsnotizen sollen:

- Aus Vorlagen in gängigen Formaten wie DOCX oder HTML erstellt werden können.
- Mit Variablen aus Verzeichnisdiensten (z. B. Active Directory, Entra ID) und anderen Datenquellen anpassbar sein, inklusive Fotos und Bildern.
- Variablen für den aktuellen Benutzer, das Postfach und den Manager unterstützen.
- Barrierefrei gestaltet werden können, z. B. mit Alternativtexten für Links und Bilder.
- Flexibel zuweisbar sein: für alle Postfächer, Gruppen, Alias-Adressen, basierend auf Attributen.
- Mehrfach nutzbar sein: eine Vorlage für viele Postfächer, mit individuellen Signatur-Namen.
- Zeitgesteuert einsetzbar sein (gültig in bestimmten Zeiträumen).
- Als Standardsignatur für neue E-Mails oder Antworten festgelegt werden können.
- Als Standard-Abwesenheitsnotiz für interne und externe Empfänger nutzbar sein.
- In Outlook Web und als Roaming-Signaturen synchronisiert werden können.
- Zentral verwaltet werden können, aber auch parallele Benutzersignaturen erlauben.
- Automatisch in neue E-Mails, Antworten, Weiterleitungen und Termine eingefügt werden können.
- Für andere E-Mail-Clients als Outlook wenn nicht automatisch, dann zumindest für manuelle Einbindung verfügbar gemacht werden (z. B. Apple Mail).

Bereitstellung und Ausführung sollen:

- Auf Windows-, Linux- und macOS-Clients möglich sein, auch auf Terminalservern oder gemeinsam genutzten Geräten.
- Ohne Installation auf Servern oder Clients auskommen.
- Über zentrale Freigaben und Standardmechanismen wie Anmeldeskripte, geplante Aufgaben oder manuelle Ausführung erfolgen.
- Optional ohne Clientbereitstellung direkt für Webnutzer möglich sein.
- In hybriden, Cloud- und On-Premises-Umgebungen funktionieren.
- Für große und komplexe Umgebungen geeignet sein (z. B. mehrere AD-Domänen, Trusts, Multitenant).
- Mehrere Instanzen durch getrennte Konfigurationen ermöglichen.

Sicherheit und Datenschutz:

- Keine Telemetrie oder externe Datenübertragung.
- Keine Änderungen an DNS oder E-Mail-Verkehr erforderlich.
- Daten bleiben innerhalb der bereits bestehenden Infrastruktur.

Zusätzliche Anforderungen:

- Dokumentierte Best Practices für Implementierung und Betrieb.
- Open-Source-Option oder transparente Lizenzbedingungen bevorzugt.

## 4. Vergleich unterschiedlicher Lösungen {#feature-comparison}

Auf Basis des Funktionsumfang wurden unterschiedliche Lösungen evaluiert, getestet und vergleichen:

<div class="table-container">
    <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
            <tr>
                <th style="text-align:left">Feature</th>
                <th style="text-align:left">Set-OutlookSignatures<br>mit dem <span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></th>
                <th style="text-align:left">Marktbegleiter A</th>
                <th style="text-align:left">Marktbegleiter B</th>
                <th style="text-align:left">Marktbegleiter C</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="text-align:left">Kostenloser und quelloffener Kern</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">E-Mails bleiben in Ihrer Umgebung (keim Umleiten auf Drittsysteme)</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Optional, reduziert den Funktionsumfang</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Wird in Umgebungen gehostet und ausgeführt, denen Sie bereits vertrauen und für die Sie Sicherheits- und Verwaltungsstrukturen eingerichtet haben.</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Rechte für Entra ID und Active Directory</td>
                <td style="text-align:left">🟢 Benutzerrechte (delegated permissions), Least-Privilege-Prinzip</td>
                <td style="text-align:left">🔴 Applikationsrechte (application permissions), alle Verzeichnisdaten lesen (und alle E-Mails umleiten)
                </td>
                <td style="text-align:left">🔴 Applikationsrechte (application permissions), alle Verzeichnisdaten lesen (und alle E-Mails umleiten)
                </td>
                <td style="text-align:left">🔴 Applikationsrechte (application permissions), alle Verzeichnisdaten lesen (und alle E-Mails umleiten)</td>
            </tr>
            <tr>
                <td style="text-align:left">Daten aus Entra ID Und Active Directory bleiben in Ihrer Umgebung (kein Transfer zu Drittsystemen)</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Erfordert keine Anpassung der Exchange-Konfiguration und erzeugt keine neuen Abhängigkeiten</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Mehrere unabhängige Instanzen können in derselben Umgebung laufen</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Kein Sammeln von Telemetrie- oder Nutzungsdaten, weder direkt noch indirekt</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Kein Abo-Vertrag</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">IT kann die Signatur-Verwaltung delegieren, z. B. an das Marketing</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Nicht auf Signatur-Ebene</td>
                <td style="text-align:left">🟡 Nicht auf Signatur-Ebene</td>
            </tr>
            <tr>
                <td style="text-align:left">Signaturen an alle E-Mails anfügen</td>
                <td style="text-align:left">🟡 Nur für Outlook-Clients</td>
                <td style="text-align:left">🟢 Bei Umleitung aller E-Mails auf ein Drittsystem</td>
                <td style="text-align:left">🟢 Bei Umleitung aller E-Mails auf ein Drittsystem</td>
                <td style="text-align:left">🟢 Bei Umleitung aller E-Mails auf ein Drittsystem</td>
            </tr>
            <tr>
                <td style="text-align:left">Signaturen auf Basis der Empfänger</td>
                <td style="text-align:left">🟡 Hochgradig anpassbar, 10+ Eigenschaften. Gleiche Signatur für alle Empfänger.</td>
                <td style="text-align:left">🟡 Interne, Externe, Gruppenmitglieder, E-Mail-Adressen. Unterschiedliche Signaturen nur bei Umleitung aller E-Mails auf ein Drittsystem.</td>
                <td style="text-align:left">🟡 Interne und Externe. Gleiche Signatur für alle Empfänger.</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Zusätzliche Datenquellen neben Active Directory und Entra ID</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Unterstützt nationale Clouds von Microsoft</td>
                <td style="text-align:left">🟢 Global/Public, US Government L4 (GCC, GCC High), US Government L5 (DOD), China operated by 21Vianet</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Unterstützt mandantenübergreifenden Zugriff und Multitenant Organizations</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Unterstützt Microsoft Roaming Signatures (mehrere Signaturen in Outlook Web und neuem Outlook)</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Anzahl der Vorlagen</td>
                <td style="text-align:left">🟢 Unlimitiert</td>
                <td style="text-align:left">🔴 1, mehr kosten extra</td>
                <td style="text-align:left">🟢 Unlimitiert</td>
                <td style="text-align:left">🟢 Unlimitiert</td>
            </tr>
            <tr>
                <td style="text-align:left">Zuweisung und Ausschließen von Vorlagen</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Kostet extra</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟢</td>
            </tr>
            <tr>
                <td style="text-align:left">Gültigkeit von Vorlagen nach Zeiträumen</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Kostet extra</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟢</td>
            </tr>
            <tr>
                <td style="text-align:left">Banner</td>
                <td style="text-align:left">🟢 Unlimitiert</td>
                <td style="text-align:left">🔴 1, mehr kosten extra</td>
                <td style="text-align:left">🟢 Unlimitiert</td>
                <td style="text-align:left">🟢 Unlimitiert</td>
            </tr>
            <tr>
                <td style="text-align:left">QR codes und vCards</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Kosten extra</td>
                <td style="text-align:left">🔴 Kosten extra</td>
                <td style="text-align:left">🟢</td>
            </tr>
            <tr>
                <td style="text-align:left">Signatur sichtbar während des Schreibens einer E-Mail</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
            </tr>
            <tr>
                <td style="text-align:left">Signatur sichtbar in den Gesendeten Elementen</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Nur Cloud-Postfächer</td>
                <td style="text-align:left">🟡 Nur Cloud-Postfächer</td>
                <td style="text-align:left">🟡 Nur Cloud-Postfächer</td>
            </tr>
            <tr>
                <td style="text-align:left">Abwesenheitsnotizen</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Kostet extra</td>
                <td style="text-align:left">🟡 Keine Trennung nach internen und externen Empfängern</td>
                <td style="text-align:left">🔴 Kostet extra</td>
            </tr>
            <tr>
                <td style="text-align:left">Benutzer-kontrollierte Signaturen</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
            </tr>
            <tr>
                <td style="text-align:left">Signaturen für verschlüsselte E-Mails</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
            </tr>
            <tr>
                <td style="text-align:left">Signaturen für delegierte, gemeinsam benutzte, zusätzliche und automapped Postfächer</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Kein Mischen von Benutzer- und Postfachattributen</td>
                <td style="text-align:left">🟡 Kein Mischen von Benutzer- und Postfachattributen</td>
                <td style="text-align:left">🟡 Kein Mischen von Benutzer- und Postfachattributen</td>
            </tr>
            <tr>
                <td style="text-align:left">Outlook Add-In</td>
                <td style="text-align:left">🟢 Nicht für on-prem Postfächer auf Android und iOS. Hochgrad anpassbar mit Regeln, eigenem Code und zur Laufzeit generierten Signaturen</td>
                <td style="text-align:left">🟡 Nicht für on-prem Postfächer auf Android und iOS, nicht für Termine</td>
                <td style="text-align:left">🟡 Nicht für on-prem Postfächer auf Android und iOS, nicht für Termine</td>
                <td style="text-align:left">🔴 Nicht für on-prem Postfächer</td>
            </tr>
            <tr>
                <td style="text-align:left">Preismodel für Support</td>
                <td style="text-align:left">🟢 Verrechnung nach Stunden</td>
                <td style="text-align:left">🔴 Kostet auch bei Nichtnutzung</td>
                <td style="text-align:left">🔴 Kostet auch bei Nichtnutzung</td>
                <td style="text-align:left">🔴 Kostet auch bei Nichtnutzung</td>
            </tr>
            <tr>
                <td style="text-align:left">Software-Treuhand</td>
                <td style="text-align:left">🟢 An Set-OutlookSignatures</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Telefonnummern formatieren</td>
                <td style="text-align:left">🟢 E164, International, National, RFC3966, Regex, benutzerdefiniert</td>
                <td style="text-align:left">🟡 Regex</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🟡 RegEx</td>
            </tr>
            <tr>
                <td style="text-align:left">Postadressen formatieren</td>
                <td style="text-align:left">🟢 Vorlagen für über 200 Länder/Regionen, benutzerdefiniert</td>
                <td style="text-align:left">🟡 Regex</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🟡 RegEx</td>
            </tr>
            <tr>
                <td style="text-align:left">Lizenzkosten für 100 Postfächer, 1 Jahr</td>
                <td style="text-align:left">🟢 300&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 1.600&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 1.300&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 1.600&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">Lizenzkosten für 250 Postfächer, 1 Jahr</td>
                <td style="text-align:left">🟢 750&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 4.000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 2.700&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 3.600&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">Lizenzkosten für 500 Postfächer, 1 Jahr</td>
                <td style="text-align:left">🟢 1.500&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 8.000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 4.400&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 6.200&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">Lizenzkosten für 1.000 Postfächer, 1 Jahr</td>
                <td style="text-align:left">🟢 3.000&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 15.700&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 8.700&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 10.500&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">Lizenzkosten für 10.000 Postfächer, 1 Jahr</td>
                <td style="text-align:left">🟢 30.000&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 110.000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 65.000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 41.000&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">Direktbezug ohne öffentliche Ausschreibung</td>
                <td style="text-align:left">🟢 Einzigartige Funktionen, exklusive Herstellerverfügbarkeit</td>
                <td style="text-align:left">🔴 Keine einzigartigen Funktionen, keine exklusive Herstellerverfügbarkeit</td>
                <td style="text-align:left">🔴 Keine einzigartigen Funktionen, keine exklusive Herstellerverfügbarkeit</td>
                <td style="text-align:left">🔴 Keine einzigartigen Funktionen, keine exklusive Herstellerverfügbarkeit</td>
            </tr>
        </tbody>
    </table>
</div>

## 5. Empfehlung: Set-OutlookSignatures {#recommendation}

Nach einer Erhebung der Kundenanforderungen und Tests mehrerer server- und clientbasierter Produkte empfehlen wir den Einsatz der kostenlosen Open-Source-Software Set-OutlookSignatures mit der kostenpflichtigen "Benefactor Circle"-Erweiterung.

### 5.1. Allgemeine Beschreibung {#general-description}

<a href="https://set-outlooksignatures.com">Set-OutlookSignatures</a> ist ein kostenloses Open-Source-Produkt mit einem kostenpflichtigen Add-On für erweiterte Unternehmensfunktionen.

Als Zielplattform werden alle Varianten von Outlook und Exchange unterstützt: Windows, macOS, Android, iOS, Linux, Web. Klassisches und neues Outlook. On-prem, hybrid und cloud-only. Durch optional im Postfach gespeicherte Signaturen stehen diese auch in anderen E-Mail-Clients zur Verfügung.

Die Verwaltung der Signaturen erfolgt zentral und kann vollständig oder auf Ebene einzelner Vorlagen z. B. an das Marketing delegiert werden. Für die Verwaltung wird nur Microsoft Word benötigt, HTML-Kenntnise sind optional.

Die Berechnung und Verteilung der Signaturen kann auf drei Varianten erfolgen, die miteinander kombinierbar sind:

- Lokal auf den Clients. Das ist die bevorzugte Variante, da auf den Clients (Windows, Linux, macOS) die meiste brachliegende Rechenleistung zur Verfügung steht.
- Auf einem oder mehreren Servern. Signaturen werden zentral vorberechnet und in die Postfächer der Benutzer geschrieben. Diese Variante erfordert hohe zentrale Rechenleistung und kann auf dem Client gesetzte Einstellungen nicht berücksichtigen. Dies ist die bevorzugte Variante für Postfächer von Benutzern, die Outlook nur im Web, auf iOS oder Android nutzen oder nur andere E-Mail-Clients verwenden.
- Über das Outlook Add-In. Damit ist nicht nur der Zugriff auf Signaturen möglich, die über eine der anderen Varianten erstellt wurden, sondern es können auch davon unabhängige Signaturen erstellt und angehängt werden. Dieser Modus erlaubt zudem die Erstellung granularer Regeln auf Basis vieler Eigenschaften des aktuell bearbeiteten Elements (z. B. abhängig von Empfängern, Absender, Betreff und vielen weiteren Eigenschaften).

Alle drei Varianten können mit allen Arten von E-Mail-Verschlüsselung umgehen, und die Einbindung in den mit Hilfe von AppLocker und anderen Mechanismen wie z. B. Microsoft Purview Information Protection abgesicherten Client ist durch etablierte Maßnahmen (wie z. B. dem digitalen Signieren von PowerShell-Scripts) technisch und organisatorisch einfach möglich.

Die Architektur stellt sicher, dass keine Daten bestehende Systeme verlassen, es gibt keine Übertragung an externe Anbieter.

Es können beliebig viele voneinander unabhängige Instanzen betrieben werden, was z. B. für eine schrittweise Ausrollung oder den Betrieb in Gesellschaften, die nur lose mit dem Konzern verbunden sind, Vorteile bringt.

### 5.2. Lizenzmodell, Kosten-Nutzen-Rechnung {#licensing-and-cost-benefit}

Das kostenlose Teil der Software ist unter der "European Union Public License (EUPL) 1.2" lizenziert, die von internationalen Organisationen als vollwertige Open-Source-Lizenz anerkannt und mit vielen anderen vergleichbaren Lizenzen kompatibel ist.

Das Benefactor Circle Add-On wird auf Basis der Anzahl jener Postfächer, die es nutzen sollen, lizenziert. Eine namentliche Nennung der Postfächer gibt es nicht.

Durch Verzicht auf Staffelpreise und Rabatte fällt die <a href="/benefactorcircle#financial-benefits">Kosten-Nutzen-Rechnung</a> schon bei einer kleinen Anzahl von Postfächern positiv aus.

## 6. Unterstützung durch den IT-Dienstleister {#support-it-service-provider}

Als IT-Dienstleister empfehlen wir Set-OutlookSignatures nicht nur, sondern bieten unseren Kunden auch umfassende Unterstützung an.

Wir teilen unsere Erfahrungen, die wir im Rahmen der Definition der Anforderungen für eine Signatur-Lösung, der Evaluierung und dem Vergleich verschiedener Lösungen, sowie der Einführung von Set-OutlookSignatures und dem Benefactor Circle Add-On gesammelt haben.

Den Gesellschaften im Konzern, die die Lösung ohne weitere Unterstützung selbst einführen möchten, empfehlen wir, zunächst die <a href="/quickstart">Schnellstart-Anleitung</a> zu befolgen. Dank der umfassenden Dokumentation können Kunden Set-OutlookSignatures und das Benefactor Circle Add-On in der Regel innerhalb kürzester Zeit selbstständig implementieren.

Allen Gesellschaften im Konzern bieten wir Unterstützung in Form von Workshops und Schulungen an. Die folgende Liste ist als maximale inhaltliche und zeitliche Ausprägung im Rahmen eines vollständigen Vorbereitungs- und Einführungsprojekts zu verstehen - **vollständige <a href="/support#professional-support">Implementierungsunterstützung</a> in Form von "train the trainer" benötigt selten mehr als einen halben Tag**.

### 6.1. Beratungs- und Einführungsphase {#consulting-implementation-phase}

#### Erstabstimmung zu textuellen Signaturen <!-- omit in toc -->

**Teilnehmer**  

- Kunde: Unternehmenskommunikation, Marketing, Clientmanagement, Koordinator des Vorhabens  
- IT-Dienstleister: Mail-Produktmanagement, Mail-Betriebsführung oder Mail-Architektur  

**Inhalt und Ziele**  

- Kunde: Vorstellung der eigenen Wünsche zu textuellen Signaturen  
- IT-Dienstleister: Kurze Beschreibung zu prinzipiellen Möglichkeiten rund um textuelle Signaturen, Vor- und Nachteile der unterschiedlichen Ansätze, Gründe für die Entscheidung zum empfohlenen Produkt  
- Abgleich der Kundenwünsche mit den technisch-organisatorischen Möglichkeiten  
- Live-Demonstration des Produkts unter Berücksichtigung der Kundenwünsche  
- Festlegung der nächsten Schritte  

**Dauer**  

- 2 Stunden  

#### Schulung der Vorlagen-Verwalter <!-- omit in toc -->

**Teilnehmer**  

- Kunde: Vorlagen-Verwalter (Unternehmenskommunikation, Marketing), optional Clientmanagement, Koordinator des Vorhabens  
- IT-Dienstleister: Mail-Produktmanagement, Mail-Betriebsführung oder Mail-Architektur  

**Inhalt und Ziele**  

- Zusammenfassung des vorangegangenen Termins "Erstabstimmung zu textuellen Signaturen", mit Fokus auf gewünschte und realisierbare Funktionen  
- Vorstellung des Aufbaus der Vorlagen-Verzeichnisse, mit Fokus auf  
- Namenskonventionen  
- Anwendungsreihenfolge (allgemein, gruppenspezifisch, postfachspezifisch, in jeder Gruppe alphabetisch)  
- Festlegung von Standard-Signaturen für neue E-Mails und für Antworten und Weiterleitungen  
- Festlegung von Abwesenheits-Texten für interne und externe Empfänger.  
- Festlegung der zeitlichen Gültigkeit von Vorlagen  
- Variablen und Benutzerfotos in Vorlagen  
- Unterschiede DOCX- und HTML-Format  
- Möglichkeiten zur Einbindung eines Disclaimers  
- Gemeinsame Erarbeitung erster Vorlagen auf Basis bestehender Vorlagen und Kundenanforderungen  
- Live-Demonstration auf einem Standard-Client mit einem Testbenutzer und Testpostfächern des Kunden (siehe Voraussetzungen)  

**Dauer**  

- 2 Stunden  

**Voraussetzungen**  

- Standard-Client mit Outlook und Word zur Verfügung.  
- Der Bildschirminhalt des Clients muss zur gemeinsamen Arbeit per Beamer projiziert oder auf einem entsprechend großen Monitor dargestellt werden können.  
- Der Kunde stellt einen Testbenutzer zur Verfügung. Dieser Testbenutzer muss auf dem Standard-Client  
  - einmalig Dateien aus dem Internet (github.com) herunterladen dürfen (alternativ kann der Kunde einen BitLocker-verschlüsselten USB-Stick für die Datenübertragung stellen).  
  - signierte PowerShell-Scripte im Full Language Mode ausführen dürfen  
  - über ein Mail-Postfach verfügen  
  - Vollzugriff auf diverse Testpostfächer (persönliche Postfächer oder Gruppenpostfächer) haben, die nach Möglichkeit direkt oder indirekt Mitglied in diversen Gruppen oder Verteilerlisten sind. Für den Vollzugriff kann der Benutzer auf die anderen Postfächer entsprechend berechtigt sein, oder Benutzername und Passwort der zusätzlichen Postfächer sind bekannt.  

#### Schulung des Kunden-IT <!-- omit in toc -->

**Teilnehmer**  

- Kunde: IT, optional ein Administrator des Active Directory, optional ein Administrator des File-Servers und/oder SharePoint-Server, optional Unternehmenskommunikation und Marketing, Koordinator des Vorhabens  
- IT-Dienstleister: Mail-Produktmanagement, Mail-Betriebsführung oder Mail-Architektur, ein Vertreter des Client-Teams bei entsprechenden Kunden  

**Inhalt und Ziele**  

- Zusammenfassung des vorangegangenen Termins "Erstabstimmung zu textuellen Signaturen", mit Fokus auf gewünschte und realisierbare Funktionen  
- Prinzipieller Ablauf der Software  
- Systemanforderungen Client (Office, PowerShell, AppLocker, digitale Signatur der Software, Netzwerk-Ports)  
- Systemanforderungen Server (Ablage der Vorlagen)  
- Möglichkeiten der Einbindung des Produkts (Logon-Script, geplante Aufgabe, Desktop-Verknüpfung)  
- Parametrisierung der Software, unter anderem:  
- Bekanntgabe der Vorlagen-Ordner  
- Outlook im Web berücksichtigen?  
- Abwesenheitsnachrichten berücksichtigen?  
- Welche Trusts berücksichtigen?  
- Wie zusätzliche Variablen definieren?  
- Vom Benutzer erstellte Signaturen erlauben?  
- Signaturen auf einem zusätzlichen Pfad ablegen?  
- Gemeinsame Tests auf Basis zuvor vom Kunden erarbeiteter Vorlagen und Kundenanforderungen  
- Festlegung nächster Schritte  

**Dauer**  

- 2 Stunden

**Voraussetzungen**  

- Der Kunde stellt einen Standard-Client mit Outlook und Word zu Verfügung.  
- Der Bildschirminhalt des Clients muss zur gemeinsamen Arbeit per Beamer projiziert oder auf einem entsprechend großen Monitor dargestellt werden können.  
- Der Kunde stellt einen Testbenutzer zur Verfügung. Dieser Testbenutzer muss auf dem Standard-Client  
  - einmalig Dateien aus dem Internet (github.com) herunterladen dürfen (alternativ kann der Kunde einen BitLocker-verschlüsselten USB-Stick für die Datenübertragung stellen).  
  - signierte PowerShell-Scripte im Full Language Mode ausführen dürfen
  - über ein Mail-Postfach verfügen  
  - Vollzugriff auf diverse Testpostfächer (persönliche Postfächer oder Gruppenpostfächer) haben, die nach Möglichkeit direkt oder indirekt Mitglied in diversen Gruppen oder Verteilerlisten sind. Für den Vollzugriff kann der Benutzer auf die anderen Postfächer entsprechend berechtigt sein, oder Benutzername und Passwort der zusätzlichen Postfächer sind bekannt.  
- Der Kunde stellt mindestens einen zentralen SMB-Share oder eine SharePoint Dokumentbibliothek für die Ablage der Vorlagen zur Verfügung.  
- Der Kunde stellt einen zentralen SMB-File-Share für die Ablage der Software und seiner Komponenten zur Verfügung.  

### 6.2. Test, Pilotbetrieb, Rollout {#testing-pilot-rollout}

Die Planung und Koordination von Tests, Pilotbetrieb und Rollout erfolgt durch den Vorhabens-Verantwortlichen des Kunden.

Die konkrete technische Umsetzung erfolgt durch den Kunden. Falls zusätzlich zu Mail auch der Client durch IT-Dienstleister betreut wird, unterstützt das Client-Team bei der Einbindung der Software (Logon-Script, geplante Aufgabe, Desktop-Verknüpfung).

Bei prinzipiellen technischen Problemen unterstützt das Mail-Produktmanagement bei der Ursachenforschung, arbeitet Lösungsvorschläge aus und stellt gegebenenfalls den Kontakt zum Hersteller des Produkts her.

Die Erstellung und Wartung von Vorlagen ist Aufgabe des Kunden.

#### Systemanforderungen <!-- omit in toc -->

**Client**  

- Outlook und Word (bei Verwendung von DOCX-Vorlagen, und/oder Signaturen im RTF-Format), jeweils ab Version 2010  
- Die Software muss im Sicherheitskontext des aktuell angemeldeten Benutzers laufen.  
- Die Software muss im "Full Language Mode" ausgeführt werden, der "Constrained Language Mode" wird nicht unterstützt.
- Falls AppLocker oder vergleichbare Lösungen zum Einsatz kommen, ist die Software bereits digital signiert.  
- Netzwerkfreischaltungen:  
  - Die Ports 389 (LDAP) and 3268 (Global Catalog), jeweils TCP and UDP, müssen zwischen Client und allen Domain Controllern freigeschaltet sein. Falls dies nicht der Fall ist, können signaturrelevante Informationen und Variablen nicht abgerufen werden. Die Software prüft bei jedem Lauf, ob der Zugriff möglich ist.  
  - Für den Zugriff auf den SMB-File-Share mit den Software-Komponenten werden folgende Ports benötigt: 137 UDP, 138 UDP, 139 TCP, 445 TCP (Details <a href="https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731402(v=ws.11)">in diesem Microsoft-Artikel</a>).  
  - Für den Zugriff auf SharePoint Dokumentbibliotheken wird Port 443 TCP benötigt. Firewalls und Proxies dürfen WebDAV HTTP Extensions nicht blockieren.

**Server**

- Ein SMB-File-Share, in den die Software und ihre Komponenten abgelegt werden. Auf diesen File-Share und seine Inhalte müssen alle Benutzer lesend zugreifen können.  
- Ein oder mehrere SMB-File-Shares oder SharePoint Dokumentbibliotheken, in den die Vorlagen für Signaturen und Abwesenheitsnachrichten gespeichert und verwaltet werden.

Falls in den Vorlagen Variablen (z. B. Vorname, Nachname, Telefonnummer) genutzt werden, müssen die entsprechenden Werte im Active Directory vorhanden sein. Im Fall von Linked Mailboxes kann dabei zwischen den Attributen des aktuellen Benutzers und den Attributen des Postfachs, die sich in unterschiedlichen AD-Forests befinden, unterschieden werden.  

Wie in den Systemanforderungen beschrieben, ist die Software samt seinen Komponenten auf einem SMB-File-Share abzulegen. Alternativ kann es durch einen beliebigen Mechanismus auf die Clients verteilt und von dort ausgeführt werden.

Alle Benutzer benötigen Lesezugriff auf die Software und alle seine Komponenten.

Solange diese Anforderungen erfüllt sind, kann jeder beliebige SMB-File-Share genutzt werden, beispielsweise  

- der NETLOGON-Share eines Active Directory  
- ein Share auf einem Windows-Server in beliebiger Architektur (einzelner Server oder Cluster, klassischer Share oder DFS in allen Variationen)  
- ein Share auf einem Windows-Client  
- ein Share auf einem beliebigen Nicht-Windows-System, z. B. über SAMBA

Solange alle Kunden die gleiche Version der Software einsetzen und diese nur über Parameter konfigurieren, genügt eine zentrale Ablage für die Software-Komponenten.

Für maximale Leistung und Flexibilität empfehlen wir, dass jeder Kunde die Software in einem eigenen SMB-File-Share ablegt und diesen gegebenenfalls über Standorte hinweg auf verschiedene Server repliziert.

Im Gegensatz zur Ablage von Vorlagen und Konfigurationen wird die Ablage der Software selbst auf SharePoint Online nicht unterstützt.

**Ablage der Vorlagen**  
Wie in den Systemanforderungen beschrieben, können Vorlagen für Signaturen und Abwesenheitsnachrichten analog zur Software selbst auf SMB-File-Shares oder SharePoint Dokumentbibliotheken abgelegt werden.

SharePoint-Dokumentbibliotheken haben den Vorteil der optionalen Versionierung von Dateien, so dass im Fehlerfall durch die Vorlagen-Verwalter rasch eine frühere Version einer Vorlage wiederhergestellt werden kann.

Es wird pro Kunde zumindest ein Share mit separaten Unterverzeichnissen für Signatur- und Abwesenheits-Vorlagen empfohlen.

Benutzer benötigen lesenden Zugriff auf alle Vorlagen.

Durch simple Vergabe von Schreibrechten auf den gesamten Vorlagen-Ordner oder auf einzelne Dateien darin wird die Erstellung und Verwaltung von Signatur- und Abwesenheits-Vorlagen an eine definierte Gruppe von Personen delegiert. Üblicherweise werden die Vorlagen von den Abteilungen Unternehmenskommunikation und Marketing definiert, erstellt und gewartet.

Für maximale Leistung und Flexibilität empfehlen wir, dass jeder Kunde die Software in einem eigenen SMB-File-Share ablegt und diesen gegebenenfalls über Standorte hinweg auf verschiedene Server repliziert.  

Vorlagen und Konfigurationsdateien können auch auf SharePoint Online abgelegt werden.

**Verwaltung der Vorlagen, Delegation**  
Durch simple Vergabe von Schreibrechten auf den Vorlagen-Ordner oder auf einzelne Dateien darin wird die Erstellung und Verwaltung von Signatur- und Abwesenheits-Vorlagen an eine definierte Gruppe von Personen delegiert. Üblicherweise werden die Vorlagen von den Abteilungen Unternehmenskommunikation und Marketing definiert, erstellt und gewartet.

Die Software kann Vorlagen im DOCX- oder im HTML-Format verarbeiten. Für den Anfang wird die Verwendung des DOCX-Formats empfohlen; die Gründe für diese Empfehlung und die Vor- und Nachteile des jeweiligen Formats werden in der `README`-Datei der Software beschrieben.

Die mit der Software mitgelieferte `README`-Datei bietet eine Übersicht, wie Vorlagen zu administrieren sind, damit sie  

- nur für bestimmte Gruppen oder Postfächer gelten  
- als Standard-Signatur für neue Mails oder Antworten und Weiterleitungen gesetzt werden  
- als interne oder externe Abwesenheits-Nachricht gesetzt werden
- und vieles mehr

In `README` und den Beispiel-Vorlagen werden zudem die ersetzbaren Variablen, die Erweiterung um benutzerdefinierte Variablen und der Umgang mit Fotos aus dem Active Directory beschrieben.

In der mitgelieferten Beispiel-Datei "Test all signature replacement variables.docx" sind alle standardmäßig verfügbaren Variablen enthalten; zusätzlich können eigene Variablen definiert werden.

**Ausführen der Software**
Die Software kann über einen beliebigen Mechanismus ausgeführt werden, beispielsweise  

- bei Anmeldung des Benutzers als Teil des Logon-Scripts oder als eigenes Script  
- über die Aufgabenplanung zu fixen Zeiten oder bei bestimmten Ereignissen  
- durch den Benutzer selbst, z. B. über eine Verknüpfung auf dem Desktop  
- durch ein Werkzeug zur Client-Verwaltung

Da es sich bei Set-OutlookSignatures hauptsächlich um ein PowerShell-Script handelt, erfolgt der Aufruf wie bei jedem anderen Script dieses Dateityps:

```
powershell.exe <PowerShell-Parameter> -file "<Pfad zu Set-OutlookSignatures.ps1>" <Script-Parameter>  
```

**Parametisierung**  
Das Verhalten der Software kann über Parameter gesteuert werden. Besonders relevant sind dabei SignatureTemplatePath und OOFTemplatePath, über die der Pfad zu den Signatur- und Abwesenheits-Vorlagen angegeben wird.

Folgend ein Beispiel, bei dem die Signatur-Vorlagen auf einem SMB-File-Share und die Abwesenheits-Vorlagen in einer SharePoint Dokumentbibliothek liegen:

```
powershell.exe -file "\\example.com\netlogon\set-outlooksignatures\set-outlooksignatures.ps1" –SignatureTemplatePath "\\example.com\DFS-Share\Common\Templates\Signatures Outlook" –OOFTemplatePath "https://sharepoint.example.com/CorporateCommunications/Templates/Out-of-office templates"  
```

Zum Zeitpunkt der Erstellung dieses Dokuments waren noch weitere Parameter verfügbar. Folgend eine kurze Übersicht der Möglichkeit, für Details sei auf die Dokumentation der Software in der `README`-Datei verwiesen:  

- SignatureTemplatePath: Pfad zu den Signatur-Vorlagen. Kann ein SMB-Share oder eine SharePoint Dokumentbibliothek sein.  
- ReplacementVariableConfigFile: Pfad zur Datei, in der vom Standard abweichende Variablen definiert werden. Kann ein SMB-Share oder eine SharePoint Dokumentbibliothek sein.  
- TrustsToCheckForGroups: Standardmäßig werden alle Trusts nach Postfachinformationen abgefragt. Über diesen Parameter können bestimmte Domains entfernt und nicht-getrustete Domains hinzugefügt werden.  
- DeleteUserCreatedSignatures: Sollen vom Benutzer selbst erstelle Signaturen gelöscht werden? Standardmäßig erfolgt dies nicht.  
- SetCurrentUserOutlookWebSignature: Standardmäßig wird für den angemeldeten Benutzer eine Signatur in Outlook im Web gesetzt. Über diesen Parameter kann das verhindert werden.  
- SetCurrentUserOOFMessage: Standardmäßig wird der Text der Abwesenheits-Nachrichten gesetzt. Über diesen Parameter kann dieses Verhalten geändert werden.  
- OOFTemplatePath: Pfad zu den Abwesenheits-Vorlagen. Kann ein SMB-Share oder eine SharePoint Dokumentbibliothek sein.  
- AdditionalSignaturePath: Pfad zu einem zusätzlichen Share, in den alle Signaturen kopiert werden sollen, z. B. für den Zugriff von einem mobilen Gerät aus und zur vereinfachten Konfiguration nicht von der Software unterstützter Clients. Kann ein SMB-Share oder eine SharePoint Dokumentbibliothek sein.  
- UseHtmTemplates: Standardmäßig werden Vorlagen im DOCX-Format verarbeitet. Über diesen Schalter kann auf HTML (.htm) umgeschaltet werden.  
Die `README`-Datei enthält weitere Parameter.

**Laufzeit und Sichtbarkeit der Software**  
Die Software ist auf schnelle Durchlaufzeit und minimale Netzwerkbelastung ausgelegt, die Laufzeit der Software hängt dennoch von vielen Parametern ab:  

- allgemeine Geschwindigkeit des Clients (CPU, RAM, HDD)  
- Anzahl der in Outlook konfigurierten Postfächer  
- Anzahl der Trusted Domains  
- Reaktionszeit der Domain Controller und File Server  
- Reaktionszeit der Exchange-Server (Setzen von Signaturen in Outlook Web, Abwesenheits-Benachrichtigungen)  
- Anzahl der Vorlagen und Komplexität der Variablen darin (z. B. Fotos)

Unter folgenden Rahmenbedingungen wurde eine reproduzierbare Laufzeit von ca. 30 Sekunden gemessen:  

- Standard-Client  
- Über VPN mit dem Firmennetzwerk verbunden  
- 4 Postfächer  
- Abfrage aller per Trust verbundenen AD-Domains  
- 9 zu verarbeitende Signatur-Vorlagen, alle mit Variablen und Grafiken (aber ohne Benutzerfotos), teilweise auf Gruppen und Mail-Adressen eingeschränkt  
- 8 zu verarbeitende Abwesenheits-Vorlagen, alle mit Variablen und Grafiken (aber ohne Benutzerfotos), teilweise auf Gruppen und Mail-Adressen eingeschränkt  
- Setzen der Signatur in Outlook Web on-prem
- Kein Kopieren der Signaturen auf einen zusätzlichen Netzwerkpfad
  
Da die Software keine Benutzerinteraktion erfordert, kann es über die üblichen Mechanismen minimiert oder versteckt ausgeführt werden. Die Laufzeit der Software wird dadurch nahezu irrelevant.  

**Nutzung von Outlook und Word während der Laufzeit**  
Die Software startet Outlook nicht, alle Abfragen und Konfigurationen erfolgen über das Dateisystem und die Registry.

Outlook kann während der Ausführung der Software nach Belieben gestartet, verwendet oder geschlossen werden.

Sämtliche Änderungen an Signaturen und Abwesenheits-Benachrichtigungen sind für den Benutzer sofort sichtbar und verwendbar, mit einer Ausnahme: Falls sich der Name der zu verwendenden Standard-Signatur für neue E-Mails oder für Antworten und Weiterleitungen ändert, so greift diese Änderung erst beim nächsten Start von Outlook. Ändert sich nur der Inhalt, aber nicht der Name einer der Standard-Signaturen, so ist diese Änderung sofort verfügbar.

Word kann während der Ausführung der Software nach Belieben gestartet, verwendet oder geschlossen werden.

Die Software nutzt Word zum Ersatz von Variablen in DOCX-Vorlagen und zum Konvertieren von DOCX und HTML nach RTF. Word wird dabei als eigener unsichtbarer Prozess gestartet. Dieser Prozess kann vom Benutzer praktisch nicht beeinflusst werden und beeinflusst vom Benutzer gestartete Word-Prozesse nicht.

### 6.3. Laufender Betrieb  

Als IT-Dienstleister unterstützen wir unsere Konzerngesellschaften auch im laufenden Betrieb von Set-OutlookSignatures mit unserer gesamten Erfahrung. Darunter fallen beispielsweise Fragen zu:

- Erstellen und Warten von Vorlagen
- Erstellen und Warten von Ablage-Shares für Vorlagen und Software-Komponenten
- Setzen und Warten von AD-Attributen oder Attributen in anderen Datenquellen
- Konfigurationsanpassungen
- Allgemeine Fragen zum laufenden Betrieb
