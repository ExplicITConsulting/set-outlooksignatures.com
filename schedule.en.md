---
layout: "page"
lang: "en"
locale: "en"
title: "Schedule Interactive Demo"
subtitle: "Ideal for Security, IT, and Marketing leadership"
description: "Guided Walkthrough. Schedule a session with our team to see how the solution adapts to your specific organizational structure, technical setup, and compliance requirements."
permalink: "/schedule"
sitemap: false
---

<style>
  /* Force the main html/body not to scroll so only the iframe scrolls */
  html, body { 
    overflow: hidden; 
    height: 100%; 
  }
  /* Ensure the Bulma section/container doesn't add extra height */
  .section, .container { 
    padding: 0 !important; 
    max-width: 100% !important; 
  }
</style>

<div id="booking-container" style="width: 100%; visibility: hidden;">
  <iframe 
    id="booking-iframe"
    src="{{ site.data[site.active_lang].strings.microsoft_bookings_link }}"
    width="100%" 
    height="100%" 
    style="border:0; display: block;"
    allowfullscreen>
  </iframe>
</div>

<script>
  function scaleBooking() {
    const container = document.getElementById('booking-container');
    const iframe = document.getElementById('booking-iframe');
    
    // Calculate distance from top of the container to bottom of viewport
    const rect = container.getBoundingClientRect();
    const availableHeight = window.innerHeight - rect.top;
    
    container.style.height = availableHeight + "px";
    container.style.visibility = "visible";
  }

  // Run on load and whenever window is resized
  window.addEventListener('load', scaleBooking);
  window.addEventListener('resize', scaleBooking);
</script>

<noscript>
  <div class="notification is-warning has-text-centered">
    Please <a href="{{ site.data[site.active_lang].strings.microsoft_bookings_link }}">click here to open the booking calendar</a> directly.
  </div>
</noscript>