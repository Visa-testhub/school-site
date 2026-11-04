# CSC Ubuntu Web Server Project

This is my Linux course project using an Ubuntu virtual machine in CSC's cPouta cloud.

I started with a basic HTML and CSS website served by Nginx. The server now also runs a Python application with a MySQL-backed page load counter.

## 1. Virtual machine and SSH

I created an Ubuntu 26.04 LTS virtual machine and configured its security group to allow SSH on port 22 and HTTP on port 80.

I generated an SSH key pair on Windows, added the public key to the server and connected using PowerShell.

## 2. First website

I installed Nginx using APT and enabled it to start automatically.

The first website contains HTML and CSS files in:

`/var/www/school-site/site/`

I created a custom Nginx configuration in `/etc/nginx/sites-available/school-site` and enabled it through a symbolic link in `sites-enabled`.

This website is still available at the server's public IP address.

## 3. Development tools and GitHub

I configured Visual Studio Community 2022 to edit files on the server through SSH using Remote File Explorer.

I also installed Zsh, Oh My Zsh and zsh-autosuggestions to make working in the terminal easier.

I initialized Git in `/var/www/school-site` and pushed the project to GitHub. The `.gitignore` excludes the Python virtual environment, generated files, local environment files and editor settings.

## 4. Python application

For the second assignment, I created a separate `viikko2` directory so the original website could stay unchanged.

I created a Python virtual environment and installed Flask and Gunicorn. The dependencies are saved in `requirements.txt`.

Flask handles the `/viikko2/` route and renders the HTML from `templates/index.html`. The stylesheet is in `static/style.css`.

I first tested the application locally using Gunicorn on `127.0.0.1:8000` and checked the response with `curl`.

## 5. Publishing the application

I added a `/viikko2/` location to the existing Nginx configuration. Nginx forwards requests for this path to Gunicorn.

After checking the configuration with `sudo nginx -t`, I reloaded Nginx and tested the page through the public IP address.

I then created a systemd service called `viikko2`. It runs Gunicorn using the project's virtual environment, starts automatically when the VM boots and restarts the process if it fails.

The application no longer needs an open SSH session to keep running. Port 8000 is only used locally and is not exposed to the internet.

## 6. MySQL and the counter

I installed MySQL and created the `viikko2_db` database.

The database contains a `visitor_counter` table with two columns:

- `id`: identifies the counter.
- `visits`: stores the number of page loads.

I created a separate MySQL user, `viikko2_app`, with only SELECT and UPDATE permissions on this table.

I installed PyMySQL in the virtual environment and updated `requirements.txt`. Flask uses it to connect to MySQL through a local Unix socket.

Each load of `/viikko2/` increases the counter, commits the change to MySQL and displays the updated value on the page. It counts page loads, not unique visitors.

The database password is stored in a protected file outside the repository. The systemd service provides it to the application using `LoadCredential`.

## 7. Testing

During setup, I fixed an HTML character encoding problem by saving the files as UTF-8 in Visual Studio.

I tested the application locally with `curl` and through the public website.

I also rebooted the VM and confirmed that Nginx, MySQL and the `viikko2` service started automatically.

## Current situation

The original static website is available at `/`, and the Flask application is available at `/viikko2/`.

The second page has a dark theme and a working counter stored in MySQL rather than in Python memory. Nginx receives the public HTTP requests, Gunicorn runs Flask, and MySQL stores the counter.

The application code and its dependencies are tracked in GitHub.

## Repository structure

```text
school-site/
├── .gitignore
├── README.md
├── site/
│   ├── index.html
│   └── style.css
└── viikko2/
    ├── app.py
    ├── requirements.txt
    ├── static/
    │   └── style.css
    └── templates/
        └── index.html
```

The Python virtual environment, database contents and database password are not included in the repository. The active Nginx and systemd configurations are stored separately under `/etc/` on the server.
