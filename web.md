# Web

<!-- INDEX_START -->

- [PaaS - Platform as a Service](#paas---platform-as-a-service)
- [SSG - Static Site Generators](#ssg---static-site-generators)
  - [Jekyll](#jekyll)
  - [Hugo](#hugo)
  - [Netlify](#netlify)
- [Web Scrapers](#web-scrapers)
- [Diagrams](#diagrams)
  - [Diagram - Web Basics](#diagram---web-basics)
  - [Diagram - AWS Web Traffic Classic](#diagram---aws-web-traffic-classic)
  - [Diagram - AWS Load Balanced Web Farm](#diagram---aws-load-balanced-web-farm)
  - [Diagram - AWS Clustered Web Services](#diagram---aws-clustered-web-services)
  - [Diagram - Web MySQL Replica Architecture](#diagram---web-mysql-replica-architecture)
  - [Diagram - Advanced Web Services Open Source](#diagram---advanced-web-services-open-source)
  - [Diagram - Cloudflare and Kubernetes Web Architecture](#diagram---cloudflare-and-kubernetes-web-architecture)
  - [Diagram - Multi-Datacenter Web Stack](#diagram---multi-datacenter-web-stack)
  - [Diagram - Kubernetes Traefik Web Architecture](#diagram---kubernetes-traefik-web-architecture)
  - [Diagram - Kubernetes Kong Web Architecture](#diagram---kubernetes-kong-web-architecture)
  - [Diagram - Rest vs GraphQL](#diagram---rest-vs-graphql)

<!-- INDEX_END -->

## PaaS - Platform as a Service

See the [PaaS](paas.md) doc.

## SSG - Static Site Generators

Generate static HTML pages from code or markdown. Jekyll is an obvious example, used with GitHub Pages.

List of SSGs:

- <https://jamstack.org/generators/>

### Jekyll

<https://jekyllrb.com/>

<https://github.com/jekyll/jekyll>

GitHub Pages has native support for Jekyll.

Written in Ruby.

See this repo: [HariSekhon/CI-CD](https://github.com/HariSekhon/CI-CD)

And this resulting GitHub Page: <https://harisekhon.github.io/CI-CD/>

### Hugo

<https://gohugo.io/>

<https://github.com/gohugoio/hugo>

Written in Go.

Faster and simpler.

### Netlify

Builds [Jekyll](#jekyll) from GitHub repo integration for CI/CD upon pushes.

<https://harisekhon.netlify.app/>

## Web Scrapers

- [FlyScrape](https://flyscrape.com/)
- [Scrapy](https://scrapy.org/) - Python web scraping library

## Diagrams

### Diagram - Web Basics

![Web Basics](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/web_basics.svg)

### Diagram - AWS Web Traffic Classic

![AWS Web Traffic Classic](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_web_traffic_classic.png)

### Diagram - AWS Load Balanced Web Farm

![AWS Load Balanced Web Farm](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_load_balanced_web_farm.png)

### Diagram - AWS Clustered Web Services

![AWS Clustered Web Services](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_clustered_web_services.png)

### Diagram - Web MySQL Replica Architecture

![Web MySQL Replica Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/mysql_replica_architecture.svg)

### Diagram - Advanced Web Services Open Source

![Advanced Web Services Open Source](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/advanced_web_services_open_source.png)

### Diagram - Cloudflare and Kubernetes Web Architecture

![Cloudflare and Kubernetes Web Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/gcp_cloudflare_web_architecture_gke.png)

### Diagram - Multi-Datacenter Web Stack

![Multi-Datacenter Web Stack](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/multi_dc_gslb_f5_java_stack.png)

### Diagram - Kubernetes Traefik Web Architecture

![Kubernetes Traefik Web Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/kubernetes_traefik_ingress_gke.png)

### Diagram - Kubernetes Kong Web Architecture

![Kubernetes Kong Web Architecture](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/kubernetes_kong_api_gateway_eks.png)

### Diagram - Rest vs GraphQL

![Rest vs GraphQL](images/rest_vs_graphql.gif)
