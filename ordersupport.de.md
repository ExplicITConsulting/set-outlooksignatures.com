---
layout: "page"
lang: "de"
locale: "de"
title: "Professionellen Support bestellen"
subtitle: "Erstklassige Unterstützung von ExplicIT Consulting"
description: "Professionellen Support bestellen. Erstklassige Unterstützung von ExplicIT Consulting."
hero_link: "https://forms.cloud.microsoft/r/CnwjH98vSs?lang=de"
hero_link_text: "<span><b>Fomular in eigenem Tab öffnen</b></span>"
hero_link_style: |
   style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
permalink: "/ordersupport"
redirect-from:
  - "/ordersupport/"
  - "/order-support"
  - "/order-support/"
---
<style>
  /* 1. Prevent global page scrolling */
  html, body { 
    overflow: hidden !important; 
    height: 100% !important; 
  }

  /* 2. Remove ONLY the bottom padding so the iframe hits the bottom of the screen */
  #booking-section {
    padding-bottom: 0 !important;
    margin-bottom: 0 !important;
  }

  /* 3. This ensures the iframe starts with high visibility on the JS calculation */
  #booking-container {
    width: 100%;
    visibility: hidden; 
  }
</style>

<section id="booking-section" class="section">
  <div id="booking-container">
    <iframe 
      id="booking-iframe"
      src="https://forms.cloud.microsoft/r/CnwjH98vSs?embed=true&lang=de"
      width="100%" 
      height="100%" 
      style="border:0; display: block;"
      allowfullscreen>
    </iframe>
  </div>
</section>

<script>
  function fitBookingToWindow() {
    const container = document.getElementById('booking-container');
    
    // Get the distance from the top of the viewport to the start of the container
    // This respects the Hero/Header height automatically.
    const rect = container.getBoundingClientRect();
    const viewportHeight = window.innerHeight;
    
    // Calculate space remaining from the bottom of the Hero to the bottom of the screen
    const remainingHeight = viewportHeight - rect.top;
    
    // Set the height. We subtract a few pixels (4-5) to ensure 
    // no rounding errors trigger a browser scrollbar.
    container.style.height = (remainingHeight - 4) + "px";
    container.style.visibility = "visible";
  }

  // Run on load and resize
  window.addEventListener('load', fitBookingToWindow);
  window.addEventListener('resize', fitBookingToWindow);
</script><style>
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
    src="https://forms.cloud.microsoft/r/CnwjH98vSs?lang=de&embed=true" 
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