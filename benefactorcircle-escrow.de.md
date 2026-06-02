---
layout: "page"
lang: "de"
locale: "de"
title: "Benefactor Circle Add-on Software-Treuhand und Projekt-Betreuung"
subtitle: "Öffentliches Software-Fallback-Framework für das Benefactor Circle Add-on"
description: "Offizielle Fortführungsgarantien, technische Hinterlegungsmodelle und Betreuungsverpflichtungen für das Set-OutlookSignatures Benefactor Circle Add-on."
hero_link: "#governance-resource-index"
hero_link_text: "<span><b>Framework-Dokumente prüfen</b></span>"
hero_link_style: |
  style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
hero_link2: "https://github.com/Set-OutlookSignatures/benefactor-circle-add-on-proof-of-escrow"
hero_link2_text: "<span><b>Öffentliches Nachweis-Repository anzeigen</b></span>"
hero_link2_style: |
  style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  width: 1200
  height: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
hide_gh_sponsor: true
permalink: "/benefactorcircle-escrow"
redirect_from:
  - /benefactorcircle-escrow/
sitemap_priority: 0.8
sitemap_changefreq: weekly
---

## Öffentliches Software-Fallback- und Projekt-Treuhand-Framework

**Absicherung der operativen Fortführbarkeit des Set-OutlookSignatures Benefactor Circle Add-ons.**

Die ExplicIT Consulting GmbH anerkennt die strukturelle Bedeutung des Open-Source-Projekts [Set-OutlookSignatures](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/, https://set-outlooksignatures.com). Um die technische und organisatorische Beständigkeit des kommerziellen Benefactor Circle Add-ons zu garantieren, haben wir ein öffentliches Betreuungs-Framework vereinbart. Dieses Angebot detailliert den Mechanismus, der genutzt wird, um die Fallback-Sicherheit sowohl für Projektadministratoren als auch für Unternehmenskunden aufrechtzuerhalten.

## Framework-Überblick

Diese Initiative ist als öffentliche einseitige Verpflichtungserklärung ausgestaltet Sie bietet direkte Schutzrechte, auf die sich die Projekt-Community und die Administratoren verlassen können. Unter diesem Framework werden der zugrundeliegende Quellcode, die Build-Konfiguration und die Dokumentation auf die Open-Source-Projektadministratoren übertragen, sofern bestimmte Auslöser-Ereignisse eintreffen.

### Technische Kernsäulen

- **Release-synchronisierte Hinterlegungen:** Ein vollständiges Deposit-Paket wird innerhalb von zehn Geschäftstagen nach jedem Produktions-Release des Add-ons aktualisiert.
- **Kryptographische Nachweise:** Für jedes Deposit-Archiv wird sein SHA-256-Hashwert berechnet. Der Hash wird zusammen mit einer Manifest-Datei und einer Hash-Verifizierungsdatei direkt im [Nachweis-Repository](https://github.com/Set-OutlookSignatures/benefactor-circle-add-on-proof-of-escrow) veröffentlicht.
- **Quartalsweise Einsichtsrechte:** Die Projektadministratoren behalten das Recht, in jedem Kalendervierteljahr oder nach jedem Repo-Update eine technische Vorführung zu verlangen, um zu überprüfen, ob das geheime Repository existiert, zugänglich ist und ein voll funktionsfähiges Produkt baut.

### Umfang des Deposit-Pakets

Wie in der Dokumentation zur technischen Architektur festgelegt, ist die Treuhand-Hinterlegung strikt kategorisiert, um die proprietäre Sicherheit mit der operativen Fortführung in Einklang zu bringen.

- **Inbegriffene Materialien:** Dies umfasst den vollständigen Quellcode des Add-ons, Build-Anweisungen, Abhängigkeitslisten (SBOM), Konfigurations- und Schemadefinitionen, Validierungstests und Architekturhinweise.
- **Ausgeschlossene Materialien:** Dies schließt Nutzer- oder Kundendatenbanken, aktive Zugangsdaten oder Passwörter, private Schlüssel und Zertifikate sowie interne kaufmännische Finanzdaten ausdrücklich aus.

## Auslöser-Bedingungen und Übergangsprozess

Der Prozess zur Code-Übergabe wird durch strenge Verifizierungsprotokolle geregelt, um eine unbefugte Offenlegung von geistigem Eigentum zu verhindern.

### Autorisierte Auslöser-Ereignisse

Eine Übergabe kann nur unter zwei Bedingungen eingeleitet werden:

1. Ausdrückliche schriftliche Einstellung oder Einstellung der Produktpflege durch die ExplicIT Consulting GmbH ohne einen ernannten Nachfolger.
2. Endgültiges Scheitern der Geschäftskontinuität, wie z. B. die Auflösung des Unternehmens, die Löschung im Firmenbuch oder eine Produktübertragung, bei der die neue Einheit diese Covenant-Verpflichtungen nicht schriftlich übernimmt.

### Verifizierungs-Zeitplan

Außer in Fällen von sofortiger Wirkung durch eine ausdrückliche Stornierung gilt eine standardmäßige Wartezeit von 90 Kalendertagen. Die Projektadministratoren müssen eine formelle Auslöser-Mitteilung im Nachweis-Repository einreichen. Wenn der Mitteilung innerhalb von 90 Tagen nicht mit fundierten Gründen widersprochen wird, wird der Auslöser rechtlich wirksam.

### Code-Autonomie und Open-Source-Rechte

Mit Wirksamwerden eines Auslösers gewährt die ExplicIT Consulting GmbH dem Projekt eine weltweite, unentgeltliche, unbefristete, unwiderrufliche und nicht-exklusive Lizenz am Code-Paket. Die Projektadministratoren besitzen die Befugnis, das Produkt privat weiterzuführen oder es unter einer anerkannten Open-Source-Softwarelizenz öffentlich freizugeben.

## Governance-Ressourcen-Index {#governance-resource-index}

Das Framework stützt sich auf standardisierte Dokumente, die im [Nachweis-Repository](https://github.com/Set-OutlookSignatures/benefactor-circle-add-on-proof-of-escrow) geführt werden, um Transparenz und Nachfolge zu regeln:

- **Covenant:** Das rechtliche Fundament, das Rechte, Umfänge und Haftung definiert (siehe `covenant-de.md` und `covenant-en.md`).
- **Technical Spec:** Die technischen Definitionen, die beschreiben, wie Deposits gebaut und wie die quartalsweisen Systemvorführungen durchgeführt werden (siehe `technical-spec-de.md` und `technical-spec-en.md`).
- **Successor Assumption:** Die Dokumentation, die von einer übernehmenden Einheit genutzt wird, um diese Fortführungsverpflichtungen zu übernehmen, ohne einen Auslöser auszulösen (beschrieben in `README.md`).
- **Trigger Notice:** Das formelle Feststellungsdokument, das von den Projektadministratoren verwendet wird, um einen aktiven Kontinuitätsanspruch zu protokollieren (beschrieben in `README.md`).
