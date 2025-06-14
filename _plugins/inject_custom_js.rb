Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        document.addEventListener("DOMContentLoaded", function () {
          const languageSelect = document.getElementById("languageDropdown");
          const savedLang = localStorage.getItem("languageDropdownValue");
          const currentPathname = window.location.pathname;
          const search = window.location.search;
          const hash = window.location.hash;
          const browserLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
          
          const currentLangMatch = currentPathname.match(/^\/([a-z]{2})(?=\/|$)/i);
          const langInPath = currentLangMatch ? currentLangMatch[1].toLowerCase() : null;
          
          const languageSelectValidValues = Array.from(languageSelect.options).map(opt => opt.value);

          let effectiveTargetLanguage = "en"; // Default to English

          // 1. Prioritize saved language from localStorage
          if (savedLang && languageSelectValidValues.includes(savedLang)) {
              effectiveTargetLanguage = savedLang;
              languageSelect.value = savedLang; 
          } 
          // 2. If no saved language, check if the URL path itself indicates a language
          else if (langInPath && languageSelectValidValues.includes(langInPath)) {
              effectiveTargetLanguage = langInPath;
              languageSelect.value = langInPath; 
          }
          // 3. Fallback to browser language if valid and no other language determined
          else if (browserLang && languageSelectValidValues.includes(browserLang)) {
              effectiveTargetLanguage = browserLang;
              languageSelect.value = browserLang; 
          }

          // --- Determine the desired target URL ---
          function getDesiredUrl(targetLanguage, currentPath) {
              let basePath = currentPath;

              // Remove any existing language prefix from the current path
              const pathLangMatch = currentPath.match(/^\/([a-z]{2})(?=\/|$)/i);
              const pathLang = pathLangMatch ? pathLangMatch[1].toLowerCase() : null;

              if (pathLang) {
                  basePath = basePath.replace(new RegExp(`^/${pathLang}(?=/|$)`, 'i'), '');
              }

              if (basePath === '') {
                  basePath = '/';
              }

              let desiredPath;
              if (targetLanguage === 'en') {
                  desiredPath = basePath;
              } else {
                  desiredPath = `/${targetLanguage}${basePath === '/' ? '' : basePath}`;
              }
              
              desiredPath = desiredPath.replace(/\/\/+/g, '/'); // Clean up double slashes
              return desiredPath + search + hash; // Add original search and hash
          }

          const fullDesiredUrl = getDesiredUrl(effectiveTargetLanguage, currentPathname);
          const currentFullUrl = window.location.pathname + window.location.search + window.location.hash;

          // --- Redirect Logic ---
          // If the determined desired URL is different from the current URL
          if (fullDesiredUrl.toLowerCase() !== currentFullUrl.toLowerCase()) {
              console.log(`Redirecting from "${currentFullUrl}" to "${fullDesiredUrl}" based on effective language "${effectiveTargetLanguage}".`);
              
              fetch(fullDesiredUrl, { method: 'HEAD' })
                  .then(response => {
                      if (response.ok) {
                          window.location.replace(fullDesiredUrl); 
                      } else {
                          console.warn(`Specific target page "${fullDesiredUrl}" for language "${effectiveTargetLanguage}" not found (404).`);
                          
                          // --- Crucial Change Here ---
                          // If the specific page in the target language doesn't exist:
                          // If the original page had a language prefix (e.g., /de/about.html) but we're trying to
                          // view an English-only page, switch to the English version of that page.
                          // If we're already on an English page (no prefix) and the saved lang is DE, and the DE page doesn't exist, 
                          // we should just stay on the English page or go to its root.

                          // Determine the path *without* any language prefix (the "base" page)
                          let nonLanguagePrefixedPath = currentPathname;
                          if (langInPath) {
                              nonLanguagePrefixedPath = nonLanguagePrefixedPath.replace(new RegExp(`^/${langInPath}(?=/|$)`, 'i'), '');
                              if (nonLanguagePrefixedPath === '') nonLanguagePrefixedPath = '/';
                          }
                          nonLanguagePrefixedPath = nonLanguagePrefixedPath.replace(/\/\/+/g, '/');

                          const englishFallbackUrl = nonLanguagePrefixedPath + search + hash;

                          console.log(`Attempting fallback to English version: ${englishFallbackUrl}`);

                          fetch(englishFallbackUrl, { method: 'HEAD' })
                              .then(englishResponse => {
                                  if (englishResponse.ok) {
                                      // If the English version of the page exists, redirect to it.
                                      // Also, update localStorage and dropdown to "en"
                                      console.log(`English version found. Redirecting to: ${englishFallbackUrl}`);
                                      localStorage.setItem('languageDropdownValue', 'en');
                                      languageSelect.value = 'en';
                                      window.location.replace(englishFallbackUrl);
                                  } else {
                                      console.error(`English version "${englishFallbackUrl}" also not found. No suitable page found.`);
                                      // If neither the target language specific page nor its English equivalent exist,
                                      // we could redirect to the English homepage as a last resort, or do nothing.
                                      const homepageFallbackUrl = '/' + search + hash;
                                      fetch(homepageFallbackUrl, { method: 'HEAD' })
                                          .then(homeResponse => {
                                              if (homeResponse.ok) {
                                                  console.log(`Falling back to English homepage: ${homepageFallbackUrl}`);
                                                  localStorage.setItem('languageDropdownValue', 'en');
                                                  languageSelect.value = 'en';
                                                  window.location.replace(homepageFallbackUrl);
                                              } else {
                                                  console.error("English homepage also not found. Staying on current (possibly 404) page.");
                                                  // As a final resort, if even the homepage isn't found,
                                                  // we might just let the browser show its 404 or stay put.
                                              }
                                          })
                                          .catch(homeError => {
                                              console.error("Error checking English homepage:", homeError);
                                          });
                                  }
                              })
                              .catch(englishError => {
                                  console.error("Error checking English fallback URL:", englishError);
                              });
                      }
                  })
                  .catch(error => {
                      console.error("Error checking initial target URL existence:", error);
                  });
          } else {
              console.log(`Already on the correct language version: ${currentFullUrl}`);
              // Ensure the dropdown is correctly set even if no redirect happens (e.g., direct navigation to /de/)
              if (effectiveTargetLanguage !== languageSelect.value) {
                  languageSelect.value = effectiveTargetLanguage;
                  localStorage.setItem('languageDropdownValue', effectiveTargetLanguage);
              }
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
