# MongoDB

TOOD: not sure where all the MongoDB notes went from all the MongoDB courses circa 2013.

<!-- INDEX_START -->

- [Install (old)](#install-old)

<!-- INDEX_END -->

## Install (old)

Check newer docs.

```shell
cat > /etc/yum.repos.d/mongodb.repo <<EOF
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF
```

```shell
yum -y install mongo-10gen mongo-10gen-server
service mongod start
chkconfig mongod on
```

**Ported from private Knowledge Base pages 2013+**
