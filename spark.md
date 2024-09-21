# Spark

NOT PORTED YET

<!-- INDEX_START -->

- [Spark-on-Kubernetes UI Tunnel](#spark-on-kubernetes-ui-tunnel)
- [Troubleshooting](#troubleshooting)
  - [JStack Thread Dumps](#jstack-thread-dumps)

<!-- INDEX_END -->

## Spark-on-Kubernetes UI Tunnel

Quickly using [DevOps-Bash-tools](devops-bash-tools.md) (will prompt if more than 1 spark job is running):

```shell
kubectl_port_forward_spark.sh  # <namespace>
```

Manually:

Set the Kubernetes namespace where the Spark job is running:

```shell
NAMESPACE=prod
```

On the bastion itself you need to find the Spark driver (master) pod which hosts the UI.

```shell
SPARK_DRIVER_POD="$(
  kubectl get pods -n "$NAMESPACE" \
                   -l spark-role=driver \
                   --field-selector=status.phase=Running \
                   -o name |
  tee /dev/stderr
)"
```

You should see a pod name output, which is also saved to `$SPARK_DRIVER_POD` for future commands.

If you see more than one pod name output then you need to pick one explicitly,
perhaps `kubectl get pods -n "$NAMESPACE"` and pick the one that aligns to your job start time.

Kubectl to port-forward to that Spark driver pod's UI port:

```shell
kubectl port-forward --address 127.0.0.1 -n "$NAMESPACE" "$SPARK_DRIVER_POD" 4040:4040
```

Then open <http://localhost:4040>.

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
