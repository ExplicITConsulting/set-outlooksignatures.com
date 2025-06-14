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

          let targetPathname;

          // Dynamically create the regex part for language codes
          // Ensure the language codes are treated as literal strings in the regex
          const langRegexPart = availableLanguages
            .map(lang => lang.toLowerCase())
            .filter(lang => lang.length === 2) // Only consider 2-letter codes for this regex
            .join('|');

          // Regex to capture the current language prefix (if any) and the rest of the path
          // It looks for /XX/ where XX is a 2-letter language code from availableLanguages
          const languagePathRegex = new RegExp(`^\\/(${langRegexPart})\\/?(.*)$`);

          let currentLanguagePrefix = '';
          let actualPathAfterLanguage = currentPathname; // Stores the path without any leading language prefix

          const match = currentPathname.match(languagePathRegex);

          if (match) {
            // If the pathname starts with a recognized 2-letter language code
            currentLanguagePrefix = match[1]; // e.g., 'de'
            actualPathAfterLanguage = `/${match[2] || ''}`; // e.g., '/help' or '/' if match[2] is empty
          } else if (currentPathname === '/') {
              // If it's the root path and no language prefix, it's implicitly 'en'
              currentLanguagePrefix = 'en';
              actualPathAfterLanguage = '/';
          } else {
              // If it's not a language path (e.g., /some-other-folder)
              // Assume it's an English path or a non-localized path, treat as if no language prefix
              currentLanguagePrefix = 'en'; // Default assumption for non-language-prefixed paths
              actualPathAfterLanguage = currentPathname;
          }

          // Clean up actualPathAfterLanguage to ensure it always starts with a single slash
          // unless it's genuinely empty (which shouldn't happen here due to the above logic)
          if (actualPathAfterLanguage !== '/') {
              actualPathAfterLanguage = `/${actualPathAfterLanguage.replace(/^\/+/, '')}`;
          }


          // Construct the target pathname based on preferred language and actual path
          if (preferredLanguage === "en") {
            // If preferred language is "en", remove any language prefix from the path
            targetPathname = actualPathAfterLanguage;
          } else {
            // For other languages, prepend the preferred language prefix
            // Ensure we don't get // if actualPathAfterLanguage is "/"
            targetPathname = `/${preferredLanguage}${actualPathAfterLanguage === '/' ? '' : actualPathAfterLanguage}`;
          }

          // Clean up potential double slashes that might result from concatenation
          targetPathname = targetPathname.replace(/\/\/+/g, '/');

          // Check if the current full path is already the target full path
          const isAlreadyTargetLanguageAndPath = currentPathname === targetPathname;


          if (!isAlreadyTargetLanguageAndPath) {
            // Construct the full target URL, including search parameters and hash
            const targetUrl = `${currentProtocol}//${currentHostname}${targetPathname}${currentSearch}${currentHash}`;

            // Attempt to redirect to the preferred language version
            fetch(targetUrl, { method: 'HEAD' }) // HEAD request is lighter, just gets headers
              .then(response => {
                if (response.ok) {
                  console.log(`Preferred language path exists. Redirecting to: ${targetUrl}`);
                  window.location.href = targetUrl;
                } else {
                  console.warn(`Preferred language path (${targetUrl}) not found (status: ${response.status}). Redirecting to English version while preserving original path.`);
                  // Fallback to English, preserving the non-language-prefixed path
                  const englishFallbackPathname = actualPathAfterLanguage;
                  const englishFallbackUrl = `${currentProtocol}//${currentHostname}${englishFallbackPathname}${currentSearch}${currentHash}`;
                  window.location.href = englishFallbackUrl;
                }
              })
              .catch(error => {
                console.error("Error checking preferred language path existence:", error);
                console.log("Redirecting to English version due to network error or uncheckability, preserving original path.");
                const englishFallbackPathname = actualPathAfterLanguage;
                const englishFallbackUrl = `${currentProtocol}//${currentHostname}${englishFallbackPathname}${currentSearch}${currentHash}`;
                window.location.href = englishFallbackUrl;
              });
          } else {
            console.log(`Already in the preferred language directory and path: ${preferredLanguage}`);
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
