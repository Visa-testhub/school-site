# CSC Ubuntu Web Server Project

This repository contains my school project for setting up an Ubuntu web server and hosting a website using Nginx.

## 1. Creating the virtual machine

I created a virtual machine using CSC's cPouta cloud service.

The VM runs Ubuntu 26.04 LTS. I configured the security group to allow SSH connections on port 22 and HTTP traffic on port 80.

## 2. Connecting with SSH

I generated an SSH key pair on my Windows computer and added the public key to the virtual machine.

I can connect to the VM using SSH and authenticate using my private key.

## 3. Installing Nginx

I installed Nginx using Ubuntu's APT package manager.

Commands used:

- `sudo apt update` — Refresh package lists
- `sudo apt upgrade` — Upgrade installed packages
- `sudo apt install nginx` — Install Nginx
- `systemctl status nginx` — Check service status
- `sudo systemctl enable nginx` — Enable automatic startup

Nginx listens for HTTP requests on port 80 and serves the website's HTML and CSS files.

## 4. Configuring the website

I created a custom Nginx server block and configured the document root to `/var/www/school-site/site/`.

The website consists of an HTML file and a CSS stylesheet.

## 5. Configuring Zsh

I installed Zsh and Oh My Zsh to improve the command-line interface.

I also installed the zsh-autosuggestions plugin, which suggests commands based on shell history.

## 6. Remote development

I configured Visual Studio Community 2022 to connect to the Ubuntu VM using SSH and an ECDSA key.

Using Remote File Explorer, I can edit the website files directly on the VM.

## 7. Future development

The next goal is to implement a visitor or page reload counter. This will introduce a backend API and persistent data storage.