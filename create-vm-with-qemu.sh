#!/bin/bash

qemu-img create -f qcow2 alpine3.22.qcow2 1g

qemu-system-x86_64 \
  -m 512 \
  -cdrom /opt/alpine-standard-3.22.0-x86_64.iso \
  -boot d \
  -hda alpine3.22.qcow2 \
  -enable-kvm \
  -nographic
