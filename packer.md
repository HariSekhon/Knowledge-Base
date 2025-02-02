# HashiCorp Packer

<https://www.packer.io/>

Packer is a tool for automating building virtual machines templates such as importable `.ova` files.

This usually involves running automated installers that are native to each Linux distribution such as:

- Debian [Preseed](debian.md#debian-preseeding---automated-installations)
- Redhat [Kickstart](redhat.md#kickstart---automated-installations)
- Ubuntu [Autoinstall](ubuntu.md#autoinstall---automated-installations)

Packer can be used to create AMI + Vagrant box at same time.

<!-- INDEX_START -->

- [Configs](#configs)
- [Convert an Old Packer JSON template to HCL](#convert-an-old-packer-json-template-to-hcl)
- [Troubleshooting](#troubleshooting)
  - [Debug Mode](#debug-mode)

<!-- INDEX_END -->

## Configs

See [HariSekhon/Packer](https://github.com/HariSekhon/Packer) repo.

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Packer&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Packer)

## Convert an Old Packer JSON template to HCL

```shell
packer hcl2_upgrade "$file.json"
```

Output:

```text
Successfully created "$file.json.pkr.hcl". Exit 0
```

## Sharing AMIs Between AWS Accounts

Packer can build in your CI/CD account, and then you can share to your other AWS Accounts from this central place.

See [AWS - Sharing AMIs Between Accounts](aws.md#sharing-amis-between-aws-accounts).

## Troubleshooting

### Debug Mode

```shell
PACKER_LOG=1 packer build "$file.pkr.hcl"
```
