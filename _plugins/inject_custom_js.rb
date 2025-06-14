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

          // Clean up contentPath to ensure it always starts with a single slash
          contentPath = contentPath.replace(/\/\/+/g, '/');
          if (!contentPath.startsWith('/')) {
              contentPath = '/' + contentPath;
          }


          // Determine the desired target pathname based on preferredLanguage and contentPath
          if (preferredLanguage === "en") {
              targetPathname = contentPath;
          } else {
              targetPathname = `/${preferredLanguage}${contentPath === '/' ? '' : contentPath}`;
          }

          // Final cleanup for targetPathname
          targetPathname = targetPathname.replace(/\/\/+/g, '/');


          // --- Redirection Logic ---

          const currentFullUrl = `${currentProtocol}//${currentHostname}${currentPathname}${currentSearch}${currentHash}`;
          const targetFullUrl = `${currentProtocol}//${currentHostname}${targetPathname}${currentSearch}${currentHash}`;
          const englishFallbackFullUrl = `${currentProtocol}//${currentHostname}${contentPath}${currentSearch}${currentHash}`;


          // Only proceed with the primary redirect attempt if current URL isn't already the target
          if (currentFullUrl !== targetFullUrl) {

              console.log(`Attempting redirect from ${currentFullUrl} to preferred language target: ${targetFullUrl}`);
              // Before redirecting, check if the target URL (with new language prefix) is valid.
              fetch(targetFullUrl, { method: 'HEAD' })
                  .then(response => {
                      if (response.ok) {
                          // The target URL exists, proceed with redirection
                          console.log(`Preferred language path exists. Redirecting to: ${targetFullUrl}`);
                          window.location.replace(targetFullUrl);
                      } else {
                          // The target URL does NOT exist (e.g., /de/help doesn't exist)
                          console.warn(`Preferred language path (${targetFullUrl}) not found (status: ${response.status}). Falling back to English.`);
                          
                          // NEW SIMPLE LOOP PREVENTION: Only redirect to fallback if we're not already there
                          if (currentFullUrl !== englishFallbackFullUrl) {
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

                      // NEW SIMPLE LOOP PREVENTION: Only redirect to fallback if we're not already there
                      if (currentFullUrl !== englishFallbackFullUrl) {
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
