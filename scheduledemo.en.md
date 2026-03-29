---
layout: "page"
lang: "en"
locale: "en"
title: "Schedule Interactive Demo"
subtitle: "Ideal for Security, IT, and Marketing leadership"
description: "Guided Walkthrough. Schedule a session with our team to see how the solution adapts to your specific organizational structure, technical setup, and compliance requirements."
hero_link: "https://outlook.office.com/book/demo.set-outlooksignatures@explicitconsulting.at"
hero_link_text: "<span><b>Open form in new tab</b></span>"
hero_link_style: |
   style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
permalink: "/scheduledemo"
redirect-from:
  - "/scheduledemo/"
  - "/schedule-demo"
  - "/schedule-demo/"
---
<style>
  /* 1. Page & Section Setup */
  html, body {
    overflow-y: auto !important;
    height: auto !important;
    margin: 0;
  }

  #booking-section {
    position: relative;
    width: 100%;
    min-height: 100vh; /* Keeps the footer from jumping up immediately */
    background-color: #ffffff;
  }

  /* 2. The Oversized Iframe */
  #booking-iframe {
    width: 100%;
    height: 400vh; /* 4 screen lengths */
    border: none;
    display: block;
    overflow: hidden;
    opacity: 0; /* Hidden until loaded */
    transition: opacity 0.5s ease;
  }

  /* 3. The Loading Spinner */
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
    border-top: 4px solid #0078d4; /* Outlook Blue */
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
    #booking-iframe { height: 600vh; }
  }
</style>

<section id="booking-section">
  <div id="loading-overlay">
    <div class="spinner"></div>
    <p>Loading booking calendar...</p>
  </div>

  <iframe 
    id="booking-iframe"
    src="https://outlook.office.com/book/demo.set-outlooksignatures@explicitconsulting.at/" 
    scrolling="no"
    onload="hideLoader()">
  </iframe>
</section>

<script>
  function hideLoader() {
    // 1. Hide the spinner
    document.getElementById('loading-overlay').style.display = 'none';
    // 2. Fade in the iframe
    document.getElementById('booking-iframe').style.opacity = '1';
    // 3. Ensure user starts at the top of the form
    window.scrollTo(0, document.getElementById('booking-section').offsetTop);
  }
</script>