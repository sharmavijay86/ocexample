# pull secrets can be patched in this way ...

```
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: sync-secret
spec:
  background: false
  rules:
  - name: sync-image-pull-secret
    match:
      resources:
        kinds:
        - Namespace
    generate:
      kind: Secret
      name: image-pull-secret
      namespace: "{{request.object.metadata.name}}"
      synchronize: true
      clone:
        namespace: default
        name: image-pull-secret
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: mutate-imagepullsecret
spec:
  rules:
    - name: mutate-imagepullsecret
      match:
        resources:
          kinds:
          - Pod
      mutate:
        patchStrategicMerge:
          spec:
            imagePullSecrets:
            - name: image-pull-secret  ## imagePullSecret that you created with docker hub pro account
            (containers):
            - (image): "*" ## match all container images
            ```
