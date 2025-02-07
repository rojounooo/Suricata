#!/bin/bash

echo("Updating packages")
sudo apt update && sudo apt full-upgrade

echo("Installing Suricata")
sudo apt install -y suricata

echo("Enabling Suricata service")
sudo systemctl enable --now suricata

echo("Verifying install")
sudo suricata --build-info