Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTML'
      <!-- Metrics via JS -->
      <script>
        var _paq = window._paq = window._paq || [];
        _paq.push(["setRequestMethod", "POST"]);
        _paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
        _paq.push(["setCookieDomain", "*.set-outlooksignatures.com"]);
        _paq.push(["setDomains", ["*.set-outlooksignatures.com"]]);
        _paq.push(["disableCookies"]);
        _paq.push(['enableHeartBeatTimer']);
        _paq.push(["disableAlwaysUseSendBeacon"]);
        _paq.push(['setLinkClasses', "mtrcs-external-link"]);
        _paq.push(['trackPageView']);
       enableLinkTracking']);
        (function () {
          var u = "//mtrcs.explicitconsulting.at/";
          _paq.push(["setTrackerUrl", u + "poop.php"]);
          _paq.push(["setSiteId", "1"]);
          var d = document, g = d.createElement("script"), s = d.getElementsByTagName("script")[0];
          g.type = "text/javascript"; g.async = true; g.defer = true; g.src = u + "poop.js"; s.parentNode.insertBefore(g, s);
        })();
      </script>

      <!-- Metrics for non-JS environments -->
      <noscript>
        <p><img referrerpolicy="no-referrer-when-downgrade" src="//mtrcs.explicitconsulting.at/poop.php?idsite=1&amp;rec=1" style="border:0;" alt="" /></p>
      </noscript>

      <!-- Add class to all links, and open all external links in a new tab -->
      <script>
        document.addEventListener("DOMContentLoaded", function () {
          const links = document.querySelectorAll("a[href]");
          links.forEach(link => {
            link.classList.add("mtrcs-external-link");
            const url = new URL(link.href, window.location.href);
            if (url.hostname !== window.location.hostname) {
              link.setAttribute("target", "_blank");
            }
          });
        });
      </script>

      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener('DOMContentLoaded', function () {
          const lang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
          const path = window.location.pathname;
          const search = window.location.search;
          const hash = window.location.hash;

          const currentLangMatch = path.match(/^\/([a-z]{2})(\/|$)/);
          const currentLang = currentLangMatch ? currentLangMatch[1] : null;

          if (currentLang !== lang && currentLang !== null && !sessionStorage.getItem('langRedirected')) {
            const targetUrl = '/' + lang + path.replace(/^\/[a-z]{2}/, '') + search;
            fetch(targetUrl, { method: 'HEAD' })
              .then(response => {
                if (response.ok) {
                  sessionStorage.setItem('langRedirected', 'true');
                  window.location.href = targetUrl + hash;
                }
              });
          } else if (!currentLang && lang !== 'en' && !sessionStorage.getItem('langRedirected')) {
            const targetUrl = '/' + lang + path + search;
            fetch(targetUrl, { method: 'HEAD' })
              .then(response => {
                if (response.ok) {
                  sessionStorage.setItem('langRedirected', 'true');
                  window.location.href = targetUrl + hash;
                }
              });
          }
        });
      </script>
    HTML

    doc.output.gsub!('</head>', "#{code_to_add}\n</head>")
  end
end
