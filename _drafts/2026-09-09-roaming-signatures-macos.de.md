---
layout: "post"
lang: "de"
locale: "de"
title: "Verwaltete Outlook-Signaturen auf dem Mac"
description: "Verwalten Sie Outlook-Signaturen auf dem Mac durch lokale Erstellung, zentrale Bereitstellung und das Outlook Add-in."
slug: "roaming-signatures-macos"
published: true
tags:
show_sidebar: true
redirect_from:
  - "/blog/2025/09/07/roaming-signatures-macos"
  - "/blog/2025/09/07/roaming-signatures-macos/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Outlook für Mac bietet in Microsoft-365-Umgebungen nicht dasselbe verlässliche Verhalten bei Roaming-Signaturen, das Administratoren möglicherweise von anderen Outlook-Clients erwarten. Unternehmen müssen daher entscheiden, wo Set-OutlookSignatures die Signaturen der einzelnen Benutzer erstellt und wie die fertigen Signaturen in Outlook verfügbar gemacht werden.

Dabei geht es nicht einfach um die Wahl zwischen lokalen Signaturen und einem Outlook Add-in. Set-OutlookSignatures verwendet eine zweistufige Architektur: Zuerst werden die Signaturen aus zentral verwalteten Vorlagen und Daten erstellt, anschließend werden die generierten Signaturen in der Outlook-Umgebung des Benutzers verfügbar gemacht. Das Benefactor Circle Add-on erweitert beide Stufen um die zentrale Ausführung, plattformübergreifende Bereitstellung und das Outlook Add-in.

### Warum Outlook für Mac ein bewusstes Bereitstellungsmodell benötigt

In einer gemischten Microsoft-365-Umgebung arbeiten Benutzer möglicherweise mit dem klassischen Outlook für Windows, dem neuen Outlook, Outlook im Web, Outlook auf Mobilgeräten und Outlook für Mac. Die Mechanismen zum Speichern, Synchronisieren und Auswählen von Signaturen sind in diesen Clients nicht identisch.

Das wird sichtbar, wenn eine Signatur zentral erstellt oder aktualisiert wurde, auf einem Mac aber nicht in der erwarteten Form erscheint. Der Benutzer sieht möglicherweise weiterhin eine alte lokale Signatur, hat keine passende Signatur zur Verfügung oder muss diese manuell auswählen. Freigegebene Postfächer und Stellvertretungsszenarien bringen eine weitere Anforderung mit sich: Die Signatur muss zum Postfach passen, das als Absender verwendet wird, und nicht nur zum angemeldeten Benutzer.

Set-OutlookSignatures trennt die Erstellung der Signaturen von deren Bereitstellung. Administratoren können dadurch eine Architektur wählen, die zu ihrer Umgebung passt. Der Client-Modus und der zentrale SimulateAndDeploy-Modus lassen sich kombinieren. Gleichzeitig können native Outlook-Funktionen und das Outlook Add-in abhängig vom benötigten Client-Verhalten als Bereitstellungskanäle ausgewählt werden.

### Stufe 1: Erstellen der Signaturen

Set-OutlookSignatures wandelt zentral verwaltete Vorlagen in fertige Signaturen und Abwesenheitsnotizen um. Dabei kann die Lösung die Vorlagen mit Eigenschaften aus Entra ID, Active Directory und anderen konfigurierten Datenquellen anreichern und anschließend die Vorlagen- und Zuweisungslogik des Unternehmens anwenden.

Für die Ausführung gibt es zwei grundlegende Modelle.

#### Dezentraler Client-Modus

Im Client-Modus wird Set-OutlookSignatures im Sicherheitskontext des angemeldeten Benutzers auf einem Windows-, Linux- oder macOS-Gerät ausgeführt. Mit dem Benefactor Circle Add-on kann Set-OutlookSignatures auch unter macOS ausgeführt werden und die erforderlichen lokalen Outlook-Signaturen direkt auf dem Mac erstellen.

