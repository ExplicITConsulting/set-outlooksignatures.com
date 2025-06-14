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

          /**
          * Normalizes a path by removing a trailing slash, unless it's the root path '/'.
          * Also ensures a single leading slash and removes internal double slashes.
          * @param {string} path The path to normalize.
          * @returns {string} The normalized path.
          */
          function normalizePathForComparison(path) {
              if (!path) return '/'; // Handle empty or null paths
              
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

          let targetPathname;

          // Dynamically create the regex part for 2-letter language codes from availableLanguages
          const langRegexPart = availableLanguages
            .map(lang => lang.toLowerCase())
            .filter(lang => lang.length === 2) // Ensure only 2-letter codes are considered for language folders
            .join('|');

          // Regex to identify if the current path starts with a valid 2-letter language folder
          const languageFolderRegex = new RegExp(`^\\/(${langRegexPart})(\\/.*)?$`);

          let contentPath = '/'; // This will store the path WITHOUT any language prefix
          let currentDetectedLanguage = 'en'; // Default to 'en' if no language prefix is found

          const match = currentPathname.match(languageFolderRegex);

          if (match) {
              currentDetectedLanguage = match[1];
              contentPath = match[2] || '/';
          } else {
              currentDetectedLanguage = 'en';
              contentPath = currentPathname;
          }

          // Normalize the contentPath for consistent handling
          contentPath = normalizePathForComparison(contentPath);


          // Determine the desired target pathname based on preferredLanguage and contentPath
          if (preferredLanguage === "en") {
              targetPathname = contentPath; // English uses the raw content path
          } else {
              // For other languages, prepend the preferred language folder
              // If contentPath is '/', result is /lang/
              // If contentPath is something else, result is /lang/content/path
              targetPathname = `/${preferredLanguage}${contentPath === '/' ? '/' : contentPath}`;
          }

          // Final cleanup for targetPathname for the URL construction (not just comparison)
          // Ensure it follows the expected pattern for actual URL setting
          if (targetPathname.length > 1 && targetPathname.endsWith('/') && preferredLanguage !== "en") {
              // For language specific paths, typically we want to preserve the trailing slash if it was there
              // but the normalizePathForComparison removes it. Re-add if it's not root and not English.
              // This part depends on your desired final URL structure for localized content.
              // If you prefer /de/help instead of /de/help/, then keep it as is.
              // If you prefer /de/help/ then uncomment the next line:
              // targetPathname = targetPathname + '/';
          }
          // For consistency, let's make the final URL setting also use the normalized version,
          // unless there's a strong reason to maintain the trailing slash for actual navigation.
          // Given the original issue, let's make the actual redirect target also use the normalized path.
          targetPathname = normalizePathForComparison(targetPathname);


          // --- Redirection Logic ---

          // Get the *current* path normalized for comparison
          const normalizedCurrentPathForComparison = normalizePathForComparison(currentPathname);

          // Get the *target* path normalized for comparison
          const normalizedTargetPathForComparison = normalizePathForComparison(targetPathname);

          // Get the *English fallback* path normalized for comparison
          const normalizedEnglishFallbackPathForComparison = normalizePathForComparison(contentPath);


          // Construct full URLs for actual navigation (these might or might not have trailing slashes
          // based on your desired final URL structure, but the comparison uses the normalized version)
          const currentFullUrl = `${currentProtocol}//${currentHostname}${currentPathname}${currentSearch}${currentHash}`;
          const targetFullUrl = `${currentProtocol}//${currentHostname}${targetPathname}${currentSearch}${currentHash}`;
          const englishFallbackFullUrl = `${currentProtocol}//${currentHostname}${contentPath}${currentSearch}${currentHash}`; // contentPath is already normalized

          // Only proceed with the primary redirect attempt if current URL (normalized) isn't already the target (normalized)
          if (normalizedCurrentPathForComparison !== normalizedTargetPathForComparison) {

              console.log(`Attempting redirect from ${currentFullUrl} to preferred language target: ${targetFullUrl}`);
              
              // Before redirecting, check if the target URL (with new language prefix) is valid.
              // For the HEAD request, use the targetFullUrl (which might have a trailing slash if intended).
              // The server will respond based on how it actually serves /path vs /path/.
              fetch(targetFullUrl, { method: 'HEAD' }) 
                  .then(response => {
                      if (response.ok) {
                          // The target URL exists, proceed with redirection
                          console.log(`Preferred language path exists. Redirecting to: ${targetFullUrl}`);
                          window.location.replace(targetFullUrl);
                      } else {
                          // The target URL does NOT exist (e.g., /de/help doesn't exist)
                          console.warn(`Preferred language path (${targetFullUrl}) not found (status: ${response.status}). Falling back to English.`);
                          
                          // NEW SIMPLE LOOP PREVENTION: Only redirect to fallback if we're not already there (normalized comparison)
                          if (normalizedCurrentPathForComparison !== normalizedEnglishFallbackPathForComparison) {
                              console.log(`Redirecting to English fallback: ${englishFallbackFullUrl}`);
                              window.location.replace(englishFallbackFullUrl);
                          } else {
                              console.log(`Already on the English fallback URL: ${englishFallbackFullUrl}. No further redirect needed.`);
                          }
                      }
                  })
                  .catch(error => {
                      // Network error or inability to perform HEAD request (e.g., CORS, offline)
                      console.error("Error checking preferred language path existence:", error);
                      console.log("Network error or uncheckability. Falling back to English version.");

                      // NEW SIMPLE LOOP PREVENTION: Only redirect to fallback if we're not already there (normalized comparison)
                      if (normalizedCurrentPathForComparison !== normalizedEnglishFallbackPathForComparison) {
                          console.log(`Redirecting to English fallback: ${englishFallbackFullUrl}`);
                          window.location.replace(englishFallbackFullUrl);
                      } else {
                          console.log(`Already on the English fallback URL: ${englishFallbackFullUrl}. No further redirect needed.`);
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
