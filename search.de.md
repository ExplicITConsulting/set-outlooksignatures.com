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
<link rel="preload" href="https://cdn.jsdelivr.net/gh/nextapps-de/flexsearch@0.8/dist/flexsearch.bundle.min.js" as="script">
{% if site.languages %}
  {% for lang in site.languages %}
    {% assign lang_clean = lang | strip | downcase %}
<link class="search-preload-pack" rel="preload" href="https://cdn.jsdelivr.net/gh/nextapps-de/flexsearch@0.8/dist/lang/{{ lang_clean }}.min.js" as="script">
    {% if lang_clean == 'en' %}
<link rel="preload" href="/search.json" as="fetch" crossorigin>
    {% else %}
<link rel="preload" href="/{{ lang_clean }}/search.json" as="fetch" crossorigin>
    {% endif %}
  {% endfor %}
{% endif %}

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

        let isSearchReady = false;
        const indexes = {};
        const searchData = {};

        const languages = {
        {% if site.languages %}
          {% for lang in site.languages %}
            {% assign lang_clean = lang | strip | downcase %}
            "{{ lang_clean }}": "{% if lang_clean == 'en' %}/search.json{% else %}/{{ lang_clean }}/search.json{% endif %}"{% unless forloop.last %},{% endunless %}
          {% endfor %}
        {% else %}
          "en": "/search.json"
        {% endif %}
        };

        const currentLang = document.documentElement.lang || Object.keys(languages)[0] || 'en';

        function createIndex(lang, languagePack) {
            return new FlexSearch.Document({
                document: {
                    id: "url",
                    index: [
                        { field: "document", weight: 10 },
                        { field: "section", weight: 5 },
                        { field: "content", weight: 1 },
                        { field: "url", weight: 1 },
                        { field: "date", weight: 1 },
                        { field: "category", weight: 1 },
                        { field: "tags", weight: 1 }
                    ],
                    store: allSearchFields
                },
                tokenize: "full",
                encoder: languagePack || FlexSearch.Charset.LatinSoundex,
                cache: true,
                context: true,
                lang: lang
            });
        }

        function debounce(func, delay) {
            let timeoutId;
            return function(...args) {
                clearTimeout(timeoutId);
                timeoutId = setTimeout(() => func.apply(this, args), delay);
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

        async function loadLanguageAssets(lang) {
            try {
                const [_, response] = await Promise.all([
                    loadScript(`${languagePackBaseUrl}${lang}.min.js`),
                    fetch(languages[lang])
                ]);

                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

                const data = await response.json();
                searchData[lang] = data;

                const languagePack = FlexSearch.Language[lang] || FlexSearch.Charset.LatinSoundex;
                const index = createIndex(lang, languagePack);

                data.forEach(item => {
                    if (item.url) index.add(item);
                });
                indexes[lang] = index;
            } catch (error) {
                console.error(`Error loading data for language "${lang}":`, error);
                delete languages[lang];
            }
        }

        async function initializeSearch() {
            try {
                await loadScript(flexsearchBaseUrl);

                const langsToLoad = Object.keys(languages);
                await Promise.all(langsToLoad.map(lang => loadLanguageAssets(lang)));

                if (Object.keys(indexes).length > 0) {
                    isSearchReady = true;
                    searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_ready }}";

                    const urlParams = new URLSearchParams(window.location.search);
                    const urlQuery = urlParams.get('search');

                    if (urlQuery) {
                        searchInput.value = urlQuery;
                        performSearch();
                    }
                } else {
                    handleInitializationFailure();
                }
            } catch (error) {
                console.error('Initialization failed:', error);
                handleInitializationFailure();
            }
        }

        function handleInitializationFailure() {
            searchInput.placeholder = "{{ site.data[site.active_lang].strings.search_search-input_placeholder_error }}";
            searchInput.disabled = true;
            searchResultsContainer.innerHTML = '<p>{{ site.data[site.active_lang].strings.search_search-input_placeholder_error }}</p>';
        }

        const debouncedSearch = debounce(() => { performSearch(); }, 150);

        searchInput.addEventListener('input', () => {
            const query = searchInput.value.trim();
            const newUrl = new URL(window.location);

            if (query.length > 0) {
                newUrl.searchParams.set('search', query);
                debouncedSearch();
            } else {
                newUrl.searchParams.delete('search');
                searchResultsContainer.innerHTML = '';
            }
            window.history.replaceState({ path: newUrl.href }, '', newUrl.href);
        });

        initializeSearch();

        function performExactMatchSearch(query, langs) {
            const allExactMatches = [];
            const normalizedQuery = query.toLowerCase()
                .replace(/\W/g, '.?')
                .replace(/(\w)/g, '$1.?')
                .replace(/\.\?\.\?/g, '.?')
                .replace(/(^\.\?|\.\?$)/g, '');

            const searchPattern = new RegExp(normalizedQuery, 'i');
            const exactMatchScore = -2000;

            if (normalizedQuery.length === 0) return allExactMatches;

            const searchSingleLanguage = (langCode) => {
                const rawData = searchData[langCode] || [];
                const langMatches = [];

                rawData.forEach(item => {
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

                    if (searchPattern.test(matchedText)) {
                        const matchResults = matchedText.match(searchPattern);
                        if (!matchResults) return;

                        const queryIndex = matchResults.index;
                        const matchedSubstring = matchResults[0];
                        const matchLength = matchedSubstring.length;
                        const isContentMatch = (matchField === 'content');

                        const contextPadding = 50;
                        const maxSnippetLength = 500;

                        let snippetStart = Math.max(0, queryIndex - contextPadding);
                        let snippetEnd = queryIndex + matchLength + contextPadding;

                        if (isContentMatch) snippetEnd = snippetStart + maxSnippetLength;

                        snippetEnd = Math.min(matchedText.length, snippetEnd);
                        let highlightSnippet = matchedText.substring(snippetStart, snippetEnd);

                        if (snippetStart > 0) highlightSnippet = "..." + highlightSnippet;
                        if (snippetEnd < matchedText.length) highlightSnippet = highlightSnippet + "...";

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

            if (!isSearchReady) {
                setTimeout(performSearch, 100);
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
                    boundary: { before: 50, after: 50, total: 500 },
                    merge: true,
                }
            };

            const availableLangs = Object.keys(indexes);
            const otherLangs = availableLangs.filter(lang => lang !== currentLang);
            const langsToSearch = [currentLang, ...otherLangs];

            allResults.push(...performExactMatchSearch(query, langsToSearch));

            const currentLangIndex = indexes[currentLang];
            if (currentLangIndex) {
                const rawResults = currentLangIndex.search(query, searchOptions);
                rawResults.forEach(fieldResult => {
                    if (fieldResult?.result) {
                        fieldResult.result.forEach(r => {
                            const originalDoc = currentLangIndex.get(r.id);
                            if (originalDoc) {
                                allResults.push({
                                    id: r.id,
                                    doc: { ...originalDoc, highlight: r.highlight, field: fieldResult.field },
                                    score: r.score - 1000,
                                    lang: currentLang
                                });
                            }
                        });
                    }
                });
            }

            otherLangs.forEach(lang => {
                const otherLangIndex = indexes[lang];
                const rawResults = otherLangIndex.search(query, searchOptions);

                rawResults.forEach(fieldResult => {
                    if (fieldResult?.result) {
                        fieldResult.result.forEach(r => {
                            const originalDoc = otherLangIndex.get(r.id);
                            if (originalDoc) {
                                allResults.push({
                                    id: r.id,
                                    doc: { ...originalDoc, highlight: r.highlight, field: fieldResult.field },
                                    score: r.score,
                                    lang: lang
                                });
                            }
                        });
                    }
                });
            });

            allResults.sort((a, b) => {
                const queryLower = query.toLowerCase();

                const getMatchStrictness = (resultObj) => {
                    if (!resultObj.doc) return 0;

                    const inTitle = (resultObj.doc.document || '').toLowerCase().includes(queryLower);
                    const inSection = (resultObj.doc.section || '').toLowerCase().includes(queryLower);
                    const inContent = (resultObj.doc.content || '').toLowerCase().includes(queryLower);
                    const inUrl = (resultObj.doc.url || '').toLowerCase().includes(queryLower);
                    const inDate = (resultObj.doc.date || '').toLowerCase().includes(queryLower);
                    const inCategory = (resultObj.doc.category || '').toLowerCase().includes(queryLower);

                    // Safe execution checking for both mixed array lists and string tags
                    const rawTags = resultObj.doc.tags;
                    const inTags = Array.isArray(rawTags)
                        ? rawTags.some(t => String(t).toLowerCase().includes(queryLower))
                        : String(rawTags || '').toLowerCase().includes(queryLower);

                    if (inTitle || inSection || inContent || inUrl || inDate || inCategory || inTags) {
                        return 2;
                    }
                    if (resultObj.doc.isExactMatch) {
                        return 1;
                    }
                    return 0;
                };

                const aStrictness = getMatchStrictness(a);
                const bStrictness = getMatchStrictness(b);
                if (aStrictness !== bStrictness) {
                    return bStrictness - aStrictness;
                }

                const aLangPriority = (a.lang === currentLang) ? 1 : 0;
                const bLangPriority = (b.lang === currentLang) ? 1 : 0;
                if (aLangPriority !== bLangPriority) {
                    return bLangPriority - aLangPriority;
                }

                return a.score - b.score;
            });
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
                if (!item) return;

                let title = item.document || 'No Title';
                const url = item.url || '#';
                let sectionContent = item.section || '';
                let mainContent = item.highlight || '';

                if (item.isExactMatch) {
                    const queryToHighlight = item.exactQuery || mainContent;
                    const safeQuery = queryToHighlight.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
                    const regex = new RegExp('(' + safeQuery + ')', 'gi');

                    title = title.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
                    sectionContent = sectionContent.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
                    mainContent = mainContent.replace(regex, '<mark style="background-color: yellow;">$1</mark>');
                }

                html += `
                    <li class="box mb-4">
                        <p>
                            <a href="${url}"><strong>${title}</strong></a>
                            ${sectionContent ? ` | <a href="${url}"><strong>${sectionContent}</strong></a>` : ''}
                        </p>
                        <p>${mainContent}</p>
                    </li>
                `;
            });

            html += '</ul>';
            searchResultsContainer.innerHTML = html;

            clearTimeout(window.searchTrackingTimer);
            window.searchTrackingTimer = setTimeout(() => {
                if (typeof _paq !== 'undefined') {
                    const query = searchInput.value.trim();
                    if (query.length > 0) {
                        _paq.push(['trackSiteSearch', query, false, uniqueResults.length]);
                    }
                }
            }, 1000);
        }
    })();
</script>