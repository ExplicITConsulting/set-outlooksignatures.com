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
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal has-text-weight-bold  mtrcs-download">Software herunterladen</a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
</div>


## Schritt 2: Einmalige Vorbereitungen {#step-2}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
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
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
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
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Entra ID App für Exchange Online erstellen</b></p>
          <p>Folgen Sie den Anweisungen in <code>.\config\default graph config.ps1</code> für die manuelle Einrichtung oder lassen Sie einen "Globalen Administrator" oder "Anwendungsadministrator" den bereitgestellten PowerShell-Befehl ausführen.</p>
{% highlight batch %}{% raw %}
powershell.exe -NoExit -File "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"
{% endraw %}{% endhighlight %}
          <p>Für nationale oder Sovereign Clouds fügen Sie den Parameter <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> hinzu.</p>
          <p>Prüfen Sie die erforderlichen Berechtigungen vorab: Alle Informationen zur Nutzung finden Sie in den Dateien selbst sowie im Kapitel <a href="/details#security-considerations">Security considerations</a>.</p>
        </div>
      </div>
    </div>
  </div>
</div>


## Schritt 3: Set-OutlookSignatures ausführen {#step-3}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Exchange Online / Hybrid</b></p>
{% highlight batch %}{% raw %}
powershell.exe -NoExit -File "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<Entra ID app client ID>"
{% endraw %}{% endhighlight %}
          <p><small><em><code>-GraphOnly true</code> stellt sicher, dass das lokale AD ignoriert wird. Fügen Sie den Parameter <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> hinzu, wenn Sie eine nationale oder Sovereign Cloud nutzen.</em></small></p>
          <p><small><em>Falls das Skript nicht startet: Rechtsklick auf Set-OutlookSignatures.ps1 > Eigenschaften > "Zulassen" (Unblock) anhaken.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🏢</span>
        <div>
          <p><b>Exchange On-Prem</b></p>
{% highlight batch %}{% raw %}
powershell.exe -NoExit -File "c:\test\Set-OutlookSignatures.ps1"
{% endraw %}{% endhighlight %}
          <p><small><em>Falls das Skript nicht startet: Rechtsklick auf Set-OutlookSignatures.ps1 > Eigenschaften > "Zulassen" (Unblock) anhaken.</em></small></p>
        </div>
      </div>
    </div>
  </div>
</div>
<details>
  <summary style="cursor: pointer;">
    Hier klicken für die Ausgabe eines Beispieldurchlaufs (für Endbenutzer normalerweise <a href="/faq#start-set-outlooksignatures-in-hiddeninvisible-mode">versteckt/unsichtbar ausgeführt</a>).
  </summary>
{% highlight plaintext %}{% raw %}
{% root_include "/assets/signatures from demo/log.txt" | escape_once %}
{% endraw %}{% endhighlight %}
</details>
<p>&nbsp;</p>
<p><b>Sie finden nun drei neue Signaturen in Outlook, die auf den integrierten Beispielvorlagen und den Attributen Ihres eigenen Benutzers basieren:</b></p>
<ul>
  <li><b><code>Formal</code></b> ist ideal für neue E-Mails an externe Empfänger.</li>
  <li><b><code>Informal</code></b> eignet sich hervorragend für Antworten, Weiterleitungen und interne E-Mails.</li>
  <li><b><code>Test all default replacement variables</code></b> gibt Ihnen einen Überblick über die integrierten Platzhalter und einen Einblick in die Möglichkeiten für Bilder, Banner sowie Telefonnummern- und Adressformatierung.</li>
</ul>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
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

## Signaturen aus den enthaltenen Mustervorlagen {#examples}
<p>Nehmen wir an, <b>Herr Bobby Busy</b> arbeitet als Sekretär im <i>Vorstandsbüro</i> von <i>Galactic Experiences</i>. Er besitzt ein eigenes persönliches Postfach, sendet E-Mails im Namen der CEO, <b>Frau Alex Alien</b>, und kann vom freigegeben Postfach des <b>Vorstandsbüros (Exec Board Office)</b> schicken.</p>
<p>Die Unternehmensrichtlinien schreiben vor, dass Signaturen nicht nur Informationen über das sendende Postfach enthalten müssen, sondern auch über den tatsächlichen Absender. Mit den standardmäßigen Mustervorlagen und der Konfiguration entstehen daraus automatisch folgende Varianten:</p>
<div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 0.75rem;">
  <div class="tabs is-toggle mb-0"><li class="is-active" data-target="sig-formal"><a>Formal</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-formal-alex"><a>Formal Delegate alex.alien</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-formal-exec"><a>Formal executiveboard.office</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-informal"><a>Informal</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-informal-alex"><a>Informal Delegate alex.alien</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-informal-exec"><a>Informal executiveboard.office</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-test-all"><a>Test all default replacement variables</a></li></div>
