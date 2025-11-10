---
layout: "page"
lang: "de"
locale: "de"
title: "Schnellstart-Anleitung"
subtitle: "Signaturen in wenigen Minuten verteilen"
description: "Schnellstart-Anleitung. Signaturen in wenigen Minuten verteilen."
page_id: "quickstart"
permalink: "/quickstart"
redirect_from: "/quickstart/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
## Schritt 1: Set-OutlookSignatures herunterladen {#step-1}
Laden Sie Set-OutlookSignatures herunter und entpacken Sie das Archiv in einen lokalen Ordner.

<p>
  <div class="buttons">
    <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal is-hovered has-text-black has-text-weight-bold mtrcs-download" style="background-color: limegreen">Software herunterladen</a></p>
    <a><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=for-the-badge" alt="Number of downloads" loading="lazy"></a>
    <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=for-the-badge" alt="Number of open issues and link to issue list" loading="lazy"></a>
  </div>
</p>

Heben Sie unter Windows und macOS die Blockierung der Datei 'Set-OutlookSignatures.ps1' auf. Sie können dazu das PowerShell-Cmdlet 'Unblock-File' verwenden oder im Datei-Explorer mit der rechten Maustaste auf die Datei klicken, Eigenschaften auswählen und 'Unblock' anklicken. Dadurch wird das 'Mark of the Web' entfernt, das die Ausführung in PowerShell verhindern kann.

Wenn Sie AppLocker oder eine vergleichbare Lösung (Defender, CrowdStrike, Ivanti und andere) verwenden, müssen Sie möglicherweise die vorhandene digitale Signatur zu Ihrer Zulassungsliste hinzufügen oder zusätzliche Einstellungen in Ihrer Sicherheitssoftware festlegen.


## Schritt 2: Einmalige Vorbereitungen {#step-2}
**Client und Benutzer**  
Für einen ersten Testlauf ist es empfehlenswert, sich mit einem Testbenutzer auf einem Windows-System anzumelden, auf dem Word und Classic Outlook for Windows installiert sind und Classic Outlook for Windows zumindest mit dem Postfach des Testbenutzers konfiguriert ist. Wenn Sie Ihren eigenen Benutzer verwenden, werden im schlimmsten Fall bestehende Signaturen überschrieben.

Für die vollständige Unterstützung von Linux, macOS und New Outlook ist das <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> erforderlich und die Postfächer müssen in Exchange Online gehostet werden.

Falls sie nicht mit Classic Outlook on Windows testen können oder oder Ihr Signatur-Setup nicht verändert haben möchten, können Sie den Simulationsmodus verwenden, der in einem späteren Schritt beschrieben wird.

**Entra ID**  
Wenn sich einige oder alle Postfächer in Exchange Online befinden, müssen Sie zunächst eine Entra ID App registrieren, da Set-OutlookSignatures Berechtigungen für den Zugriff auf die Graph API benötigt.

Um die Entra ID App zu erstellen, bitten Sie Ihren Entra ID 'Global Admin' oder 'Application Administrator', folgendes auszuführen und den Anweisungen zu folgen:
```
.\sample code\Create-EntraApp.ps1 -AppType 'Set-OutlookSignatures' -AppName 'Set-OutlookSignatures'
```

Der Code in der Skriptdatei ist gut dokumentiert und enthält alle Details zu den erforderlichen Einstellungen der Entra ID App, den Berechtigungen und warum sie benötigt werden.

**Endpoint Security**  
Wenn Sie verlangen, dass PowerShell-Skripte mit ausgewählten Zertifikaten signiert werden, AppLocker oder eine vergleichbare Lösung wie Defender, CrowdStrike, Ivanti und andere verwenden, müssen Sie möglicherweise die Ausführung von Set-OutlookSignatures und das Laden von Bibliotheken aus dem TEMP-Ordner (der verwendet wird, um Dateien nicht an ihrem ursprünglichen Speicherort zu sperren) ausdrücklich erlauben.

Bitten Sie Ihren Endpoint Security Administrator Software zu vertrauen, die mit dem Zertifikat von ExplicIT Consulting signiert ist. Alle PS1- und DLL-Dateien, die im Download von Set-OutlookSignatures in Schritt 2 enhalten sind, sind mit diesem Zertifikat signiert.


## Schritt 3: Set-OutlookSignatures ausführen  {#step-3}
- **Wenn alle Postfächer on-prem gehalten werden**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
  ```

- **Wenn einige oder alle Postfächer in Exchange Online gehalten werden**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId aus Schritt 1 Entra ID>"
  ```
  Der Parameter '`-GraphOnly true`' stellt sicher, dass das on-prem Active Directory ignoriert wird und stattdessen nur Graph/Entra ID zum Finden von Postfächern und deren Attributen verwendet wird.

Wenn Sie nicht die Public Cloud von Microsoft nutzen, sondern eine National Cloud, fügen Sie folgenden Parameter hinzu: '`-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]`'

Set-OutlookSignatures fügt jetzt Signaturen, basierend auf Standardeinstellungen und integrierten Beispielvorlagen, zu Ihrem Classic Outlook hinzu.

Öffnen Sie Classic Outlook und werfen Sie einen Blick auf die neu erzeugten Signaturen: 'Formal', 'Informal' und die besonders umfangreiche 'Test all default replacement variables'.

