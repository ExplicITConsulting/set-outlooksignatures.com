Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <!-- Open pages in the correct language -->
      <script>
        const browserLang = (navigator.language || navigator.userLanguage || "en").toLowerCase().split("-")[0];
        const path = window.location.pathname;
        const search = window.location.search;
        const hash = window.location.hash;

        const languageSelect = document.getElementById("language-select");

        // Function to set the language-select dropdown
        const setLanguageSelect = (lang) => {
          const optionExists = Array.from(languageSelect.options).some((option) => option.value === lang);
          if (optionExists) {
            languageSelect.value = lang;
          } else {
            languageSelect.value = ""; // Set to "Automatic" if the language is not in the options
          }
        };

        const currentLangMatch = path.match(/^\/([a-z]{2})(?:\/|$)/i);
        const pathLang = currentLangMatch ? currentLangMatch[1].toLowerCase() : null;

        let shouldRedirect = false;
        let targetPath = "";

        // Check if a language is explicitly set in the URL path
        if (pathLang) {
          // If the path has a language, set the dropdown to that language
          setLanguageSelect(pathLang);

          // If the path language doesn't match the browser language, redirect
          if (pathLang !== browserLang) {
            shouldRedirect = true;
            targetPath = "/" + browserLang + path.replace(/^\/[a-z]{2}/i, "");
          }
        } else {
          // If no language in the path, it means "Automatic" has preference
          // Set the dropdown to "Automatic" initially
          setLanguageSelect("");

          // If browser language is not 'en' (default root language), redirect
          if (browserLang !== "en") {
            shouldRedirect = true;
            targetPath = "/" + browserLang + path;
          }
        }

        if (shouldRedirect) {
          const targetUrl = targetPath + search;
          // Use fetch HEAD to check existence
          fetch(targetUrl, { method: "HEAD" })
            .then((response) => {
              if (response.ok) {
                window.location.replace(targetUrl + hash); // Use replace() for cleaner history
              }
            })
            .catch((error) => {
              console.error("Error checking URL existence:", error);
            });
        }

        // Add event listener for when the language selection changes manually
        languageSelect.addEventListener("change", (event) => {
          const selectedLang = event.target.value;
          let newPath = "";

          if (selectedLang === "") {
            // "Automatic" selected
            if (browserLang === "en") {
              // If browser is English, go to root (no language prefix)
              newPath = path.replace(/^\/[a-z]{2}/i, "");
              if (newPath === "") newPath = "/"; // Ensure it's at least "/"
            } else {
              // If browser is not English, go to browser's language
              newPath = "/" + browserLang + path.replace(/^\/[a-z]{2}/i, "");
            }
          } else {
            // A specific language is selected
            newPath = "/" + selectedLang + path.replace(/^\/[a-z]{2}/i, "");
            if (!newPath.startsWith("/" + selectedLang + "/")) {
              // Handle root path
              newPath = "/" + selectedLang + (newPath === "/" ? "" : newPath);
            }
          }

          // Ensure path starts with a slash and avoid double slashes for root
          if (!newPath.startsWith("/")) {
            newPath = "/" + newPath;
          }
          newPath = newPath.replace(/\/{2,}/g, "/"); // Replace multiple slashes with a single one

          const newUrl = newPath + search + hash;
          if (window.location.pathname + window.location.search + window.location.hash !== newUrl) {
            fetch(newUrl, { method: "HEAD" })
              .then((response) => {
                if (response.ok) {
                  window.location.href = newUrl; // Use href for manual navigation
                } else {
                  // If the target URL for the selected language doesn't exist, revert or show error
                  alert("The selected language version is not available for this page.");
                  setLanguageSelect(pathLang || ""); // Revert to previous path language or automatic
                }
              })
              .catch((error) => {
                console.error("Error checking URL existence on manual language change:", error);
                alert("An error occurred while changing language.");
                setLanguageSelect(pathLang || ""); // Revert on error
              });
          }
        });
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
