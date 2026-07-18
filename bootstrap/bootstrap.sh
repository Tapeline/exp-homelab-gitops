#!/bin/bash
set -e

echo "Deploy ArgoCD"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side --force-conflicts

echo "Waiting for ArgoCD"
kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=300s

echo "Configuring secrets store"
kubectl create namespace external-secrets --dry-run=client -o yaml | kubectl apply -f -

echo "Applying root"
kubectl apply -f bootstrap/root-app.yml

echo "Applied. Over"