Das ist besonders hilfreich, wenn der Mac das primäre verwaltete Gerät des Benutzers ist. Das Unternehmen kann Set-OutlookSignatures und die zugehörige Konfiguration auf diesem Mac bereitstellen, die Ausführung bei der Anmeldung oder nach einem regelmäßigen Zeitplan starten und die lokal verfügbaren Outlook-Signaturen mit den zentralen Vorlagen und Postfachzuweisungen abgleichen.

Der Client-Modus verwendet die Ressourcen des Endgeräts und die vorhandenen Berechtigungen des Benutzers. Er kann außerdem vergleichsweise häufig ausgeführt werden, beispielsweise bei der Anmeldung oder alle paar Stunden. Änderungen an Vorlagen, Benutzerattributen und Signaturzuweisungen erreichen den Benutzer dadurch, ohne auf den nächsten zentralen Bereitstellungszyklus warten zu müssen.

Die architektonische Voraussetzung besteht darin, dass sich der Benutzer an einem verwalteten Windows-, Linux- oder macOS-Gerät anmeldet, auf dem Set-OutlookSignatures ausgeführt werden kann. Software oder zumindest die zugehörige Konfiguration muss daher auf den betreffenden Endgeräten bereitgestellt werden.

#### Zentraler SimulateAndDeploy-Modus

Das Benefactor Circle Add-on stellt zusätzlich den SimulateAndDeploy-Modus bereit. In diesem Modell wird Set-OutlookSignatures auf einem oder mehreren zentralen Systemen ausgeführt und erstellt Signaturen für Benutzer, ohne dass die Lösung auf jedem einzelnen Benutzergerät laufen muss.

Das ist sinnvoll, wenn Benutzer kein primäres verwaltetes Windows-, Linux- oder macOS-Gerät haben oder wenn das Unternehmen nicht auf jedem Endgerät eine Set-OutlookSignatures-Laufzeitumgebung unterhalten möchte. Dieser Ansatz eignet sich daher unter anderem für BYOD-Szenarien, Benutzer mit primärer Mobilgerätenutzung, Benutzer mit Microsoft-365-F-Lizenzen sowie Macs, die nur als sekundäre oder gelegentlich verwendete Geräte dienen.

Die zentrale Ausführung verändert das Betriebsmodell. Statt im Kontext des angemeldeten Benutzers läuft der Prozess unter einem entsprechend berechtigten Dienstkonto und benötigt Zugriff auf die in der Bereitstellung enthaltenen Benutzerpostfächer. Abhängig vom Zeitplan und von der Infrastruktur des Unternehmens können zentrale Ausführungen außerdem seltener stattfinden als Ausführungen im Client-Modus.

Entscheidend ist, dass auch die zentrale Ausführung benutzer- und postfachspezifische Signaturen erstellt. Sie reduziert die Bereitstellung nicht auf eine generische Signatur für alle Benutzer. Für das fertige Ergebnis gelten weiterhin dieselben Vorlagen, Datenquellen und Zuweisungsregeln.

> 💡 **Best Practice:** Ordnen Sie Benutzer zuerst nach ihren Anforderungen an das Ausführungsmodell ein und erst anschließend nach ihren Outlook-Clients. Verwenden Sie den Client-Modus, wenn Set-OutlookSignatures regelmäßig auf einem verwalteten primären Gerät ausgeführt werden kann, und SimulateAndDeploy, wenn eine zentrale Ausführung betrieblich besser geeignet ist. Wählen Sie danach die passenden Bereitstellungskanäle für die einzelnen Outlook-Clients.

### Stufe 2: Bereitstellen der Signaturen in Outlook

Nachdem Set-OutlookSignatures die Signaturen erstellt hat, müssen sie in der Outlook-Umgebung des Benutzers verfügbar gemacht werden. Für diese zweite Stufe können native Outlook-Funktionen, das Outlook Add-in oder eine geeignete Kombination aus beiden verwendet werden.

Die Architektur sollte deshalb nicht als „lokale Signaturen für primäre Macs und das Outlook Add-in für sekundäre Macs“ beschrieben werden. Diese Formulierung vermischt zwei voneinander getrennte Entscheidungen:

