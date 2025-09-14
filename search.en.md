<script>
    (function() {
        const allSearchFields = ["document", "section", "content", "url", "date", "category", "tags"];

        const searchInput = document.getElementById('search-input');
        const searchResultsContainer = document.getElementById('search-results');
        
        // Set initial placeholder and disable the input
        searchInput.placeholder = "Loading search data…";
        searchInput.disabled = true;

        // Initialize a container for multiple FlexSearch indexes
        const indexes = {};
        const languages = {
            'en': '/search.json',
            'de': '/de/search.json'
        };

        // Determine the current page language
        const currentLang = document.documentElement.lang || 'en';

        // Function to create a new FlexSearch index for a given language
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

        // Function to check if all files are loaded
        function checkIfReady() {
            filesLoaded++;
            if (filesLoaded === filesToLoad.length) {
                searchInput.placeholder = "What are you looking for?";
                searchInput.disabled = false;
                
                // Add event listeners AFTER the indexes are ready
                document.getElementById('search-button').addEventListener('click', performSearch);
                
                searchInput.addEventListener('keydown', (event) => {
                    if (event.key === 'Enter') {
                        event.preventDefault();
                        performSearch();
                    }
                });

                // This event listener will clear the results when the input changes.
                searchInput.addEventListener('input', () => {
                    searchResultsContainer.innerHTML = '';
                });
            }
        }

        // Fetch the search.json files and populate the correct index
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

        // Function to perform search across all indexes
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
            
            // Search the current language index first.
            const currentLangIndex = indexes[currentLang];
            if (currentLangIndex) {
                const rawResults = currentLangIndex.search(query, {
                    limit: 99,
                    enrich: true
                });
                
                rawResults.forEach(fieldResult => {
                    if (fieldResult && fieldResult.result) {
                        fieldResult.result.forEach(r => {
                            const doc = currentLangIndex.get(r.id);
                            if (doc) {
                                // Add a higher score for results from the current language
                                allResults.push({ id: r.id, doc: doc, score: r.score - 1000, lang: currentLang });
                            }
                        });
                    }
                });
            }

            // Search other language indexes.
            Object.keys(indexes).forEach(lang => {
                if (lang !== currentLang) {
                    const otherLangIndex = indexes[lang];
                    const rawResults = otherLangIndex.search(query, {
                        limit: 99,
                        enrich: true
                    });
                    
                    rawResults.forEach(fieldResult => {
                        if (fieldResult && fieldResult.result) {
                            fieldResult.result.forEach(r => {
                                const doc = otherLangIndex.get(r.id);
                                if (doc) {
                                    allResults.push({ id: r.id, doc: doc, score: r.score, lang: lang });
                                }
                            });
                        }
                    });
                }
            });

            // Sort the combined results by their relevance score.
            allResults.sort((a, b) => a.score - b.score);

            displayResults(allResults, query);
        }

        function displayResults(results, query) {
            if (typeof _paq !== 'undefined') {
                _paq.push(['trackSiteSearch', query, false, results.length]);
            }
            // Deduplicate results, as a single document may appear in multiple indexes
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
                
                try {
                    let displayContentDictionary = {};
                    allSearchFields.forEach(field => {
                        const content = item[field];
                        if (content && typeof content === 'string' && content.length > 0) {
                            let displayedFieldContent;
                            if (field === 'content' || field === 'section') {
                                displayedFieldContent = generateContextualSnippet(content, query, 500, 80);
                            } else {
                                displayedFieldContent = applyHighlighting(content, query);
                                if (field !== 'url' && displayedFieldContent.length > 500) {
                                    displayedFieldContent = displayedFieldContent.substring(0, 500) + '…';
                                }
                            }
                            displayContentDictionary[field] = {
                                rawContent: displayedFieldContent
                            };
                        }
                    });

                    const title = displayContentDictionary.document?.rawContent || item.document || 'No Title';
                    const url = item.url || '#';
                    const sectionContent = displayContentDictionary.section?.rawContent || item.section || '';
                    const mainContent = displayContentDictionary.content?.rawContent || item.content || '';

                    html += `
                        <li class="box mb-4">
                            <p><a href="${url}"><strong>${title}</strong></a><br>${sectionContent}</p>
                            <p>${mainContent}</p>
                        </li>
                    `;
                } catch (error) {
                    console.error(`Error processing search result for URL: ${item.url || 'N/A'}. Displaying unformatted content.`, error);
                    html += `
                        <li class="box mb-4">
                            <p><a href="${item.url || '#'}"><strong>${item.document || 'No Title'}</strong></a><br>${item.section || ''}</p>
                            <p>${item.content || ''}</p>
                        </li>
                    `;
                }
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
                return fullText.substring(0, totalSnippetLength) + (fullText.length > totalSnippetLength ? '…' : '');
            }
            const lowerText = fullText.toLowerCase();
            const lowerQuery = query.toLowerCase();
            const matchIndexes = [];
            const regex = new RegExp(`\\b${lowerQuery}\\b|${lowerQuery}`, 'g');
            let match;
            while ((match = regex.exec(lowerText)) !== null) {
                matchIndexes.push(match.index);
            }
            if (matchIndexes.length === 0) {
                return fullText.substring(0, totalSnippetLength) + (fullText.length > totalSnippetLength ? '…' : '');
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
            let actualStart = start;
            let actualEnd = end;
            if (start > 0) {
                const spaceBefore = fullText.lastIndexOf(' ', start);
                if (spaceBefore !== -1) {
                    actualStart = spaceBefore + 1;
                }
            }
            if (end < fullText.length) {
                const spaceAfter = fullText.indexOf(' ', end);
                if (spaceAfter !== -1) {
                    actualEnd = spaceAfter;
                }
            }
            if (actualStart > actualEnd) { 
                actualStart = start; 
                actualEnd = end; 
            }
            let snippet = fullText.substring(actualStart, actualEnd);
            const prefix = actualStart > 0 ? '…' : '';
            const suffix = actualEnd < fullText.length ? '…' : '';
            return prefix + applyHighlighting(snippet, query) + suffix;
        }
    })();
</script>