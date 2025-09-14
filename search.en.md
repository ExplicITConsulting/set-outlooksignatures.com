---
layout: page
title: Search and find
subtitle: What are you looking for?
description: Search and find. What are you looking for?
page_id: "search"
permalink: /search
---

<input type="search" id="search-input" placeholder="Start typing to search…" class="input is-large mb-4">

<div id="search-results" class="content">
</div>

<script src="https://cdn.jsdelivr.net/npm/flexsearch@0.8.205/dist/flexsearch.bundle.min.js"></script>

<script>
    (function() {
        const allSearchFields = ["document", "section", "content", "url", "date", "category", "tags"];

        const searchInput = document.getElementById('search-input');
        const searchResultsContainer = document.getElementById('search-results');
        let searchTimeout;

        // Step 1: Set initial placeholder and disable the input
        searchInput.placeholder = "Loading search data...";
        searchInput.disabled = true;

        // Initialize FlexSearch index
        const index = new FlexSearch.Document({
            document: {
                id: "url", // Unique identifier for each document
                index: allSearchFields, // Index all specified fields
                store: allSearchFields // Store all specified fields for retrieval
            },
            // Configure search options for better results
            tokenize: "full", // Tokenize by words, allowing partial matches
            resolution: 9, // Higher resolution for better relevance
            depth: 2, // Deeper search for nested objects if any (though our JSON is flat)
            optimize: true, // Optimize index for faster searches
            cache: true, // Cache search results
        });

        // Keep track of how many files have been loaded
        let filesToLoad = ['/search.json', '/de/search.json'];
        let filesLoaded = 0;

        // Function to check if all files are loaded
        function checkIfReady() {
            filesLoaded++;
            // Step 3: Check if all files are loaded and if so, update the UI
            if (filesLoaded === filesToLoad.length) {
                // console.log('FlexSearch index populated successfully.');
                searchInput.placeholder = "Start typing to search…";
                searchInput.disabled = false;
                // Add event listener AFTER the index is ready
                searchInput.addEventListener('input', () => {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(performSearch, 300);
                });
            }
        }

        // Fetch the search.json files and populate the index
        filesToLoad.forEach(url => {
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
                            index.add(item);
                        } else {
                            console.warn('Item missing URL, skipping for FlexSearch index:', item);
                        }
                    });
                    checkIfReady();
                })
                .catch(error => {
                    console.error('Error fetching or parsing search.json:', error);
                    // In case of error, still try to enable the search
                    searchResultsContainer.innerHTML = '<p>Error loading search data. Some results may be missing. You can still search, but not all data might be available. Please try reloading the page.</p>';
                    checkIfReady();
                });
        });

        // Function to perform search and display results (no changes here)
        function performSearch() {
            const query = searchInput.value.trim();
            if (query.length === 0) {
                searchResultsContainer.innerHTML = '<p>Results will appear here.</p>';
                return;
            }
            if (typeof query !== 'string' || query.length === 0) {
                console.warn("Invalid search query received (not a non-empty string):", query);
                searchResultsContainer.innerHTML = '<p>Please enter a valid search term.</p>';
                return;
            }
            const rawResults = index.search(query, {
                limit: 99,
                enrich: true,
            });
            let flatResults = [];
            rawResults.forEach(fieldResult => {
                if (fieldResult && fieldResult.field && Array.isArray(fieldResult.result)) {
                    fieldResult.result.forEach(r => flatResults.push({ id: r.id, doc: index.get(r.id) }));
                } else if (fieldResult && fieldResult.doc) {
                    flatResults.push(fieldResult);
                }
            });
            displayResults(flatResults, query);
        }
        function displayResults(results, query) {
            if (typeof _paq !== 'undefined') {
                _paq.push(['trackSiteSearch', query, false, results.length]);
            }
            if (results.length === 0) {
                searchResultsContainer.innerHTML = '<p>No results found.</p>';
                return;
            }
            let html = '<ul class="search-results-list">';
            results.forEach(result => {
                const item = result.doc;
                if (!item) {
                    console.warn('Skipping search result with undefined document:', result);
                    return;
                }
                let displayContentDictionary = {}
                allSearchFields.forEach(field => {
                    if (item[field] && typeof item[field] === 'string' && item[field].length > 0) {
                        let displayedFieldContent;
                        if (field === 'content' || field === 'section') {
                            displayedFieldContent = generateContextualSnippet(item[field], query, 500, 80);
                        } else {
                            displayedFieldContent = applyHighlighting(item[field], query);
                            if (field !== 'url' && displayedFieldContent.length > 500) {
                                displayedFieldContent = displayedFieldContent.substring(0, 500) + '…';
                            }
                        }
                        displayContentDictionary[field] = {
                            rawContent: displayedFieldContent
                        };
                    }
                });
                let title = displayContentDictionary.document.rawContent || 'No Title';
                title = applyHighlighting(title, query);
                const url = item.url || '#';
                html += `
                    <li class="box mb-4">
                        <p><a href="${url}"><strong>${title}</strong></a><br>${displayContentDictionary.section.rawContent}</p>
                        <p>${displayContentDictionary.content.rawContent}</p>
                    </li>
                `;
            });
            html += '</ul>';
            searchResultsContainer.innerHTML = html;
        }
        function applyHighlighting(text, query) {
            if (!text || typeof text !== 'string' || !query || typeof query !== 'string' || query.trim().length === 0) {
                return text;
            }
            const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            const regex = new RegExp(`(${escapedQuery})`, 'gi');
            return text.replace(regex, '<mark>$1</mark>');
        }
        function generateContextualSnippet(fullText, query, totalSnippetLength = 250, contextChars = 80) {
            if (!fullText || typeof fullText !== 'string' || !query || typeof query !== 'string' || query.trim().length === 0) {
                return applyHighlighting(fullText.substring(0, totalSnippetLength), query) + (fullText.length > totalSnippetLength ? '' : '…');
            }
            const lowerText = fullText.toLowerCase();
            const lowerQuery = query.toLowerCase();
            let matchIndexes = [];
            let currentPos = lowerText.indexOf(lowerQuery);
            while (currentPos !== -1) {
                matchIndexes.push(currentPos);
                currentPos = lowerText.indexOf(lowerQuery, currentPos + lowerQuery.length);
            }
            if (matchIndexes.length === 0) {
                return applyHighlighting(fullText.substring(0, totalSnippetLength), query) + (fullText.length > totalSnippetLength ? '…' : '');
            }
            const firstMatchIndex = matchIndexes[0];
            let start = Math.max(0, firstMatchIndex - contextChars);
            let end = Math.min(fullText.length, firstMatchIndex + lowerQuery.length + contextChars);
            if (end - start < totalSnippetLength) {
                end = Math.min(fullText.length, start + totalSnippetLength);
            }
            if (end - start < totalSnippetLength) {
                start = Math.max(0, end - totalSnippetLength);
            }
            if (start > end) { start = Math.max(0, end - totalSnippetLength); }
            let actualStart = start;
            if (start > 0) {
                const spaceBefore = fullText.lastIndexOf(' ', start);
                if (spaceBefore !== -1 && (start - spaceBefore) < (contextChars / 2)) {
                    actualStart = spaceBefore + 1;
                }
            }
            let actualEnd = end;
            if (end < fullText.length) {
                const spaceAfter = fullText.indexOf(' ', end);
                if (spaceAfter !== -1 && (spaceAfter - end) < (contextChars / 2)) {
                    actualEnd = spaceAfter;
                }
            }
            if (actualEnd - actualStart < lowerQuery.length + (contextChars / 2)) {
                actualEnd = Math.min(fullText.length, actualStart + totalSnippetLength);
            }
            let snippet = fullText.substring(actualStart, actualEnd);
            const prefix = actualStart > 0 ? '…' : '';
            const suffix = actualEnd < fullText.length ? '…' : '';
            return prefix + applyHighlighting(snippet, query) + suffix;
        }
    })();
</script>

<style>
    .search-results-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .search-results-list li {
        margin-bottom: 1rem;
        padding: 1rem;
        /* border-radius: 8px; */
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        background-color: transparent;
    }

    .search-results-list li a {
        text-decoration: none;
        color: deepskyblue;
    }

    .search-results-list li a:hover {
        text-decoration: underline;
    }
</style>