- **Ausführung:** Wird Set-OutlookSignatures auf dem Gerät des Benutzers oder auf einem zentralen System ausgeführt?
- **Bereitstellung:** Werden die generierten Signaturen über lokale oder native Outlook-Mechanismen, über das Outlook Add-in oder über beide Wege verfügbar gemacht?

Die Rolle des Macs beeinflusst diese Entscheidungen, legt sie aber nicht allein fest.

### Wenn Set-OutlookSignatures auf dem Mac ausgeführt wird

Für einen verwalteten Mac, der als primäres Gerät des Benutzers dient, ist der dezentrale Client-Modus häufig der direkteste Ansatz. Set-OutlookSignatures läuft lokal, verarbeitet die zentral verwalteten Vorlagen und Daten und erstellt die für Outlook für Mac benötigten Signaturen.

Vor der Einführung dieses Modells ist der Benutzer möglicherweise auf manuell gepflegte Signaturen in Outlook angewiesen. Änderungen am Corporate Design, an rechtlichen Texten oder an Benutzerdaten müssen dann auf dem Mac nachvollzogen werden. Die verfügbaren Signaturen entsprechen unter Umständen nicht mehr den aktuellen Postfachzuweisungen des Unternehmens.

Nach der Bereitstellung der lokalen Ausführung ändert sich das Verhalten:

- Set-OutlookSignatures läuft im Sicherheitskontext des Benutzers.
- Zentral verwaltete Vorlagen werden auf dem Mac verarbeitet.
- Benutzer- und Postfachdaten werden in die jeweils relevanten Vorlagen eingefügt.
- Die Zuweisungslogik bestimmt, welche Signaturen erstellt werden.
- Die fertigen Signaturen werden Outlook für Mac lokal zur Verfügung gestellt.
- Wiederholte Ausführungen können veraltete Versionen durch aktuelle Signaturen ersetzen.

Dabei handelt es sich nicht um klassisches Roaming von einem anderen Outlook-Client. Set-OutlookSignatures erstellt und pflegt die Signaturen aktiv auf dem Mac auf Grundlage der zentralen Konfiguration des Unternehmens.

### Wenn Set-OutlookSignatures zentral ausgeführt wird

Nur weil ein Benutzer Outlook auf einem Mac öffnet, benötigt dieser Mac nicht automatisch eine lokale Installation von Set-OutlookSignatures. Ist der Mac ein sekundäres, nur gelegentlich verwendetes oder nicht verwaltetes Gerät beziehungsweise befindet er sich außerhalb des regulären Endgeräte-Bereitstellungsprozesses, kann das Unternehmen die Signaturen zentral mit SimulateAndDeploy erstellen.

Vor der zentralen Bereitstellung ist auf dem Mac möglicherweise keine zentral verwaltete Signatur vorhanden, weil Set-OutlookSignatures ausschließlich auf einem anderen primären Gerät ausgeführt wird. Der Benutzer erstellt dann eventuell eine separate lokale Signatur, kopiert eine Signatur von einem anderen Gerät oder versendet Nachrichten ohne die erforderliche Signatur.

Nach der Einführung der zentralen Ausführung ändert sich das Verhalten:

- Set-OutlookSignatures erstellt die Signaturen auf einem zentralen System.
- Es werden dieselben zentralen Vorlagen, Datenquellen und Zuweisungen angewendet.
- Der Benutzer muss sich nicht an einem Gerät anmelden, auf dem Set-OutlookSignatures ausgeführt wird.
- Die fertigen Signaturen können über die konfigurierten Outlook-Mechanismen bereitgestellt werden.
- Das Outlook Add-in kann die relevanten Signaturinformationen in Outlook für Mac verfügbar machen.

Dadurch kann der Mac in die Signaturbereitstellung des Unternehmens einbezogen werden, ohne ihn zu einem weiteren verwalteten Set-OutlookSignatures-Endgerät zu machen.

### Die Rolle des Outlook Add-ins

