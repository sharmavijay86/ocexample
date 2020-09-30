#!/bin/sh
exec /opt/octant --kubeconfig /kube/config --disable-open-browser --listener-addr 0.0.0.0:8080
