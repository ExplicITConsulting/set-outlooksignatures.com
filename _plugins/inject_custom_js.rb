Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener("DOMContentLoaded", function () {
            const languageSelect = document.getElementById("languageDropdown");
            const savedLang = localStorage.getItem("languageDropdownValue");
            const currentPathname = window.location.pathname; // Get the current path without search/hash
            const search = window.location.search;
            const hash = window.location.hash;
            const browserLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
            
            // Regex to match and capture a two-letter language code at the start of the path
            // e.g., /de/some-page.html -> 'de'
            //       /en/some-page.html -> 'en' (though 'en' is root)
            //       /some-page.html    -> null
            const currentLangMatch = currentPathname.match(/^\/([a-z]{2})(?=\/|$)/i);
            const langInPath = currentLangMatch ? currentLangMatch[1].toLowerCase() : null;
            
            const languageSelectValidValues = Array.from(languageSelect.options).map(opt => opt.value);

            let effectiveTargetLanguage = "en"; // Default to English

            // 1. Prioritize saved language from localStorage
            if (savedLang && languageSelectValidValues.includes(savedLang)) {
                effectiveTargetLanguage = savedLang;
                languageSelect.value = savedLang; // Ensure dropdown reflects this
            } 
            // 2. If no saved language, check if the URL path itself indicates a language
            else if (langInPath && languageSelectValidValues.includes(langInPath)) {
                effectiveTargetLanguage = langInPath;
                languageSelect.value = langInPath; // Ensure dropdown reflects this
            }
            // 3. Fallback to browser language if valid and no other language determined
            else if (browserLang && languageSelectValidValues.includes(browserLang)) {
                effectiveTargetLanguage = browserLang;
                languageSelect.value = browserLang; // Ensure dropdown reflects this
            }
            // (If none of the above, effectiveTargetLanguage remains "en", and dropdown remains "en" by default)

            // --- Determine the desired target URL ---

            let basePath = currentPathname;

            // Remove any existing language prefix from the current pathname
            if (langInPath) {
                // This regex ensures we only remove the prefix if it's a full segment
                // e.g., /de/page.html -> /page.html
                //       /depth/page.html -> /depth/page.html (not removing 'de' from 'depth')
                basePath = basePath.replace(new RegExp(`^/${langInPath}(?=/|$)`, 'i'), '');
            }

            // Ensure basePath is at least '/' if it becomes empty after removing prefix
            if (basePath === '') {
                basePath = '/';
            }

            let desiredTargetPath;
            if (effectiveTargetLanguage === 'en') {
                // English documents are in the root, so no language prefix
                desiredTargetPath = basePath;
            } else {
                // Other languages get a prefix
                // Handle cases where basePath is just '/' to avoid double slashes like /de//
                desiredTargetPath = `/${effectiveTargetLanguage}${basePath === '/' ? '' : basePath}`;
            }

            // Clean up any potential double slashes (e.g., from /de//page.html becoming /de/page.html)
            desiredTargetPath = desiredTargetPath.replace(/\/\/+/g, '/');

            // Construct the full desired URL
            const fullDesiredUrl = desiredTargetPath + search + hash;

            // --- Redirect Logic ---

            // Get the current URL as it appears in the browser's address bar
            const currentFullUrl = window.location.pathname + window.location.search + window.location.hash;

            // Only redirect if the current URL does not match the desired URL
            if (fullDesiredUrl.toLowerCase() !== currentFullUrl.toLowerCase()) {
                console.log(`Redirecting from ${currentFullUrl} to ${fullDesiredUrl}`);
                fetch(fullDesiredUrl, { method: 'HEAD' })
                    .then(response => {
                        if (response.ok) {
                            // Use replace to avoid adding the intermediate redirect to browser history
                            window.location.replace(fullDesiredUrl); 
                        } else {
                            console.warn(`Target URL not found: ${fullDesiredUrl}. Attempting fallback.`);
                            // Fallback if the specific page doesn't exist for the target language.
                            // Try to redirect to the language's root (e.g., /de/ or /).
                            let fallbackUrl = '/';
                            if (effectiveTargetLanguage !== 'en') {
                                fallbackUrl = `/${effectiveTargetLanguage}/`;
                            }

                            fetch(fallbackUrl, { method: 'HEAD' })
                                .then(fallbackResponse => {
                                    if (fallbackResponse.ok) {
                                        console.log(`Falling back to ${fallbackUrl}`);
                                        window.location.replace(fallbackUrl);
                                    } else {
                                        console.error(`Neither "${fullDesiredUrl}" nor "${fallbackUrl}" exist. Staying on current page.`);
                                        // If even the fallback doesn't exist, you might want to show an error message
                                        // or redirect to a generic 404 page if you have one.
                                    }
                                })
                                .catch(fallbackError => {
                                    console.error("Error checking fallback URL existence:", fallbackError);
                                });
                        }
                    })
                    .catch(error => {
                        console.error("Error checking URL existence:", error);
                    });
            } else {
                console.log(`Already on the correct language version: ${currentFullUrl}`);
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