Das Outlook Add-in ist im Benefactor Circle Add-on enthalten. Es ist einer der verfügbaren Bereitstellungsmechanismen für Signaturen, die Set-OutlookSignatures bereits erstellt hat. Es ersetzt nicht die Verarbeitung der Vorlagen und die Zuweisung der Signaturen.

Das Add-in ist besonders hilfreich, wenn Set-OutlookSignatures zentral ausgeführt wird und nicht auf dem Mac selbst läuft. Die Signaturinformationen können im Postfach abgelegt und vom Add-in in unterstützten Outlook-Clients verwendet werden. Der Mac erhält dadurch verwaltete Signaturen, ohne dass die Signaturen lokal durch Set-OutlookSignatures generiert werden müssen.

Das Add-in ist jedoch nicht auf sekundäre Macs beschränkt. Es kann auch eine dezentrale Bereitstellung ergänzen, wenn das Unternehmen ein Verhalten benötigt, das über das bloße Vorhandensein lokaler Signaturdateien hinausgeht.

Das Add-in unterstützt eine ereignisgesteuerte Signaturlogik. Abhängig von seiner Konfiguration kann es reagieren, wenn ein Benutzer eine Nachricht oder einen Termin erstellt, relevante Eigenschaften des Elements ändert oder das Element sendet. Aktuelle Versionen unterstützen außerdem Start- und Sendeereignisse wie OnMessageSend, OnAppointmentSend, OnMessageCompose, OnAppointmentOrganizer und OnSensitivityLabelChanged. Die benötigten Ereignisse werden gezielt in der Bereitstellungskonfiguration aktiviert.

Damit ist das Add-in unter anderem für Situationen relevant, in denen Signaturen auf den aktuellen Outlook-Kontext reagieren müssen:

- Ein Benutzer ändert das Absenderpostfach.
- Eine Signatur soll auf einen Termin angewendet werden.
- Benutzerdefinierte Regeln hängen von Element- oder Empfängereigenschaften ab.
- Eine Signatur muss beim Senden geprüft oder erneut angewendet werden.
- Die Signaturlogik hängt von der Vertraulichkeitsbezeichnung des Elements ab.

Diese Funktionen können unabhängig davon verwendet werden, ob die ursprünglichen Signaturen im Client-Modus oder durch eine zentrale SimulateAndDeploy-Ausführung erstellt wurden.

### Primäre und sekundäre Macs als Planungskategorien

Die Unterscheidung zwischen primären und sekundären Macs bleibt für die Betriebsplanung hilfreich. Sie unterstützt Administratoren bei der Entscheidung, ob eine lokale Bereitstellung und regelmäßige Ausführung von Set-OutlookSignatures verhältnismäßig ist.

Ein primärer verwalteter Mac ist in der Regel ein geeigneter Endpunkt für den Client-Modus. Der Benutzer meldet sich regelmäßig an, das Gerät wird bereits vom Unternehmen verwaltet und Set-OutlookSignatures kann die Signaturen in kurzen Abständen aktualisieren.

Ein sekundärer oder nur gelegentlich verwendeter Mac eignet sich möglicherweise besser für die zentrale Erstellung, da das Gerät nicht durchgehend online, verwaltet oder in den normalen Softwarebereitstellungsprozess eingebunden ist. Das Outlook Add-in kann die generierten Signaturen dann in Outlook verfügbar machen, ohne dass Set-OutlookSignatures lokal ausgeführt werden muss.

Diese Kategorien sind eine Planungshilfe und keine festen Architekturregeln. Ein Unternehmen kann sich auch bei primären Macs für die zentrale Ausführung entscheiden. Ebenso kann das Outlook Add-in auf einem primären Mac bereitgestellt werden, wenn dessen ereignisgesteuertes Verhalten und die benutzerdefinierten Regeln benötigt werden. Set-OutlookSignatures unterstützt ausdrücklich die Kombination aus dezentraler und zentraler Ausführung mit nativen Outlook- und Add-in-Bereitstellungsmethoden.

### Vor und nach der Ausrichtung der Architektur

