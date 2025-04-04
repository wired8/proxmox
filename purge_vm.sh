#!/bin/bash

# Check if VMID is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <VMID>"
    exit 1
fi

VMID=$1

echo "Stopping VM $VMID..."
qm stop $VMID 2>/dev/null

if [ $? -eq 0 ]; then
    echo "VM $VMID stopped successfully."
else
    echo "VM $VMID is not running or could not be stopped."
fi

echo "Deleting VM $VMID..."
qm destroy $VMID --purge

if [ $? -eq 0 ]; then
    echo "VM $VMID deleted successfully."
else
    echo "Failed to delete VM $VMID."
    exit 1
fi

# Clean up leftover files
VM_PATH="/var/lib/vz/images/$VMID"
if [ -d "$VM_PATH" ]; then
    echo "Removing leftover files for VM $VMID..."
    rm -rf "$VM_PATH"
    echo "Leftover files removed."
else
    echo "No leftover files found for VM $VMID."
fi

echo "VM $VMID successfully purged from Proxmox."
