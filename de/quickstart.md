---
layout: page
lang: de
title: |
  <span class="title is-2 has-text-white">
    Schnellstart-Anleitung
  </span>
subtitle: |
  <span class="subtitle is-4 has-text-white">
    Ihre ersten Signaturen in unter einer Stunde
  </span>
description: |
  Schnellstart-Anleitung. Verteilen Sie Ihre ersten Signaturen in unter einer Stunde. Implementierung. Hilfe.
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

## Ihre ersten Signaturen in unter einer Stunde
Folgen Sie der einfachen 4-Schritte-Anleitung, um Ihre ersten Signaturen zu verteilen, einen Einblick in die Möglichkeiten von Set-OutlookSignatures zu erhalten und einen soliden Ausgangspunkt für Ihre eigenen Anpassungen zu schaffen.

## Schritt 1: Voraussetzungen prüfen
Für einen ersten Testlauf ist es empfehlenswert, sich mit einem Testbenutzer auf einem Windows-System anzumelden, auf dem Word und Outlook installiert sind und Outlook zumindest mit dem Postfach des Testbenutzers konfiguriert ist. Auf diese Weise erhalten Sie schnell Ergebnisse und können den größten Funktionsumfang nutzen.

Für die vollständige Unterstützung von Linux und macOS ist das ➔&nbsp;<a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> erforderlich und die Postfächer müssen in Exchange Online gehostet werden.

Wenn sich einige oder alle Postfächer in Exchange Online befinden, benötigen Sie einen Benutzer mit 'Global Admin'- oder 'Application Administrator'-Rechten für einmalige Vorbereitungen.


## Schritt 2: Set-OutlookSignatures herunterladen
Laden Sie Set-OutlookSignatures herunter und entpacken Sie das Archiv in einen lokalen Ordner.

<p><a id="download-link" href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" target="_blank"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔&nbsp;<span class="version-text">Die aktuelle Version</span>&nbsp;als ZIP-Datei herunterladen</button></a></p>

Heben Sie unter Windows und macOS die Blockierung der Datei 'Set-OutlookSignatures.ps1' auf. Sie können dazu das PowerShell-Cmdlet 'Unblock-File' verwenden oder im Datei-Explorer mit der rechten Maustaste auf die Datei klicken, Eigenschaften auswählen und 'Unblock' anklicken. Dadurch wird das 'Mark of the Web' entfernt, das die Skriptausführung verhindern kann, wenn die PowerShell-Ausführungsrichtlinie auf RemoteSigned eingestellt ist.

Wenn Sie AppLocker oder eine vergleichbare Lösung (Defender, CrowdStrike, Ivanti und andere) verwenden, müssen Sie möglicherweise die vorhandene digitale Signatur zu Ihrer Zulassungsliste hinzufügen oder zusätzliche Einstellungen in Ihrer Sicherheitssoftware festlegen.


## Schritt 3: Entra ID vorbereiten
Wenn sich einige oder alle Postfächer in Exchange Online befinden, müssen Sie zunächst eine Entra ID App registrieren, da Set-OutlookSignatures Berechtigungen für den Zugriff auf die Graph API benötigt.

Um die Entra ID App zu erstellen, bitten Sie einen 'Global Admin' oder 'Application Administrator', folgendes auszuführen
```
.\sample code\Create-EntraApp.ps1 -AppType 'Set-OutlookSignatures' -AppName 'Set-OutlookSignatures'
```
und den Anweisungen zu folgen.

Der Code in der Skriptdatei ist gut dokumentiert und enthält alle Details zu den erforderlichen Einstellungen der Entra ID App, den Berechtigungen und warum sie benötigt werden.


## Schritt 4: Set-OutlookSignatures ausführen
- **Wenn alle Postfächer on-prem gehalten werden**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
  ```

- **Wenn einige oder alle Postfächer in Exchange Online gehalten werden**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from step 3>"
  ```
  Der Parameter '-GraphOnly true' stellt sicher, dass das on-prem Active Directory ignoriert wird und stattdessen nur Graph/Entra ID zum Finden von Postfächern und deren Attributen verwendet wird.

Wenn Sie nicht die Public Cloud von Microsoft nutzen, sondern eine National Cloud, fügen Sie folgenden Parameter hinzu: '-CloudEnvironment \[AzureUSGovernment\|AzureUSGovernmentDoD\|AzureChina\]'

Set-OutlookSignatures verteilt jetzt ihr ersten Signaturen, basierend auf Standardeinstellungen und Beispielvorlagen.

Öffnen Sie Outlook und werfen Sie einen Blick auf die neu erzeugten Signaturen, besonders auf die Vorzeigesignatur 'Test all default replacement variables'.


## Anpassungen vornehmen
Wenn mit den Standardeinstellung alles gut funktioniert, ist es an der Zeit damit zu beginnen, das Verhalten der Software Ihren Bedürfnissen anzupassen. Zum Beispiel:
- Erstellen Sie einen Ordner mit Ihren eigenen Vorlagen und Konfigurationen.  
  Es ist eine gute Idee, den Ordner '.\sample templates' zu kopieren und dessen Inhalte zu bearbeiten.  
  Vergessen sie nicht, Set-OutlookSignatures mit den Parametern 'SignatureTemplatePath', 'SignatureIniFile', 'OOFTemplatePath' and 'OOFIniFile' mitzuteilen, wo Ihre Vorlagen und Konfiguration zu finden sind.
- Passen Sie andere [Parameter](/parameters) an, die Sie nützlich finden.
- Beginnen Sie, den [Simulations-Modus](/parameters/#16-simulateuser) zu nutzen.

Die [Liste der Funktionen](/features) und die [Dokumentation der Parameter](/parameters) zeigen, was möglich ist.

Die [FAQ-Seite](/faq) hilft Ihnen, Antworten auf die am häufigsten an uns gestellten Fragen zu finden. Um tiefer einzutauchen, bietet unser [Hilfe- und Support-Zentrum](/help) großartige Unterlagen.


## Benötigen Sie Hilfe oder weitere Funktionen?
Set-OutlookSignatures ist sehr gut dokumentiert, was unweigerlich eine Menge Inhalt mit sich bringt.

Wenn Sie jemanden mit Erfahrung suchen, der Sie schnell schulen und bei der Evaluierung, Planung, Implementierung und dem laufenden Betrieb unterstützen kann: Unser Partner <a href="https://explicitconsulting.at" target="_blank">ExplicIT Consulting</a> bietet erstklassigen [kostenpflichtigen Support](/support), und das ➔&nbsp;<a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></a> bietet zusätzliche Funktionen für Ihr Unternehmen.

<p><a href="/support"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Support-Optionen ansehen</button></a></p>

<p><a href="/benefactorcircle"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">➔ Das Benefactor Circle Add-On</button></a></p>


<script>
  fetch('https://api.github.com/repos/Set-OutlookSignatures/Set-OutlookSignatures/releases/latest')
    .then(response => response.json())
    .then(data => {
      document.querySelectorAll('.version-text').forEach(span => {
        span.textContent = data.tag_name;
      });

      document.getElementById('download-link').href = 
        `https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases/download/${data.tag_name}/Set-OutlookSignatures_${data.tag_name}.zip`;
    })
    .catch(error => {
      console.error('Error fetching release info:', error);
    });
</script>
