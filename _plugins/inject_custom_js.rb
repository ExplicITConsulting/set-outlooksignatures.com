Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        (function () {
          const languageSelect = document.getElementById("language-select");

          let userPreferredLang = localStorage.getItem("userSelectedLanguage");
          const detectedBrowserLang = (navigator.language || navigator.userLanguage || "en").toLowerCase().split("-")[0];
          let effectiveSessionLang;

          if (userPreferredLang !== null) {
            effectiveSessionLang = userPreferredLang === "" ? detectedBrowserLang : userPreferredLang;
          } else {
            effectiveSessionLang = detectedBrowserLang;
          }

          const path = window.location.pathname;
          const search = window.location.search;
          const hash = window.location.hash;

          const setLanguageSelect = (lang) => {
            const optionExists = Array.from(languageSelect.options).some((option) => option.value === lang);
            if (optionExists) {
              languageSelect.value = lang;
            } else {
              languageSelect.value = "";
            }
          };

          const currentLangMatch = path.match(/^\/([a-z]{2})(?:\/|$)/i);
          const pathLang = currentLangMatch ? currentLangMatch[1].toLowerCase() : null;

          if (pathLang) {
            setLanguageSelect(pathLang);
          } else if (userPreferredLang !== null) {
            setLanguageSelect(userPreferredLang);
          } else {
            setLanguageSelect("");
          }

          let shouldRedirect = false;
          let targetPath = "";

          if (pathLang) {
            if (pathLang !== effectiveSessionLang) {
              shouldRedirect = true;
              targetPath = "/" + effectiveSessionLang + path.replace(/^\/[a-z]{2}/i, "");
            }
          } else {
            if (effectiveSessionLang !== "en") {
              shouldRedirect = true;
              targetPath = "/" + effectiveSessionLang + path;
            }
          }

          if (shouldRedirect) {
            if (!targetPath.startsWith("/")) {
              targetPath = "/" + targetPath;
            }
            targetPath = targetPath.replace(/\/{2,}/g, "/");

            const targetUrl = targetPath + search;
            fetch(targetUrl, { method: "HEAD" })
              .then((response) => {
                if (response.ok) {
                  window.location.replace(targetUrl + hash);
                } else {
                  console.warn(`Target URL for initial redirect (${targetUrl}) not found. Staying on current page.`);
                  setLanguageSelect(pathLang || "");
                }
              })
              .catch((error) => {
                console.error("Error checking URL existence for initial redirect:", error);
                setLanguageSelect(pathLang || "");
              });
          }

          languageSelect.addEventListener("change", (event) => {
            const selectedLang = event.target.value;
            localStorage.setItem("userSelectedLanguage", selectedLang);

            effectiveSessionLang = selectedLang === "" ? detectedBrowserLang : selectedLang;

            let newPath = "";

            if (selectedLang === "") {
              if (detectedBrowserLang === "en") {
                newPath = path.replace(/^\/[a-z]{2}/i, "");
                if (newPath === "") newPath = "/";
              } else {
                newPath = "/" + detectedBrowserLang + path.replace(/^\/[a-z]{2}/i, "");
              }
            } else {
              newPath = "/" + selectedLang + path.replace(/^\/[a-z]{2}/i, "");
              if (!newPath.startsWith("/" + selectedLang + "/")) {
                newPath = "/" + selectedLang + (newPath === "/" ? "" : newPath);
              }
            }

            if (!newPath.startsWith("/")) {
              newPath = "/" + newPath;
            }
            newPath = newPath.replace(/\/{2,}/g, "/");

            const newUrl = newPath + search + hash;

            if (window.location.pathname + window.location.search + window.location.hash !== newUrl) {
              fetch(newUrl, { method: "HEAD" })
                .then((response) => {
                  if (response.ok) {
                    window.location.href = newUrl;
                  } else {
                    alert("The selected language version is not available for this page.");
                    setLanguageSelect(pathLang || userPreferredLang || "");
                  }
                })
                .catch((error) => {
                  console.error("Error checking URL existence on manual language change:", error);
                  alert("An error occurred while changing language.");
                  setLanguageSelect(pathLang || userPreferredLang || "");
                });
            }
          });
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