</div>
<div id="signature-gallery-content" class="p-4 has-background-white" style="border: 1px solid #dbdbdb; border-radius: 4px;">
  <div id="sig-formal" class="tab-content-panel has-text-black">
    <p><i>Formal: Vollständige Signatur für das persönliche Postfach von Bobby Busy</i></p>
    <iframe src="/assets/signatures from demo/Formal.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-formal-alex" class="tab-content-panel has-text-black is-hidden">
    <p><i>Formal Delegate alex.alien: Vollständige Signatur für den Fall, dass Bobby im Namen der CEO, Frau Alex Alien, sendet</i></p>
    <iframe src="/assets/signatures from demo/Formal Delegate alex.alien.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-formal-exec" class="tab-content-panel has-text-black is-hidden">
    <p><i>Formal executiveboard.office: Vollständige Signatur für den Fall, dass Bobby als geteiltes Postfach des Vorstandsbüros sendet</i></p>
    <iframe src="/assets/signatures from demo/Formal executiveboard.office.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-informal" class="tab-content-panel has-text-black is-hidden">
    <p><i>Informal: Kurzsignatur für das persönliche Postfach (interne Kommunikation, Antworten/Weiterleitungen bei externem E-Mail-Verlauf)</i></p>
    <iframe src="/assets/signatures from demo/Informal.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-informal-alex" class="tab-content-panel has-text-black is-hidden">
    <p><i>Informal Delegate alex.alien: Kurzsignatur für den Fall, dass Bobby im Namen der CEO, Frau Alex Alien, sendet (interne Kommunikation, Antworten/Weiterleitungen bei externem E-Mail-Verlauf)</i></p>
    <iframe src="/assets/signatures from demo/Informal Delegate alex.alien.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-informal-exec" class="tab-content-panel has-text-black is-hidden">
    <p><i>Informal executiveboard.office: Kurzsignatur für den Fall, dass Bobby als geteiltes Postfach des Vorstandsbüros sendet (interne Kommunikation, Antworten/Weiterleitungen bei externem E-Mail-Verlauf)</i></p>
    <iframe src="/assets/signatures from demo/Informal executiveboard.office.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-test-all" class="tab-content-panel has-text-black is-hidden">
    <p><i>Test all default replacement variables: Zeigt alle Platzhalter, aber auch Profilbilder, bedingte Banner, QR-Codes und mehr</i></p>
    <iframe src="/assets/signatures from demo/Test all default replacement variables.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
</div>

<!-- JavaScript to handle the new wrapped button layout -->
<script>
  function resizeIframe(iframe) {
    if (iframe && iframe.contentWindow && iframe.contentWindow.document.body) {
      iframe.style.height = iframe.contentWindow.document.body.scrollHeight + 'px';
    }
  }

  // Look for any list item with a data-target attribute, regardless of its parent container
  const tabElements = document.querySelectorAll('[data-target]');

  tabElements.forEach(tab => {
    tab.addEventListener('click', () => {
      // 1. Toggle Active Class on the clicked element and remove from others
      tabElements.forEach(t => t.classList.remove('is-active'));
      tab.classList.add('is-active');

      // 2. Toggle Active Panel Visibility
      document.querySelectorAll('.tab-content-panel').forEach(panel => panel.classList.add('is-hidden'));
      const targetId = tab.dataset.target;
      const targetPanel = document.getElementById(targetId);
      targetPanel.classList.remove('is-hidden');

      // 3. Force Resize on the newly visible iframe
      const iframe = targetPanel.querySelector('iframe');
      resizeIframe(iframe);
    });
  });

  // Automatically adjust heights once the HTML files finish loading completely
  document.querySelectorAll('.tab-content-panel iframe').forEach(iframe => {
    iframe.addEventListener('load', () => {
      if (!iframe.closest('.tab-content-panel').classList.contains('is-hidden')) {
        resizeIframe(iframe);
      }
    });
  });
</script>

## Anpassen {#customize}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🎨</span>
        <div>
          <p><b>Eigene Vorlagen verwenden</b></p>
          <p>Bereit für mehr als nur Beispiele? Kopieren Sie <code>.\sample templates</code> in einen neuen Ordner und beginnen Sie mit der Bearbeitung. Wir empfehlen, unserer <a href="/faq#folder-structure-recommendation">Empfehlung zur Ordnerstruktur</a> zu folgen, um zukünftige Updates zu erleichtern.</p>
          <p>Verweisen Sie das Skript auf Ihre neuen Dateien mit:</p>
{% highlight batch %}{% raw %}
[…] -SignatureTemplatePath "C:\Signatures\Templates" -SignatureIniFile "C:\Signatures\Templates\_Signatures.ini"
{% endraw %}{% endhighlight %}
          <p><small><em>Bei Verwendung von HTML-Vorlagen fügen Sie einfach <code>-UseHtmTemplates true</code> hinzu.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🎯</span>
        <div>
          <p><b>Reichweite ausbauen</b></p>
          <p>Sobald Ihre Vorlagen bereit sind, definieren Sie gezielt, wer welche Signatur erhält.</p>
          <p>Steuern Sie dies zentral über Template-Zuweisung und INI-Konfiguration – z. B. durch gezielte Zuweisung zu Postfächern, Gruppen oder Attributen, mehrere Varianten aus einer Vorlage sowie unterschiedliche Standards für neue E-Mails und Antworten.</p>
          <p>Details:</p>
          <ul>
            <li><a href="/details#template-tags-and-ini-files">Template-Tags und INI-Dateien</a></li>
            <li><a href="/parameters">Parameter-Dokumentation</a></li>
            <li><a href="/features">Funktionsübersicht</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid #ff3860;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.75em;">
        <span style="font-size: 1.5rem;">✨</span>
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