Wenn Sie für Ihre Tests keinen Zugriff auf Classic Outlook for Windows haben oder Ihr Signatur-Setup nicht verändern möchten, nutzen Sie stattdessen einfach den integrierten [Simulations-Modus](/details#11-simulation-mode):
- Führen Sie Set-OutlookSignatures in einer neuen PowerShell-Session aus und fügen Sie die Parameter'`-SimulateUser a@example.com -SimulateMailboxes a@example.com`' hinzu ('a@example.com' ersetzen Sie durch Ihre eigene E-Mail-Adresse oder eine beliebige E-Mail-Adresse aus Ihrem System).
- Anstatt die Outlook-Konfiguration zu ändern, enthält Ihr 'Dokumente'-Ordner nun einen neuen Unterordner 'Outlook Signatures', der wiederum die Signaturen des simulierten Benutzers enthält.

Glückwunsch, Sie haben jetzt einen soliden Ausgangspunkt für Ihre eigenen Anpassungen!

## Anpassungen vornehmen {#customize}
Sie können jetzt mit Ihren eigenen Anpassungen starten. Hier ein paar beliebte Beispiele:

**Simulations-Modus**  
Sie möchten wissen, wie die mitgelieferten Beispiel-Signaturen für einen anderen Benutzer aussehen? Dann nutzen Sie doch einfach den integrierten [Simulations-Modus](/details#11-simulation-mode):
- Wählen die E-Mail-Adresse eines beliebigen Benutzers in Ihrem System aus.
- Führen Sie Set-OutlookSignatures in einer neuen PowerShell-Session aus und fügen sie die Parameter'`-SimulateUser a@example.com -SimulateMailboxes a@example.com`' hinzu ('a@example.com' ersetzen Sie durch die zuvor ausgewählte E-Mail-Adresse).

Ihr 'Dokumente'-Ordner enthält nun einen neuen Unterordner 'Outlook Signatures', der wiederum die Signaturen des simulierten Benutzers enthält.

Der [Simulations-Modus](/details#11-simulation-mode) kann noch viel mehr und ist dadurch sehr gut für Tests und Analysen in Produktionsumgebungen geeignet.

**Ihre eigenen Vorlagen verwenden**  
Keine Beispiel-Signatur ist so schön wie Ihre eigene. Lassen wir Set-OutlookSignatures also mit Ihren eigenen Vorlagen arbeiten!

- Erstellen Sie einen Ordner mit Ihren eigenen Vorlagen und Konfigurationen. Befolgen Sie die FAQ '[What is the recommended folder structure for script, license, template and config files?](/faq#34-what-is-the-recommended-folder-structure-for-script-license-template-and-config-files)', da die Trennung von Quellcode und Anpassungen die Verwaltung und Versions-Upgrades erheblich vereinfacht.
  - Kopieren Sie für den Anfang einfach den Ordner '.\sample templates' und passen Sie die enthaltenen Vorlagen und die INI-Datei an.
- Lassen Sie Set-OutlookSignatures erneut laufen und geben Sie an, wo es die neuen Vorlagen findet:
  - '`-SignatureTemplatePath 'c:\your_signature_template_path'`' für den Ordner, in dem Ihre Signatur-Vorlagen liegen.
  - '`-SignatureIniFile 'c:\your_signature_template_path\_Signatures.ini'`' für den Pfad zur Signatur-Konfiguration.
  - Wenn Sie statt den DOCX- die HTML-Vorlagen angepasst haben, verwenden Sie zusätzlich '`-UseHtmTemplates true`'.

Ihr eigene Signatur in Outlook sieht gut aus? Mit dem [Simulations-Modus](/details#11-simulation-mode) finden Sie im Handumdrehen heraus, wie sie für ein anderes Postfach aussieht.

**Und jetzt Sie!**  
Passen Sie andere [Parameter](/parameters) an, die Sie nützlich finden.

Die [Liste der Funktionen](/features) und die [Dokumentation der Parameter](/parameters) zeigen, was möglich ist.

Auf unserer [FAQ-Seite](/faq) finden Sie Antworten auf die am häufigsten gestellten Fragen. Um tiefer einzutauchen, bietet unser [Hilfe- und Support-Zentrum](/help) großartige Unterlagen.

## Zeigen Sie, was Sie geschaffen haben {#show-what-you-created}
Wir wissen, dass einige von Ihnen visuell beeindruckende E-Mail-Signaturen erstellt, clevere Abwesenheitsnotizen verfasst, benutzerdefinierte Ersatzvariablen implementiert und sogar Systeme von Drittanbietern auf eine Weise integriert haben, die weit über die Grundlagen hinausgeht.

Jetzt haben Sie die Möglichkeit, diese mit der Community zu teilen.

Wir suchen:
- Finale Versionen oder Vorlagen Ihrer E-Mail-Signaturen
- Beispiele für Abwesenheitsnotizen
- Ausschnitte aus benutzerdefiniertem Code oder Integrationslogik
- Eine kurze Stellungnahme zu Ihren Erfahrungen mit Set-OutlookSignatures oder dem Benefactor Circle Add-On

Nehmen Sie einfach [Kontakt](/contact) mit uns auf!

## Benötigen Sie Hilfe oder weitere Funktionen? {#support}
Set-OutlookSignatures ist sehr gut dokumentiert, was unweigerlich eine Menge Inhalt mit sich bringt.

Wenn Sie jemanden mit Erfahrung suchen, der Sie schnell schulen und bei der Evaluierung, Planung, Implementierung und dem laufenden Betrieb unterstützen kann: Unser Partner <a href="https://explicitconsulting.at">ExplicIT Consulting</a> bietet erstklassigen [professionellen Support](/support), und das <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> bietet zusätzliche Funktionen für Ihr Unternehmen.

<p>
  <div class="buttons">
    <a href="/support" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Support-Optionen ansehen</a>
    <a href="/benefactorcircle" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">Das Benefactor Circle Add-On</a>
  </div>
</p>
