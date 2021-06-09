#!/bin/env bash
# shellcheck source=demo-magic.sh
source demo-magic.sh

clear

k3d cluster delete 101 > /dev/null 2>&1 || true

k3d cluster create 101 -p "8080:80@loadbalancer" -a 3 --wait > /dev/null 2>&1

pe "flux install"
wait
clear

pe "kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/runtime_git.yaml"
wait
clear

pe "kubectl apply -f ~/git_repos/buoyant/gitops_examples/flux/runtime/manifests/dev_cluster.yaml"
wait
clear

pe "linkerd check"
wait
clear

pe "linkerd viz check"
wait
clear

pe "kubectl get deploy -n kube-system traefik -o yaml | linkerd inject --ingress - | kubectl apply -f -"
wait
clear

pe "kubectl apply -k supporting-files/"
wait
clear

pe "kubectl ns petclinic"
wait
clear

pe "helm install petclinic chart/spring-boot-example/ -n petclinic"
wait
clear

pe "helm upgrade petclinic spring-boot-example/ --set image.tag=1.0.1"
wait
clear