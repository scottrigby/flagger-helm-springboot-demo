#!/bin/env bash

k3d cluster delete 101 > /dev/null 2>&1 || true

k3d cluster create 101 -p "8080:80@loadbalancer" --wait

kubectl apply -k raw_yaml/