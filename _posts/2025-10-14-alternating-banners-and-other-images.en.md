---
layout: "post"
lang: "en"
locale: "en"
title: "Randomly alternate banners and other images"
description:
published: true
author: Markus Gruber
tags: 
slug: "alternating-banners-and-other-images"
permalink: "/blog/:year/:month/:day/:slug/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
## Running a marketing campaign with multiple banners?
Rotating them manually across your team's signatures is nearly impossible and definitely not scalable.

With Set-OutlookSignatures, you can automate banner rotation effortlessly, using flexible conditions tailored to your needs.

Whether you want to:
- Randomly rotate banners to avoid viewer fatigue
- Show specific banners to certain departments or locations
- Adjust banners based on season, date, or even external data like weather or stock prices

It's all possible and easy to implement.

1. Add all banners to your template and define an alternate text
   - Use '`$CurrentMailbox_Banner1DELETEEMPTY$`' for banner 1, '`$CurrentMailbox_Banner2DELETEEMPTY$`' for banner 2, and so on.  
   - The 'DELETEEMPTY' part deletes an image when the corresponding replacement variable does not contain a value.
2. Create a custom replacement variable for each banner in your replacement variable config file, and randomly only assign one of these variables a value:
    ```powershell
    $tempBannerIdentifiers = @(1, 2, 3)

    $tempBannerIdentifiers | Foreach-Object {
        $ReplaceHash["CurrentMailbox_Banner$($_)"] = $null
    }

    $ReplaceHash["CurrentMailbox_Banner$($tempBannerIdentifiers | Get-Random)"] = $true

    Remove-Variable -Name 'tempBannerIdentifiers'
    ```
Now, with every run of Set-OutlookSignatures, a different random banner from the template is chosen and the other banners are deleted.
 
You can enhance this even further:  
- Use banner 1 twice as often as the others. Just add it to the code multiple times: '`$tempBannerIdentifiers = @(1, 1, 2, 3)`'  
- Assign banners to specific users, departments, locations or any other attribute  
- Restrict banner usage by date or season  
- You could assign banners based on your share price or expected weather queried from a web service  
- And much more, including any combination of the above

## Interested in learning more or seeing our solution in action?
[Contact us](/contact/) or explore further on our [website](/). We look forward to connecting with you!