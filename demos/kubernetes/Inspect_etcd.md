## ETCD Inspection

How do we explore the state of our Kubernetes cluster? Well lets start with taking a look in the etcd server!

First set some of the shell variables the ```etcdctl``` command expects to be present:
```
export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379
```

And lets dive deeper:

```
etcdctl get / --prefix --keys-only
etcdctl get /registry/serviceaccounts/kube-system/root-ca-cert-publisher
etcdctl watch  /registry/serviceaccounts/kube-system/root-ca-cert-publisher
```

Okay cool, as expected, the root-ca-cert-publisher isn't changing too often.

Let's save the database state so we don't do anything harmful:

```etcdctl snapshot save backup.db```

And lets restore it back:

```etcdctl snapshot restore backup.db```

Lists all members in the etcd cluster. Helps in understanding the current cluster membership and health.

```etcdctl member list
   etcdctl endpoint health
   etcdctl defrag
   etcdctl alarm list
   etcdctl auth status
```

