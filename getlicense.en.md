---
layout: "page"
lang: "en"
locale: "en"
title: "Get a trial version or a license quote"
subtitle: "You are ready for the next step"
description: "Get a trial version or a license quote. You are ready for the next step."
hero_link: "https://forms.cloud.microsoft/r/sgKrkkd0Eb?lang=en"
hero_link_text: "<span><b>Open form in new tab</b></span>"
hero_link_style: |
   style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
permalink: "/getlicense"
redirect-from:
  - "/getlicense/"
  - "/get-license"
  - "/get-license/"
  - "/getlicence"
  - "/getlicence/"
  - "/get-licence"
  - "/get-licence/"
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
      src="https://forms.cloud.microsoft/r/sgKrkkd0Eb?embed=true&lang=en"
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
</script>