Bevor die zweistufige Architektur berücksichtigt wird, orientiert sich die Signaturbereitstellung häufig an einzelnen Outlook-Clients. Administratoren versuchen möglicherweise, lokale Signaturen auf jeden Mac zu kopieren, gehen davon aus, dass Microsoft Roaming Signatures jedes Szenario abdeckt, oder stellen das Outlook Add-in bereit, ohne vorher festzulegen, wo die zugrunde liegenden Signaturen erstellt werden.

Dadurch können mehrere direkt erkennbare Probleme entstehen:

- Primäre Macs behalten veraltete oder manuell erstellte lokale Signaturen.
- Sekundäre Macs erhalten keine verwaltete Signatur, weil Set-OutlookSignatures dort nie ausgeführt wird.
- Freigegebene Postfächer und Stellvertretungsszenarien erhalten nicht die vorgesehene postfachspezifische Signatur.
- Aktualisierungen erreichen Benutzer abhängig vom jeweiligen Client zu unterschiedlichen Zeitpunkten.
- Administratoren können die Erstellung der Signaturen nicht klar von deren Bereitstellung unterscheiden.

Nach der Ausrichtung der Architektur erstellt Set-OutlookSignatures zunächst die korrekten Signaturen im Client-Modus, mit SimulateAndDeploy oder mit einer Kombination aus beiden Modellen. Anschließend werden die fertigen Signaturen über die Outlook-Mechanismen bereitgestellt, die zu den Clients und Anforderungen des Unternehmens passen.

Das daraus entstehende Verhalten ist klarer:

- Ein verwalteter primärer Mac kann Signaturen lokal erstellen und aktuell halten.
- Benutzer ohne geeignetes verwaltetes Endgerät können weiterhin zentral generierte Signaturen erhalten.
- Ein sekundärer Mac benötigt keine eigene lokale Laufzeitumgebung, nur um Signaturen zu erhalten.
- Das Outlook Add-in kann postfachbasierte und ereignisgesteuerte Signaturfunktionen bereitstellen.
- Lokale, native und Add-in-basierte Bereitstellungsmethoden können in derselben Microsoft-365-Umgebung nebeneinander verwendet werden.
- Zentrale Vorlagen und Zuweisungsregeln bleiben die gemeinsame Grundlage der fertigen Signaturen.

### Auswahl der Architektur

Die Entscheidung über die Bereitstellung sollte mit dem Ausführungsmodell von Set-OutlookSignatures beginnen und nicht allein mit dem jeweiligen Outlook-Client.

Administratoren sollten folgende Punkte klären:

- Verfügt jeder Benutzer über ein verwaltetes Gerät, auf dem der Client-Modus ausgeführt werden kann?
- Ist dieses Gerät häufig genug verfügbar, um die gewünschte Aktualisierungsfrequenz zu erreichen?
- Ist eine zentrale Ausführung mit SimulateAndDeploy betrieblich besser geeignet?
- Welche Berechtigungen und welches Dienstkontomodell benötigt die zentrale Ausführung?
- Welche nativen Outlook-Bereitstellungsmethoden erfüllen die Anforderungen des Unternehmens?
- Wo wird das Outlook Add-in für plattformübergreifendes oder ereignisgesteuertes Verhalten benötigt?
- Welche Szenarien mit freigegebenen Postfächern und Stellvertretungen müssen berücksichtigt werden?
- Beeinflussen Termine, Sendeereignisse, Vertraulichkeitsbezeichnungen oder benutzerdefinierte Regeln die Signaturauswahl?

Die resultierende Architektur kann lokale Signaturerstellung für Benutzer mit verwalteten primären Macs, zentrale Erstellung für Benutzer ohne geeignete verwaltete Endgeräte und das Outlook Add-in überall dort umfassen, wo dessen Bereitstellungs- und Kontextfunktionen benötigt werden. Diese Elemente ergänzen einander und können kombiniert werden, statt jeweils ausschließlich einer Gerätekategorie zugeordnet zu sein.

### Verwaltete Signaturen in der gesamten Mac-Umgebung

