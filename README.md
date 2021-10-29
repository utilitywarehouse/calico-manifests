This repository provides [Kustomize][1] base to deploy [Calico][2].

The goal is to have a base to dump calico manifests almost as they come via the
calico release archives and patch environment specific values downstream. That
way we could easily compare and identify changes between calico releases.

Table of Contents
=================

      * [Upstream](#upstream)
      * [Usage](#usage)
      * [Using PSPs](#using-psps)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## Upstream

Upstream manifests could be fetched from calico [releases][3] by downloading the
relevant release archive and looking for `k8s-manifests/calico.yaml` file.
A diff between the release archive and the manifests in this repo should be good
to highlight the upgrade changes.

## Usage

To use the base, reference the remote in you `kustomization.yaml`

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
  - github.com/utilitywarehouse/calico-manifests/base
```

You can then patch the environment variables on the manifests according to your
environment.

- ConfigMap/calico-config should be defined as a resource downstream, as a patch
  on it would include rewriting the json data anyway. 

## Using PSPs

In case calico is deployed in a cluster that uses pod security policies, the
calico-node role needs to be patched to include the needed policy. This can be
achieved via a kustomize json patch.
In `kustomization.yaml`:
```
patchesJson6902:
  - target:
      group: rbac.authorization.k8s.io
      version: v1
      kind: ClusterRole
      name: calico-node
    path: calico/calico-node-clusterrole-patch.yaml
```

Where `calico/calico-node-clusterrole-patch.yaml` is:
```
- op: add
  path: /rules/0
  value:
    apiGroups:
      - policy
    resources:
      - podsecuritypolicies
    verbs:
      - use
    resourceNames:
      - calico-psp
```

[1]: https://kustomize.io/
[2]: https://www.projectcalico.org/
[3]: https://github.com/projectcalico/calico/releases/
