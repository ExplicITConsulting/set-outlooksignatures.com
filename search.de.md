---
layout: "page"
lang: "de"
locale: "de"
title: "Wonach suchen Sie?"
subtitle: "Finden Sie es hier"
description: "Suchen Sie nach Informationen? Finden Sie schnell die passenden Inhalte und Antworten zu unseren Lösungen und Services."
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

        const debouncedTrackSearch = debounce(function() {
            if (typeof _paq !== 'undefined') {
                const query = searchInput.value.trim();
                const resultsCount = searchResultsContainer.querySelectorAll('li').length;
                _paq.push(['trackSiteSearch', query, false, resultsCount]);
            }
        }, 2000); // 2000ms delay for _paq

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
                    searchInput.addEventListener('input', () => {
                        const query = searchInput.value.trim();

                        if (query.length > 0) {
                            performSearch();
                        } else {
                            searchResultsContainer.innerHTML = '';
                        }

                        debouncedTrackSearch();
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

        function performExactMatchSearch(query, lang) {
            const rawData = searchData[lang] || [];
            
            // REGEX: Matches any character that is NOT a word character (\w) AND NOT whitespace (\s).
            const nonPunctuationRegex = /[^\w\s]/g; 

            // 1. Normalize and trim the query (for the exact MATCH check)
            const normalizedQuery = query.toLowerCase().replace(nonPunctuationRegex, '').trim();
            const exactMatches = [];
            
            const exactMatchScore = -2000; 

            // Skip if the query is empty after normalizing
            if (normalizedQuery.length === 0) {
                return exactMatches;
            }

            // NEW: Create a flexible regex pattern from the query for snippet locating and highlighting.
            // 1. Escape special regex characters in the raw query.
            const safeQuery = query.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
            // 2. Replace a sequence of non-alphanumeric/non-whitespace characters with the '.*?' wildcard.
            const flexiblePattern = safeQuery.replace(nonPunctuationRegex, '.*?');


            rawData.forEach(item => {
                // 2. Normalize data fields using the same logic for the match check.
                const docText = item.document ? item.document.toLowerCase().replace(nonPunctuationRegex, '').trim() : '';
                const sectionText = item.section ? item.section.toLowerCase().replace(nonPunctuationRegex, '').trim() : '';
                const contentText = item.content ? item.content.toLowerCase().replace(nonPunctuationRegex, '').trim() : '';

                // Check if the normalized data includes the normalized query
                const isDocMatch = docText.includes(normalizedQuery);
                const isSectionMatch = sectionText.includes(normalizedQuery);
                const isContentMatch = contentText.includes(normalizedQuery);

                const isExactMatch = isDocMatch || isSectionMatch || isContentMatch;

                if (isExactMatch) {
                    // Determine which field contained the match
                    let matchedText = '';
                    
                    // Priority for snippet selection: Document > Section > Content
                    if (isDocMatch) {
                        matchedText = item.document;
                    } else if (isSectionMatch) {
                        matchedText = item.section;
                    } else { // Must be isContentMatch
                        matchedText = item.content || '';
                    }

                    // Calculate snippet boundaries using the flexible regex
                    const flexibleRegex = new RegExp(flexiblePattern, 'i');
                    const match = matchedText.match(flexibleRegex);
                    const queryIndex = match ? match.index : -1;
                    
                    // If no index is found (shouldn't happen if isExactMatch is true), skip.
                    if (queryIndex === -1) {
                        return;
                    }
                    
                    // Define boundaries for context (50 before, 50 after)
                    const contextPadding = 50; 
                    const maxSnippetLength = 500;
                    
                    // Use the length of the actual match found for better snippet calculation
                    const matchLength = match[0].length; 
                    let snippetStart = Math.max(0, queryIndex - contextPadding);
                    let snippetEnd = Math.min(matchedText.length, queryIndex + matchLength + contextPadding);
                    
                    let highlightSnippet = matchedText.substring(snippetStart, snippetEnd);
                    
                    // If the match was found in content, provide a longer snippet up to 500 chars
                    if (isContentMatch) {
                        // Recalculate end boundary for max length
                        snippetEnd = Math.min(matchedText.length, snippetStart + maxSnippetLength);
                        highlightSnippet = matchedText.substring(snippetStart, snippetEnd);
                    }
                    
                    // Prepend ellipsis if snippet starts late
                    if (snippetStart > 0) {
                        highlightSnippet = "..." + highlightSnippet;
                    }
                    // Append ellipsis if content was truncated
                    if (snippetEnd < matchedText.length && highlightSnippet.length >= maxSnippetLength) {
                        highlightSnippet = highlightSnippet + "...";
                    }

                    // Create a simplified result object for display
                    exactMatches.push({
                        id: item.url,
                        doc: { 
                            ...item, 
                            highlight: highlightSnippet, 
                            isExactMatch: true,
                            // Store the flexible pattern for highlighting in displayResults
                            exactQueryPattern: flexiblePattern 
                        }, 
                        score: exactMatchScore, 
                        lang: lang
                    });
                }
            });

            return exactMatches;
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

            // 1. Perform Exact Match Search for the current language
            const currentLangExactMatches = performExactMatchSearch(query, currentLang);
            allResults.push(...currentLangExactMatches);

            // 2. Perform FlexSearch for the current language
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

            // 3. Perform FlexSearch for other languages
            Object.keys(indexes).forEach(lang => {
                if (lang !== currentLang) {
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
                }
            });

            allResults.sort((a, b) => a.score - b.score);
            displayResults(allResults);
        }

        function displayResults(results) {
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
                searchResultsContainer.innerHTML = '<p>{{ site.data[site.active_lang].string.search_resultsContainer_placeholder_queryNoResults }}</p>';
                return;
            }

            let html = '<ul class="search-results-list">';
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
                    // 1. Retrieve the stored flexible pattern
                    const flexiblePatternToHighlight = item.exactQueryPattern; 
                    
                    // 2. Create the case-insensitive global regex from the flexible pattern
                    const regex = new RegExp('(' + flexiblePatternToHighlight + ')', 'gi');
                    
                    // 3. Apply manual highlight to the title, section, AND the content snippet
                    title = title.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
                    sectionContent = sectionContent.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
                    
                    // Highlight the content snippet itself
                    mainContent = mainContent.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
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
        }
    })();
</script>