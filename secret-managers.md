# Secret Managers

Personal password managers offer a great convenience to use different passwords everywhere to limit
exposure risks when one site or another inevitably gets hacked (see <https://haveibeenpwned.com/>).

However, they also represent a single point of failure they themselves get hacked.

<!-- INDEX_START -->

- [SaaS Secret Managers](#saas-secret-managers)
- [Local Secret Managers](#local-secret-managers)
- [Cloud Secret Managers & Vaults](#cloud-secret-managers--vaults)

<!-- INDEX_END -->

## SaaS Secret Managers

- [Google Password Manager](https://passwords.google.com/?pli=1) - built-in to the Chrome browser. If Google gets hacked it's game over because everybody relies on Google for GMail and SSO auth logins.
- [BitWarden](https://bitwarden.com/) - open-core, free for personal use
- [1Password](https://1password.com/)
- [Keeper](https://www.keepersecurity.com/)
- LastPass - don't use this one - they've been hacked before. I'm not even going to provide a link to this.

## Local Secret Managers

- [KeePassX](https://www.keepassx.org/)
- [KeePassXC](https://keepassxc.org/) - fork of the above

## Cloud Secret Managers & Vaults

Secret Managers allow integrations to share secrets between different technologies.

- [HashiCorp Vault](https://developer.hashicorp.com/vault/docs)
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)
- [Google Secret Manager](https://cloud.google.com/secret-manager/docs/overview)
- [Azure KeyVault](https://learn.microsoft.com/en-us/azure/key-vault/general/)
- [CyberArk](https://www.cyberark.com/) - enterprise key vault
