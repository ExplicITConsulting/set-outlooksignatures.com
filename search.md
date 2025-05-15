---
layout: page
title: |
  <p class="has-text-white">
    Search and find
  </p>
subtitle: |
  <p class="subtitle is-3 has-text-white">
    What are you looking for?
  </p>
description: Search and find. What are you looking for?
---
## What are you looking for?
<div id="search-demo-container">
  <input type="search" id="search-input" placeholder="Search this site" style='font-size: 1em; padding: 0.25em; font-weight: 700;' size="25" autofocus>
  <ul id="results-container"></ul>
</div>

<script src="https://unpkg.com/simple-jekyll-search@latest/dest/simple-jekyll-search.min.js" type="text/javascript"></script>

<script type="text/javascript">
  SimpleJekyllSearch({
    searchInput: document.getElementById('search-input'),
    resultsContainer: document.getElementById('results-container'),
    json: '/search.json',
    searchResultTemplate: '<li style="margin-bottom: 1.25em;"><a href="{url}"><span style="font-weight: normal; font-style: italic;">{url}</span><br /><span style="font-weight: bold; font-style: normal; font-size: 125%">{title}</span><br /><span style="font-weight: normal; font-style normal;">{subtitle}</span></a></li>',
    noResultsText: 'No results found',
    fuzzy: false
  })
</script>

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
