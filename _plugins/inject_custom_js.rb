Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener('DOMContentLoaded', function() {
            const languageDropdown = document.getElementById('languageDropdown');

            // Refined Function to get the current page's base name or path segment
            function getCurrentPageBaseName() {
                const path = window.location.pathname; // e.g., "/", "/download", "/de/about.html"
                let baseName = '';

                // Remove trailing slash if present, unless it's just "/"
                let cleanPath = path.endsWith('/') && path.length > 1 ? path.slice(0, -1) : path;

                const parts = cleanPath.split('/');
                // The actual file/resource name is the last part
                baseName = parts[parts.length - 1];

                // Handle root path (e.g., "/") or language root paths (e.g., "/de/")
                // If the path is just "/" or if the last segment is empty after splitting
                if (!baseName && path === '/') {
                    return 'index.html'; // Default for the very root of the site
                }

                // If the path is like "/xx/" (a language root) and doesn't specify a file, assume index.html
                // This checks if the current path has only two segments (like /en/ or /de/) after splitting
                // and the second segment is a known language code.
                // It must check against available languages to distinguish /de/ from /something-else/.
                const currentPathSegments = path.split('/').filter(s => s); // Remove empty strings
                if (currentPathSegments.length === 1 && availableLanguages.includes(currentPathSegments[0])) {
                    return 'index.html'; // e.g., for /de/, this returns index.html
                }


                // For paths like /download or /about.html or /de/about.html
                return baseName || 'index.html'; // Fallback for safety if baseName is somehow still empty
            }

            // Function to get the current URL's query string (including '?')
            function getCurrentQueryString() {
                return window.location.search; // Returns '?key=value&another=foo' or ''
            }

            // Function to get the current URL's hash (including '#')
            function getCurrentHash() {
                return window.location.hash; // Returns '#section-id' or ''
            }

            // --- Start: Get Available Languages from Dropdown ---
            // This needs to be available early for getLanguageFromUrl
            // It is defined here to ensure it's always accessible when needed.
            const availableLanguages = Array.from(languageDropdown.options).map(option => option.value);

            // Function to determine the current language *from the URL*
            function getLanguageFromUrl() {
                const path = window.location.pathname;
                const pathSegments = path.split('/').filter(s => s); // Split and remove empty strings

                // Check if the first segment of the path is a two-letter language code (excluding 'en')
                if (pathSegments.length > 0 && pathSegments[0].length === 2 && availableLanguages.includes(pathSegments[0]) && pathSegments[0] !== 'en') {
                    return pathSegments[0]; // Returns 'de', 'fr', 'es', 'jp', etc.
                }
                return 'en'; // Default to English if no specific language directory is found
            }
            // --- End: Get Available Languages from Dropdown ---


            // Get the preferred language from localStorage (which was set by the HTML onchange)
            let preferredLanguage = localStorage.getItem("languageDropdownValue");


            // If preferredLanguage is not set or is invalid, try to infer from navigator, then default to 'en'
            if (!preferredLanguage || !availableLanguages.includes(preferredLanguage)) {
                preferredLanguage = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
                if (!availableLanguages.includes(preferredLanguage)) {
                    preferredLanguage = 'en'; // Fallback to English if navigator language isn't available
                }
                // Update localStorage with this newly determined preferred language
                localStorage.setItem("languageDropdownValue", preferredLanguage);
            }

            // Set the dropdown to the determined preferred language
            languageDropdown.value = preferredLanguage;

            // --- Core Fallback Logic (executed on every page load) ---
            const currentPageBaseName = getCurrentPageBaseName(); // This will now be "download" for /download
            const currentQuery = getCurrentQueryString();
            const currentHash = getCurrentHash();

            let targetUrlLanguage = preferredLanguage;
            let newUrlPath;

            // Construct the path based on the selected language and the extracted base name/segment
            if (targetUrlLanguage === 'en') {
                newUrlPath = `/${currentPageBaseName}`; // Will be "/download" for English, "/about.html" etc.
            } else {
                // For language-specific paths
                newUrlPath = `/${targetUrlLanguage}/${currentPageBaseName}`;
            }

            // Construct the full new URL including query parameters and hash
            const newFullUrl = `${newUrlPath}${currentQuery}${currentHash}`;

            // If the current URL already matches what we expect from localStorage, no need to check/redirect
            if (newFullUrl === window.location.pathname + window.location.search + window.location.hash) {
                return;
            }

            // Perform a HEAD request to check if the target language URL exists
            fetch(newUrlPath, { method: 'HEAD' })
                .then(response => {
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
                .catch(error => {
                    // Handle network errors or other issues during the fetch
                    console.error('Error checking URL:', error);
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
