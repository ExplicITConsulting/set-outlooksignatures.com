---
layout: page
lang: de
title: Implementierungs-Ansatz
subtitle: Erfahrungen aus der Praxis bei der Implementierung der Software in Multi-Client-Umgebungen mit einer fünfstelligen Anzahl von Postfächern
description: Erfahrungen aus der Praxis bei der Implementierung der Software in Multi-Client-Umgebungen mit einer fünfstelligen Anzahl von Postfächern
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
---


## Welcher Ansatz für die Implementierung der Software wird empfohlen? <!-- omit in toc -->
Es gibt sicherlich keine endgültige allgemeine Empfehlung, aber dieses Dokument sollte ein guter Ausgangspunkt sein.

Der Inhalt basiert auf Erfahrungen aus der Praxis bei der Implementierung der Software in Multi-Client-Umgebungen mit einer fünfstelligen Anzahl von Postfächern.

Es enthält bewährte Verfahren und Empfehlungen für Produktmanager, Architekten, Betriebsleiter, Kundenbetreuer sowie Mail- und Client-Administratoren. Es ist sowohl für Dienstanbieter als auch für Kunden geeignet.

Es deckt mehrere allgemeine Überblicksthemen, Administration, Support, Training über den gesamten Lebenszyklus von der Beratung über Tests, Pilotbetrieb und Rollout bis hin zum Tagesgeschäft ab.


