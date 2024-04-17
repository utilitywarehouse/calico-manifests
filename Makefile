CALICO_VERSION:=v3.27.3

.PHONY: update-upstream
# update-upstream fetches manifests from upstream and disregards calico-config
# ConfigMap, which we define downstream per environment.
update-upstream:
	curl -L https://raw.githubusercontent.com/projectcalico/calico/$(CALICO_VERSION)/manifests/calico-typha.yaml |\
	awk  'BEGIN{RS="---\n"; ORS="---\n"} !match($$0, /kind: ConfigMap\n.* name: calico-config/) {print}' |\
	grep -v "namespace: kube-system" > base/calico-typha.yaml
	curl -L https://raw.githubusercontent.com/projectcalico/calico/$(CALICO_VERSION)/manifests/apiserver.yaml |\
	awk  'BEGIN{RS="---\n"; ORS="---\n"} !match($$0, /kind: (Namespace|NetworkPolicy)/) {print}' |\
	grep -v "namespace: calico-apiserver" > base/apiserver.yaml
