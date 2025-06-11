Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    tracking_code = <<~HTML
      <script>
        var _paq = window._paq = window._paq || [];
        _paq.push(["setRequestMethod", "POST"]);

        /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
        _paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
        _paq.push(["setCookieDomain", "*.set-outlooksignatures.com"]);
        _paq.push(["setDomains", ["*.set-outlooksignatures.com"]]);
        _paq.push(["disableCookies"]);
        _paq.push(['trackPageView']);
        _paq.push(['enableLinkTracking']);

        (function () {
          var u = "//mtrcs.explicitconsulting.at/";
          _paq.push(["setTrackerUrl", u + "poop.php"]);
          _paq.push(["setSiteId", "1"]);
          var d = document, g = d.createElement("script"), s = d.getElementsByTagName("script")[0];
          g.type = "text/javascript"; g.async = true; g.defer = true; g.src = u + "poop.js"; s.parentNode.insertBefore(g, s);
        })();
      </script>

      <noscript>
        <p><img referrerpolicy="no-referrer-when-downgrade" src="//mtrcs.explicitconsulting.at/poop.php?idsite=1&amp;rec=1" style="border:0;" alt="" /></p>
      </noscript>
    HTML

    doc.output.gsub!('</head>', "#{tracking_code}\n</head>")
  end
end