Das Signaturverhalten von Outlook für Mac erfordert nicht, dass jeder Mac auf dieselbe Weise verwaltet wird. Set-OutlookSignatures und das Benefactor Circle Add-on stellen getrennte Optionen für die Erstellung der Signaturen und deren Bereitstellung in Outlook zur Verfügung.

Auf einem verwalteten primären Mac kann Set-OutlookSignatures lokal ausgeführt werden und die Outlook-Signaturen des Benutzers aktuell halten. Wo eine lokale Ausführung nicht geeignet ist, kann SimulateAndDeploy die Signaturen zentral erstellen. Das im Benefactor Circle Add-on enthaltene Outlook Add-in kann die generierten Signaturinformationen anschließend in Outlook verfügbar machen und bei Bedarf um eine kontextabhängige, ereignisgesteuerte Auswahl ergänzen.

Die entscheidende Frage ist daher nicht nur, ob ein Mac als primäres oder sekundäres Gerät verwendet wird. Entscheidend ist, wo die Signaturerstellung ausgeführt werden soll, welchen Bereitstellungsmechanismus die einzelnen Outlook-Clients verwenden und ob die kontextabhängigen Funktionen des Add-ins benötigt werden.

Weitere Informationen zu den Bereitstellungs- und ereignisgesteuerten Funktionen des enthaltenen Outlook Add-ins:

[Set-OutlookSignatures Outlook Add-in](https://set-outlooksignatures.com/outlookaddin)

<!--
LinkedIn Post:

Outlook für Mac bietet in Microsoft-365-Umgebungen nicht dasselbe verlässliche Verhalten bei Roaming-Signaturen, das Administratoren möglicherweise von anderen Outlook-Clients erwarten. Eine geeignete Architektur muss daher sowohl festlegen, wo die Signaturen erstellt werden, als auch wie die fertigen Signaturen Outlook erreichen.

Set-OutlookSignatures kann auf einem verwalteten Mac ausgeführt werden und dort lokale Signaturen erstellen oder zentral laufen, wenn nicht auf jedem Endgerät eine eigene Laufzeitumgebung betrieben werden soll. Das Outlook Add-in bildet einen eigenständigen Bereitstellungskanal und kann zusätzlich eine ereignisgesteuerte Signaturauswahl anhand des aktuellen Outlook-Kontexts ermöglichen.

Die Einordnung eines Macs als primäres oder sekundäres Gerät unterstützt die Planung, bestimmt die Architektur aber nicht allein. Die verbleibende Diskrepanz besteht häufig zwischen dem Ort, an dem Unternehmen die Signaturerstellung vermuten, und dem Mechanismus, über den die einzelnen Outlook-Clients die fertigen Signaturen tatsächlich erhalten.

https://set-outlooksignatures.com/de/blog/2026/09/09/roaming-signatures-macos
-->

## Machen Sie jeden kleinen E-Mail-Moment zu einem professionellen Vorteil

E-Mail-Signaturen und Abwesenheitsnotizen mögen unbedeutend erscheinen, aber stellen Sie sich vor, wie oft sie gesehen werden.

Wir helfen Unternehmen, diese Kontaktpunkte für alle Benutzer zentral zu verwalten und zu standardisieren — **einheitliches Outlook-Branding überall, ohne Datenabfluss nach außen.** Kein manueller Aufwand, keine Inkonsistenzen, keine Daten verlassen Ihr Unternehmen. Mit Set-OutlookSignatures wird jede E-Mail zu einem konsistenten, sicheren und vollständig kontrollierten Markenerlebnis.

👉 Sehen Sie, was für Ihr E-Mail-Setup möglich ist  
→ [So funktioniert es (2 Minuten)](https://set-outlooksignatures.com/)

👉 Möchten Sie es selbst ausprobieren?  
→ [Schnellstart](https://set-outlooksignatures.com/quickstart)

_Nicht verantwortlich für die E-Mail-Konfiguration in Ihrem Unternehmen?_  
Teilen Sie diesen Artikel mit Ihrer IT-Abteilung oder Ihrem Marketingteam, sie werden es Ihnen danken.
