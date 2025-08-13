# Web

<!-- INDEX_START -->

- [PaaS - Platform as a Service](#paas---platform-as-a-service)
- [URL Shorteners](#url-shorteners)
- [SSG - Static Site Generators](#ssg---static-site-generators)
  - [Jekyll](#jekyll)
  - [Hugo](#hugo)
  - [Netlify](#netlify)
- [Web Scrapers](#web-scrapers)
  - [Flyscrape](#flyscrape)
    - [Install](#install)
    - [Config](#config)
    - [Interactive Config Development](#interactive-config-development)
    - [Run](#run)
- [Diagrams](#diagrams)
  - [Web Basics](#web-basics)
  - [AWS Web Traffic Classic](#aws-web-traffic-classic)
  - [AWS Load Balanced Web Farm](#aws-load-balanced-web-farm)
  - [AWS Clustered Web Services](#aws-clustered-web-services)
  - [Web MySQL Replica Architecture](#web-mysql-replica-architecture)
  - [Advanced Web Services Open Source](#advanced-web-services-open-source)
  - [Cloudflare and Kubernetes Web Architecture](#cloudflare-and-kubernetes-web-architecture)
  - [Multi-Datacenter Web Stack](#multi-datacenter-web-stack)
  - [Kubernetes Traefik Web Architecture](#kubernetes-traefik-web-architecture)
  - [Kubernetes Kong Web Architecture](#kubernetes-kong-web-architecture)
  - [Rest vs GraphQL](#rest-vs-graphql)

<!-- INDEX_END -->

## PaaS - Platform as a Service

See the [PaaS](paas.md) doc.

## URL Shorteners

- [TinyURL](https://tinyurl.com)
- [Bit.ly](https://bit.ly)

## SSG - Static Site Generators

Generate static HTML pages from code or markdown. Jekyll is an obvious example, used with GitHub Pages.

List of SSGs:

- <https://jamstack.org/generators/>

### Jekyll

<https://jekyllrb.com/>

[:octocat: jekyll/jekyll](https://github.com/jekyll/jekyll)

GitHub Pages has native support for Jekyll.

Written in Ruby.

See this repo: [HariSekhon/CI-CD](https://github.com/HariSekhon/CI-CD)

And this resulting GitHub Page: <https://harisekhon.github.io/CI-CD/>

### Hugo

<https://gohugo.io/>

[:octocat: gohugoio/hugo](https://github.com/gohugoio/hugo)

Written in Go.

Faster and simpler.

### Netlify

Builds [Jekyll](#jekyll) from GitHub repo integration for CI/CD upon pushes.

<https://harisekhon.netlify.app/>

## Web Scrapers

- [FlyScrape](https://flyscrape.com/) - standalone scraping tool using Javascript configurations
- [Scrapy](https://scrapy.org/) - Python web scraping library

### Flyscrape

<https://flyscrape.com>

[:octocat: philippta/flyscrape](https://github.com/philippta/flyscrape)

*"Doesn't require advanced programming skills"*

- but it does require some basic Javascript programming to fill in a `config.js` file of what to extract and return
  - jQuery or cheerio-like API selecting HTML elements
- can access cookie stores from browsers
- Browser / Javascript rendering for complex websites
  - can launch Chromium browsers to materialize the page and then scrape the resulting HTML
- outputs in [JSON](json.md) for further processing

#### Install

On Mac:

```shell
brew install flyscrape
```

or

```shell
curl -fsSL https://flyscrape.com/install | bash
```

#### Config

Create a new config:

```shell
flyscrape new flyscrape.config.js
```

or use a ready-to-run example from
[HariSekhon/Templates](https://github.com/HariSekhon/Templates/blob/master/flyscrape.config.js):

```shell
wget -cO flyscrape.config.js https://raw.githubusercontent.com/HariSekhon/Templates/refs/heads/master/flyscrape.config.js
```

#### Interactive Config Development

Run this and then edit the file for live terminal updates of what it is extracting:

```shell
flyscrape dev flyscrape.config.js
```

#### Run

```shell
flyscrape run flyscrape.config.js
```

## Diagrams

From the [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

### Web Basics

![Web Basics](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/web_basics.svg)

### AWS Web Traffic Classic

![AWS Web Traffic Classic](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_web_traffic_classic.png)

### AWS Load Balanced Web Farm

![AWS Load Balanced Web Farm](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_load_balanced_web_farm.png)

### AWS Clustered Web Services

![AWS Clustered Web Services](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_clustered_web_services.png)

### Web MySQL Replica Architecture

![Web MySQL Replica Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/mysql_replica_architecture.svg)

### Advanced Web Services Open Source

![Advanced Web Services Open Source](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/advanced_web_services_open_source.png)

### Cloudflare and Kubernetes Web Architecture

![Cloudflare and Kubernetes Web Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/gcp_cloudflare_web_architecture_gke.png)

### Multi-Datacenter Web Stack

![Multi-Datacenter Web Stack](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/multi_dc_gslb_f5_java_stack.png)

### Kubernetes Traefik Web Architecture

![Kubernetes Traefik Web Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/kubernetes_traefik_ingress_gke.png)

### Kubernetes Kong Web Architecture

![Kubernetes Kong Web Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/kubernetes_kong_api_gateway_eks.png)

### Rest vs GraphQL

![Rest vs GraphQL](images/rest_vs_graphql.gif)
