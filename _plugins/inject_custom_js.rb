Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener("DOMContentLoaded", function () {
            const languageSelect = document.getElementById("languageDropdown");
            let savedLang = localStorage.getItem("languageDropdownValue"); // Use 'let' as it might be set for the first time
            const currentPathname = window.location.pathname;
            const search = window.location.search;
            const hash = window.location.hash;
            const browserLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
            
            // Regex to capture the language prefix (e.g., 'de' from /de/page.html)
            const currentLangMatch = currentPathname.match(/^\/([a-z]{2})(?=\/|$)/i);
            const langInPath = currentLangMatch ? currentLangMatch[1].toLowerCase() : null; // Language actually present in the URL path
            
            const languageSelectValidValues = Array.from(languageSelect.options).map(opt => opt.value);

            // --- Step 1: Initialize localStorage ONLY if it's not already set ---
            if (!savedLang) { // localStorage item 'languageDropdownValue' has not been set before
                if (languageSelectValidValues.includes(browserLang)) {
                    savedLang = browserLang; // Set based on browser language if it's a valid option
                } else {
                    savedLang = "en"; // Default to English if browser language isn't valid
                }
                localStorage.setItem("languageDropdownValue", savedLang); // Set localStorage for the very first time
                console.log(`localStorage initialized to: "${savedLang}" based on browser detection.`);
            } else {
                console.log(`localStorage already set: "${savedLang}".`);
            }

            // --- Step 2: Determine the effective target language for THIS page load ---
            // This primarily comes from `savedLang` (either from localStorage or initial browser detection).
            let effectiveTargetLanguage = savedLang;

            // However, if the current URL explicitly states a different valid language,
            // we prioritize the URL's language for *this specific load's redirection logic*.
            // This handles scenarios where a user manually typed a URL like /de/page.html
            // but their saved preference is 'en'. This avoids an immediate redirect back.
            if (langInPath && languageSelectValidValues.includes(langInPath) && langInPath !== effectiveTargetLanguage) {
                effectiveTargetLanguage = langInPath;
                console.log(`URL path language "${langInPath}" overrides localStorage "${savedLang}" for current effective target.`);
            }

            // --- Step 3: Set the dropdown value to reflect the effective target language ---
            // This updates the UI without touching localStorage if it's not the initial set.
            if (languageSelect.value !== effectiveTargetLanguage) {
                languageSelect.value = effectiveTargetLanguage;
                console.log(`Dropdown set to: "${effectiveTargetLanguage}".`);
            }


            // --- Helper function to construct a URL path for a given language ---
            function getUrlForLanguage(targetLanguage, basePagePath) {
                let desiredPath;
                if (targetLanguage === 'en') { // English documents are in the root
                    desiredPath = basePagePath;
                } else { // Other languages get a prefix
                    desiredPath = `/${targetLanguage}${basePagePath === '/' ? '' : basePagePath}`;
                }
                return desiredPath.replace(/\/\/+/g, '/'); // Clean up potential double slashes
            }

            // --- Step 4: Calculate the base page path (the URL without any language prefix) ---
            let basePagePath = currentPathname;
            if (langInPath) { // If there's a language prefix in the current URL, remove it
                basePagePath = basePagePath.replace(new RegExp(`^/${langInPath}(?=/|$)`, 'i'), '');
            }
            if (basePagePath === '') { // Ensure it's at least '/' if it became empty
                basePagePath = '/';
            }
            basePagePath = basePagePath.replace(/\/\/+/g, '/'); // Final cleanup for base path

            // --- Step 5: Determine the full desired URLs ---
            const desiredUrlForEffectiveLang = getUrlForLanguage(effectiveTargetLanguage, basePagePath) + search + hash;
            const englishFallbackUrl = getUrlForLanguage('en', basePagePath) + search + hash; // Always consider English as a fallback
            const currentFullUrl = window.location.pathname + window.location.search + window.location.hash;

            // --- Step 6: Perform Redirection Logic ---
            // Use an async IIFE (Immediately Invoked Function Expression) for cleaner await usage
            (async () => {
                // Only attempt a redirect if the current URL doesn't match the desired URL for the effective language
                // This prevents an immediate reload if the user is already on the correct page.
                if (desiredUrlForEffectiveLang.toLowerCase() === currentFullUrl.toLowerCase()) {
                    console.log(`Already on the correct URL for effective language: ${currentFullUrl}. No redirect needed.`);
                    return; // No action needed if already on the target URL
                }

                console.log(`Attempting to load: "${desiredUrlForEffectiveLang}" for effective language "${effectiveTargetLanguage}".`);
                try {
                    const response = await fetch(desiredUrlForEffectiveLang, { method: 'HEAD' });

                    if (response.ok) {
                        // If the page for the effective target language exists, redirect to it
                        console.log(`Page "${desiredUrlForEffectiveLang}" found. Redirecting.`);
                        window.location.replace(desiredUrlForEffectiveLang);
                    } else {
                        console.warn(`Specific page "${desiredUrlForEffectiveLang}" for effective language "${effectiveTargetLanguage}" not found (404).`);

                        // If the target language page doesn't exist, attempt to load the English version of the same content
                        console.log(`Attempting fallback to English version: ${englishFallbackUrl}`);
                        const englishResponse = await fetch(englishFallbackUrl, { method: 'HEAD' });

                        if (englishResponse.ok) {
                            // If the English version exists, redirect to it.
                            // IMPORTANT: Per requirement, localStorage is *NOT* updated here to 'en'.
                            console.log(`English version found at "${englishFallbackUrl}". Redirecting.`);
                            window.location.replace(englishFallbackUrl);
                        } else {
                            console.error(`Neither "${desiredUrlForEffectiveLang}" nor "${englishFallbackUrl}" exist.`);
                            
                            // As a last resort, try redirecting to the English homepage
                            const englishHomepageUrl = getUrlForLanguage('en', '/') + search + hash;
                            console.log(`Attempting fallback to English homepage: ${englishHomepageUrl}`);
                            const homeResponse = await fetch(englishHomepageUrl, { method: 'HEAD' });
                            if (homeResponse.ok) {
                                console.log(`English homepage found. Redirecting to: ${englishHomepageUrl}`);
                                window.location.replace(englishHomepageUrl);
                            } else {
                                console.error(`English homepage "${englishHomepageUrl}" also not found. Staying on current (possibly 404) page.`);
                                // At this point, no valid alternative found. The browser will display its 404
                                // or the current page if it's already a 404.
                            }
                        }
                    }
                } catch (error) {
                    console.error("Network or fetch error during language detection/redirect:", error);
                }
            })(); // End of async IIFE
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
