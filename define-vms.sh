#!/bin/bash
virsh define scrapps-vm-01.xml
virsh define scrapps-vm-02.xml

virsh start scrapps-vm-01
virsh start scrapps-vm-02
