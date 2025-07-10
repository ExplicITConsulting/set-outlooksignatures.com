---
layout: page
title: Search Your Site
permalink: /searchtest/
---

<input type="search" id="search-input" placeholder="Start typing to search..." class="input is-large is-rounded mb-4">

<div id="search-results" class="content">
    <p>Results will appear here.</p>
</div>

<!-- Using jsdelivr.net for FlexSearch, which should resolve MIME type issues -->
<script src="https://cdn.jsdelivr.net/npm/flexsearch@0/dist/flexsearch.bundle.min.js"></script>

<script>
    (function() {
        // Initialize FlexSearch index
        const index = new FlexSearch.Document({
            // Define the document fields to be indexed
            document: {
                id: "url", // Unique identifier for each document
                index: ["title", "content", "documenttitle", "url"], // Fields to search within
                store: ["title", "content", "documenttitle", "url"] // Fields to store and return with results
            },
            // Configure search options for better results
            tokenize: "full", // Tokenize by words, allowing partial matches
            resolution: 9, // Higher resolution for better relevance
            depth: 2, // Deeper search for nested objects if any (though our JSON is flat)
            optimize: true, // Optimize index for faster searches
            cache: true, // Cache search results
            suggest: true, // Enable suggestions
            // Advanced options for fuzzy, partial, and highlighting
            // These are enabled by default with the above configurations,
            // but can be explicitly set for clarity or fine-tuning.
            // For example, to control fuzzy search:
            // fuzzy: 0.2, // A value between 0 and 1 (0=no fuzzy, 1=max fuzzy)
            // For partial search, 'tokenize: "full"' already handles it.
            // Highlighting is handled in the search results display.
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
                    // Add each item from the JSON to the FlexSearch index
                    // Assign a unique ID for each item, using its index in the array
                    // if 'url' is not guaranteed to be unique or present for all items.
                    // Assuming 'url' is unique and present based on the user's description.
                    index.add(item);
                });
                console.log('FlexSearch index populated successfully.');
            })
            .catch(error => {
                console.error('Error fetching or parsing search.json:', error);
                document.getElementById('search-results').innerHTML = '<p class="has-text-danger">Error loading search data. Please try again later.</p>';
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

            // Perform the search with advanced options
            // `limit` can be adjusted based on how many results you want to show
            const results = index.search(query, {
                limit: 20, // Limit the number of results
                enrich: true, // Return the full document (stored fields)
                suggest: true, // Get suggestions for autocomplete
                // You can fine-tune fuzzy, partial, and match options here if needed
                // For example, to enable fuzzy search with a specific tolerance:
                // fuzzy: true, // Enables fuzzy matching
                // For partial search, it's covered by `tokenize: "full"`
            });

            displayResults(results, query);
            displaySuggestions(query);
        }

        // Function to display search results
        function displayResults(results, query) {
            if (results.length === 0) {
                searchResultsContainer.innerHTML = '<p>No results found.</p>';
                return;
            }

            let html = '<ul class="search-results-list">';
            results.forEach(result => {
                // Access the original document data from the 'doc' property
                const item = result.doc;
                let title = item.title || item.documenttitle || 'No Title';
                let content = item.content || 'No content snippet available.';
                const url = item.url || '#';

                // Highlight matches in title and content
                // FlexSearch returns `_highlight` property on the enriched results
                if (result.highlight) {
                    if (result.highlight.title) {
                        title = highlightText(title, result.highlight.title);
                    }
                    if (result.highlight.content) {
                        content = highlightText(content, result.highlight.content);
                    }
                }

                html += `
                    <li class="box mb-4">
                        <a href="${url}" class="has-text-info is-size-5 has-text-weight-bold">${title}</a>
                        <p class="is-size-7 has-text-grey-light">${url}</p>
                        <p class="mt-2">${content.substring(0, 200)}...</p>
                    </li>
                `;
            });
            html += '</ul>';
            searchResultsContainer.innerHTML = html;
        }

        // Helper function to highlight text
        function highlightText(text, highlightRanges) {
            // Sort ranges by start position to handle overlaps correctly
            highlightRanges.sort((a, b) => a[0] - b[0]);

            let highlightedText = '';
            let lastIndex = 0;

            highlightRanges.forEach(range => {
                const [start, end] = range;
                highlightedText += text.substring(lastIndex, start);
                highlightedText += `<mark>${text.substring(start, end)}</mark>`;
                lastIndex = end;
            });
            highlightedText += text.substring(lastIndex);
            return highlightedText;
        }

        // Function to display suggestions (for autocomplete)
        function displaySuggestions(query) {
            const suggestions = index.suggest(query, {
                limit: 5, // Limit the number of suggestions
                // You can add `fuzzy: true` here if you want fuzzy suggestions
            });

            // For simplicity, we'll just log suggestions to the console.
            // In a real UI, you might display these in a dropdown below the search input.
            if (suggestions.length > 0) {
                console.log('Suggestions:', suggestions.map(s => s.suggestion));
            } else {
                console.log('No suggestions.');
            }
        }


        // Event listener for input changes with debounce
        searchInput.addEventListener('input', () => {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(performSearch, 300); // Debounce to 300ms
        });

        // Initial search (optional, e.g., if there's a pre-filled query)
        // performSearch();
    })();
</script>

<style>
    /* Basic styling for the search results using Bulma classes */
    .search-results-list {
        list-style: none;
        padding: 0;
    }

    .search-results-list li {
        margin-bottom: 1rem;
        padding: 1rem;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        background-color: #fff;
    }

    .search-results-list li a {
        text-decoration: none;
        color: #3273dc; /* Bulma's info color */
    }

    .search-results-list li a:hover {
        text-decoration: underline;
    }

    mark {
        background-color: #ffe08a; /* A light yellow for highlighting */
        padding: 0 2px;
        border-radius: 3px;
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .input.is-large {
            font-size: 1rem;
        }
    }
</style>