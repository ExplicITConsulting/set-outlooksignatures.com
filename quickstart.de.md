---
layout: "page"
lang: "de"
locale: "de"
title: "Schnellstart-Anleitung"
subtitle: "Signaturen in wenigen Minuten"
description: "Schnellstart-Anleitung. Signaturen innerhalb von Minuten bereitstellen."
permalink: "/quickstart"
---
## Schritt 1: Herunterladen {#step-1}
<div class="buttons">
Laden Sie das Archiv herunter und entpacken Sie es in einen lokalen Ordner: 
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal is-hovered  has-text-weight-bold  mtrcs-download">Software herunterladen</a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
</div>


## Schritt 2: Einmalige Vorbereitungen {#step-2}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💻</span>
        <div>
          <p><b>Client und Benutzer</b></p>
          <p>Melden Sie sich mit einem Testbenutzer unter Windows mit Classic Outlook und Word an. Wenn Sie dies mit Ihrem Hauptkonto ausführen, werden Signaturen mit den Namen <code>Formal</code> oder <code>Informal</code> überschrieben, sofern Sie nicht den später beschriebenen Simulationsmodus verwenden.</p>
          <p>Linux, macOS und das neue Outlook erfordern das <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span></a> und Hosting in Exchange Online.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #48c774;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🛡️</span>
        <div>
          <p><b>Endpoint Security (AppLocker, Defender, CrowdStrike…)</b></p>
          <p>Vertrauen Sie der Software, die mit dem Zertifikat von ExplicIT Consulting signiert ist – alle enthaltenen PS1- und DLL-Dateien sind mit diesem Zertifikat signiert.</p>
          <p>Erlaufen Sie bei Bedarf die Ausführung und das Laden von Bibliotheken aus dem TEMP-Ordner.</p>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #ffdd57;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Entra ID App für Exchange Online erstellen</b></p>
          <p>Folgen Sie den Anweisungen in <code>.\config\default graph config.ps1</code> für die manuelle Einrichtung oder lassen Sie einen "Globalen Administrator" oder "Anwendungsadministrator" den bereitgestellten PowerShell-Befehl ausführen.</p>
          <div class="highlighter-rouge">
            <pre><code>powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"</code></pre>
          </div>
          <p><small><em>Für nationale oder Sovereign Clouds fügen Sie den Parameter <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> hinzu.</em></small></p>
        </div>
      </div>
    </div>
  </div>
</div>


## Schritt 3: Set-OutlookSignatures ausführen {#step-3}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Exchange Online / Hybrid</b></p>
          <div class="highlighter-rouge">
            <pre><code>powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "&lt;GraphClientId from Step 2&gt;"</code></pre>
          </div>
          <p><small><em><code>-GraphOnly true</code> stellt sicher, dass das lokale AD ignoriert wird. Fügen Sie den Parameter <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> hinzu, wenn Sie eine nationale oder Sovereign Cloud nutzen.</em></small></p>
          <p><small><em>Falls das Skript nicht startet: Rechtsklick auf Set-OutlookSignatures.ps1 > Eigenschaften > "Zulassen" (Unblock) anhaken.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🏢</span>
        <div>
          <p><b>Exchange On-Prem</b></p>
          <div class="highlighter-rouge">
            <pre><code>powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"</code></pre>
          </div>
          <p><small><em>Falls das Skript nicht startet: Rechtsklick auf Set-OutlookSignatures.ps1 > Eigenschaften > "Zulassen" (Unblock) anhaken.</em></small></p>
        </div>
      </div>
    </div>
  </div>
</div>
<p><b>Sie finden nun drei neue Signaturen in Outlook, die auf den integrierten Beispielvorlagen und den Attributen Ihres eigenen Benutzers basieren:</b></p>
<ul>
  <li><b><code>Formal</code></b> ist ideal für neue E-Mails an externe Empfänger.</li>
  <li><b><code>Informal</code></b> eignet sich hervorragend für Antworten, Weiterleitungen und interne E-Mails.</li>
  <li><b><code>Test all default replacement variables</code></b> gibt Ihnen einen Überblick über die integrierten Platzhalter und einen Einblick in die Möglichkeiten für Bilder, Banner sowie Telefonnummern- und Adressformatierung.</li>
