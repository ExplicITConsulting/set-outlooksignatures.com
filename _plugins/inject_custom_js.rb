Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener("DOMContentLoaded", function () {
          const languageDropdown = document.getElementById("languageDropdown");

          // Function to get the current page's base name (e.g., "index.html", "about.html")
          function getCurrentPageBaseName() {
            const path = window.location.pathname;
            const parts = path.split("/");
            const baseName = parts[parts.length - 1];
            if (!baseName && path.endsWith("/")) {
              return "index.html"; // Common default for directory URLs
            }
            return baseName || "index.html"; // Default to index.html if baseName is empty (e.g., for "/")
          }

          // NEW: Function to get the current URL's query string (including '?')
          function getCurrentQueryString() {
            return window.location.search; // Returns '?key=value&another=foo' or ''
          }

          // NEW: Function to get the current URL's hash (including '#')
          function getCurrentHash() {
            return window.location.hash; // Returns '#section-id' or ''
          }

          // Function to determine the current language *from the URL*
          function getLanguageFromUrl() {
            const path = window.location.pathname;
            if (path.startsWith("/de/")) {
              return "de";
            } else if (path.startsWith("/fr/")) {
              return "fr";
            } else if (path.startsWith("/es/")) {
              return "es";
            }
            return "en"; // Default to English if no specific language directory is found
          }

          // Get the preferred language from localStorage (which was set by the HTML onchange)
          let preferredLanguage = localStorage.getItem("languageDropdownValue");
          const availableLanguages = Array.from(languageDropdown.options).map((option) => option.value);

          // If preferredLanguage is not set or is invalid, try to infer from navigator, then default to 'en'
          if (!preferredLanguage || !availableLanguages.includes(preferredLanguage)) {
            preferredLanguage = (navigator.language || navigator.userLanguage || "en").toLowerCase().split("-")[0];
            if (!availableLanguages.includes(preferredLanguage)) {
              preferredLanguage = "en"; // Fallback to English if navigator language isn't available
            }
            // Update localStorage with this newly determined preferred language
            localStorage.setItem("languageDropdownValue", preferredLanguage);
          }

          // Set the dropdown to the determined preferred language
          languageDropdown.value = preferredLanguage;

          // --- Core Fallback Logic (executed on every page load) ---
          const currentPageBaseName = getCurrentPageBaseName();
          const currentQuery = getCurrentQueryString(); // Get current query string
          const currentHash = getCurrentHash(); // Get current hash

          let targetUrlLanguage = preferredLanguage;
          let newUrlPath; // This will be the path part, without query or hash

          if (targetUrlLanguage === "en") {
            newUrlPath = `/${currentPageBaseName}`;
          } else {
            newUrlPath = `/${targetUrlLanguage}/${currentPageBaseName}`;
          }

          // Construct the full new URL including query parameters and hash
          const newFullUrl = `${newUrlPath}${currentQuery}${currentHash}`;

          // If the current URL already matches what we expect from localStorage, no need to check/redirect
          if (newFullUrl === window.location.pathname + window.location.search + window.location.hash) {
            // If the URL already perfectly matches the target, we don't need to do another fetch.
            return;
          }

          // Perform a HEAD request to check if the target language URL exists
          // NOTE: The HEAD request should be made to the path *without* query parameters or hash
          // because the server typically maps files based on path, not parameters/anchors.
          fetch(newUrlPath, { method: "HEAD" }) // Use newUrlPath here, not newFullUrl
            .then((response) => {
              if (response.ok) {
                // The target language document exists, redirect if not already on it
                if (window.location.href !== newFullUrl) {
                  window.location.href = newFullUrl;
                }
              } else {
                // The target language document does NOT exist (e.g., 404)
                console.warn(`Document not found for ${newUrlPath}. Falling back to English: /${currentPageBaseName}`);
                // Redirect to the English version, preserving query parameters and hash
                const englishFallbackFullUrl = `/${currentPageBaseName}${currentQuery}${currentHash}`;
                if (window.location.href !== englishFallbackFullUrl) {
                  window.location.href = englishFallbackFullUrl;
                }
              }
            })
            .catch((error) => {
              // Handle network errors or other issues during the fetch
              console.error("Error checking URL:", error);
              // In case of an error, fall back to English, preserving query parameters and hash
              const englishFallbackFullUrl = `/${currentPageBaseName}${currentQuery}${currentHash}`;
              if (window.location.href !== englishFallbackFullUrl) {
                window.location.href = englishFallbackFullUrl;
              }
            });
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
