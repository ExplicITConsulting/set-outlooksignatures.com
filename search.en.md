---
layout: "page"
lang: "en"
locale: "en"
title: "What are you looking for?"
subtitle: "Find it here"
description: "Find what you need quickly: explore resources, answers, and solutions tailored to your needs."
permalink: "/search"
redirect_from:
  - "/search/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<div class="field has-addons">
    <div class="control is-expanded">
        <input type="search" id="search-input" placeholder="{{ site.data[site.active_lang].strings.search_search-input_placeholder_ready }}" class="input is-large">
    </div>
</div>

<div id="search-results" class="content">
</div>


<script>
    (function() {
        const flexsearchBaseUrl = "https://cdn.jsdelivr.net/gh/nextapps-de/flexsearch@0.8/dist/flexsearch.bundle.min.js";
        const languagePackBaseUrl = "https://cdn.jsdelivr.net/gh/nextapps-de/flexsearch@0.8/dist/lang/";

        const allSearchFields = ["document", "section", "content", "url", "date", "category", "tags"];

        const searchInput = document.getElementById('search-input');
        const searchResultsContainer = document.getElementById('search-results');

        // Set initial placeholder and disable the input
        searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_loading }}";
        searchInput.disabled = true;

        const indexes = {};
        // Store raw JSON data for exact match search
        const searchData = {};

        // Get the languages string from the custom meta tag
        const languagesMeta = document.querySelector('meta[name="site-languages"]');
        const languages = {};

        if (languagesMeta) {
            const languageCodes = languagesMeta.content.toLowerCase().split(',');
            languageCodes.forEach(code => {
                const trimmedCode = code.trim();
                // Check for the English language code
                if (trimmedCode === 'en') {
                    languages[trimmedCode] = '/search.json';
                } else {
                    languages[trimmedCode] = `/${trimmedCode}/search.json`;
                }
            });
        }

        const currentLang = document.documentElement.lang || Object.keys(languages)[0] || 'en';

        function createIndex(lang, languagePack) {
            return new FlexSearch.Document({
                document: {
                    id: "url",
                    index: allSearchFields,
                    store: allSearchFields
                },
                tokenize: "full",
                encoder: languagePack || FlexSearch.Charset.LatinSoundex,
                cache: true,
                context: true,
                lang: lang
            });
        }

        // Debounce function specifically for the _paq tracking
        function debounce(func, delay) {
            let timeoutId;
            return function(...args) {
                clearTimeout(timeoutId);
                timeoutId = setTimeout(() => {
                    func.apply(this, args);
                }, delay);
            };
        }

        async function loadScript(url) {
            return new Promise((resolve, reject) => {
                const script = document.createElement('script');
                script.src = url;
                script.onload = () => resolve();
                script.onerror = () => reject(new Error(`Failed to load script: ${url}`));
                document.head.appendChild(script);
            });
        }

        async function initializeSearch() {
            try {
                // 1. Load the main FlexSearch library.
                await loadScript(flexsearchBaseUrl);

                // 2. Loop through language codes to load language packs and search.json.
                for (const lang of Object.keys(languages)) {
                    try {
                        let languagePack = null;

                        // Await the script load before accessing FlexSearch.lang.
                        await loadScript(`${languagePackBaseUrl}${lang}.min.js`);
                        languagePack = FlexSearch.Language[lang] || FlexSearch.Charset.LatinSoundex;

                        const response = await fetch(languages[lang]);
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        const data = await response.json();

                        // Store raw data
                        searchData[lang] = data;

                        const index = createIndex(lang, languagePack);
                        data.forEach(item => {
                            if (item.url) {
                                index.add(item);
                            } else {
                                console.warn(`Item missing URL in ${languages[lang]}, skipping for FlexSearch index:`, item);
                            }
                        });
                        indexes[lang] = index;
                    } catch (error) {
                        console.error(`Error loading data for language "${lang}":`, error);
                        delete languages[lang];
                    }
                }

                if (Object.keys(indexes).length > 0) {
                    searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_ready }}";
                    searchInput.disabled = false;

                    const urlParams = new URLSearchParams(window.location.search);
                    const urlQuery = urlParams.get('search');

                    if (urlQuery) {
                        searchInput.value = urlQuery;
                        performSearch();
                    }

                    searchInput.addEventListener('input', () => {
                        const query = searchInput.value.trim();
                        const newUrl = new URL(window.location);

                        if (query.length > 0) {
                            newUrl.searchParams.set('search', query);
                            performSearch();
                        } else {
                            newUrl.searchParams.delete('search');
                            searchResultsContainer.innerHTML = '';
                        }

                        window.history.replaceState({ path: newUrl.href }, '', newUrl.href);
                    });
                } else {
                    searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_error }}";
                    searchInput.disabled = true;
                    searchResultsContainer.innerHTML = '<p>Error loading search data. Please check your network connection and reload the page.</p>';
                }
            } catch (error) {
                console.error('Initialization failed:', error);
                searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_error }}";
                searchInput.disabled = true;
                searchResultsContainer.innerHTML = '<p>Search functionality failed to load. Please try again later.</p>';
            }
        }

        initializeSearch();

        /**
         * Searches for exact matches without non-word characters in the raw data across a list of languages.
         * Note: Assumes 'searchData' is available in the scope.
         * * @param {string} query The search term.
         * @param {string[]} langs An array of language codes to search in (e.g., ['en', 'fr', 'es']).
         * @returns {object[]} An array of result objects with the exact match score.
         */
        function performExactMatchSearch(query, langs) {
            const allExactMatches = [];

            // 1. QUERY NORMALIZATION: Creates a fuzzy pattern
            // Example: "open-source" -> "open.?source"
            const normalizedQuery = query.toLowerCase()
                .replace(/\W/g, '.?')      // Replace non-word chars (space, hyphen) with '.?'
                .replace(/(\w)/g, '$1.?')  // Replace every word char with itself + '.?' (e.g., 'f' -> 'f.?')
                .replace(/\.\?\.\?/g, '.?') // Collapse consecutive '.?.?' into single '.?'
                .replace(/(^\.\?|\.\?$)/g, ''); // Trim leading/trailing '.?'

            const searchPattern = new RegExp(normalizedQuery, 'i');

            const exactMatchScore = -2000;

            // Skip if the query is empty after normalizing
            if (normalizedQuery.length === 0) {
                return allExactMatches;
            }

            // Define the search logic for a single language
            const searchSingleLanguage = (langCode) => {
                const rawData = searchData[langCode] || [];
                const langMatches = [];

                rawData.forEach(item => {
                    // Priority for which field to use for snippet/match
                    let matchedText = item.document;
                    let matchField = 'document';

                    if (!searchPattern.test(item.document)) {
                        matchedText = item.section;
                        matchField = 'section';
                        if (!searchPattern.test(item.section)) {
                            matchedText = item.content || '';
                            matchField = 'content';
                        }
                    }

                    const isExactMatch = searchPattern.test(matchedText);

                    if (isExactMatch) {
                        const matchResults = matchedText.match(searchPattern);

                        if (!matchResults) return; // Should not happen if .test() passed, but for safety

                        const queryIndex = matchResults.index;
                        const matchedSubstring = matchResults[0]; // The actual text that satisfied the fuzzy pattern
                        const matchLength = matchedSubstring.length;
                        const isContentMatch = (matchField === 'content');

                        // Define boundaries for context (50 before, 50 after)
                        const contextPadding = 50;
                        const maxSnippetLength = 500;

                        let snippetStart = Math.max(0, queryIndex - contextPadding);

                        // Calculate short snippet end boundary: match end + padding
                        let snippetEnd = queryIndex + matchLength + contextPadding;

                        // If the match was found in content, provide a longer snippet up to 500 chars
                        if (isContentMatch) {
                            // Recalculate end boundary for max length
                            snippetEnd = snippetStart + maxSnippetLength;
                        }

                        // Final boundary clipping
                        snippetEnd = Math.min(matchedText.length, snippetEnd);

                        let highlightSnippet = matchedText.substring(snippetStart, snippetEnd);

                        // Prepend ellipsis if snippet starts late
                        if (snippetStart > 0) {
                            highlightSnippet = "..." + highlightSnippet;
                        }

                        // Append ellipsis if content was truncated (either by padding or max length)
                        if (snippetEnd < matchedText.length) {
                            highlightSnippet = highlightSnippet + "...";
                        }

                        // Create a simplified result object for display
                        langMatches.push({
                            id: item.url,
                            doc: {
                                ...item,
                                highlight: highlightSnippet,
                                isExactMatch: true,
                                exactQuery: matchedSubstring,
                            },
                            score: exactMatchScore,
                            lang: langCode
                        });
                    }
                });
                return langMatches;
            };

            // Iterate over all provided languages and accumulate results
            langs.forEach(langCode => {
                allExactMatches.push(...searchSingleLanguage(langCode));
            });

            return allExactMatches;
        }


        function performSearch() {
            const query = searchInput.value.trim();
            if (query.length === 0) {
                searchResultsContainer.innerHTML = '';
                return;
            }
            if (typeof query !== 'string' || query.length === 0) {
                searchResultsContainer.innerHTML = '<p>{{ site.data[site.active_lang].strings.search_resultsContainer_placeholder_queryEmpty }}</p>';
                return;
            }

            let allResults = [];
            const searchOptions = {
                limit: 99,
                suggest: true,
                highlight: {
                    template: '<mark style="background-color: yellow;">$1</mark>',
                    boundary: {
                        before: 50,
                        after: 50,
                        total: 500
                    },
                    merge: true,
                }
            };

            // 1. Determine the search order: current language first, then all others.
            const availableLangs = Object.keys(indexes);
            const otherLangs = availableLangs.filter(lang => lang !== currentLang);
            const langsToSearch = [currentLang, ...otherLangs];

            // 2. Perform Exact Match Search for ALL languages, prioritizing currentLang
            // Note: The array will be searched in order, but results will be merged and sorted later.
            const allExactMatches = performExactMatchSearch(query, langsToSearch);
            allResults.push(...allExactMatches);


            // 3. Perform FlexSearch for the current language
            const currentLangIndex = indexes[currentLang];
            if (currentLangIndex) {
                const rawResults = currentLangIndex.search(query, searchOptions);
                rawResults.forEach(fieldResult => {
                    if (fieldResult && fieldResult.result) {
                        fieldResult.result.forEach(r => {
                            const originalDoc = currentLangIndex.get(r.id);
                            if (originalDoc) {
                                const highlightedDoc = { ...originalDoc, highlight: r.highlight, field: fieldResult.field };
                                // Negative score for current language priority
                                allResults.push({ id: r.id, doc: highlightedDoc, score: r.score - 1000, lang: currentLang });
                            }
                        });
                    }
                });
            }

            // 4. Perform FlexSearch for other languages
            otherLangs.forEach(lang => { // Iterate over the 'otherLangs' list
                const otherLangIndex = indexes[lang];
                const rawResults = otherLangIndex.search(query, searchOptions);

                rawResults.forEach(fieldResult => {
                    if (fieldResult && fieldResult.result) {
                        fieldResult.result.forEach(r => {
                            const originalDoc = otherLangIndex.get(r.id);
                            if (originalDoc) {
                                const highlightedDoc = { ...originalDoc, highlight: r.highlight, field: fieldResult.field };
                                // Positive score for other languages
                                allResults.push({ id: r.id, doc: highlightedDoc, score: r.score, lang: lang });
                            }
                        });
                    }
                });
            });

            allResults.sort((a, b) => a.score - b.score);
            displayResults(allResults);
        }

        function displayResults(results) {
            let githubLinkHtml = "";

            if (window.location.hostname.toLowerCase() === 'set-outlooksignatures.com') {
                githubLinkHtml = `<div class="mb-4"><a href="${`https://github.com/search?q=repo%3ASet-OutlookSignatures%2FSet-OutlookSignatures+${encodeURIComponent(searchInput.value.trim())}&type=code`}" target="_blank">{{ site.data[site.active_lang].strings.search_resultsContainer_continueOnGitHub }}</a></div>`;
            }

            const uniqueResults = [];
            const seenUrls = new Set();
            results.forEach(result => {
                // IMPORTANT: Exact matches (score -2000) will appear before FlexSearch results (score -1000 or higher) for the same URL,
                // so the exact match version is guaranteed to be added first due to the sort order.
                if (result.doc && !seenUrls.has(result.doc.url)) {
                    uniqueResults.push(result);
                    seenUrls.add(result.doc.url);
                }
            });

            if (uniqueResults.length === 0) {
                searchResultsContainer.innerHTML = githubLinkHtml + '<p>{{ site.data[site.active_lang].strings.search_resultsContainer_placeholder_queryNoResults }}</p>';
                return;
            }

            let html = githubLinkHtml + '<ul class="search-results-list">';
            uniqueResults.forEach(result => {
                const item = result.doc;
                if (!item) {
                    console.warn('Skipping search result with undefined document:', result);
                    return;
                }

                let title = item.document || 'No Title';
                const url = item.url || '#';
                let sectionContent = item.section || '';
                let mainContent = item.highlight || ''; // Use the content/snippet stored here

                // Logic for Exact Match (using the isExactMatch flag)
                if (item.isExactMatch) {
                    // Use the stored query for highlighting the snippet and titles
                    const queryToHighlight = item.exactQuery || mainContent;

                    // 1. Escape special regex characters in the query
                    const safeQuery = queryToHighlight.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');

                    // 2. Create the case-insensitive global regex
                    const regex = new RegExp('(' + safeQuery + ')', 'gi');

                    // 3. Apply manual highlight to the title, section, AND the content snippet
                    title = title.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
                    sectionContent = sectionContent.replace(regex, '<mark style="background-color: yellow;">$1</mark>');

                    // Highlight the content snippet itself
                    mainContent = mainContent.replace(regex, '<mark style="background-color: yellow;">$1</mark>');

                    // Add a subtle indicator above the content
                    // mainContent = `<p class="has-text-weight-bold has-text-primary mb-1">High-Priority Match:</p>${mainContent}`;
                }


                html += `
                    <li class="box mb-4">
                        <p><a href="${url}"><strong>${title}</strong></a><br>${sectionContent}</p>
                        <p>${mainContent}</p>
                    </li>
                `;
            });

            html += '</ul>';

            searchResultsContainer.innerHTML = html;

            clearTimeout(window.searchTrackingTimer);

            window.searchTrackingTimer = setTimeout(() => {
                // Check if _paq exists AND if there's actually a query to track
                if (typeof _paq !== 'undefined') {
                    const query = searchInput.value.trim();
                    // Ensure we don't track empty searches if the user cleared the input
                    if (query.length > 0) {
                        console.log(`Search result count: ${uniqueResults.length}`);
                        _paq.push(['trackSiteSearch', query, false, uniqueResults.length]);
                    }
                }
            }, 1000); // Wait 1 second after last result render before tracking
        }
    })();
</script>