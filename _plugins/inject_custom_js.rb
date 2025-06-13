Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
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
        _paq.push(['enableLinkTracking']);

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
          const browserLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
          const path = window.location.pathname;
          const search = window.location.search;
          const hash = window.location.hash;

          // Regex to capture the language prefix from the path (e.g., /en/, /fr/)
          // The 'i' flag makes it case-insensitive for the language code
          const currentLangMatch = path.match(/^\/([a-z]{2})(?:\/|$)/i); // Non-capturing group for the trailing slash or end

          // Extract the current language from the path, or null if no language prefix is found
          const pathLang = currentLangMatch ? currentLangMatch[1].toLowerCase() : null; // Ensure consistency with browserLang

          // --- Debugging logs (keep these in while testing) ---
          console.log('Browser Language:', browserLang);
          console.log('Current Path:', path);
          console.log('Language from Path (pathLang):', pathLang);
          // --- End Debugging logs ---

          let shouldRedirect = false;
          let targetPath = '';

          // Scenario 1: Path has a language prefix (e.g., /en/about, /fr/contact)
          if (pathLang) {
            // If the path's language is different from the browser's preferred language
            if (pathLang !== browserLang) {
              console.log('Scenario 1: Path language (' + pathLang + ') differs from browser language (' + browserLang + ').');
              shouldRedirect = true;
              // Replace the existing language prefix with the browser's language
              targetPath = '/' + browserLang + path.replace(/^\/[a-z]{2}/i, ''); // Use 'i' flag here for consistency
            } else {
              console.log('Scenario 1: Path language matches browser language. No redirect needed.');
            }
          }
          // Scenario 2: Path does NOT have a language prefix (e.g., /about, /)
          else {
            // If the browser's preferred language is NOT 'en' (our assumed default)
            if (browserLang !== 'en') {
              console.log('Scenario 2: No path language prefix, and browser language (' + browserLang + ') is not "en".');
              shouldRedirect = true;
              // Prepend the browser's language to the path
              targetPath = '/' + browserLang + path;
            } else {
              console.log('Scenario 2: No path language prefix, and browser language is "en". No redirect needed.');
            }
          }

          if (shouldRedirect) {
            const targetUrl = targetPath + search; // Reconstruct with search params
            console.log('Attempting redirect to Target URL:', targetUrl);

            // Perform a HEAD request to check if the target URL exists and is accessible
            fetch(targetUrl, { method: 'HEAD' })
              .then(response => {
                if (response.ok) {
                  console.log('HEAD request successful. Redirecting browser...');
                  window.location.href = targetUrl + hash; // Redirect the browser
                } else {
                  // If the target URL doesn't exist (e.g., 404), do nothing.
                  // This prevents redirecting to a broken link.
                  console.warn('Target URL (' + targetUrl + ') did not return 200 OK. Status:', response.status);
                }
              })
              .catch(error => {
                console.error('Fetch error:', error);
              });
          } else {
            console.log('No redirect conditions met. Staying on current page.');
          }
        });
      </script>
    HTMLHereDocString

    doc.output.gsub!('</head>', "#{code_to_add}\n</head>")
  end
end
