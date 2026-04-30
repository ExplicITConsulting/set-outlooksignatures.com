---
layout: "page"
lang: "en"
locale: "en"
title: "Order professional support"
subtitle: "First-class help from ExplicIT Consulting"
description: "Order professional support. First-class help from ExplicIT Consulting."
hero_link: "https://forms.cloud.microsoft/r/CnwjH98vSs?lang=en"
hero_link_text: "<span><b>Open form in new tab</b></span>"
hero_link_style: |
   style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
permalink: "/ordersupport"
redirect_from:
  - "/ordersupport/"
  - "/order-support"
  - "/order-support/"
---
<style>
  html, body {
    overflow-y: auto !important;
    height: auto !important;
    margin: 0;
  }

  #form-section {
    position: relative;
    width: 100%;
    min-height: 100vh;
    background-color: #ffffff;
  }

  #form-iframe {
    width: 100%;
    height: 500vh; /* 5 screen lengths */
    border: none;
    display: block;
    overflow: hidden;
    opacity: 0; /* Hidden until loaded */
    transition: opacity 0.5s ease;
  }

  #loading-overlay {
    position: absolute;
    top: 100px; /* Position it where the form usually starts */
    left: 50%;
    transform: translateX(-50%);
    text-align: center;
    font-family: sans-serif;
    color: #555;
    z-index: 10;
  }

  .spinner {
    border: 4px solid #f3f3f3;
    border-top: 4px solid #0078d4;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
    margin: 0 auto 10px;
  }

  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  /* Mobile Adjustment */
  @media (max-width: 768px) {
    #form-iframe { height: 600vh; }
  }
</style>

<section id="form-section">
  <div id="loading-overlay">
    <div class="spinner"></div>
    <p>Loading form…</p>
    <p>Lade Formular…</p>
  </div>

  <iframe 
    id="form-iframe"
    src="https://forms.cloud.microsoft/r/CnwjH98vSs?lang=en&embed=true" 
    scrolling="no"
    onload="hideLoader()">
  </iframe>
</section>

<script>
  function hideLoader() {
    // 1. Hide the spinner
    document.getElementById('loading-overlay').style.display = 'none';
    // 2. Fade in the iframe
    document.getElementById('form-iframe').style.opacity = '1';
    // 3. Ensure user starts at the top of the form
    window.scrollTo(0, document.getElementById('form-section').offsetTop);
  }
</script>