## Table of Contents  <!-- omit in toc -->
- [1. Überblick](#1-überblick)
- [2. Manuelle Wartung von Signaturen](#2-manuelle-wartung-von-signaturen)
  - [2.1. Signaturen in Outlook](#21-signaturen-in-outlook)
  - [2.2. Signatur in Outlook im Web](#22-signatur-in-outlook-im-web)
- [3. Automatische Wartung von Signaturen](#3-automatische-wartung-von-signaturen)
  - [3.1. Serverbasierte Signaturen](#31-serverbasierte-signaturen)
  - [3.2. Clientbasierte Signaturen](#32-clientbasierte-signaturen)
- [4. Kritierien](#4-kritierien)
- [5. Abgleich von Signaturen zwischen verschiedenen Geräten](#5-abgleich-von-signaturen-zwischen-verschiedenen-geräten)
- [6. Empfehlung: Set-OutlookSignatures](#6-empfehlung-set-outlooksignatures)
  - [6.1. Allgemeine Beschreibung, Lizenzmodell](#61-allgemeine-beschreibung-lizenzmodell)
  - [6.2. Funktionen](#62-funktionen)
- [7. Administration](#7-administration)
  - [7.1. Client](#71-client)
  - [7.2. Server](#72-server)
  - [7.3. Ablage der Vorlagen](#73-ablage-der-vorlagen)
  - [7.4. Verwaltung der Vorlagen](#74-verwaltung-der-vorlagen)
  - [7.5. Ausführen der Software](#75-ausführen-der-software)
    - [7.5.1. Parameter](#751-parameter)
    - [7.5.2. Laufzeit und Sichtbarkeit der software](#752-laufzeit-und-sichtbarkeit-der-software)
    - [7.5.3. Nutzung von Outlook und Word während der Laufzeit](#753-nutzung-von-outlook-und-word-während-der-laufzeit)
- [8. Unterstützung durch den Service-Provider](#8-unterstützung-durch-den-service-provider)
  - [8.1. Beratungs- und Einführungsphase](#81-beratungs--und-einführungsphase)
    - [8.1.1. Erstabstimmung zu textuellen Signaturen](#811-erstabstimmung-zu-textuellen-signaturen)
      - [8.1.1.1. Teilnehmer](#8111-teilnehmer)
      - [8.1.1.2. Inhalt und Ziele](#8112-inhalt-und-ziele)
      - [8.1.1.3. Dauer](#8113-dauer)
    - [8.1.2. Schulung der Vorlagen-Verwalter](#812-schulung-der-vorlagen-verwalter)
      - [8.1.2.1. Teilnehmer](#8121-teilnehmer)
      - [8.1.2.2. Inhalt und Ziele](#8122-inhalt-und-ziele)
      - [8.1.2.3. Dauer](#8123-dauer)
      - [8.1.2.4. Voraussetzungen](#8124-voraussetzungen)
    - [8.1.3. Schulung des Clientmanagements](#813-schulung-des-clientmanagements)
      - [8.1.3.1. Teilnehmer](#8131-teilnehmer)
      - [8.1.3.2. Inhalt und Ziele](#8132-inhalt-und-ziele)
      - [8.1.3.3. Dauer](#8133-dauer)
      - [8.1.3.4. Voraussetzungen](#8134-voraussetzungen)
  - [8.2. Tests, Pilotbetrieb, Rollout](#82-tests-pilotbetrieb-rollout)
- [9. Laufender Betrieb](#9-laufender-betrieb)
  - [9.1. Erstellen und Warten von Vorlagen](#91-erstellen-und-warten-von-vorlagen)
  - [9.2. Erstellen und Warten von Ablage-Shares für Vorlagen und Software-Komponenten](#92-erstellen-und-warten-von-ablage-shares-für-vorlagen-und-software-komponenten)
  - [9.3. Setzen und Warten von AD-Attributen](#93-setzen-und-warten-von-ad-attributen)
  - [9.4. Konfigurationsanpassungen](#94-konfigurationsanpassungen)
  - [9.5. Probleme und Fragen im laufenden Betrieb](#95-probleme-und-fragen-im-laufenden-betrieb)
  - [9.6. Unterstützte Versionen](#96-unterstützte-versionen)
  - [9.7. Neue Versionen](#97-neue-versionen)
  - [9.8. Anpassungen am Code des Produkts](#98-anpassungen-am-code-des-produkts)


## 1. Überblick  
Textuelle Signaturen sind nicht nur ein wesentlicher Aspekt der Corporate Identity, sondern gemeinsam mit dem Disclaimer im Regelfall eine rechtliche Notwendigkeit.

Dieses Dokument bietet einen generellen Überblick über Signaturen, Anleitungen für Endbenutzer, sowie Details zur vom Service-Provider empfohlenen Lösung zur zentralen Verwaltung und automatisierten Verteilung von textuellen Signaturen.

Das Wort "Signatur" ist in diesem Dokument immer als textuelle Signatur zu verstehen und nicht mit einer digitalen Signatur, die der Verschlüsselung von emails und/oder der Legitimierung des Absenders dient, zu verwechseln.


## 2. Manuelle Wartung von Signaturen  
Bei der manuellen Wartung wird dem Benutzer z. B. über das Intranet eine Vorlage für die textuelle Signatur zur Verfügung gestellt.

Jeder Benutzer richtet sich die Signatur selbst ein. Je nach technischer Konfiguration des Clients wandern Signaturen bei einem Wechsel des verwendeten Computers mit oder sind neu einzurichten.

Eine zentrale Wartung gibt es nicht.
### 2.1. Signaturen in Outlook  
In Outlook können pro Postfach praktisch beliebig viele Signaturen erstellt werden. Dies ist beispielsweise praktisch, um zwischen internen und externen emails, oder emails in verschiedenen Sprachen zu unterscheiden.

Pro Postfach kann darüber hinaus eine Standard-Signatur für neue emails und eine für Antworten festgelegt werden.   
### 2.2. Signatur in Outlook im Web  
Falls Sie auch mit Outlook im Web arbeiten, müssen Sie sich unabhängig von Ihrer Signatur am Client Ihre Signatur in Outlook im Web einrichten:  
1. Melden Sie sich in einem Webbrowser auf <a href="https://mail.example.com">https<area>://mail.example.com</a> an. Geben Sie Ihren Benutzernamen und Ihr Kennwort ein, und klicken Sie dann auf Anmelden.  
2. Wählen Sie auf der Navigationsleiste Einstellungen > Optionen aus.  
3. Wählen Sie unter Optionen den Befehl Einstellungen > email aus.  
4. Geben Sie im Textfeld unter email-Signatur die Signatur ein, die Sie verwenden möchten. Verwenden Sie die Minisymbolleiste "Formatieren", um das Aussehen der Signatur zu ändern.  
5. Wenn Ihre Signatur automatisch am Ende aller ausgehenden Nachrichten angezeigt werden soll, und zwar auch in Antworten und weitergeleiteten Nachrichten, aktivieren Sie Signatur automatisch in meine gesendeten Nachrichten einschließen. Wenn Sie diese Option nicht aktivieren, können Sie Ihre Signatur jeder Nachricht manuell hinzufügen.  
6. Klicken Sie auf Speichern.

In Outlook im Web ist nur eine einzige Signatur möglich, außer das Postfach befindet sich in Exchange Online und die Funktion Roaming Signatures wurde aktiviert.


## 3. Automatische Wartung von Signaturen  
Der Service-Provider empfiehlt eine Lösung mit zentraler Verwaltung und erweitertem clientseitigen Funktionsumfang, die im Kern kostenlos und quelloffen ist, und mit Unterstützung des Service-Providers von den Kunden selbst betrieben und gewartet werden kann. Details siehe "Empfehlung: Set-OutlookSignatures Benefact Circle".  
### 3.1. Serverbasierte Signaturen  
Der größte Vorteil einer serverbasierten Lösung ist, dass an Hand eines definierten Regelsets jedes email erfasst wird, ganz gleich, von welcher Applikation oder welchem Gerät es verschickt wurde.

Da die Signatur erst am Server angehängt wird, sieht der Benutzer während der Erstellung eines emails nicht, welche Signatur verwendet wird.

Nachdem die Signatur am Server angehängt wurde, muss das nun veränderte email vom Client neu heruntergeladen werden, damit es im Ordner „Gesendete Elemente“ korrekt angezeigt wird. Das erzeugt zusätzlichen Netzwerkverkehr.

Wird eine Nachricht schon bei Erstellung digital signiert oder verschlüsselt, kann die textuelle Signatur serverseitig nicht hinzugefügt werden, ohne die digitale Signatur und die Verschlüsselung zu brechen. Alternativ wird die Nachricht so angepasst, dass der Inhalt nur aus der textuellen Signatur besteht und unveränderte ursprüngliche Nachricht als Anhang mitgeschickt wird.
### 3.2. Clientbasierte Signaturen  
Bei clientbasierten Lösungen werden in einer zentralen Ablage Vorlagen und Anwendungsregeln für textuelle Signaturen definiert. Eine Komponente am Client prüft bei automatisiertem oder manuellen Aufruf die zentrale Konfiguration und wendet sie lokal an.

Clientbasierte Lösungen sind im Gegensatz zu serverbasierten Lösungen an bestimmte email-Clients und bestimmte Betriebssysteme gebunden.

Der Benutzer sieht die Signatur bereits während der Erstellung des emails und kann diese gegebenenfalls anpassen.

Die Verschlüsselung und das digitale Signieren von Nachrichten stellen weder client- noch serverseitig ein Problem dar.


## 4. Kritierien
Bei der Evaluierung von Produkten sollten unter anderem folgende Aspekte geprüft werden:  
- Kann das Produkt mit der Anzahl der AD- und Mail-Objekte in der Umgebung ohne reproduzierbare Abstürze oder unvollständige Suchergebnissen umgehen?  
- Muss das Produkt direkt auf den Mail-Servern installiert werden? Das bedeutet zusätzliche Abhängigkeiten und Fehlerquellen, und kann sich negativ auf Verfügbarkeit und Zuverlässigkeit des AD- und Mail-Systems auswirken.  
- Kann die Administration der Produkte ohne Vergabe erheblicher Rechte direkt auf den Mail-Servern delegiert werden?
- Können Kunden separat voneinander berechtigt werden?  
- Können Variablen in den Signaturen nur mit Werten des aktuellen Benutzers ersetzt werden, oder auch mit Werten des aktuellen Postfachs und des jeweiligen Managers?
- Kann eine Vorlagen-Datei unter verschiedenen Signatur-Namen verwendet werden?
- Können Vorlagen zielgerichtet verteilt werden? Allgemein, nach Gruppenzugehörigkeit, nach email-Adresse? Kann nur zugewiesen oder auch verboten werden?
- Kann die Lösung mit gemeinsam verwendeten Postfächern umgehen?
- Kann die Lösung mit zusätzlichen Postfächern umgehen, die z. B. per Automapping verteilt wurden?
- Können Bilder in Signaturen attributgesteuert ein- und ausgeblendet werden?
- Kann die Lösung mit Roaming Signatures in Exchange Online umgehen?
- Wie hoch sind die Anschaffungs- und Wartungskosten? Liegen diese über der Ausschreibungsgrenze?
- Müssen emails in eine Cloud des Herstellers umgeleitet werden?
- Muss der SPF-Eintrag im DNS angepasst werden?


## 5. Abgleich von Signaturen zwischen verschiedenen Geräten  
Die Signaturen in Outlook, Outlook im Web und anderen Clients (z. B. in Smartphone-Apps) sind nicht synchronisiert und müssen daher separat eingerichtet werden.

Je nach Client-Konfiguration wandern Outlook-Signaturen mit dem Benutzer zwischen verschiedenen Windows-Geräten mit oder nicht, für Details wenden Sie sich bitte an Ihre lokale IT.

Das vom Service-Provider empfohlene clientbasierte Werkzeug kann Signaturen sowohl in Outlook als auch in Outlook im Web setzen und bietet dem Benutzer darüber hinaus eine einfache Möglichkeit zur Übernahme bestehender Signaturen in weitere email-Clients an.

Das empfohlene Produkt unterstützt bereits die Roaming Signatures von Exchange Online. Es ist davon auszugehen, dass Mail-Clients (z. B. Smartphone-Apps) in absehbarer Zeit nachziehen.


## 6. Empfehlung: Set-OutlookSignatures  
Der Service-Provider empfiehlt nach einer Erhebung der Kundenanforderungen und Tests mehrerer server- und clientbasierten Produkte die kostenlose Open-Source-Software Set-OutlookSignatures mit der kostenpflichtigen "Benefactor Circle"-Erweiterung und bietet seinen Kunden Unterstützung bei Einführung und Betrieb an.  

Dieses Dokument bietet einen Überblick über Funktionsumfang und Administration der empfohlenen Lösung, Unterstützung des Service-Providers bei Einführung und Betrieb, sowie damit verbundene Aufwände.  
### 6.1. Allgemeine Beschreibung, Lizenzmodell  
<a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures">Set-OutlookSignatures</a> ist ein kostenloses Open-Source-Produkt mit einer kostenpflichtigen Erweiterung für unternehmensrelevante Funktionen.

Das Produkt dient der zentralen Verwaltung und lokalen Verteilung textueller Signaturen und Abwesenheits-Nachrichten auf Clients. Als Zielplattform werden dabei Outlook auf Windows, New Outlook und Outlook Web unterstützt.

Die Einbindung in den mit Hilfe von AppLocker und anderen Mechanismen wie z. B. Microsoft Purview Informatoin Protection abgesicherten Client ist durch etablierte Maßnahmen (wie z. B. dem digitalen Signieren von PowerShell-Scripts) technisch und organisatorisch einfach möglich.  
### 6.2. Funktionen  
**Signaturen und OOF-Nachrichten können:**
- Aus **Vorlagen im DOCX- oder HTML**-Dateiformat generiert werden  
- Mit einer **großen Auswahl an Variablen**, einschließlich **Fotos**, aus Active Directory und anderen Quellen angepasst werden
  - Variablen sind für den **aktuell angemeldeten Benutzer, den Manager dieses Benutzers, jedes Postfach und den Manager jedes Postfachs** verfügbar
  - Bilder in Signaturen können **an das Vorhandensein bestimmter Variablen** gebunden werden (nützlich z. B. für optionale Icons sozialer Netzwerke)
- Angewandt werden auf alle **Postfächer (einschließlich gemeinsam genutzter Postfächer)**, bestimmte **Postfachgruppen** oder bestimmte **email-Adressen**, für **jedes Postfach in allen Outlook-Profilen** (**automatisierte und zusätzliche Postfächer** sind optional)  
- Mit unterschiedlichen Namen aus derselben Vorlage erstellt (z.B. **eine Vorlage kann für mehrere gemeinsame Postfächer verwendet werden**)
- Innerhalb zugewiesener **Zeitbereiche**, innerhalb derer sie gültig sind, verwendet werden  
- Als **Standardsignatur** für neue emails oder für Antworten und Weiterleitungen festgelegt werden (nur Signaturen)  
- Als **Standard-OOF-Nachricht** für interne oder externe Empfänger festgelegt werden (nur OOF-Nachrichten)  
- Nach **Outlook Web** für den aktuell angemeldeten Benutzer synchronisiert werden  
- Nur zentral verwaltet sein oder **mit vom Benutzer erstellten Signaturen** koexistieren (nur Signaturen)  
- In einen **alternativen Pfad** kopiert werden für einfachen Zugriff auf mobilen Geräten (nur Signaturen)
- **Schreibgeschützt** (nur Outlook-Signaturen)
- Gespiegelt in die Cloud als **Roaming-Signaturen**

Set-Outlooksignatures kann **von Benutzern auf Clients oder auf einem Server ohne Interaktion des Endbenutzers** ausgeführt werden.  
Auf den Clients kann es als Teil des Anmeldescripts, als geplante Aufgabe oder auf Wunsch des Benutzers über ein Desktop-Symbol, einen Startmenüeintrag, eine Verknüpfung oder eine andere Art des Programmstarts ausgeführt werden.  
Signaturen und OOF-Nachrichten können auch zentral erstellt und bereitgestellt werden, ohne dass der Endbenutzer oder der Client beteiligt sind.

**Beispielvorlagen** für Signaturen und OOF-Nachrichten demonstrieren alle verfügbaren Funktionen und werden als .docx- und .htm-Dateien bereitgestellt.

Der **Simulationsmodus** ermöglicht es Inhaltserstellern und Administratoren, das Verhalten der Software zu simulieren und die resultierenden Signaturdateien zu überprüfen, bevor sie in Betrieb gehen.
  
Die Software ist **für den Einsatz in großen und komplexen Umgebungen** (Exchange Resource Forest-Szenarien, AD-übergreifende Trusts, mehrstufige AD-Subdomänen, viele Objekte) konzipiert. Es funktioniert **vor Ort, in hybriden und reinen Cloud-Umgebungen**.

Es ist **multimandantenfähig** durch die Verwendung verschiedener Vorlagenpfade, Konfigurationsdateien und Softwareparameter.

Set-OutlookSignatures erfordert **keine Installation auf Servern oder Clients**. Sie benötigen lediglich eine Standard-Dateifreigabe auf einem Server sowie PowerShell und Office.


## 7. Administration  
### 7.1. Client  
- Outlook und Word (bei Verwendung von DOCX-Vorlagen, und/oder Signaturen im RTF-Format), jeweils ab Version 2010  
- Die Software muss im Sicherheitskontext des aktuell angemeldeten Benutzers laufen.  
- Die Software muss im „Full Language Mode” ausgeführt werden. Der „Constrained Language Mode“ wird nicht unterstützt, da gewisse Funktionen wie z. B. Base64-Konvertierungen in diesem Modus nicht verfügbar sind oder sehr langsame Alternativen benötigen.  
- Falls AppLocker oder vergleichbare Lösungen zum Einsatz kommen, ist die Software bereits digital signiert.  
- Netzwerkfreischaltungen:  
	- Die Ports 389 (LDAP) and 3268 (Global Catalog), jeweils TCP and UDP, müssen zwischen Client und allen Domain Controllern freigeschaltet sein. Falls dies nicht der Fall ist, können signaturrelevante Informationen und Variablen nicht abgerufen werden. Die Software prüft bei jedem Lauf, ob der Zugriff möglich ist.  
	- Für den Zugriff auf den SMB-File-Share mit den Software-Komponenten werden folgende Ports benötigt: 137 UDP, 138 UDP, 139 TCP, 445 TCP (Details <a href="https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731402(v=ws.11)">in diesem Microsoft-Artikel</a>).  
	- Für den Zugriff auf SharePoint Dokumentbibliotheken wird Port 443 TCP benötigt. Firewalls und Proxies dürfen WebDAV HTTP Extensions nicht blockieren.  
### 7.2. Server  
Benötigt werden:
- Ein SMB-File-Share, in den die Software und seine Komponenten abgelegt werden. Auf diesen File-Share und seine Inhalte müssen alle Benutzer lesend zugreifen können.  
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

Für maximale Leistung und Flexibilität wird empfohlen, dass jeder Kunde die Software in einem eigenen SMB-File-Share ablegt und diesen gegebenenfalls über Standorte hinweg auf verschiedene Server repliziert.  
### 7.3. Ablage der Vorlagen  
Wie in den Systemanforderungen beschrieben, können Vorlagen für Signaturen und Abwesenheitsnachrichten analog zur Software selbst auf SMB-File-Shares oder SharePoint Dokumentbibliotheken abgelegt werden.

SharePoint-Dokumentbibliotheken haben den Vorteil der optionalen Versionierung von Dateien, so dass im Fehlerfall durch die Vorlagen-Verwalter rasch eine frühere Version einer Vorlage wiederhergestellt werden kann.

Es wird pro Kunde zumindest ein Share mit separaten Unterverzeichnissen für Signatur- und Abwesenheits-Vorlagen empfohlen.

Benutzer benötigen lesenden Zugriff auf alle Vorlagen.

Durch simple Vergabe von Schreibrechten auf den gesamten Vorlagen-Ordner oder auf einzelne Dateien darin wird die Erstellung und Verwaltung von Signatur- und Abwesenheits-Vorlagen an eine definierte Gruppe von Personen delegiert. Üblicherweise werden die Vorlagen von den Abteilungen Unternehmenskommunikation und Marketing definiert, erstellt und gewartet.

Für maximale Leistung und Flexibilität wird empfohlen, dass jeder Kunde die Software in einem eigenen SMB-File-Share ablegt und diesen gegebenenfalls über Standorte hinweg auf verschiedene Server repliziert.  
### 7.4. Verwaltung der Vorlagen  
Durch simple Vergabe von Schreibrechten auf den Vorlagen-Ordner oder auf einzelne Dateien darin wird die Erstellung und Verwaltung von Signatur- und Abwesenheits-Vorlagen an eine definierte Gruppe von Personen delegiert. Üblicherweise werden die Vorlagen von den Abteilungen Unternehmenskommunikation und Marketing definiert, erstellt und gewartet.

Die Software kann Vorlagen im DOCX- oder im HTML-Format verarbeiten. Für den Anfang wird die Verwendung des DOCX-Formats empfohlen; die Gründe für diese Empfehlung und die Vor- und Nachteile des jeweiligen Formats werden in der `README`-Datei der Software beschrieben.

Die mit der Software mitgelieferte `README`-Datei bietet eine Übersicht, wie Vorlagen zu administrieren sind, damit sie  
- nur für bestimmte Gruppen oder Postfächer gelten  
- als Standard-Signatur für neue Mails oder Antworten und Weiterleitungen gesetzt werden  
- als interne oder externe Abwesenheits-Nachricht gesetzt werden
- und vieles mehr

In `README` und den Beispiel-Vorlagen werden zudem die ersetzbaren Variablen, die Erweiterung um benutzerdefinierte Variablen und der Umgang mit Fotos aus dem Active Directory beschrieben.

In der mitgelieferten Beispiel-Datei „Test all signature replacement variables.docx“ sind alle standardmäßig verfügbaren Variablen enthalten; zusätzlich können eigene Variablen definiert werden.
### 7.5. Ausführen der Software
Die Software kann über einen beliebigen Mechanismus ausgeführt werden, beispielsweise  
- bei Anmeldung des Benutzers als Teil des Logon-Scripts oder als eigenes Script  
- über die Aufgabenplanung zu fixen Zeiten oder bei bestimmten Ereignissen  
- durch den Benutzer selbst, z. B. über eine Verknüpfung auf dem Desktop  
- durch ein Werkzeug zur Client-Verwaltung

Da es sich bei Set-OutlookSignatures hauptsächlich um ein PowerShell-Script handelt, erfolgt der Aufruf wie bei jedem anderen Script dieses Dateityps:

```
powershell.exe <PowerShell-Parameter> -file "<Pfad zu Set-OutlookSignatures.ps1>" <Script-Parameter>  
```

#### 7.5.1. Parameter  
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
#### 7.5.2. Laufzeit und Sichtbarkeit der software 
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
- Abfrage aller per Trust verbundenen Domains  
- 9 zu verarbeitende Signatur-Vorlagen, alle mit Variablen und Grafiken (aber ohne Benutzerfotos), teilweise auf Gruppen und Mail-Adressen eingeschränkt  
- 8 zu verarbeitende Abwesenheits-Vorlagen, alle mit Variablen und Grafiken (aber ohne Benutzerfotos), teilweise auf Gruppen und Mail-Adressen eingeschränkt  
- Setzen der Signatur in Outlook im Web  
- Kein Kopieren der Signaturen auf einen zusätzlichen Netzwerkpfad
  
Da die Software keine Benutzerinteraktion erfordert, kann es über die üblichen Mechanismen minimiert oder versteckt ausgeführt werden. Die Laufzeit der Software wird dadurch nahezu irrelevant.  
#### 7.5.3. Nutzung von Outlook und Word während der Laufzeit  
Die Software startet Outlook nicht, alle Abfragen und Konfigurationen erfolgen über das Dateisystem und die Registry.

Outlook kann während der Ausführung der Software nach Belieben gestartet, verwendet oder geschlossen werden.

Sämtliche Änderungen an Signaturen und Abwesenheits-Benachrichtigungen sind für den Benutzer sofort sichtbar und verwendbar, mit einer Ausnahme: Falls sich der Name der zu verwendenden Standard-Signatur für neue emails oder für Antworten und Weiterleitungen ändert, so greift diese Änderung erst beim nächsten Start von Outlook. Ändert sich nur der Inhalt, aber nicht der Name einer der Standard-Signaturen, so ist diese Änderung sofort verfügbar.

Word kann während der Ausführung der Software nach Belieben gestartet, verwendet oder geschlossen werden.

Die Software nutzt Word zum Ersatz von Variablen in DOCX-Vorlagen und zum Konvertieren von DOCX und HTML nach RTF. Word wird dabei als eigener unsichtbarer Prozess gestartet. Dieser Prozess kann vom Benutzer praktisch nicht beeinflusst werden und beeinflusst vom Benutzer gestartete Word-Prozesse nicht.


## 8. Unterstützung durch den Service-Provider  
Der Service-Provider empfiehlt die Software Set-OutlookSignatures nicht nur, sondern bietet seinen Kunden auch definierte kostenlose Unterstützung an.

Darüberhinausgehende Unterstützung kann nach vorheriger Abstimmung gegen separate Verrechnung bezogen werden.

Zentrale Anlaufstelle für Fragen aller Art ist das Mail-Produktmanagement.  
### 8.1. Beratungs- und Einführungsphase  
Folgende Leistungen sind mit dem Produktpreis abgedeckt:  
#### 8.1.1. Erstabstimmung zu textuellen Signaturen  
##### 8.1.1.1. Teilnehmer  
- Kunde: Unternehmenskommunikation, Marketing, Clientmanagement, Koordinator des Vorhabens  
- Service-Provider: Mail-Produktmanagement, Mail-Betriebsführung oder Mail-Architektur  
##### 8.1.1.2. Inhalt und Ziele  
- Kunde: Vorstellung der eigenen Wünsche zu textuellen Signaturen  
- Service-Provider: Kurze Beschreibung zu prinzipiellen Möglichkeiten rund um textuelle Signaturen, Vor- und Nachteile der unterschiedlichen Ansätze, Gründe für die Entscheidung zum empfohlenen Produkt  
- Abgleich der Kundenwünsche mit den technisch-organisatorischen Möglichkeiten  
- Live-Demonstration des Produkts unter Berücksichtigung der Kundenwünsche  
- Festlegung der nächsten Schritte  
##### 8.1.1.3. Dauer  
4 Stunden  
#### 8.1.2. Schulung der Vorlagen-Verwalter  
##### 8.1.2.1. Teilnehmer  
- Kunde: Vorlagen-Verwalter (Unternehmenskommunikation, Marketing, Analytiker), optional Clientmanagement, Koordinator des Vorhabens  
- Service-Provider: Mail-Produktmanagement, Mail-Betriebsführung oder Mail-Architektur  
##### 8.1.2.2. Inhalt und Ziele  
- Zusammenfassung des vorangegangenen Termins „Erstabstimmung zu textuellen Signaturen“, mit Fokus auf gewünschte und realisierbare Funktionen  
- Vorstellung des Aufbaus der Vorlagen-Verzeichnisse, mit Fokus auf  
- Namenskonventionen  
- Anwendungsreihenfolge (allgemein, gruppenspezifisch, postfachspezifisch, in jeder Gruppe alphabetisch)  
- Festlegung von Standard-Signaturen für neue emails und für Antworten und Weiterleitungen  
- Festlegung von Abwesenheits-Texten für interne und externe Empfänger.  
- Festlegung der zeitlichen Gültigkeit von Vorlagen  
- Variablen und Benutzerfotos in Vorlagen  
- Unterschiede DOCX- und HTML-Format  
- Möglichkeiten zur Einbindung eines Disclaimers  
- Gemeinsame Erarbeitung erster Vorlagen auf Basis bestehender Vorlagen und Kundenanforderungen  
- Live-Demonstration auf einem Standard-Client mit einem Testbenutzer und Testpostfächern des Kunden (siehe Voraussetzungen)  
##### 8.1.2.3. Dauer  
4 Stunden  
##### 8.1.2.4. Voraussetzungen  
- Der Kunde stellt einen Standard-Client mit Outlook und Word zu fVerfügung.  
- Der Bildschirminhalt des Clients muss zur gemeinsamen Arbeit per Beamer projiziert oder auf einem entsprechend großen Monitor dargestellt werden können.  
- Der Kunde stellt einen Testbenutzer zur Verfügung. Dieser Testbenutzer muss auf dem Standard-Client  
	- einmalig Dateien aus dem Internet (github.com) herunterladen dürfen (alternativ kann der Kunde einen BitLocker-verschlüsselten USB-Stick für die Datenübertragung stellen).  
	- signierte PowerShell-Scripte im Full Language Mode ausführen dürfen  
	- über ein Mail-Postfach verfügen  
	- Vollzugriff auf diverse Testpostfächer (persönliche Postfächer oder Gruppenpostfächer) haben, die nach Möglichkeit direkt oder indirekt Mitglied in diversen Gruppen oder Verteilerlisten sind. Für den Vollzugriff kann der Benutzer auf die anderen Postfächer entsprechend berechtigt sein, oder Benutzername und Passwort der zusätzlichen Postfächer sind bekannt.  
#### 8.1.3. Schulung des Clientmanagements  
##### 8.1.3.1. Teilnehmer  
- Kunde: Clientmanagement, optional ein Administrator des Active Directory, optional ein Administrator des File-Servers und/oder SharePoint-Server, optional Unternehmenskommunikation und Marketing, Koordinator des Vorhabens  
- Service-Provider: Mail-Produktmanagement, Mail-Betriebsführung oder Mail-Architektur, ein Vertreter des Client-Teams bei entsprechenden Kunden  
##### 8.1.3.2. Inhalt und Ziele  
- Zusammenfassung des vorangegangenen Termins „Erstabstimmung zu textuellen Signaturen“, mit Fokus auf gewünschte und realisierbare Funktionen  
- Vorstellung der Möglichkeiten mit Fokus auf  
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
##### 8.1.3.3. Dauer  
4 Stunden  
##### 8.1.3.4. Voraussetzungen  
- Der Kunde stellt einen Standard-Client mit Outlook und Word zu Verfügung.  
- Der Bildschirminhalt des Clients muss zur gemeinsamen Arbeit per Beamer projiziert oder auf einem entsprechend großen Monitor dargestellt werden können.  
- Der Kunde stellt einen Testbenutzer zur Verfügung. Dieser Testbenutzer muss auf dem Standard-Client  
	- einmalig Dateien aus dem Internet (github.com) herunterladen dürfen (alternativ kann der Kunde einen BitLocker-verschlüsselten USB-Stick für die Datenübertragung stellen).  
	- signierte PowerShell-Scripte im Full Language Mode ausführen dürfen
	- über ein Mail-Postfach verfügen  
	- Vollzugriff auf diverse Testpostfächer (persönliche Postfächer oder Gruppenpostfächer) haben, die nach Möglichkeit direkt oder indirekt Mitglied in diversen Gruppen oder Verteilerlisten sind. Für den Vollzugriff kann der Benutzer auf die anderen Postfächer entsprechend berechtigt sein, oder Benutzername und Passwort der zusätzlichen Postfächer sind bekannt.  
- Der Kunde stellt mindestens einen zentralen SMB-Share oder eine SharePoint Dokumentbibliothek für die Ablage der Vorlagen zur Verfügung.  
- Der Kunde stellt einen zentralen SMB-File-Share für die Ablage der Software und seiner Komponenten zur Verfügung.  
### 8.2. Tests, Pilotbetrieb, Rollout  
Die Planung und Koordination von Tests, Pilotbetrieb und Rollout erfolgt durch den Vorhabens-Verantwortlichen des Kunden.

Die konkrete technische Umsetzung erfolgt durch den Kunden. Falls zusätzlich zu Mail auch der Client durch Service-Provider betreut wird, unterstützt das Client-Team bei der Einbindung der Software (Logon-Script, geplante Aufgabe, Desktop-Verknüpfung).

Bei prinzipiellen technischen Problemen unterstützt das Mail-Produktmanagement bei der Ursachenforschung, arbeitet Lösungsvorschläge aus und stellt gegebenenfalls den Kontakt zum Hersteller des Produkts her.

Die Erstellung und Wartung von Vorlagen ist Aufgabe des Kunden

Zur Vorgehensweise bei Anpassungen am Code oder der Veröffentlichung neuer Funktionen siehe Kapitel „Laufender Betrieb“.


## 9. Laufender Betrieb  
### 9.1. Erstellen und Warten von Vorlagen  
Das Erstellen und Warten von Vorlagen ist Aufgabe des Kunden.  
Das Mail-Produktmanagement steht für Fragen zu Realisierbarkeit und Auswirkungen beratend zur Verfügung.

### 9.2. Erstellen und Warten von Ablage-Shares für Vorlagen und Software-Komponenten  
Das Erstellen und Warten von Ablage-Shares für Vorlagen und Software-Komponenten ist Aufgabe des Kunden.

Das Mail-Produktmanagement steht für Fragen zu Realisierbarkeit und Auswirkungen beratend zur Verfügung.  
### 9.3. Setzen und Warten von AD-Attributen  
Das Setzen und Warten von AD-Attributen, die im Zusammenhang mit textuellen Signaturen stehen (z. B. Attribute für Variablen, Benutzerfotos, Gruppenmitgliedschaften), ist Aufgabe des Kunden.

Das Mail-Produktmanagement steht für Fragen zu Realisierbarkeit und Auswirkungen beratend zur Verfügung.  
### 9.4. Konfigurationsanpassungen  
Konfigurationsanpassungen, die von den Entwicklern der Software explizit vorgesehen sind, werden jederzeit unterstützt.

Das Mail-Produktmanagement steht für Fragen zur Realisierbarkeit und den Auswirkungen gewünschter Anpassungen beratend zur Verfügung.

Die Planung und Koordination von Tests, Pilotbetrieb und Rollout im Zusammenhang mit Konfigurationsanpassungen erfolgt ebenso durch den Kunden wie die konkrete technische Umsetzung.

Falls zusätzlich zu Mail auch der Client durch den Service-Provider betreut wird, unterstützt das Client-Team bei der Einbindung der Software (Logon-Script, geplante Aufgabe, Desktop-Verknüpfung).  
### 9.5. Probleme und Fragen im laufenden Betrieb  
Bei prinzipiellen technischen Problemen unterstützt das Mail-Produktmanagement bei der Ursachenforschung, arbeitet Lösungsvorschläge aus und stellt gegebenenfalls den Kontakt zum Hersteller des Produkts her.

Für allgemeine Fragen zum Produkt und dessen Anwendungsmöglichkeiten steht ebenfalls das Mail-Produktmanagement zur Verfügung.  
### 9.6. Unterstützte Versionen  
Die Versionsnummern des Produkts folgen den Vorgaben des Semantic Versioning und sind daher nach dem Format „Major.Minor.Patch“ aufgebaut.  
- „Major“ wird erhöht, wenn die Kompatibilität zu bisherigen Versionen nicht mehr gegeben ist.  
- „Minor“ wird erhöht, wenn neue Funktionen, die zu bisherigen Versionen kompatibel sind, eingeführt werden.  
- „Patch“ wird erhöht, wenn die Änderungen ausschließlich zu bisherigen Versionen kompatible Fehlerbehebungen umfassen.  
- Zusätzlich sind Bezeichner für Vorveröffentlichungen und Build-Metadaten als Anhänge zum „Major.Minor.Patch“-Format verfügbar, z. B. „-Beta1“.

Vom Service-Provider unterstützte Versionen:  
- Die höchste vom Service-Provider freigegebene Version des Produkts, unabhängig von deren Veröffentlichungsdatum.  
- Die Unterstützung einer freigegeben Version endet automatisch drei monate nach Freigabe einer höheren Version.

Kunden haben nach Freigabe einer neuen Version also drei Monate Zeit, auf diese Version umzusteigen, bevor der Service-Provider-Support für davor freigegebene Versionen erlischt.

Somit ist in einem 3-Monats-Zeitraum nie mehr als eine Aktualisierung notwendig. Dies schützt sowohl Kunden als auch Service-Provider vor groben Fehlern in der Produktentwicklung.  
### 9.7. Neue Versionen  
Wenn neue Versionen des Produkts veröffentlicht werden, informiert das Mail-Produktmanagement vom Kunden definierte Ansprechpartner über die mit dieser Version verbundenen Änderungen, mögliche Auswirkungen auf die bestehende Konfiguration und zeigt Aktualisierungsmöglichkeiten auf.

Die Planung und Koordination der Einführung der neuen Version erfolgt durch den Ansprechpartner beim Kunden.

Die konkrete technische Umsetzung erfolgt ebenfalls durch den Kunden. Falls zusätzlich zu Mail auch der Client durch Service-Provider betreut wird, unterstützt das Client-Team bei der Einbindung der Software (Logon-Script, geplante Aufgabe, Desktop-Verknüpfung).

Bei prinzipiellen technischen Problemen unterstützt das Mail-Produktmanagement bei der Ursachenforschung, arbeitet Lösungsvorschläge aus und stellt gegebenenfalls den Kontakt zum Hersteller des Produkts her.  
### 9.8. Anpassungen am Code des Produkts  
Falls Anpassungen am Code des Produkts gewünscht werden, werden die damit verbundenen Aufwände geschätzt und nach Beauftragung separat verrechnet.

Entsprechend dem Open-Source-Gedanken des Produkts werden die Code-Anpassungen als Verbesserungsvorschlag an die Entwickler des Produkts übermittelt.

Um die Wartbarkeit des Produkts sicherzustellen, kann der Service-Provider nur Code unterstützen, der auch offiziell in das Produkt übernommen wird. Jedem Kunden steht es frei, den Code des Produkts selbst anzupassen, in diesem Fall kann der Service-Provider allerdings keine Unterstützung mehr anbieten. Für Details, siehe „Unterstützte Versionen“.
