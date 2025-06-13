Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
    <script>
      document.addEventListener("DOMContentLoaded", () => {
        const path = window.location.pathname;
        const search = window.location.search;
        const hash = window.location.hash;

        const browserLang = (navigator.language || navigator.userLanguage || "en").toLowerCase().split("-")[0];
        const currentPathLangMatch = path.match(/^\/([a-z]{2})(?:\/|$)/i);
        const currentPathLang = currentPathLangMatch ? currentPathLangMatch[1].toLowerCase() : null;

        const languageSelect = document.getElementById("language-select");

        // --- Language Logic ---
        let effectiveLang;
        const manualLang = sessionStorage.getItem("manualLang");
        const initialVisitHandled = sessionStorage.getItem("initialVisitHandled");

        if (manualLang) {
          // Priority 1: If a manual selection exists, respect it
          effectiveLang = manualLang;
        } else if (currentPathLang === "de" && !initialVisitHandled) {
          // Priority 2: If this is the very first visit to /de/ in this session, use de.
          // This ensures /de/ is the default if explicitly visited first.
          effectiveLang = "de";
          sessionStorage.setItem("initialVisitHandled", "true"); // Mark as handled for this session
        } else if (currentPathLang) {
          // Priority 3: If there's a language in the path, use it
          effectiveLang = currentPathLang;
        } else if (browserLang === "de") {
          // Priority 4: If no path language and browser is 'de', use 'de' (only applies if not already handled by path or manual)
          effectiveLang = "de";
        } else {
          // Fallback: Default to 'en'
          effectiveLang = "en";
        }

        // Set the dropdown to the determined effective language immediately
        if (languageSelect) {
          // Check if element exists
          languageSelect.value = effectiveLang;
        }

        // --- Redirection Logic ---
        let shouldRedirect = false;
        let targetPath = path;

        // Only redirect if the effective language does not match the current path's language,
        // or if the effective language is 'en' and we are on a '/de/' path.
        if (effectiveLang === "en") {
          if (currentPathLang === "de") {
            shouldRedirect = true;
            targetPath = path.replace(/^\/de/i, "");
          }
        } else if (effectiveLang === "de") {
          if (currentPathLang !== "de") {
            shouldRedirect = true;
            targetPath = "/de" + (path === "/" ? "" : path);
          }
        }

        if (shouldRedirect) {
          const targetUrl = targetPath + search;
          fetch(targetUrl, { method: "HEAD" })
            .then((response) => {
              if (response.ok) {
                window.location.replace(targetUrl + hash);
              } else {
                const langRootTargetUrl = "/" + effectiveLang + "/";
                fetch(langRootTargetUrl, { method: "HEAD" })
                  .then((rootResponse) => {
                    if (rootResponse.ok) {
                      window.location.replace(langRootTargetUrl + hash);
                    } else {
                      console.warn(`Could not find a valid page for language '${effectiveLang}' at '${targetUrl}' or '${langRootTargetUrl}'`);
                    }
                  })
                  .catch((rootError) => {
                    console.error("Error checking language root:", rootError);
                  });
              }
            })
            .catch((error) => {
              console.error("Error checking target URL:", error);
            });
        }

        // --- Language Switcher Event Listener ---
        if (languageSelect) {
          languageSelect.addEventListener("change", (event) => {
            const selectedLang = event.target.value;
            sessionStorage.setItem("manualLang", selectedLang); // Store manual selection
            sessionStorage.setItem("initialVisitHandled", "true"); // A manual switch means initial visit logic is overridden

            let newPath;
            if (selectedLang === "en") {
              newPath = currentPathLang === "de" ? path.replace(/^\/de/i, "") : path;
            } else if (selectedLang === "de") {
              newPath = currentPathLang !== "de" ? "/de" + (path === "/" ? "" : path) : path;
            }

            if (!newPath.startsWith("/")) {
              newPath = "/" + newPath;
            }

            const newUrl = newPath + search + hash;

            fetch(newUrl, { method: "HEAD" })
              .then((response) => {
                if (response.ok) {
                  window.location.href = newUrl;
                } else {
                  const newLangRoot = "/" + selectedLang + "/";
                  fetch(newLangRoot, { method: "HEAD" })
                    .then((rootResponse) => {
                      if (rootResponse.ok) {
                        window.location.href = newLangRoot;
                      } else {
                        console.warn(`Could not find a valid page for language '${selectedLang}' at '${newUrl}' or '${newLangRoot}'. Staying on current page.`);
                      }
                    })
                    .catch((rootError) => {
                      console.error("Error checking new language root:", rootError);
                    });
                }
              })
              .catch((error) => {
                console.error("Error checking new URL:", error);
              });
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
