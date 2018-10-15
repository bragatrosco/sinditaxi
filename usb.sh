#!/bin/bash
# script criado por @fabiolrodriguez - https://tchubirabiron.wordpress.com/
 
# Reiniciando as portas USB 2.0
for i in $(ls /sys/bus/pci/drivers/uhci_hcd/ | grep : )
do echo $i >/sys/bus/pci/drivers/ehci_hcd/unbind
echo $i > /sys/bus/pci/drivers/ehci_hcd/bind
done
 
# Reiniciando as portas USB 3.0
for i in $(ls /sys/bus/pci/drivers/xhci_hcd/ | grep : )
do echo $i > /sys/bus/pci/drivers/xhci_hcd/unbind
echo $i > /sys/bus/pci/drivers/xhci_hcd/bind
done
 
# Reiniciando as portas para hub USB
for i in $(ls /sys/bus/pci/drivers/ehci-pci | grep : )
do echo $i > /sys/bus/pci/drivers/ehci-pci/unbind
echo $i > /sys/bus/pci/drivers/ehci-pci/bind
done
