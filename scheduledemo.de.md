---
layout: "page"
lang: "de"
locale: "de"
title: "Schedule Interactive Demo"
subtitle: "Ideal for Security, IT, and Marketing leadership"
description: "Guided Walkthrough. Schedule a session with our team to see how the solution adapts to your specific organizational structure, technical setup, and compliance requirements."
permalink: "/scheduledemo"
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
  <p class="has-text-centered is-size-7 mb-2 has-text-grey">
    Trouble viewing the calendar? <a href="https://outlook.office.com/book/demo.set-outlooksignatures@explicitconsulting.at" target="_blank">Open in a new window.</a>
  </p>

  <div id="booking-container">
    <iframe 
      id="booking-iframe"
      src="https://outlook.office.com/book/demo.set-outlooksignatures@explicitconsulting.at"
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

<noscript>
  <a href="https://outlook.office.com/book/demo.set-outlooksignatures@explicitconsulting.at" 
      class="button is-info is-normal is-hovered has-text-black has-text-weight-bold is-flex-direction-column" 
      style="height: 4.5rem; width: 100%; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod); border: none; display: flex; align-items: center; justify-content: center;" 
      target="_blank">
    <span>Schedule Interactive Demo</span>
    <span><small>Ideal for Security, IT, and Marketing leadership</small></span>
  </a>
</noscript>