---
layout: page
lang: de
locale: de
title: Funktionen und Funktions-Vergleich
subtitle: Unsere Lösung auf einen Blick und im Vergleich
description: Unsere Lösung auf einen Blick und im Vergleich
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
---


## Funktionen&nbsp;&nbsp;&nbsp;&nbsp;<a href="#feature-comparison"><img src="https://img.shields.io/badge/zum-Funktions--Vergleich-limegreen?labelColor=black" alt="Zum Funktions-Vergleich"></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="/quickstart"><img src="https://img.shields.io/badge/zur-🚀%20Schnellstart--Anleitung%20🚀-limegreen?labelColor=black" alt="Zur Schnellstart-Anleitung"></a> {#features}
Mit SetOutlookSignatures können Signaturen und Abwesenheitsnotizen:
- Aus **Vorlagen im DOCX- oder HTML-Dateiformat** generiert werden.
- Mit einer **Vielzahl von Variablen**, einschließlich **Fotos und Bildern**, aus Entra ID, Active Directory und anderen Quellen angepasst werden.
  - Variablen stehen für den **aktuell angemeldeten Benutzer, das aktuelle Postfach und deren Manager** zur Verfügung.
- Für **barrierefreien Zugriff** gestaltet werden, mit benutzerdefinierten Link- und Bildbeschreibungen für Screenreader und ähnliche Tools.
- Flexibel zugewiesen werden: Für **alle Postfächer (auch shared mailboxes¹)**, **Postfach-Gruppen**, **E-Mail-Adressen** (auch Alias und sekundäre Adressen), auf Basis von **Benutzer- oder Postfach-Attributen**, für **jedes Postfach in allen Profilen (Outlook, New Outlook¹, Outlook Web¹)**, auch für **automapped und zusätzliche Postfächer**¹. 
- Aus einer Vorlage heraus mit unterschiedlichen Namen erstellt werden, **eine Vorlage kann für viele Postfächer genutzt werden**.
- Mit **Zeitbeschränkungen** versehen werden, innerhalb derer sie gültig sind¹.
- Als **Standard-Signatur** für neue E-Mails oder für Antworten festgelegt werden.
- Als **Standard-Abwesenheitsnotiz** für interne oder externe Empfänger festgelegt werden.
- Im **Outlook Web**¹ des angemeldeten Benutzer gesetzt werden, und auch als **Roaming Signatures** mit der Cloud synchronisiert werden (Linux/macOS/Windows, klassisches and neues Outlook¹).
- Signaturen können rein zental verwaltet werden¹, oder **parallel zu vom Benutzer erstellten Signaturen** bestehen.
- Mit dem **Outlook Add-In**¹ automatisch zu neuen E-Mails, Antworten und Weiterleitungen, sowie zu Terminen hinzugefügt werden.
- In einen **zusätzlichen Ordner**¹ kopiert werden, um den einfachen Zugriff auf Signaturen auf Mobilgeräten oder zur Verwendung mit anderen E-Mail-Clients und Apps als Outlook zu ermöglichen: Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail und andere.
- In einem **E-Mail-Entwurf mit allen verfügbaren Signaturen**¹ in HTML und reinem Text für den einfachen Zugriff in E-Mail-Clients ohne Signatur-API gesammelt werden.
- **Schreibgeschützt** werden (nur klassisches Outlook für Windows).

Set-OutlookSignatures kann von Nutzern auf **Windows-, Linux- und macOS-Clients, einschließlich gemeinsam genutzter Geräte und Terminalserver, oder auf einem zentralen System mit einem Dienstkonto**¹ ausgeführt werden.<br>Auf Clients kann es als Teil des Anmeldeskripts, als geplante Aufgabe oder auf Benutzeranforderung über ein Desktopsymbol, einen Startmenüeintrag, eine Verknüpfung oder einer andere Möglichkeit zum Starten eines Programms ausgeführt werden - **was auch immer Ihre Methode zur Verteilung von Software erlaubt**.

**Beispielvorlagen** für Signaturen und Abwesenheitsnachrichten demonstrieren viele Funktionen und stehen als DOCX- und HTM-Dateien zur Verfügung.

