Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ /<\/head>/
    code_to_add = <<~'HTMLHereDocString'
      <script>
        document.addEventListener('DOMContentLoaded', function() {
          const languageDropdown = document.getElementById('languageDropdown');
          // Important: If languageDropdown might not exist on all pages,
          // consider a robust fallback or ensure it's always present.
          // For now, assume it's always there for language detection.
          const availableLanguages = Array.from(languageDropdown ? languageDropdown.options : []).map((option) => option.value);
          // Fallback if no dropdown exists (e.g., on a 404 page, or if dropdown isn't in layout)
          if (availableLanguages.length === 0) {
              availableLanguages.push('en', 'de'); // Add your default languages if dropdown is absent
          }


          let preferredLanguage = localStorage.getItem("languageDropdownValue");

          // 1. Check if preferredLanguage is already set and valid
          if (preferredLanguage && availableLanguages.includes(preferredLanguage)) {
              // Valid preferredLanguage from localStorage, use it.
          } else {
              // 2. Try to get preferred language from navigator.languages
              if (navigator.languages && navigator.languages.length > 0) {
                  for (let i = 0; i < navigator.languages.length; i++) {
                      const browserLang = navigator.languages[i].toLowerCase().split("-")[0];
                      if (availableLanguages.includes(browserLang)) {
                          preferredLanguage = browserLang;
                          break; // Found a match
                      }
                  }
              }

              // 3. Fallback to navigator.language or navigator.userLanguage
              if (!preferredLanguage) {
                  const fallbackLang = (navigator.language || navigator.userLanguage || "").toLowerCase().split("-")[0];
                  if (availableLanguages.includes(fallbackLang)) {
                      preferredLanguage = fallbackLang;
                  }
              }

              // 4. Final fallback to "en" if no suitable language was found
              if (!preferredLanguage) {
                  preferredLanguage = "en"; // Default fallback
              }
          }

          // Update the dropdown value and localStorage if you have a dropdown
          if (languageDropdown) {
              languageDropdown.value = preferredLanguage;
          }

          // Do not set localStorage here, but only when the user explicitly changes the dropdown
          // localStorage.setItem("languageDropdownValue", preferredLanguage);

          const currentPathname = window.location.pathname;
          const currentHostname = window.location.hostname;
          const currentProtocol = window.location.protocol;
          const currentSearch = window.location.search;
          const currentHash = window.location.hash;

          /**
           * Normalizes a path by removing a trailing slash, unless it's the root path '/'.
           * Also ensures a single leading slash and removes internal double slashes.
           * @param {string} path The path to normalize.
           * @returns {string} The normalized path.
           */
          function normalizePathForComparison(path) {
              if (!path) return '/';
              let normalized = path.replace(/\/\/+/g, '/');
              if (normalized.length > 1 && normalized.endsWith('/')) {
                  normalized = normalized.slice(0, -1);
              }
              if (!normalized.startsWith('/')) {
                  normalized = '/' + normalized;
              }
              return normalized;
          }

          let baseContentPath = '/';
          const anyTwoLetterFolderRegex = /^\/([a-z]{2})(\/.*)?$/;
          const pathSegmentMatch = currentPathname.match(anyTwoLetterFolderRegex);

          if (pathSegmentMatch) {
              baseContentPath = pathSegmentMatch[2] || '/';
          } else {
              baseContentPath = currentPathname;
          }
          baseContentPath = normalizePathForComparison(baseContentPath);

          let targetPathname;
          if (preferredLanguage === "en") {
              targetPathname = baseContentPath;
          } else {
              targetPathname = `/${preferredLanguage}${baseContentPath === '/' ? '/' : baseContentPath}`;
          }
          targetPathname = normalizePathForComparison(targetPathname);

          const normalizedCurrentPathForComparison = normalizePathForComparison(currentPathname);
          const normalizedTargetPathForComparison = normalizePathForComparison(targetPathname);

          if (normalizedCurrentPathForComparison !== normalizedTargetPathForComparison) {
              const currentFullUrl = `${currentProtocol}//${currentHostname}${currentPathname}${currentSearch}${currentHash}`;
              const targetFullUrl = `${currentProtocol}//${currentHostname}${targetPathname}${currentSearch}${currentHash}`;
              const fallbackToEnglishFullUrl = `${currentProtocol}//${currentHostname}${baseContentPath}${currentSearch}${currentHash}`;

              fetch(targetFullUrl, { method: 'HEAD' })
                  .then(response => {
                      if (response.ok) {
                          // The target URL exists, proceed with redirection
                          window.location.replace(targetFullUrl);
                      } else {
                          // The target URL does NOT exist, fall back to English
                          if (normalizedCurrentPathForComparison !== normalizePathForComparison(baseContentPath)) {
                              window.location.replace(fallbackToEnglishFullUrl);
                          }
                      }
                  })
                  .catch(error => {
                      if (normalizedCurrentPathForComparison !== normalizePathForComparison(baseContentPath)) {
                          window.location.replace(fallbackToEnglishFullUrl);
                      }
                  });
          } else {
              // No redirect needed, the current page is already the correct preferred language
          }
        });
      </script>

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

      <script>
        document.addEventListener("DOMContentLoaded", function () {
            const headings = document.querySelectorAll("h1, h2, h3, h4, h5, h6");

            headings.forEach(function (heading) {
            if (!heading.id) {
                // Generate a slug from the heading text
                const slug = heading.textContent
                .toLowerCase()
                .trim()
                .replace(/[^\w\s-]/g, '') // Remove non-word characters
                .replace(/\s+/g, '-');    // Replace spaces with dashes

                // Ensure uniqueness by appending a number if needed
                let uniqueSlug = slug;
                let counter = 1;
                while (document.getElementById(uniqueSlug)) {
                uniqueSlug = `${slug}-${counter++}`;
                }

                heading.id = uniqueSlug;
            }

            const anchor = document.createElement("a");
            anchor.href = `#${heading.id}`;
            anchor.className = "anchor-link";
            anchor.innerHTML = "🔗"; // You can replace this with an SVG or icon font
            heading.appendChild(anchor);
            });
        });
      </script>
    HTMLHereDocString

    doc.output.gsub!('</head>', "#{code_to_add}\n</head>")
  end
end