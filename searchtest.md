---
layout: page
title: Search and find
subtitle: What are you looking for?
description: Search and find. What are you looking for?
---

<input type="search" id="search-input" placeholder="Start typing to search..." class="input is-large mb-4">

<div id="search-results" class="content">
    <p>Results will appear here.</p>
</div>

<script src="https://cdn.jsdelivr.net/npm/flexsearch@0.8.205/dist/flexsearch.bundle.min.js"></script>

<script>
    (function() {
        // Define all possible fields from your search.json for indexing and storing.
        // This list should be exhaustive based on your JSON structure.
        const allSearchFields = ["document", "section", "content", "url", "date", "category", "tags"];

        // Initialize FlexSearch index
        const index = new FlexSearch.Document({
            // Define the document fields to be indexed
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
            // Note: 'suggest: true' here primarily influences internal indexing for suggestions.
            // The actual suggestion retrieval is done via the search method's options.
            suggest: true,
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
                    // Ensure 'url' is present and unique for each item.
                    // If 'url' is not always present, you might need a fallback ID.
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
                document.getElementById('search-results').innerHTML = '<p class="has-text-primary">Error loading search data. Please try again later.</p>';
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

            // --- START ADDITION FOR OPTION 2 ---
            // Explicitly check if the query is a non-empty string.
            // This defends against potential edge cases where 'query' might not be a string
            // or an empty string might somehow slip through due to timing/debounce.
            if (typeof query !== 'string' || query.length === 0) {
                console.warn("Invalid search query received (not a non-empty string):", query);
                searchResultsContainer.innerHTML = '<p>Please enter a valid search term.</p>';
                return;
            }
            // --- END ADDITION FOR OPTION 2 ---

            // Perform the search with advanced options
            const rawResults = index.search(query, {
                limit: 99, // Limit the number of results
                enrich: true, // Return the full document (stored fields)
                // highlight: true, // Enable highlighting!
                // suggest: true // Request suggestions with the search results
            });

            // FlexSearch can return results grouped by field if searching across multiple fields.
            // This flattens the results to a single array of enriched documents.
            let flatResults = [];
            let suggestions = []; // Array to hold extracted suggestions

            rawResults.forEach(fieldResult => {
                // Check if it's a field-grouped result (e.g., {field: "title", result: [...]})
                if (fieldResult && fieldResult.field && Array.isArray(fieldResult.result)) {
                    flatResults = flatResults.concat(fieldResult.result);
                    // Extract suggestions if available at the field level
                    if (fieldResult.suggestion) {
                        suggestions.push(fieldResult.suggestion);
                    }
                } else if (fieldResult && fieldResult.doc) {
                    // It's already an enriched document directly
                    flatResults.push(fieldResult);
                    // Extract suggestions if available at the document level
                    if (fieldResult.suggestion) {
                        suggestions.push(fieldResult.suggestion);
                    }
                } else if (typeof fieldResult === 'string') {
                    // Sometimes 'suggest: true' can return raw suggestion strings directly in the top-level array
                    suggestions.push(fieldResult);
                }
            });

            displayResults(flatResults, query);
            displaySuggestions(suggestions); // Pass the extracted suggestions
        }

        // Function to display search results
        function displayResults(results, query) {
            if (results.length === 0) {
                searchResultsContainer.innerHTML = '<p>No results found.</p>';
                return;
            }

            let html = '<ul class="search-results-list">';
            results.forEach(result => {
                // IMPORTANT: Ensure result.doc is not undefined before proceeding
                const item = result.doc;
                if (!item) {
                    console.warn('Skipping search result with undefined document:', result);
                    return; // Skip this iteration if item (result.doc) is undefined
                }

                // Dynamically get content from all indexed fields for display
                let displayContent = '';
                allSearchFields.forEach(field => {
                    if (item[field] && typeof item[field] === 'string' && item[field].length > 0) {
                        let fieldContent = item[field];
                        // Highlight matches in the current field
if (
    result.highlight &&
    Array.isArray(result.highlight[field]) &&
    result.highlight[field].every(r => Array.isArray(r) && r.length === 2)
) {
    fieldContent = highlightText(fieldContent, result.highlight[field]);
}

                        // Truncate content for display, add ellipsis if truncated
                        const truncatedContent = fieldContent.length > 150 ? fieldContent.substring(0, 150) + '...' : fieldContent;
                        displayContent += `<p class="is-size-7 mt-1"><strong>${field.charAt(0).toUpperCase() + field.slice(1)}:</strong> ${truncatedContent}</p>`;
                    }
                });


                let title = item.document || 'No Title';
                const url = item.url || '#';

                // Highlight matches in title (which is 'document' in your index)
                if (result.highlight && result.highlight.document) {
                    title = highlightText(title, result.highlight.document);
                }


                html += `
                    <li class="box mb-4">
                        <a href="${url}" class="is-size-5 has-text-weight-bold">${title}</a>
                        <p class="is-size-7">${url}</p>
                        ${displayContent}
                    </li>
                `;
            });
            html += '</ul>';
            searchResultsContainer.innerHTML = html;
        }

        // Helper function to highlight text
function highlightText(text, highlightRanges) {
    if (!Array.isArray(highlightRanges)) return text;

    highlightRanges.sort((a, b) => a[0] - b[0]);
    let highlightedText = '';
    let lastIndex = 0;

    highlightRanges.forEach(range => {
        if (!Array.isArray(range) || range.length !== 2) return;
        const [start, end] = range;
        highlightedText += text.substring(lastIndex, start);
        highlightedText += `<mark>${text.substring(start, end)}</mark>`;
        lastIndex = end;
    });

    highlightedText += text.substring(lastIndex);
    return highlightedText;
}


        // Function to display suggestions (for autocomplete)
        // Now accepts an array of suggestions directly
        function displaySuggestions(suggestions) {
            // Remove duplicates from suggestions, as they might appear multiple times
            const uniqueSuggestions = [...new Set(suggestions)];

            // For simplicity, we'll just log unique suggestions to the console.
            // In a real UI, you might display these in a dropdown below the search input.
            if (uniqueSuggestions.length > 0) {
                console.log('Suggestions:', uniqueSuggestions);
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

    mark {
        background-color: limegreen;
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