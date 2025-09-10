---
layout: page
lang: de
locale: de
title: Schnellstart-Anleitung
subtitle: Erste Signaturen in unter einer Stunde
description: Erste Signaturen in unter einer Stunde
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
redirect_from:
  - /de/quick
  - /de/quick-start
  - /de/quickstartguide
  - /de/quickstart-guide
  - /de/quick-start-guide
---


## Schritt 1: Set-OutlookSignatures herunterladen {#step-1}
Laden Sie Set-OutlookSignatures herunter und entpacken Sie das Archiv in einen lokalen Ordner.

<p><a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Software herunterladen</button></a></p>

Heben Sie unter Windows und macOS die Blockierung der Datei 'Set-OutlookSignatures.ps1' auf. Sie können dazu das PowerShell-Cmdlet 'Unblock-File' verwenden oder im Datei-Explorer mit der rechten Maustaste auf die Datei klicken, Eigenschaften auswählen und 'Unblock' anklicken. Dadurch wird das 'Mark of the Web' entfernt, das die Ausführung in PowerShell verhindern kann.

Wenn Sie AppLocker oder eine vergleichbare Lösung (Defender, CrowdStrike, Ivanti und andere) verwenden, müssen Sie möglicherweise die vorhandene digitale Signatur zu Ihrer Zulassungsliste hinzufügen oder zusätzliche Einstellungen in Ihrer Sicherheitssoftware festlegen.


## Schritt 2: Einmalige Vorbereitungen {#step-2}
**Client und Benutzer**  
Für einen ersten Testlauf ist es empfehlenswert, sich mit einem Testbenutzer auf einem Windows-System anzumelden, auf dem Word und Outlook installiert sind und Outlook zumindest mit dem Postfach des Testbenutzers konfiguriert ist. Wenn Sie Ihren eigenen Benutzer verwenden, werden im schlimmsten Fall bestehende Signaturen überschrieben.

Für die vollständige Unterstützung von Linux und macOS ist das <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> erforderlich und die Postfächer müssen in Exchange Online gehostet werden.

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
  Der Parameter '-GraphOnly true' stellt sicher, dass das on-prem Active Directory ignoriert wird und stattdessen nur Graph/Entra ID zum Finden von Postfächern und deren Attributen verwendet wird.

Wenn Sie nicht die Public Cloud von Microsoft nutzen, sondern eine National Cloud, fügen Sie folgenden Parameter hinzu: '-CloudEnvironment \[AzureUSGovernment\|AzureUSGovernmentDoD\|AzureChina\]'

Set-OutlookSignatures verteilt jetzt erste Signaturen, basierend auf Standardeinstellungen und Beispielvorlagen.

Öffnen Sie Outlook und werfen Sie einen Blick auf die neu erzeugten Signaturen, besonders auf die Vorzeigesignatur 'Test all default replacement variables'.


## Anpassungen vornehmen {#customize}
Wenn mit den Standardeinstellungen alles gut funktioniert, haben Sie einen soliden Ausgangspunkt für Ihre eigenen Anpassungen.

Sie können Set-OutlookSignatures jetzt für Ihre konkreten Anforderungen konfigurieren. Zum Beispiel:
- Erstellen Sie einen Ordner mit Ihren eigenen Vorlagen und Konfigurationen.  
  Es ist eine gute Idee, den Ordner '.\sample templates' zu kopieren und dessen Inhalte zu bearbeiten.  
  Vergessen Sie nicht, Set-OutlookSignatures mit den Parametern 'SignatureTemplatePath', 'SignatureIniFile', 'OOFTemplatePath' and 'OOFIniFile' mitzuteilen, wo Ihre Vorlagen und Konfiguration zu finden sind.
- Passen Sie andere [Parameter](/parameters) an, die Sie nützlich finden.
- Beginnen Sie, den [Simulations-Modus](/parameters/#16-simulateuser) zu nutzen.

Die [Liste der Funktionen](/features) und die [Dokumentation der Parameter](/parameters) zeigen, was möglich ist.

Die [FAQ-Seite](/faq) hilft Ihnen, Antworten auf die am häufigsten an uns gestellten Fragen zu finden. Um tiefer einzutauchen, bietet unser [Hilfe- und Support-Zentrum](/help) großartige Unterlagen.


## Benötigen Sie Hilfe oder weitere Funktionen? {#support}
Set-OutlookSignatures ist sehr gut dokumentiert, was unweigerlich eine Menge Inhalt mit sich bringt.

Wenn Sie jemanden mit Erfahrung suchen, der Sie schnell schulen und bei der Evaluierung, Planung, Implementierung und dem laufenden Betrieb unterstützen kann: Unser Partner <a href="https://explicitconsulting.at">ExplicIT Consulting</a> bietet erstklassigen [professionellen Support](/support), und das <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> bietet zusätzliche Funktionen für Ihr Unternehmen.

<p><a href="/support"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Support-Optionen ansehen</button></a></p>

<p><a href="/benefactorcircle"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">➔ Das Benefactor Circle Add-On</button></a></p>