Der **Simulationsmodus** ermöglicht es Inhaltserstellern und Administratoren, das Verhalten der Software für einen bestimmten Benutzer zu einem bestimmten Zeitpunkt zu simulieren und die resultierenden Signaturen vor der Live-Schaltung zu prüfen.

**SimulateAndDeploy**¹ ermöglicht die Bereitstellung von Signaturen und Abwesenheitsantworten in Outlook Web¹/New Outlook¹ (sofern Outlook Web-basiert) **ohne Client-Bereitstellung oder Endbenutzerinteraktion**. Dies ist ideal für Nutzer, die sich nur bei Webdiensten, aber nie an einem Client anmelden (z. B. Nutzer mit einer Microsoft 365-Lizenz).

Die Software funktioniert **on-premises, in hybriden und reinen Cloud-Umgebungen**. Sie ist **für große und komplexe Umgebungen konzipiert**: Exchange Resource Forests, AD-Trusts, mehrstufige AD-Subdomänen sowie mandantenübergreifende und Multitenant Szenarien.

**Alle nationalen Clouds werden unterstützt**: Öffentlich (AzurePublic), US-Regierung L4 (AzureUSGovernment), US-Regierung L5 (AzureUSGovernment DoD), China (AzureChinaCloud, betrieben von 21Vianet).

Die Software ist **multiinstanzfähig** durch Verwendung verschiedener Vorlagenpfade, Konfigurationsdateien und Skriptparameter.
ers.

Set-OutlookSignatures erfordert **keine Installation auf Servern oder Clients**. Sie benötigen lediglich eine Standard-SMB-Dateifreigabe auf einem zentralen System und optional Office auf Ihren Clients.

Es gibt **keine Telemetrie** und kein „Calling Home“. E-Mails und Verzeichnisdaten werden **nicht über externe Rechenzentren oder Cloud-Dienste geleitet**, und **DNS-Einträge (MX, SPF) oder der E-Mail-Verkehr müssen nicht geändert werden**.

Ein **dokumentierter Implementierungsansatz**, der auf praktischen Erfahrungen mit der Implementierung der Software in Multiclient-Umgebungen mit einer fünfstelligen Anzahl von Postfächern basiert, enthält bewährte Vorgehensweisen und Empfehlungen für Produktmanager, Architekten, Betriebsleiter, Account Manager sowie E-Mail- und Client-Administratoren.

Der Kern der Software ist als **Freie Open-Source-Software (FOSS)** quelloffen und kostenlos. Sie wird unter der European Union Public Licnse veröffentlicht, die unter anderem von der Free Software Foundation (FSF) und der Open Source Initiative (OSI) anerkannt wird und mit der General Public License (GPL) und anderen gängigen Lizenzen kompatibel ist.

Fußnote 1 (¹): **Einige Funktionen sind exklusiv dem Benefactor Circle-Add-on vorbehalten**. Das optionale <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> erweitert das quelloffene und kostenlose Set-OutlookSignatures um leistungsstarke Unternehmensfunktionen, priorisierten Support und direkten Zugang zu neuen Leistungsmerkmalen.


## Funktions-Vergleich&nbsp;&nbsp;&nbsp;&nbsp;<a href="#features"><img src="https://img.shields.io/badge/zu den-Funktionen-limegreen?labelColor=black" alt="Zu den Funktionen"></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="/quickstart"><img src="https://img.shields.io/badge/zur-🚀%20Schnellstart--Anleitung%20🚀-limegreen?labelColor=black" alt="Zur Schnellstart-Anleitung"></a> {#feature-comparison}

<div class="table-container">
    <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
            <tr>
                <th style="text-align:left">Feature</th>
                <th style="text-align:left">Set-OutlookSignatures mit dem <span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></th>
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
                <td style="text-align:left">🟢 Hochgradig anpassbar, nicht nur basierend auf den Empfängern</td>
                <td style="text-align:left">🟡 Interne oder externe Empfänger</td>
                <td style="text-align:left">🔴</td>
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
        </tbody>
    </table>
</div>