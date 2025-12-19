---
layout: "post"
lang: "de"
locale: "de"
title: "Die besten Bildformate für E-Mail-Signaturen: Kompatibilitätsleitfaden"
description: "Wählen Sie das richtige Bildformat für Ihre E-Mail-Signatur. Stellen Sie universelle Kompatibilität sicher und vermeiden Sie Stolperfallen."
published: true
tags: 
slug: "image-formats"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Die Verwendung eines professionellen Bildes oder Logos in Ihrer E-Mail-Signatur steigert Ihre Markenpräsenz erheblich. Die Welt der E-Mail-Renderer ist jedoch bekanntermaßen komplex, und nicht alle Bildformate sind gleich. Die Wahl des falschen Formats oder der falschen Einbettungsart kann zu fehlerhaften Bildern, Sicherheitswarnungen oder schlechter Qualität auf dem Bildschirm Ihres Empfängers führen.

Dieser Leitfaden führt Sie durch die Formate, auf die Sie sich verlassen können, und diejenigen, die Sie besser nicht verwenden.


## Bildformate, die grundsätzlich von allen E-Mail-Clients unterstützt werden
- JPEG (.jpg oder .jpeg): Am besten geeignet für Fotos und komplexe Bilder mit vielen Farben und Farbverläufen. Bietet eine gute Komprimierung für kleinere Dateigrößen.
- PNG (.png): Ideal für Logos, Symbole und Grafiken, die einen transparenten Hintergrund benötigen. Unterstützt Millionen von Farben, kann jedoch größere Dateigrößen als JPEG haben.

## Bildformate, die weit verbreitet sind, aber mit Einschränkungen verbunden sind
- GIF (.gif): Perfekt für einfache Animationen oder Grafiken. Obwohl es weit verbreitet ist und großartige visuelle Effekte erzeugt, sollte es nur bei Bedarf verwendet werden: Einige E-Mail-Clients zeigen nur das erste Bild und nicht die Animation, andere zeigen die Animation möglicherweise erst, nachdem der Benutzer auf eine überlagerte Wiedergabetaste geklickt hat.


## Bildformate, die Sie vermeiden sollten
- SVG (.svg): SVG-Dateien eignen sich zwar hervorragend für das Web, werden jedoch aufgrund von Sicherheitsbedenken (Cross-Site-Scripting und andere) von den meisten E-Mail-Clients nicht vollständig unterstützt.
- WebP (.webp), HEIF (.heif), AVIF (.avif), APNG (.apng) und andere: Zu neu für E-Mail-Clients und deren integrierte Renderer. Einige dieser Formate werden noch nicht einmal von allen Browsern unterstützt.
- TIFF (.tiff), PSD (.psd): Völlig vermeiden. Hierbei handelt es sich um hochwertige, oft unkomprimierte Dateiformate, die für den professionellen Druck oder die Bearbeitung gedacht sind, nicht für die Anzeige im Web oder in E-Mails. Ihre Dateigrößen sind unzumutbar groß, was ein langsames Laden und keine Unterstützung durch E-Mail-Clients garantiert.
- BMP (.bmp): Völlig vermeiden. Ein sehr altes, unkomprimiertes Bitmap-Format, das hauptsächlich von Windows verwendet wird. Obwohl es gelegentlich von einigen Clients unterstützt wird, ist die Dateigröße im Vergleich zu einem optimierten JPEG oder PNG bei gleicher Qualität enorm. Halten Sie sich an die moderneren Standards.
- MP4 (.mp4, .m4*) und andere Animations- und Videoformate: Vollständig vermeiden. E-Mail-Clients können Videodateien in der Regel nicht direkt abspielen. Wenn Sie sie einfügen, werden oft Spam-Filter ausgelöst oder das Symbol für den Anhang wird nicht angezeigt. Um ein Video zu teilen, verwenden Sie ein statisches Bild, das auf eine externe Video-Hosting-Website verlinkt.


## Verlinkte Bilddateien
Verlinkte Bilder sind theoretisch eine großartige Sache, führen in der Praxis jedoch häufig zu Problemen.
- Aus Sicherheitsgründen zeigen die meisten E-Mail-Clients verlinkte Bilder erst dann an, wenn der Empfänger den Download genehmigt hat. In der Zwischenzeit wird in der Regel ein Platzhalterbild mit einer Fehlermeldung angezeigt.
- Sie können die Datei auf Ihrem Webserver nicht verschieben.
- Am Webserver aktualisierte Bilder werden je nach Client in älteren E-Mails angezeigt oder auch nicht.
- Wenn sich die Breite oder Höhe des Bildes ändert, kann dies unerwünschte visuelle Auswirkungen auf Ihre Signaturen haben.
- Nach dem Herunterladen des Bildes komprimieren und verkleinern einige E-Mail-Clients das Bild, wodurch es unscharf werden kann. Einige Outlook-Versionen tun dies nur, wenn Sie eine E-Mail mit verlinkten Bildern beantworten oder weiterleiten.

All dies hinterlässt weder einen professionellen Eindruck bei den Empfängern Ihrer E-Mails, noch macht es die Marketingabteilung glücklich.

Fügen Sie Bilder nach Möglichkeit direkt in Ihre Signatur ein, nicht als verlinkte Bilder. 


## Bilder direkt hinzufügen
Bilder können direkt hinzugefügt werden, d. h. nicht als verlinkte Bilddatei, als Base64-eingebettetes Bild oder als versteckter Anhang.
- Versteckte Anhänge, auch als Inline-Anhänge bekannt, sind seit langem der Standard. Praktisch alle E-Mail-Clients unterstützen dieses Format schon immer.
- Die Base64-Einbettung ist die modernere Methode. Anstatt auf einen versteckten Anhang zu verweisen, wird das Bild zu einem integralen Bestandteil des HTML-Codes der E-Mail.

Auf der Empfängerseite unterstützen E-Mail-Clients, die nach 2015 veröffentlicht wurden, nicht nur versteckte Anhänge, sondern auch eingebettete Bilder.

Auf der Absenderseite variiert die Unterstützung je nach Client und Plattform leicht. Aber keine Sorge: Sie müssen sich darüber keine Gedanken machen, Ihr E-Mail-Client kümmert sich um alles. Nehmen wir Outlook als Beispiel: Alle Editionen auf allen Plattformen unterstützen versteckte Anhänge, seit 2016 gilt das Gleiche auch für eingebettete Bilder.

Set-OutlookSignatures und das Benefactor Circle Add-On unterstützen beide Varianten, sodass Sie eine bevorzugte Option auswählen können, während Situationen, die die Verwendung einer bestimmten Methode erfordern, automatisch gemeistert werden.


## Fazit und abschließender Ratschlag
Die goldene Regel für E-Mail-Signaturen lautet: Kompatibilität geht vor modernster Technologie. Neue, hocheffiziente Bildformate wie WebP und AVIF sind zwar für das Web spannend, aber für die fragmentierte und eher traditionelle Welt der E-Mails einfach noch nicht bereit.

Um sicherzustellen, dass Ihre professionelle Signatur jedes Mal perfekt dargestellt wird, sollten Sie PNG für scharfe Logos und JPEG für fotografische Elemente verwenden.

Und denken Sie daran: Einbetten statt verlinken! So bleiben Ihre Bilder angehängt und sind vom Moment des E-Mail-Eingangs an sichtbar.

Wenn Sie diese einfachen Richtlinien befolgen, wird Ihr Markenimage stets makellos präsentiert.


## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to connecting with you!