</ul>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #ffdd57;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💡</span>
        <div>
          <p><b>Profi-Tipp: Risikofrei starten mit dem Simulationsmodus</b></p>
          <p>Wenn Sie kein Classic Outlook installiert haben oder die Software ohne Auswirkungen testen möchten, nutzen Sie den <a href="/details#simulation-mode">Simulationsmodus</a>: Dieser Modus erstellt die exakten Signaturen für den simulierten Benutzer als Dateien auf Ihrer Festplatte, ohne Outlook zu verändern – der perfekte Weg, um Ihre Konfiguration zu prüfen, ohne Systemeinstellungen zu ändern.</p>
          <p>Fügen Sie einfach den Parameter <code>-SimulateUser a@example.com -SimulateMailboxes a@example.com</code> hinzu und sehen Sie sich die Ergebnisse in Ihrem Ordner <code>Dokumente\Outlook Signatures</code> an.</p>
        </div>
      </div>
    </div>
  </div>
</div>


## Anpassen {#customize}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🎨</span>
        <div>
          <p><b>Eigene Vorlagen verwenden</b></p>
          <p>Bereit für mehr als nur Beispiele? Kopieren Sie <code>.\sample templates</code> in einen neuen Ordner und beginnen Sie mit der Bearbeitung. Wir empfehlen, unserer <a href="/faq#what-is-the-recommended-folder-structure-for-script-license-template-and-config-files">Anleitung zur Ordnerstruktur</a> zu folgen, um zukünftige Updates zu erleichtern.</p>
          <p>Verweisen Sie das Skript auf Ihre neuen Dateien mit:</p>
          <ul>
            <li><code>-SignatureTemplatePath "C:\Signatures\Templates"</code></li>
            <li><code>-SignatureIniFile "C:\Signatures\Templates\_Signatures.ini"</code></li>
          </ul>
          <p><small><em>Bei Verwendung von HTML fügen Sie einfach <code>-UseHtmTemplates true</code> hinzu.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #48c774;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🚀</span>
        <div>
          <p><b>Rollout skalieren</b></p>
          <p>Sobald Ihre Vorlagen bereit sind, erkunden Sie die <a href="/features">vollständige Funktionsliste</a>, die <a href="/details">technischen Details</a> und die <a href="/parameters">Parameter-Dokumentation</a>, um die Bereitstellung zu automatisieren und an Ihre Organisation anzupassen.</p>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid #ff3860;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.75em;">
        <span style="font-size: 1.5rem;">⭐</span>
        <div>
          <p class="title is-4 has-text-black">Teilen Sie Ihren Erfolg!</p>
          <p>Haben Sie etwas Großartiges erstellt? Ob es eine optisch beeindruckende E-Mail-Signatur, clevere Abwesenheitsnotizen, benutzerdefinierte Ersetzungsvariablen oder eine einzigartige Drittanbieter-Integration ist — <b>wir wollen es sehen.</b></p>
          <div>
            <p>Wir freuen uns über:</p>
            <ul>
              <li>Fertige Vorlagen oder einzigartige Design-Layouts.</li>
              <li>Kreative Beispiele für Abwesenheitsnotizen (OOF).</li>
              <li>Snippets von benutzerdefinierter Logik oder Integrationsskripten.</li>
              <li>Einen kurzen Erfahrungsbericht über Set-OutlookSignatures oder das Benefactor Circle Add-on.</li>
            </ul>
          </div>
          <p><small><em>Optional: Geben Sie Ihren Namen, Ihre Rolle, Ihr Firmenlogo oder ein Foto an, um in unserem Community-Showcase vorgestellt zu werden!</em></small></p>
          <a href="/support" class="button is-danger is-outlined has-text-weight-bold">Kontakt aufnehmen & andere inspirieren!</a>
        </div>
      </div>
    </div>
  </div>
</div>


<p id="remark-1" class="mt-6 is-italic has-text-centered">
  Die <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> Lizenz finanziert die Open-Source-Mission und stellt sicher, dass die Core-Engine für die weltweite Community kostenlos und Peer-Review-fähig bleibt.
</p>