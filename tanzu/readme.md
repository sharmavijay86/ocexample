This is how to setup vmware tanzu with insecure harbor

kind create cluster --image registry.tkg.vmware.run/kind/node:v1.18.2_vmware.1 --config kind-config.yaml

grep -rl "registry.tkg.vmware.run" . | xargs sed -i 's/registry.tkg.vmware.run/registry.cloud.vssi.com\/library/g'

tkg init --infrastructure=vsphare:v0.6.4 --ui -e --kubeconfig /root/.kube/config -v 6
