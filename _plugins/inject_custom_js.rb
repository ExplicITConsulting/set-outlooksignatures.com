Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener('DOMContentLoaded', function() {
          const availableLanguages = Array.from(languageDropdown.options).map((option) => option.value);

          let preferredLanguage = localStorage.getItem("languageDropdownValue");

          if (!preferredLanguage || !availableLanguages.includes(preferredLanguage)) {
            preferredLanguage = (navigator.language || navigator.userLanguage || "en").toLowerCase().split("-")[0];

            if (!availableLanguages.includes(preferredLanguage)) {
              preferredLanguage = "en"; // Fallback to English if navigator language isn't available
            }
          }

          languageDropdown.value = preferredLanguage;
          localStorage.setItem("languageDropdownValue", preferredLanguage);

          const currentPathname = window.location.pathname;
          const currentHostname = window.location.hostname;
          const currentProtocol = window.location.protocol;
          const currentSearch = window.location.search; // Get URL parameters
          const currentHash = window.location.hash;     // Get URL anchor

          let targetPath;

          if (preferredLanguage === "en") {
            // If preferred language is "en", the path should be the root
            targetPath = "/";
          } else {
            // For other languages, the path should start with /<language_code>
            targetPath = `/${preferredLanguage}/`;
          }

          // Check if the current path already matches the preferred language directory
          // This check is simplified and assumes a structure like /en/, /fr/, or just / for root.
          // It might need refinement based on your exact URL structure.
          const isAlreadyPreferredLanguage = (preferredLanguage === "en" && currentPathname === "/") ||
            (preferredLanguage !== "en" && currentPathname.startsWith(`/${preferredLanguage}/`));

          if (!isAlreadyPreferredLanguage) {
            // Construct the full target URL, including search parameters and hash
            const targetUrl = `${currentProtocol}//${currentHostname}${targetPath}${currentSearch}${currentHash}`;

            // Attempt to redirect to the preferred language version
            fetch(targetUrl, { method: 'HEAD' }) // HEAD request is lighter, just gets headers
              .then(response => {
                if (response.ok) {
                  console.log(`Preferred language path exists. Redirecting to: ${targetUrl}`);
                  window.location.href = targetUrl;
                } else {
                  console.warn(`Preferred language path (${targetUrl}) not found (status: ${response.status}). Redirecting to English version.`);
                  // Redirect to root (English), preserving parameters and hash
                  window.location.href = `${currentProtocol}//${currentHostname}/${currentSearch}${currentHash}`;
                }
              })
              .catch(error => {
                console.error("Error checking preferred language path existence:", error);
                console.log("Redirecting to English version due to network error or uncheckability.");
                // Redirect to root (English), preserving parameters and hash
                window.location.href = `${currentProtocol}//${currentHostname}/${currentSearch}${currentHash}`;
              });
          } else {
            console.log(`Already in the preferred language directory: ${preferredLanguage}`);
          }
        });
      </script>


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
    HTMLHereDocString

    doc.output.gsub!('</head>', "#{code_to_add}\n</head>")
  end
end
