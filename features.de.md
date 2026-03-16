---
layout: "page"
lang: "de"
locale: "de"
title: "Funktionen und Funktions-Vergleich"
subtitle: "Unsere Lösung auf einen Blick und im Vergleich"
description: "Vergleichen Sie Funktionen und Vorteile unserer Lösung auf einen Blick – klare Übersicht für den besten Funktions-Vergleich."
hero_link: "#features"
hero_link_text: "<span><b>Funktionen: </b>Was unsere Lösung kann</span>"
hero_link_style: |
  style="background-color: LawnGreen;"
hero_link2: "#feature-comparison"
hero_link2_text: "<span><b>Funktions-Vergleich </b>mit Mitbewerbern</span>"
hero_link2_style: |
  style="background-color: LawnGreen;"
hero_link3: "/quickstart"
hero_link3_text: "<span><b>Schnellstart: </b>Signaturen in Minuten</span>"
hero_link3_style: |
  style="background-color: LawnGreen;"
permalink: "/features"
redirect_from:
  - "/features/"
sitemap_priority: 0.9
sitemap_changefreq: weekly
---
## Übersicht {#overview}

Set-OutlookSignatures ist das fortschrittlichste, sicherste und vielseitigste kostenlose Open-Source-Tool zur Verwaltung von E-Mail-Signaturen und Abwesenheitsnotizen. Mit dem optionalen [Benefactor Circle Add-on](/benefactorcircle) stehen Ihnen noch leistungsstärkere Funktionen zur Verfügung, die speziell auf Geschäftsumgebungen zugeschnitten sind.

Es bietet alles, was Sie von einer modernen Lösung erwarten: Zentralisierte Verwaltung, nahtlose Bereitstellung und vollständige Kontrolle über alle Outlook-Editionen auf allen Plattformen: Classic und New, Android, iOS, Linux, macOS, Web, Windows.

Dank seiner zukunftsorientierten Architektur, die nicht auf einem kommerziellen Geschäftsmodell, sondern auf praktischer Nützlichkeit, Datenschutz und digitaler Souveränität basiert, bietet es einzigartige Funktionen, die es von anderen Lösungen abheben.

Einen schnellen Überblick erhalten Sie in unserem <a href="#feature-comparison">Funktions-Vergleich mit Mitbewerbern</a>. Wenn Sie genau wissen möchten, was alles möglich ist, oder Sie nach Inspiration für neue Anwendungsfälle suchen, finden Sie hier die vollständige Liste der Funktionen. Achtung: Sie ist lang!


