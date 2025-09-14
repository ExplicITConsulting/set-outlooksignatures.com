---
layout: page
lang: en
locale: en
title: What are you looking for?
subtitle: Find it here
description: What are you looking for? Find it here.
page_id: "search"
permalink: /search
---

<div class="field has-addons">
    <div class="control is-expanded">
        <input type="search" id="search-input" placeholder="Type to search" class="input is-large">
    </div>
</div>

<div id="search-results" class="content">
</div>

<script src="https://cdn.jsdelivr.net/gh/nextapps-de/flexsearch@0.8/dist/flexsearch.bundle.min.js"></script>

<script>
    (function() {
        const allSearchFields = ["document", "section", "content", "url", "date", "category", "tags"];

        const searchInput = document.getElementById('search-input');
        const searchResultsContainer = document.getElementById('search-results');

        // Set initial placeholder and disable the input
        searchInput.placeholder = "Loading data…";
        searchInput.disabled = true;

        const indexes = {};

        // Get the languages string from the custom meta tag
        const languagesMeta = document.querySelector('meta[name="site-languages"]');
        const languages = {};

        if (languagesMeta) {
            const languageCodes = languagesMeta.content.split(',');

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

        const currentLang = document.documentElement.lang || languageCodes[0] || 'en';

        function createIndex(lang) {
            return new FlexSearch.Document({
                document: {
                    id: "url",
                    index: allSearchFields,
                    store: allSearchFields
                },
                tokenize: "full",
                encoder: FlexSearch.Charset.LatinSoundex,
                cache: true,
                context: true,
                lang: lang
            });
        }

        let filesToLoad = Object.keys(languages).map(lang => languages[lang]);
        let filesLoaded = 0;

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

        function checkIfReady() {
            filesLoaded++;
            if (filesLoaded === filesToLoad.length) {
                searchInput.placeholder = "Type to search";
                searchInput.disabled = false;

                // Attach the event listener to trigger both actions
                searchInput.addEventListener('input', () => {
                    const query = searchInput.value.trim();
                    if (query.length > 0) {
                        performSearch(); // Immediate search
                        debouncedTrackSearch(); // Debounced _paq call
                    } else {
                        // Clear results if the input is empty
                        searchResultsContainer.innerHTML = '';
                    }
                });
            }
        }

        Object.keys(languages).forEach(lang => {
            const url = languages[lang];
            indexes[lang] = createIndex(lang);

            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    data.forEach(item => {
                        if (item.url) {
                            indexes[lang].add(item);
                        } else {
                            console.warn(`Item missing URL in ${url}, skipping for FlexSearch index:`, item);
                        }
                    });
                    checkIfReady();
                })
                .catch(error => {
                    console.error(`Error fetching or parsing ${url}:`, error);
                    searchResultsContainer.innerHTML = '<p>Error loading search data. Some results may be missing. You can still search, but not all data might be available. Please try reloading the page.</p>';
                    checkIfReady();
                });
        });

        function performSearch() {
            const query = searchInput.value.trim();
            if (query.length === 0) {
                searchResultsContainer.innerHTML = '';
                return;
            }
            if (typeof query !== 'string' || query.length === 0) {
                console.warn("Invalid search query received (not a non-empty string):", query);
                searchResultsContainer.innerHTML = '<p>Please enter a valid search term.</p>';
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

            const currentLangIndex = indexes[currentLang];
            if (currentLangIndex) {
                const rawResults = currentLangIndex.search(query, searchOptions);

                rawResults.forEach(fieldResult => {
                    if (fieldResult && fieldResult.result) {
                        fieldResult.result.forEach(r => {
                            const originalDoc = currentLangIndex.get(r.id);
                            if (originalDoc) {
                                const highlightedDoc = { ...originalDoc, highlight: r.highlight, field: fieldResult.field };
                                allResults.push({ id: r.id, doc: highlightedDoc, score: r.score - 1000, lang: currentLang });
                            }
                        });
                    }
                });
            }

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
                if (result.doc && !seenUrls.has(result.doc.url)) {
                    uniqueResults.push(result);
                    seenUrls.add(result.doc.url);
                }
            });

            if (uniqueResults.length === 0) {
                searchResultsContainer.innerHTML = '<p>No results found.</p>';
                return;
            }

            let html = '<ul class="search-results-list">';
            uniqueResults.forEach(result => {
                const item = result.doc;
                if (!item) {
                    console.warn('Skipping search result with undefined document:', result);
                    return;
                }

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