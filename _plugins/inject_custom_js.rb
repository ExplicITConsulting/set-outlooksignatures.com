Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener('DOMContentLoaded', function() {
          const languageDropdown = document.getElementById('languageDropdown');
          const availableLanguages = Array.from(languageDropdown.options).map((option) => option.value);

          let preferredLanguage = localStorage.getItem("languageDropdownValue");

          // 1. Check if preferredLanguage is already set and valid (from a cookie, local storage, etc.)
          //    This part assumes preferredLanguage might be pre-populated from an earlier session.
          if (preferredLanguage && availableLanguages.includes(preferredLanguage)) {
              // If preferredLanguage is already valid and available, use it directly.
              // No need to proceed further.
          } else {
              // 2. Try to get preferred language from navigator.languages (most modern browsers)
              if (navigator.languages && navigator.languages.length > 0) {
                  for (let i = 0; i < navigator.languages.length; i++) {
                      const browserLang = navigator.languages[i].toLowerCase().split("-")[0];
                      if (availableLanguages.includes(browserLang)) {
                          preferredLanguage = browserLang;
                          break; // Found a match, no need to check further
                      }
                  }
              }

              // 3. Fallback to navigator.language or navigator.userLanguage (older browsers or single preference)
              if (!preferredLanguage) { // Only if a language hasn't been found yet
                  const fallbackLang = (navigator.language || navigator.userLanguage || "").toLowerCase().split("-")[0];
                  if (availableLanguages.includes(fallbackLang)) {
                      preferredLanguage = fallbackLang;
                  }
              }

              // 4. Final fallback to "en" if no suitable language was found
              if (!preferredLanguage) {
                  preferredLanguage = "en"; // Default fallback
              }
          }

          // Update the dropdown value and localStorage if you have a dropdown
          if (languageDropdown) {
              languageDropdown.value = preferredLanguage;
          }

          localStorage.setItem("languageDropdownValue", preferredLanguage);

          const currentPathname = window.location.pathname;
          const currentHostname = window.location.hostname;
          const currentProtocol = window.location.protocol;
          const currentSearch = window.location.search; // Get URL parameters
          const currentHash = window.location.hash;    // Get URL anchor

          /**
          * Normalizes a path by removing a trailing slash, unless it's the root path '/'.
          * Also ensures a single leading slash and removes internal double slashes.
          * @param {string} path The path to normalize.
          * @returns {string} The normalized path.
          */
          function normalizePathForComparison(path) {
              if (!path) return '/';
              let normalized = path.replace(/\/\/+/g, '/'); // Remove any double slashes

              // Remove trailing slash unless it's the root '/'
              if (normalized.length > 1 && normalized.endsWith('/')) {
                  normalized = normalized.slice(0, -1);
              }

              // Ensure it starts with a single slash
              if (!normalized.startsWith('/')) {
                  normalized = '/' + normalized;
              }

              return normalized;
          }

          let baseContentPath = '/'; // This will store the path without ANY leading 2-letter segments (e.g., /download from /fr/download)
          let detectedUrlPrefix = null; // Stores the 2-letter prefix found in the URL (e.g., 'fr')

          // Regex to identify if the current path starts with any 2-letter folder (potential language)
          const anyTwoLetterFolderRegex = /^\/([a-z]{2})(\/.*)?$/;
          const pathSegmentMatch = currentPathname.match(anyTwoLetterFolderRegex);

          if (pathSegmentMatch) {
              detectedUrlPrefix = pathSegmentMatch[1]; // e.g., 'fr' from /fr/download
              baseContentPath = pathSegmentMatch[2] || '/'; // e.g., '/download' from /fr/download
          } else {
              baseContentPath = currentPathname; // No 2-letter prefix found (e.g., /download, /about)
          }

          // Normalize the baseContentPath (e.g., makes sure /download/ becomes /download)
          baseContentPath = normalizePathForComparison(baseContentPath);

          let targetPathname;

          // Determine the desired target pathname based on preferredLanguage and baseContentPath
          if (preferredLanguage === "en") {
              // If preferred language is English, the target is simply the baseContentPath (no prefix)
              targetPathname = baseContentPath;
          } else {
              // For other *available* languages (e.g., 'de'), prepend the preferred language folder
              // This assumes preferredLanguage has been validated to be in availableLanguages
              targetPathname = `/${preferredLanguage}${baseContentPath === '/' ? '/' : baseContentPath}`;
          }

          // Ensure targetPathname is normalized before comparison/use
          targetPathname = normalizePathForComparison(targetPathname);

          // --- Redirection Logic ---

          const normalizedCurrentPathForComparison = normalizePathForComparison(currentPathname);
          const normalizedTargetPathForComparison = normalizePathForComparison(targetPathname);

          // Only proceed with redirect if current URL (normalized) isn't already the target (normalized)
          if (normalizedCurrentPathForComparison !== normalizedTargetPathForComparison) {
              const currentFullUrl = `${currentProtocol}//${currentHostname}${currentPathname}${currentSearch}${currentHash}`;
              const targetFullUrl = `${currentProtocol}//${currentHostname}${targetPathname}${currentSearch}${currentHash}`;
              // The fallback URL in case the preferred language version doesn't exist on the server
              const fallbackToEnglishFullUrl = `${currentProtocol}//${currentHostname}${baseContentPath}${currentSearch}${currentHash}`;

              console.log(`Attempting redirect from ${currentFullUrl} to preferred language target: ${targetFullUrl}`);

              fetch(targetFullUrl, { method: 'HEAD' })
                  .then(response => {
                      if (response.ok) {
                          // The target URL exists, proceed with redirection
                          console.log(`Preferred language path exists. Redirecting to: ${targetFullUrl}`);
                          window.location.replace(targetFullUrl);
                      } else {
                          // The target URL does NOT exist (e.g., /de/help doesn't exist, but /help does)
                          console.warn(`Target path (${targetFullUrl}) not found (status: ${response.status}). Falling back to base English path.`);

                          // Only redirect to fallback if we're not already on the fallback path
                          if (normalizedCurrentPathForComparison !== normalizePathForComparison(baseContentPath)) {
                              console.log(`Redirecting to English fallback: ${fallbackToEnglishFullUrl}`);
                              window.location.replace(fallbackToEnglishFullUrl);
                          } else {
                              console.log(`Already on the English fallback URL: ${fallbackToEnglishFullUrl}. No further redirect needed.`);
                          }
                      }
                  })
                  .catch(error => {
                      // Network error or inability to perform HEAD request (e.g., CORS, offline)
                      console.error("Error checking preferred language path existence:", error);
                      console.log("Network error or uncheckability. Falling back to base English path.");

                      // Only redirect to fallback if we're not already on the fallback path
                      if (normalizedCurrentPathForComparison !== normalizePathForComparison(baseContentPath)) {
                          console.log(`Redirecting to English fallback: ${fallbackToEnglishFullUrl}`);
                          window.location.replace(fallbackToEnglishFullUrl);
                      } else {
                          console.log(`Already on the English fallback URL: ${fallbackToEnglishFullUrl}. No further redirect needed.`);
                      }
                  });
          } else {
              console.log(`Already on the correct language version for: ${preferredLanguage} at ${currentPathname}`);
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
