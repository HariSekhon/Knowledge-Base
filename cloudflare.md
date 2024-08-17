# Cloudflare

<https://www.cloudflare.com/>

<!-- INDEX_START -->
<!-- INDEX_END -->

## Summmary

- DNS
- CDN
- Proxy protection (DDoS, WAF)
- Worker scripts (can return web pages for given URLs eg. maintenance page)

## Cloudflare API Scripts

[HariSekhon/DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools#internet-services)

- List/Add/Update/Delete DNS records
- List zones, iterate zones
- Firewall rules
- Purge cache
- get Cloudflare IP Ranges for Proxied Protection for your firewall rules

`cloudflare/cloudflare_*.sh`

## Kubernetes Cert Manager + Cloudflare Integration

Integrates to generate the TXT validation records for [LetsEncrypt](https://letsencrypt.org/) to generate automatic free SSL certificates for Kubernetes ingresses.

[HariSekhon/Kubernetes-configs cert-manager](https://github.com/HariSekhon/Kubernetes-configs/blob/master/cert-manager/base/cert-manager-clusterissuer.yaml)

## Kubernetes External DNS + Cloudflare Integration

Integrates to upsert DNS records to Cloudflare for Kubernetes ingresses.

[HariSekhon/Kubernetes-configs external-dns](https://github.com/HariSekhon/Kubernetes-configs/blob/master/external-dns/base/values.yaml#L164)

## Cloudflare Workers

List of workers:

```shell
curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/scripts" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $TOKEN"
```

List of workers routes:

```shell
curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/scripts" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $TOKEN"
```

Create route:

```shell
curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/routes" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"pattern":"*.mydomain.com/*","script":"maintenance"}'
```

Delete route:

```shell
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/routes/$ROUTE_ID" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $TOKEN"
```

###### Ported from private Knowledge Base page 2020+
