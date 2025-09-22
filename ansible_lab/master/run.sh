#!/bin/bash
for h in host01 host02 host03 host04 host05; do
  ssh -o StrictHostKeyChecking=accept-new root@$h exit || true
done