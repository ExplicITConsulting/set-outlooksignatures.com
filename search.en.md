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

        searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_loading }}";
        searchInput.disabled = true;

        // Modified to store dual indexes: indexes[lang] = { full: Index, strict: Index }
        const indexes = {};

        // Get language codes (copied from your original)
        const languagesMeta = document.querySelector('meta[name="site-languages"]');
        const languages = {};
        if (languagesMeta) {
            const languageCodes = languagesMeta.content.toLowerCase().split(',');
            languageCodes.forEach(code => {
                const trimmedCode = code.trim();
                if (trimmedCode === 'en') {
                    languages[trimmedCode] = '/search.json';
                } else {
                    languages[trimmedCode] = `/${trimmedCode}/search.json`;
                }
            });
        }
        const currentLang = document.documentElement.lang || Object.keys(languages)[0] || 'en';

        // --- Dual Index Creation Function ---
        function createDualIndices(lang, languagePack) {
            const baseConfig = {
                document: { id: "url", index: allSearchFields, store: allSearchFields },
                cache: true,
                context: true
            };

            // Configuration for flexible/general search (applies stemming and encoding)
            const fullConfig = {
                ...baseConfig,
                tokenize: "full",
                encoder: languagePack || FlexSearch.Charset.LatinSoundex, // Keeps flexible encoding
                lang: lang                                               // Keeps stemming/language rules
            };

            // Configuration for exact phrase search (disables stemming and encoding)
            const strictConfig = {
                ...baseConfig,
                tokenize: "strict",
                encoder: false, // Explicitly set to false to disable phonetic encoding
                lang: false,     // Explicitly set to false or omitted to disable stemming/language processing
                context: { 
                    resolution: 5,
                    depth: 1,
                    bidirectional: false
                }
            };

            // 1. Full Index (Flexible Search)
            const fullIndex = new FlexSearch.Document(fullConfig);

            // 2. Strict Index (Phrase Search)
            const strictIndex = new FlexSearch.Document(strictConfig);

            return { full: fullIndex, strict: strictIndex };
        }

        // Debounce function (copied from your original)
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
        }, 2000);

        // Load Script function (copied from your original)
        async function loadScript(url) {
            return new Promise((resolve, reject) => {
                const script = document.createElement('script');
                script.src = url;
                script.onload = () => resolve();
                script.onerror = () => reject(new Error(`Failed to load script: ${url}`));
                document.head.appendChild(script);
            });
        }

        // --- Initialization ---
        async function initializeSearch() {
            try {
                await loadScript(flexsearchBaseUrl);

                for (const lang of Object.keys(languages)) {
                    try {
                        await loadScript(`${languagePackBaseUrl}${lang}.min.js`);
                        const languagePack = FlexSearch.Language[lang] || FlexSearch.Charset.LatinSoundex;

                        const response = await fetch(languages[lang]);
                        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                        const data = await response.json();

                        // Create AND Populate Dual Indexes
                        const dualIndex = createDualIndices(lang, languagePack);
                        data.forEach(item => {
                            if (item.url) {
                                dualIndex.full.add(item);
                                dualIndex.strict.add(item); // Populate both
                            } else {
                                console.warn(`Item missing URL in ${languages[lang]}, skipping for FlexSearch index:`, item);
                            }
                        });
                        indexes[lang] = dualIndex;
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

        // --- Perform Merged Search ---
        function performSearch() {
            const rawQuery = searchInput.value.trim();
            if (rawQuery.length === 0) {
                searchResultsContainer.innerHTML = '';
                return;
            }

            const isPhraseSearch = rawQuery.startsWith('"') && rawQuery.endsWith('"') && rawQuery.length > 1;
            const query = isPhraseSearch ? rawQuery.slice(1, -1) : rawQuery; // Remove quotes for strict search

            let allResults = [];
            const searchOptions = {
                limit: 99,
                suggest: true, // Use suggest for the full/general search
                highlight: {
                    template: '<mark style="background-color: yellow;">$1</mark>',
                    boundary: { before: 50, after: 50, total: 500 },
                    merge: true,
                }
            };

            // Helper function to process results from a specific index
            const processResults = (index, lang, scoreAdjustment, isStrictMatch) => {
                // Note: FlexSearch will automatically handle the phrase query in the strict index
                // but we pass the unquoted query if isPhraseSearch is true for cleaner logic.
                const results = index.search(isStrictMatch ? query : rawQuery, searchOptions);
                
                results.forEach(fieldResult => {
                    if (fieldResult && fieldResult.result) {
                        fieldResult.result.forEach(r => {
                            const originalDoc = index.get(r.id);
                            if (originalDoc) {
                                const highlightedDoc = { ...originalDoc, highlight: r.highlight, field: fieldResult.field };
                                // Apply the score adjustment here to prioritize results
                                allResults.push({ 
                                    id: r.id, 
                                    doc: highlightedDoc, 
                                    score: r.score + scoreAdjustment, // Lower score is better
                                    lang: lang 
                                });
                            }
                        });
                    }
                });
            };
            
            // --- 1. SEARCH THE STRICT INDEX (Phrase Priority) ---
            // This is necessary to find exact matches and to apply the prioritization score.
            // We use a large negative score adjustment (e.g., -2000) to ensure these
            // results appear before any results from the full index.
            const PRIORITY_ADJUSTMENT = -2000;
            
            // Only query strict index if the query looks like a phrase or if we want to ensure exact matches are prioritized
            if (isPhraseSearch || !isPhraseSearch) { // Always query as requested
                processResults(indexes[currentLang].strict, currentLang, PRIORITY_ADJUSTMENT, isPhraseSearch);
            }

            // --- 2. SEARCH THE FULL INDEX (General Flexibility) ---
            // We use a score adjustment of 0 (or a small negative number) as the baseline.
            // This captures all flexible results.
            processResults(indexes[currentLang].full, currentLang, 0, false);
            
            // --- 3. SEARCH OTHER LANGUAGES (Optional - uses full index by default) ---
            // Adjust score for non-current-language results (as done in your original code)
            Object.keys(indexes).forEach(lang => {
                if (lang !== currentLang) {
                    // To keep this clean, we only search the 'full' index for other languages
                    processResults(indexes[lang].full, lang, 0, false);
                }
            });

            // --- 4. Sort and Display ---
            // allResults.sort((a, b) => a.score - b.score);
            displayResults(allResults);
        }

        // Display function (copied from your original with deduplication)
        function displayResults(results) {
            const uniqueResults = [];
            const seenUrls = new Set();
            results.forEach(result => {
                // Deduplication: only add if we haven't seen this URL before
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
                if (!item) return;

                const title = item.document || 'No Title';
                const url = item.url || '#';
                const sectionContent = item.section || '';
                const mainContent = item.highlight || '';

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