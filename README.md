*This project has been created as part of the 42 curriculum by kziari.*

# Inception

## Description

This project is a small infrastructure made of three services, each running in its own container:

- **NGINX** — the web server and the single entry point between the client and the infrastructure, handling the connection over TLS.
- **WordPress** (with php-fpm) — runs the website itself.
- **MariaDB** — the database storing the website's content and user information.

It also uses two named volumes: one for the WordPress website files, and one for the MariaDB database — so the data is never lost when containers are recreated.

With the help of Docker Compose, these three containers — whose images we build ourselves from our own Dockerfiles, following specific rules — run together as one system. The result is a WordPress website served behind NGINX, ready to receive requests and send responses, accessible at `https://kziari.42.fr`.

## Instructions

This project must be run inside the dedicated Virtual Machine.

1. **Clone the repository** into the VM:
```bash
   git clone <repository-url> inception
   cd inception
```

2. **Set up the environment variables.** Copy the example file and fill in your values:
```bash
   cp srcs/.env.example srcs/.env
   nano srcs/.env
```
   Edit `srcs/.env` with the values needed for WordPress and the database (domain name, database name, usernames, etc.).

3. **Create the secret files.** The passwords are not stored in the repository; create them locally in the `secrets/` folder (database password, database root password, WordPress admin and user passwords).

4. **Start the Docker service.** On first setup, enable Docker so it starts automatically on every boot:
```bash
   sudo systemctl enable docker      # one-time: auto-start on boot
   sudo systemctl start docker       # start it now (if not already running)
   sudo systemctl status docker      # check it shows "active (running)" — press q to exit
```
   After enabling, Docker starts on its own when the VM boots, so on later runs you can skip straight to `make`.

5. **Build and run the project** with the Makefile:
```bash
   make
```

6. **Check that it works.** If no error appears in the terminal, visit the website:
```bash
   curl -k https://kziari.42.fr
```
   Or open `https://kziari.42.fr` in a browser inside the VM (accept the self-signed certificate warning).

## Resources

To understand the concepts behind this project, I used the following resources:

- **Docker crash course (YouTube)** — to get a first general idea of what Docker is and how it works.
- **[Docker Documentation — What is Docker?](https://docs.docker.com/get-started/docker-overview/)** — read through each part as my main reference.
- **[Docker Compose Documentation](https://docs.docker.com/compose/)** — to understand how Compose orchestrates multiple containers.

**How AI was used:** After reading the documentation, I asked AI to quiz me with relevant questions on each topic, to make sure I understood the concepts deeply enough. When I was confused about a specific topic, I used AI to clarify it. AI was used as a study aid and to help me understand concepts.

## Project Description
### Virtual Machines vs Docker
### Secrets vs Environment Variables
### Docker Network vs Host Network
### Docker Volumes vs Bind Mounts
