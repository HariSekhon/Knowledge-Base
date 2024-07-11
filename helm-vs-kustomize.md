# Helm vs Kustomize

[Helm](helm.md) is better for publishing Kubernetes configuration for official apps.

[Kustomize](kustomize.md) is better for internal team managed apps, or for wrapping / extending / patching Helm
generated k8s yaml.

Helm requires you to plan up front all configuration parameters.
This is quite hard to do unless you want to spend a huge amount of time trying to think about all possible variations.

Kustomize allows you to override and patch and Kubernetes field and is therefore much more flexible.

Kustomize is also bundled within `kubectl` and is can be activated with the `-k` switch.

It is also a standalone binary, which is preferred as it's more up-to-date.
