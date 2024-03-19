#!/bin/bash
kubectl apply -f - <<EOF && kubectl logs -f $(kubectl get pods -l app=gpu-test -o custom-columns=:metadata.name --no-headers=true)
apiVersion: v1
kind: Pod
metadata:
  name: gpu-test
  labels:
    app: gpu-test
spec:
  restartPolicy: OnFailure
  containers:
  - name: cuda-container
    image: nvidia/cuda:latest
    command: ["nvidia-smi"]
    securityContext:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      capabilities:
        drop:
        - ALL
      seccompProfile:
        type: RuntimeDefault
    resources:
      limits:
        nvidia.com/gpu: 1
EOF
kubectl describe pod gpu-test