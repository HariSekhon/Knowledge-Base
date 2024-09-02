# CDN - Content Delivery Network

Caching of web HTTP(S) static files to speed up websites.

Modern CDNs add security features like DDoS protection and edge-computing capabilities.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Beware Public Shared CDNs](#beware-public-shared-cdns)
- [Best Free CDNs](#best-free-cdns)
  - [Wordpress CDNs](#wordpress-cdns)
- [Popular CDNs](#popular-cdns)
  - [Akamai](#akamai)
  - [Cloudflare](#cloudflare)
  - [Fastly](#fastly)
  - [AWS CloudFront](#aws-cloudfront)
  - [Azure CDN](#azure-cdn)
  - [Google Cloud CDN](#google-cloud-cdn)
  - [Netlify](#netlify)
  - [StackPath (formerly MaxCDN)](#stackpath-formerly-maxcdn)
  - [Imperva (formerly Incapsula)](#imperva-formerly-incapsula)
  - [Digital Ocean CDN](#digital-ocean-cdn)
  - [KeyCDN](#keycdn)
  - [Gcore](#gcore)
  - [CDN77](#cdn77)
  - [JSDelivr](#jsdelivr)
  - [LightCDN](#lightcdn)
  - [Bunny CDN](#bunny-cdn)

<!-- INDEX_END -->

## Key Points

Modern CDNs commonly offer the same sorts of services:

- web performance optimization
- security solutions like DDoS protection and Web Application Firewall (WAF)
- edge computing capabilities

## Beware Public Shared CDNs

This is a different category to standard CDNs, see this article:

<https://httptoolkit.com/blog/public-cdn-risks/>

## Best Free CDNs

Don't waste time on limited time trials.

- [Cloudflare](#cloudflare) - best free plan, no time limit
- [Gcore](#gcore) - good speeds, limited free tier
- [Netlify](#netlify)
- [JSDelivr](#jsdeliver)

### Wordpress CDNs

- [Jetpack](https://jetpack.com/features/design/content-delivery-network/)
- [W3 Total Cache](https://wordpress.org/plugins/w3-total-cache/)
- [LiteSpeed](https://wordpress.org/plugins/litespeed-cache/)
- [Shift8](https://wordpress.org/plugins/shift8-cdn/)
- [Optimole](https://wordpress.org/plugins/optimole-wp/)

## Popular CDNs

Roughly stack ranked by popularity and maturity.

### Akamai

<https://www.akamai.com>

One of the oldest and most established CDNs, known for its extensive global network and robust security
features.

Akamai is a leader in the CDN market, particularly for enterprise customers and large-scale media distribution.

### Cloudflare

<https://www.cloudflare.com>

Popular CDN known for security features, DNS and DDoS protection - which you may commonly encounter on popular
websites - and a large network of data centers worldwide.

It provides a free tier with essential CDN services, DNS services, and support for edge
computing.

See the [Cloudflare](cloudflare.md) doc for more tech info, scripts and configs.

Beware that the company has previously deplatformed the 4Chan anonymous freedom of speech message board
leading to an outage.

### Fastly

<https://www.fastly.com>

Fastly is known for its real-time content delivery and edge cloud platform.

Popular among developers and media companies for speed and being highly configurable.

It provides high-performance delivery for dynamic content, streaming, and APIs, with advanced caching and edge computing
capabilities.

No free tier :-(

### AWS CloudFront

<https://aws.amazon.com/cloudfront>

Amazon CloudFront is part of the [AWS](aws.md) cloud ecosystem.

Convenient for people already using AWS since it requires no purchase orders, it'll bill into your existing account.

Beware that Amazon has previously deplatformed Parler (a freedom of speech app) without warning, leading to an outage.

### Azure CDN

<https://azure.microsoft.com/en-us/services/cdn/>

Convenient for people already using [Azure](azure.md) cloud since it requires no new purchase orders, it'll bill into
your existing account.

### Google Cloud CDN

<https://cloud.google.com/cdn>

Convenient for people already using [GCP](gcp.md) cloud since it requires no new purchase orders, it'll bill into your
existing account.

### Netlify

<https://www.netlify.com/platform/core/edge/>

Good for static sites. Integrates with GitHub pages for your GitHub projects.

Popular among developers and small to medium-sized websites.

Netlify offers a CDN as part of its static site hosting service.

### StackPath (formerly MaxCDN)

<https://www.stackpath.com>

Popular for its edge computing capabilities and ease of use for developers.

### Imperva (formerly Incapsula)

<https://www.imperva.com>

Combines a CDN with advanced security features like WAF, DDoS protection, and bot management.

Highly regarded for its focus on security and protecting web applications.

### Digital Ocean CDN

<https://docs.digitalocean.com/products/spaces/how-to/enable-cdn/>

Popular developer cloud Digital Ocean has a CDN but it's only for their S3-compatible blob storage called Spaces.

This is a more limited offering than the specialist CDNs above like Akamai or Cloudflare.

### KeyCDN

<https://www.keycdn.com>

KeyCDN is known for affordability and ease of use, as well as real-time image processing.

Popular among smaller websites and developers.

### Gcore

<https://gcore.com/cdn>

More used in specific industries and regions, focusing on low-latency performance 30ms advertised, sometimes as low as
3ms, used in entertainment service such as gaming and streaming networks.

100% uptime commitment with defenses against DDoS, malware and bots.

### CDN77

<https://www.cdn77.com>

Known for its transparent pricing and high-performance network, making it a popular choice among small to
mid-sized businesses.

Uses free LetsEncrypt SSL certificates.

### JSDelivr

<https://www.jsdelivr.com/>

Free CDN for open-source projects used for hosting JavaScript libraries and files.

Popular among developers for specific use cases.

### LightCDN

<https://www.lightcdn.com/>

### Bunny CDN

<https://bunny.net/>

Simple low-cost CDN.
