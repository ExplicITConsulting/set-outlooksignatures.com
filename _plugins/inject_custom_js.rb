Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
          document.addEventListener('DOMContentLoaded', () => {
              const path = window.location.pathname;
              const search = window.location.search;
              const hash = window.location.hash;

              const browserLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().split('-')[0];
              const currentPathLangMatch = path.match(/^\/([a-z]{2})(?:\/|$)/i);
              // currentPathLang will be 'en', 'de', or null if no explicit language prefix
              const currentPathLang = currentPathLangMatch ? currentPathLangMatch[1].toLowerCase() : null;

              const languageSelect = document.getElementById('language-select');

              // --- Determine the actual language to use for this page load ---
              let effectiveLang;
              const manualLang = sessionStorage.getItem('manualLang');
              const initialVisitHandled = sessionStorage.getItem('initialVisitHandled');

              if (manualLang) {
                  // RULE: Manual selection (from dropdown) ALWAYS wins if present.
                  effectiveLang = manualLang;
              } else if (currentPathLang === 'de' && !initialVisitHandled) {
                  // RULE: If it's the very first visit to a /de/ path in this session, default to de.
                  effectiveLang = 'de';
                  sessionStorage.setItem('initialVisitHandled', 'true'); // Mark as handled for this session
              } else if (currentPathLang) {
                  // RULE: If there's an explicit language in the path (e.g., /en/page or /de/page) and no manual override, use it.
                  effectiveLang = currentPathLang;
              } else if (browserLang === 'de') {
                  // RULE: If no manual selection, no explicit path language, and browser is German, suggest German.
                  effectiveLang = 'de';
              } else {
                  // FALLBACK: Default to English.
                  effectiveLang = 'en';
              }

              // Set the dropdown to reflect the determined effective language immediately on load
              if (languageSelect) {
                  languageSelect.value = effectiveLang;
              }

              // --- Redirection Logic (only if necessary) ---
              let shouldRedirect = false;
              let targetPath = path; // Start with the current path

              // Determine what the current path's language *looks* like for comparison
              // If currentPathLang is null, treat it as 'en' for comparison purposes, as /path is implicitly English
              const currentActualPathLang = currentPathLang || 'en';

              if (effectiveLang !== currentActualPathLang) {
                  // A redirect is needed if the effective language determined above
                  // does not match what the current URL's structure implies.

                  if (effectiveLang === 'en') {
                      // If effectiveLang is 'en', we want a path without /de/
                      targetPath = path.replace(/^\/de/i, '');
                      if (!targetPath.startsWith('/')) { // Ensure it always starts with /
                          targetPath = '/' + targetPath;
                      }
                  } else if (effectiveLang === 'de') {
                      // If effectiveLang is 'de', we want a path with /de/
                      if (!currentPathLang || currentPathLang !== 'de') {
                          targetPath = '/de' + (path === '/' ? '' : path);
                      }
                  }
                  shouldRedirect = true;
              }


              if (shouldRedirect) {
                  const targetUrl = targetPath + search;
                  // Add an additional check: only redirect if the targetUrl is actually different
                  // from the current window.location. This is a common infinite loop breaker.
                  if (window.location.pathname + window.location.search !== targetUrl) {
                      fetch(targetUrl, { method: 'HEAD' })
                          .then(response => {
                              if (response.ok) {
                                  window.location.replace(targetUrl + hash); // Use replace() for cleaner history
                              } else {
                                  // Fallback to language root if specific page doesn't exist
                                  const langRootTargetUrl = '/' + effectiveLang + '/';
                                  fetch(langRootTargetUrl, { method: 'HEAD' })
                                      .then(rootResponse => {
                                          if (rootResponse.ok) {
                                              window.location.replace(langRootTargetUrl + hash);
                                          } else {
                                              console.warn(`Could not find a valid page for language '${effectiveLang}' at '${targetUrl}' or '${langRootTargetUrl}'. Staying on current page.`);
                                          }
                                      })
                                      .catch(rootError => {
                                          console.error("Error checking language root:", rootError);
                                      });
                              }
                          })
                          .catch(error => {
                              console.error("Error checking target URL:", error);
                          });
                  }
              }

              // --- Language Switcher Event Listener ---
              if (languageSelect) {
                  languageSelect.addEventListener('change', (event) => {
                      const selectedLang = event.target.value;
                      sessionStorage.setItem('manualLang', selectedLang); // Store manual selection
                      // A manual switch means initial visit logic is now superseded for this session.
                      sessionStorage.setItem('initialVisitHandled', 'true');

                      let newPath;
                      // Start with the current path relative to its language prefix
                      let basePagePath = path;
                      if (currentPathLang) {
                          // If current path has a language prefix, remove it to get the base page
                          basePagePath = path.replace(/^\/[a-z]{2}/i, '');
                      }
                      if (basePagePath === '') basePagePath = '/'; // Ensure root is '/'

                      if (selectedLang === 'en') {
                          // For English, ensure no /de/ prefix
                          newPath = basePagePath;
                      } else if (selectedLang === 'de') {
                          // For German, ensure /de/ prefix
                          newPath = '/de' + (basePagePath === '/' ? '' : basePagePath);
                      }

                      // Ensure newPath always starts with a /
                      if (!newPath.startsWith('/')) {
                          newPath = '/' + newPath;
                      }

                      const newUrl = newPath + search + hash;

                      // Only navigate if the target URL is actually different to prevent unnecessary reloads
                      if (window.location.href !== newUrl) {
                          fetch(newUrl, { method: 'HEAD' })
                              .then(response => {
                                  if (response.ok) {
                                      window.location.href = newUrl; // Use href for manual navigation
                                  } else {
                                      // Fallback to language root if specific page doesn't exist
                                      const newLangRoot = '/' + selectedLang + '/';
                                      fetch(newLangRoot, { method: 'HEAD' })
                                          .then(rootResponse => {
                                              if (rootResponse.ok) {
                                                  window.location.href = newLangRoot;
                                              } else {
                                                  console.warn(`Could not find valid page for '${selectedLang}' at '${newUrl}' or '${newLangRoot}'. Staying on current page.`);
                                              }
                                          })
                                          .catch(rootError => {
                                              console.error("Error checking new language root:", rootError);
                                          });
                                  }
                              })
                              .catch(error => {
                                  console.error("Error checking new URL:", error);
                              });
                      }
                  });
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
