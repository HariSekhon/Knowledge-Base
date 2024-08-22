# Spark

NOT PORTED YET

<!-- INDEX_START -->

- [Troubleshooting](#troubleshooting)
  - [JStack Thread Dumps](#jstack-thread-dumps)

<!-- INDEX_END -->

## Troubleshooting

### JStack Thread Dumps

If the docker image used eg. [Informatica](informatica.md) is using JRE instead of JDK and the copied versions of JDK
don't work then another workaround is to tunnel to the Spark master drive UI and get the thread dumps from there:

```shell
ssh bastion -L 4040:localhost:4040
```

On the bastion:

```shell
kubectl port-forward --address 127.0.0.1 "$(kubectl get pods -l spark-role=driver -o name | head -n1)" 4040
```
