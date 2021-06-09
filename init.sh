#!/bin/env bash

k3d cluster delete 101 > /dev/null 2>&1 || true

k3d cluster create 101 -p "8080:80@loadbalancer" --wait

flux install

kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/runtime_git.yaml

kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/dev_cluster.yaml

linkerd check

kubectl get deploy -n kube-system traefik -o yaml | linkerd inject --ingress - | kubectl apply -f -

kubectl apply -k raw_yaml/