from kubernetes import client, config, watch

config.load_kube_config()
v1 = client.CoreV1Api()

w = watch.Watch()
for event in w.stream(v1.list_pod_for_all_namespaces):
    pod = event['object']
    phase = pod.status.phase
    name = pod.metadata.name

    if phase == 'Succeeded' and name == 'example-pod-succeeded':
        print(f"Pod {name} has succeeded. Creating replacement pod...")
        
        pod_manifest = {
            'apiVersion': 'v1',
            'kind': 'Pod',
            'metadata': {
                'name': 'replacement-pod',
                'labels': {'app': 'replacement-pod'}
            },
            'spec': {
                'containers': [{
                    'name': 'replacement-container',
                    'image': 'alpine:latest',
                    'command': ['/bin/sh'],
                    'args': ['-c', 'echo "Replacement pod running"; sleep 30']
                }],
                'restartPolicy': 'Never'
            }
        }
        
        v1.create_namespaced_pod(namespace='default', body=pod_manifest)

