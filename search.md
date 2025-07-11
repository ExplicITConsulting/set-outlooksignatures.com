---
layout: page
title: Search and find
subtitle: What are you looking for?
description: Search and find. What are you looking for?
---

<input type="search" id="search-input" placeholder="Start typing to search…" class="input is-large mb-4">

<div id="search-results" class="content">
</div>

<script src="https://cdn.jsdelivr.net/npm/flexsearch@0.8.205/dist/flexsearch.bundle.min.js"></script>

<script>
    (function() {
        const allSearchFields = ["document", "section", "content", "url", "date", "category", "tags"];

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
            // 'suggest' option removed
        });

        // Fetch the search.json data and populate the index
        fetch('/search.json')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                data.forEach((item, i) => {
                    if (item.url) {
                        index.add(item);
                    } else {
                        console.warn('Item missing URL, skipping for FlexSearch index:', item);
                    }
                });
                console.log('FlexSearch index populated successfully.');
            })
            .catch(error => {
                console.error('Error fetching or parsing search.json:', error);
                document.getElementById('search-results').innerHTML = '<p>Error loading search data. Please try again later.</p>';
            });

        const searchInput = document.getElementById('search-input');
        const searchResultsContainer = document.getElementById('search-results');
        let searchTimeout;

        // Function to perform search and display results
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

            // Perform the search with advanced options
            const rawResults = index.search(query, {
                limit: 99, // Limit the number of results
                enrich: true, // Return the full document (stored fields)
                // 'highlight' and 'suggest' options removed here to use custom logic
            });

            let flatResults = [];
            
            rawResults.forEach(fieldResult => {
                if (fieldResult && fieldResult.field && Array.isArray(fieldResult.result)) {
                    // Flatten results and add 'doc' property for consistency
                    fieldResult.result.forEach(r => flatResults.push({ id: r.id, doc: index.get(r.id) }));
                } else if (fieldResult && fieldResult.doc) {
                    flatResults.push(fieldResult);
                }
            });

            displayResults(flatResults, query);
        }

        // Function to display search results
        function displayResults(results, query) {
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
                            // For 'content' or 'section', generate a contextual snippet
                            // Default: ~250 chars total, trying to show ~80 chars context around match
                            displayedFieldContent = generateContextualSnippet(item[field], query, 500, 80);
                        } else {
                            // For other fields, just apply highlighting to the whole field
                            displayedFieldContent = applyHighlighting(item[field], query);
                            // Add simple truncation for non-content fields if they can be long, but not for URLs
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
                title = applyHighlighting(title, query); // Apply highlighting to the title

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

        // Helper function to apply <mark> highlighting tags
        function applyHighlighting(text, query) {
            if (!text || typeof text !== 'string' || !query || typeof query !== 'string' || query.trim().length === 0) {
                return text;
            }
            // Escape special characters in the query for regex
            const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            // Create a regex for case-insensitive global matching
            const regex = new RegExp(`(${escapedQuery})`, 'gi');
            // Replace matched terms with highlighted versions
            return text.replace(regex, '<mark>$1</mark>');
        }

        // New helper function to generate a contextual snippet around highlighted terms
        function generateContextualSnippet(fullText, query, totalSnippetLength = 250, contextChars = 80) {
            if (!fullText || typeof fullText !== 'string' || !query || typeof query !== 'string' || query.trim().length === 0) {
                // If no valid text or query, apply highlighting to a truncated version (if query is valid)
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
                // If query not found in text, return a simple truncated snippet with highlight applied
                return applyHighlighting(fullText.substring(0, totalSnippetLength), query) + (fullText.length > totalSnippetLength ? '…' : '');
            }

            // Use the first match to center the snippet
            const firstMatchIndex = matchIndexes[0];

            // Calculate the ideal start and end of the snippet
            let start = Math.max(0, firstMatchIndex - contextChars);
            let end = Math.min(fullText.length, firstMatchIndex + lowerQuery.length + contextChars);

            // If the calculated snippet is too short, extend it up to totalSnippetLength
            if (end - start < totalSnippetLength) {
                end = Math.min(fullText.length, start + totalSnippetLength);
            }
            if (end - start < totalSnippetLength) { // If still too short after extending end, expand from start
                start = Math.max(0, end - totalSnippetLength);
            }
            // Ensure start isn't past end (can happen with very short texts/long queries)
            if (start > end) { start = Math.max(0, end - totalSnippetLength); }


            // Try to adjust to word boundaries for readability
            let actualStart = start;
            if (start > 0) {
                const spaceBefore = fullText.lastIndexOf(' ', start);
                if (spaceBefore !== -1 && (start - spaceBefore) < (contextChars / 2)) { // Only adjust if space is somewhat close
                    actualStart = spaceBefore + 1;
                }
            }

            let actualEnd = end;
            if (end < fullText.length) {
                const spaceAfter = fullText.indexOf(' ', end);
                if (spaceAfter !== -1 && (spaceAfter - end) < (contextChars / 2)) { // Only adjust if space is somewhat close
                    actualEnd = spaceAfter;
                }
            }
            
            // Re-adjust actualEnd if actualStart pushes it too far left, ensuring minimum length around highlight
            if (actualEnd - actualStart < lowerQuery.length + (contextChars / 2)) {
                actualEnd = Math.min(fullText.length, actualStart + totalSnippetLength);
            }


            let snippet = fullText.substring(actualStart, actualEnd);

            // Add ellipses based on whether the snippet is a partial slice of the original text
            const prefix = actualStart > 0 ? '…' : '';
            const suffix = actualEnd < fullText.length ? '…' : '';

            return prefix + applyHighlighting(snippet, query) + suffix;
        }

        searchInput.addEventListener('input', () => {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(performSearch, 300);
        });
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