## Funktionen {#features}
Mit Set-OutlookSignatures können Signaturen und Abwesenheitsnotizen:
- Aus **[Vorlagen im DOCX- oder HTML-Dateiformat](/details#signature-and-oof-template-file-format)** generiert werden.
- Mit einer **[Vielzahl von Variablen](/details#replacement-variables)**, einschließlich **[Fotos und Bildern](/details#photos-account-pictures-user-image-from-active-directory-or-entra-id)**, aus Entra ID, Active Directory und anderen Quellen angepasst werden.
  - Variablen stehen für den **[aktuell angemeldeten Benutzer, das aktuelle Postfach und deren Manager](/details#replacement-variables)** zur Verfügung.
- Für **[barrierefreien Zugriff](/blog/2025/12/03/barrier-free-email-signatures-and-out-of-office-replies)** gestaltet werden, mit benutzerdefinierten Link- und Bildbeschreibungen für Screenreader und ähnliche Tools.
- Flexibel zugewiesen werden: Für **alle Postfächer (auch [Shared Mailboxes](/benefactorcircle#key-features)¹)**, **[Gruppen](/details#template-tags-and-ini-files)**, **[E-Mail-Adressen](/details#template-tags-and-ini-files)** (auch Alias und sekundäre Adressen), auf Basis von **[Benutzer- und Postfach-Attributen](/details#template-tags-and-ini-files)**, für **jedes Postfach in allen Profilen (Outlook, [New Outlook](/benefactorcircle#key-features)¹, [Outlook on the web](/benefactorcircle#key-features)¹)**, auch für **[automapped und zusätzliche Postfächer](/parameters#signaturesforautomappedandadditionalmailboxes)**¹. 
- Aus einer Vorlage heraus mit unterschiedlichen Namen erstellt werden, **[eine Vorlage kann für viele Postfächer genutzt werden](/details#how-to-work-with-ini-files)**.
- Mit **[Zeitbeschränkungen](/details#allowed-tags)**¹ versehen werden, innerhalb derer sie gültig sind.
- Als **[Standard-Signatur](/details#allowed-tags)** für neue E-Mails oder für Antworten festgelegt werden.
- Als **[Standard-Abwesenheitsnotiz](/details#allowed-tags)**¹ für interne oder externe Empfänger festgelegt werden.
- Im **[Outlook on the web](/parameters#setcurrentuseroutlookwebsignature)**¹ des angemeldeten Benutzer gesetzt werden, und auch als **[Roaming Signatures](/parameters#mirrorcloudsignatures)**¹ mit der Cloud synchronisiert werden (Linux/macOS/Windows, klassisches and neues Outlook¹).
- Signaturen können rein zental verwaltet werden¹, oder **[parallel zu vom Benutzer erstellten Signaturen](/parameters#deleteusercreatedsignatures)** bestehen.
- Mit dem **[Outlook Add-in](/outlookaddin)**¹ automatisch zu neuen E-Mails, Antworten und Weiterleitungen, sowie zu Terminen hinzugefügt werden.
- In einen **[zusätzlichen Ordner](/parameters#additionalsignaturepath)**¹ kopiert werden, um den einfachen Zugriff auf Signaturen auf Mobilgeräten oder zur Verwendung mit anderen E-Mail-Clients und Apps als Outlook zu ermöglichen: Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail und andere.
- In einem **[E-Mail-Entwurf mit allen verfügbaren Signaturen](/parameters#signaturecollectionindrafts)**¹ in HTML und reinem Text für den einfachen Zugriff in E-Mail-Clients ohne Signatur-API gesammelt werden.
- **[Schreibgeschützt](/details#allowed-tags)** werden (nur klassisches Outlook für Windows).

Set-OutlookSignatures kann von Nutzern auf **[Windows-, Linux- und macOS-Clients, einschließlich gemeinsam genutzter Geräte und Terminalserver, oder auf einem zentralen System mit einem Dienstkonto](/details#architecture-considerations)**¹ ausgeführt werden.<br>Auf Clients kann es als Teil des Anmeldeskripts, als geplante Aufgabe oder auf Benutzeranforderung über ein Desktopsymbol, einen Startmenüeintrag, eine Verknüpfung oder einer andere Möglichkeit zum Starten eines Programms ausgeführt werden - **[was auch immer Ihre Methode zur Verteilung von Software erlaubt](/faq#how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)**.

**[Beispielvorlagen](/quickstart#customize-use-your-own-templates)** für Signaturen und Abwesenheitsnachrichten demonstrieren viele Funktionen und stehen als DOCX- und HTM-Dateien zur Verfügung.

**[Telefonnummern](/faq#format-phone-numbers)** und **[Post-Adressen](/faq#format-postal-addresses)** können nach internationalen Standards oder eigenen Vorgaben formatiert werden.

Der **[Simulationsmodus](/details#simulation-mode)** ermöglicht es Inhaltserstellern und Administratoren, das Verhalten der Software für einen bestimmten Benutzer zu einem bestimmten Zeitpunkt zu simulieren und die resultierenden Signaturen vor der Live-Schaltung zu prüfen.

**[SimulateAndDeploy](/details#creating-signatures-and-out-of-office-replies)**¹ ermöglicht die Bereitstellung von Signaturen und Abwesenheitsantworten **[ohne Ausführung auf Endgeräten oder Endbenutzerinteraktion](/details#creating-signatures-and-out-of-office-replies)**. Signaturen werden im Postfach als roaming signatures (nur für Exchange Online) gespeichert und stehen darüber hinaus dem [Outlook add-in](/outlookaddin) (Exchange Online und Exchange on-prem) zur Verfügung.

Die Software funktioniert **[on-premises, in hybriden und reinen Cloud-Umgebungen](/details#hybrid-and-cloud-only-support)**. Sie ist **[für große und komplexe Umgebungen konzipiert](/implementationapproach)**: Exchange Resource Forests, AD-Trusts, mehrstufige AD-Subdomänen sowie mandantenübergreifende und Multitenant Szenarien.

**[Alle öffentlichen, nationalen und souveränen Clouds werden unterstützt](/parameters#cloudenvironment)**: Öffentlich, US-Regierung (GCC, GCC High, DoD), China, souveräne Clouds Bleu, Delos, GovSG und mehr.

Die Software ist **[multiinstanzfähig](/faq#can-multiple-script-instances-run-in-parallel)** durch Verwendung verschiedener Vorlagenpfade, Konfigurationsdateien und Skriptparameter.
ers.

Set-OutlookSignatures erfordert **[keine Installation auf Servern oder Clients](/faq#how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)**. Sie benötigen lediglich eine Standard-SMB-Dateifreigabe auf einem zentralen System und optional Office auf Ihren Clients.

Es gibt **[keine Telemetrie](/features#feature-comparison)** und kein "Calling Home". E-Mails und Verzeichnisdaten werden **[nicht über externe Rechenzentren oder Cloud-Dienste geleitet](/features#feature-comparison)**, und **[DNS-Einträge (SPF) und Nachrichtenfluss bleiben unverändert](/features#feature-comparison)**.

Ein **[dokumentierter Implementierungsansatz](/implementationapproach)**, der auf praktischen Erfahrungen mit der Implementierung der Software in Multiclient-Umgebungen mit einer fünfstelligen Anzahl von Postfächern basiert, enthält bewährte Vorgehensweisen und Empfehlungen für Produktmanager, Architekten, Betriebsleiter, Account Manager sowie E-Mail- und Client-Administratoren.

Der Kern der Software ist als **[Freie Open-Source-Software (FOSS)](/faq#why-the-tagline)** quelloffen und kostenlos. Sie wird unter der European Union Public Licnse veröffentlicht, die unter anderem von der Free Software Foundation (FSF) und der Open Source Initiative (OSI) anerkannt wird und mit der General Public License (GPL) und anderen gängigen Lizenzen kompatibel ist.

Nach einer bestimmten Nutzungsdauer wird der **[dezente Hinweis 'Free and open-source Set-OutlookSignatures' an Signaturen angefügt](/faq#how-to-disable-the-tagline-in-signatures)**. Dieser Slogan kann leicht entfernt werden¹.

**Anmerkung 1 (¹):** Einige Funktionen sind exklusiv dem <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span></a> vorbehalten.


## Funktions-Vergleich {#feature-comparison}

<div style="display: grid;">
    <div class="table-container">
        <table class="table is-bordered is-striped is-hoverable">
            <thead>
                <tr>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;"></th>
                    <th class="has-text-weight-bold" style="min-width: 10em; white-space: nowrap;">Set-OutlookSignatures mit<br><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span></th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Mitbewerber A</th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Mitbewerber B</th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Mitbewerber C</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="has-text-weight-bold" style="white-space: nowrap;">Kostenloser und quelloffener Kern</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">E-Mails bleiben in Ihrer Umgebung (kein Umleiten auf Drittsysteme)</td>
                    <td>🟢</td>
                    <td>🟡 Optional, reduziert den Funktionsumfang</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Wird in Umgebungen gehostet und ausgeführt, denen Sie bereits vertrauen und für die Sie Sicherheits- und Verwaltungsstrukturen eingerichtet haben.</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Rechte für Entra ID und Active Directory</td>
                    <td>🟢 Benutzerrechte (delegated permissions), Least-Privilege-Prinzip, klar dokumentiert und begründet</td>
                    <td>🔴 Applikationsrechte (application permissions), alle Verzeichnisdaten übertragen, alle E-Mails übertragen</td>
                    <td>🔴 Applikationsrechte (application permissions), alle Verzeichnisdaten übertragen, alle E-Mails übertragen</td>
                    <td>🔴 Applikationsrechte (application permissions), alle Verzeichnisdaten übertragen, alle E-Mails übertragen</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Daten aus Entra ID Und Active Directory bleiben in Ihrer Umgebung (kein Transfer zu Drittsystemen)</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Erfordert keine Anpassung der Exchange-Konfiguration und erzeugt keine neuen Abhängigkeiten</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Mehrere unabhängige Instanzen können in derselben Umgebung laufen</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Kein Sammeln von Telemetrie- oder Nutzungsdaten, weder direkt noch indirekt</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Kein Abo-Vertrag</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">IT kann die Signatur-Verwaltung delegieren, z. B. an das Marketing</td>
                    <td>🟢</td>
                    <td>🟢</td>
                    <td>🟡 Nicht auf Signatur-Ebene</td>
                    <td>🟡 Nicht auf Signatur-Ebene</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signaturen an alle E-Mails anfügen</td>
                    <td>🟡 Nur für Outlook-Clients</td>
                    <td>🟢 Bei Umleitung aller E-Mails auf ein Drittsystem</td>
                    <td>🟢 Bei Umleitung aller E-Mails auf ein Drittsystem</td>
                    <td>🟢 Bei Umleitung aller E-Mails auf ein Drittsystem</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signaturen auf Basis der Empfänger</td>
                    <td>🟡 Hochgradig anpassbar, 10+ Eigenschaften. Gleiche Signatur für alle Empfänger.</td>
                    <td>🟡 Interne, Externe, Gruppenmitglieder, E-Mail-Adressen. Unterschiedliche Signaturen nur bei Umleitung aller E-Mails auf ein Drittsystem.</td>
                    <td>🟡 Interne und Externe. Gleiche Signatur für alle Empfänger.</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Zusätzliche Datenquellen neben Active Directory und Entra ID</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Unterstützt on-prem und alle M365 Clouds (öffentlich, national, souverän, hybrid)</td>
                    <td>🟢 Public, US Government (GCC, GCC High, DoD), China, souveräne Clouds Bleu, Delos, GovSG und mehr</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Unterstützt mandantenübergreifenden Zugriff und Multitenant Organizations</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Unterstützt Microsoft Roaming Signatures (mehrere Signaturen in Outlook on the web und neuem Outlook)</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Anzahl der Vorlagen</td>
                    <td>🟢 Unlimitiert</td>
                    <td>🔴 1, mehr kosten extra</td>
                    <td>🟢 Unlimitiert</td>
                    <td>🟢 Unlimitiert</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Zuweisung und Ausschließen von Vorlagen</td>
                    <td>🟢</td>
                    <td>🔴 Kostet extra</td>
                    <td>🟢</td>
                    <td>🟢</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Gültigkeit von Vorlagen nach Zeiträumen</td>
                    <td>🟢</td>
                    <td>🔴 Kostet extra</td>
                    <td>🟢</td>
                    <td>🟢</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Banner</td>
                    <td>🟢 Unlimitiert</td>
                    <td>🔴 1, mehr kosten extra</td>
                    <td>🟢 Unlimitiert</td>
                    <td>🟢 Unlimitiert</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">QR codes und vCards</td>
                    <td>🟢</td>
                    <td>🔴 Kosten extra</td>
                    <td>🔴 Kosten extra</td>
                    <td>🟢</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signatur sichtbar während des Schreibens einer E-Mail</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🟡</td>
                    <td>🟡</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signatur sichtbar in den Gesendeten Elementen</td>
                    <td>🟢</td>
                    <td>🟡 Nur Cloud-Postfächer</td>
                    <td>🟡 Nur Cloud-Postfächer</td>
                    <td>🟡 Nur Cloud-Postfächer</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Abwesenheitsnotizen</td>
                    <td>🟢</td>
                    <td>🔴 Kostet extra</td>
                    <td>🟡 Keine Trennung nach internen und externen Empfängern</td>
                    <td>🔴 Kostet extra</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Benutzer-kontrollierte Signaturen</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🟡</td>
                    <td>🟡</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signaturen für verschlüsselte E-Mails</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🟡</td>
                    <td>🟡</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signaturen für delegierte, gemeinsam benutzte, zusätzliche und automapped Postfächer</td>
                    <td>🟢</td>
                    <td>🟡 Kein Mischen von Benutzer- und Postfachattributen</td>
                    <td>🟡 Kein Mischen von Benutzer- und Postfachattributen</td>
                    <td>🟡 Kein Mischen von Benutzer- und Postfachattributen</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Outlook Add-in</td>
                    <td>🟢 Nicht für on-prem Postfächer auf Android und iOS. Hochgrad anpassbar mit Regeln, eigenem Code und zur Laufzeit generierten Signaturen</td>
                    <td>🟡 Nicht für on-prem Postfächer auf Android und iOS, nicht für Termine</td>
                    <td>🟡 Nicht für on-prem Postfächer auf Android und iOS, nicht für Termine</td>
                    <td>🔴 Nicht für on-prem Postfächer</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Preismodel für Support</td>
                    <td>🟢 Verrechnung nach Stunden</td>
                    <td>🔴 Kostet auch bei Nichtnutzung</td>
                    <td>🔴 Kostet auch bei Nichtnutzung</td>
                    <td>🔴 Kostet auch bei Nichtnutzung</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Software-Treuhand</td>
                    <td>🟢 An Set-OutlookSignatures</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Telefonnummern formatieren</td>
                    <td>🟢 E164, International, National, RFC3966, Regex, benutzerdefiniert</td>
                    <td>🟡 Regex</td>
                    <td>🔴</td>
                    <td>🟡 RegEx</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Postadressen formatieren</td>
                    <td>🟢 Vorlagen für über 200 Länder/Regionen, benutzerdefiniert</td>
                    <td>🟡 Regex</td>
                    <td>🔴</td>
                    <td>🟡 RegEx</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Lizenzkosten für 100&nbsp;Postfächer, 1&nbsp;Jahr</td>
                    <td>🟢 300&nbsp;EUR</td>
                    <td>🔴 ca. 1.600&nbsp;EUR</td>
                    <td>🟡 ca. 1.300&nbsp;EUR</td>
                    <td>🔴 ca. 1.600&nbsp;EUR</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Lizenzkosten für 250&nbsp;Postfächer, 1&nbsp;Jahr</td>
                    <td>🟢 750&nbsp;EUR</td>
                    <td>🔴 ca. 4.000&nbsp;EUR</td>
                    <td>🟡 ca. 2.700&nbsp;EUR</td>
                    <td>🔴 ca. 3.600&nbsp;EUR</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Lizenzkosten für 500&nbsp;Postfächer, 1&nbsp;Jahr</td>
                    <td>🟢 1.500&nbsp;EUR</td>
                    <td>🔴 ca. 8.000&nbsp;EUR</td>
                    <td>🟡 ca. 4.400&nbsp;EUR</td>
                    <td>🟡 ca. 6.200&nbsp;EUR</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Lizenzkosten für 1.000&nbsp;Postfächer, 1&nbsp;Jahr</td>
                    <td>🟢 3.000&nbsp;EUR</td>
                    <td>🔴 ca. 15.700&nbsp;EUR</td>
                    <td>🟡 ca. 8.700&nbsp;EUR</td>
                    <td>🟡 ca. 10.500&nbsp;EUR</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Lizenzkosten für 10.000&nbsp;Postfächer, 1&nbsp;Jahr</td>
                    <td>🟢 30.000&nbsp;EUR</td>
                    <td>🔴 ca. 110.000&nbsp;EUR</td>
                    <td>🟡 ca. 65.000&nbsp;EUR</td>
                    <td>🟡 ca. 41.000&nbsp;EUR</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Direktbezug ohne öffentliche Ausschreibung</td>
                    <td>🟢 Einzigartige Funktionen, exklusive Herstellerverfügbarkeit</td>
                    <td>🔴 Keine einzigartigen Funktionen, keine exklusive Herstellerverfügbarkeit</td>
                    <td>🔴 Keine einzigartigen Funktionen, keine exklusive Herstellerverfügbarkeit</td>
                    <td>🔴 Keine einzigartigen Funktionen, keine exklusive Herstellerverfügbarkeit</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>