In a basic, vanilla Kubernetes cluster, several built-in controllers watch the state of Pods and other resources. Here are some of them:

1. ReplicaSet Controller: Ensures that the correct number of pod replicas are running at any given time. If a Pod crashes, the ReplicaSet controller starts a new one.

2. Deployment Controller: Manages updates to Pods and ReplicaSets. It allows for rolling updates to your application, ensuring that your application remains available even as it's being updated with new code.

3. StatefulSet Controller: Similar to a Deployment, but for stateful applications, ensuring that the deployment and scaling of a set of Pods happens in a strict, ordered manner.

4. DaemonSet Controller: Ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected.

5. Job Controller: Ensures that a specified number of successful completions for a task (Pods) have been run.

6. CronJob Controller: Similar to the Job controller, but able to schedule jobs to run at specific times of day.

7. Service Controller: Watches the shared state of services and their endpoints, and updates the network routing (iptables, IPVS, etc.) rules to allow for traffic to be routed to the correct Pods.

- Namespace Controller: Watches for namespace objects and ensures finalizers are executed when a namespace is deleted.

9. Node Controller: Responsible for noticing and responding when nodes go down.

10. Persistent Volume Controller: Manages the lifecycle of PersistentVolumes and PersistentVolumeClaims.

These controllers are part of the Kubernetes control plane and run as part of the kube-controller-manager process. They are constantly reconciling the desired state of the cluster (as expressed in the Kubernetes API) with the actual state of the cluster.