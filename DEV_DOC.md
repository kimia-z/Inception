# Developer Documentation

## 1. Set up the environment from scratch

### Prerequisites

This project runs inside a dedicated Linux Virtual Machine. Before starting, the following must be installed on the VM:

- **Docker** — to build and run the containers
- **Docker Compose** — to orchestrate the three services together
- **make** — to run the Makefile
- **git** — to clone the repository

On a Debian/Ubuntu VM these can be installed with `apt`.

### Configuration files and secrets

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
   `srcs/.env` holds non-sensitive configuration: the domain name (`kziari.42.fr`), database name, and WordPress usernames. No passwords go here.

3. **Create the secret files** in the `secrets/` folder — these hold the passwords and are never committed to git:
   - `db_password.txt` — WordPress database user password
   - `db_root_password.txt` — MariaDB root password
   - `wp_admin_password.txt` — WordPress admin password
   - `wp_user_password.txt` — WordPress second user password

## 2. Build and launch the project

**Start the Docker service.** On first setup, enable Docker so it starts automatically on every boot:
```bash
sudo systemctl enable docker      # one-time: auto-start on boot
sudo systemctl start docker       # start it now (if not already running)
sudo systemctl status docker      # check it shows "active (running)" — press q to exit
```
After enabling, Docker starts on its own when the VM boots, so on later runs you can skip straight to `make`.

**Build and run the project** with the Makefile:
```bash
make
```
Running `make` calls `docker-compose.yml`, which in turn builds the three images — one per Dockerfile (`nginx`, `wordpress`, `mariadb`) — and starts each as its own container on the shared `inception` network.

**Check that it works.** If no error appears in the terminal, visit the website:
```bash
curl -k https://kziari.42.fr
```
Or open `https://kziari.42.fr` in a browser inside the VM (accept the self-signed certificate warning).

## 3. Manage containers and volumes

### Container lifecycle
| Command | What it does |
|---|---|
| `make` | Build and start all containers (`docker compose up --build -d`) |
| `make down` | Stop and remove containers (data volumes are kept) |
| `make clean` | `down`, then prune **all** unused Docker images/volumes on the machine (not just this project) |
| `make re` | `down` then `up` — rebuild and restart while **keeping existing data** |
| `make fclean` | Full reset: removes containers, all images, all volumes, and the host data directories — irreversible |

### Inspecting state
| Command | What it does |
|---|---|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers, including stopped ones |
| `docker logs <name>` | View a container's output/errors |

### Testing crash recovery
| Command | What it does |
|---|---|
| `docker exec <name> kill 1` | Kill the main process inside a container to simulate a real crash — confirms the `restart: always` policy brings it back |

## 4. Where data is stored and how it persists

This project uses two Docker **named volumes**, each bound to a folder on the host machine:

| Volume | Host path | Contains |
|---|---|---|
| `mariadb_data` | `/home/kziari/data/mariadb` | The MariaDB database files |
| `wordpress_data` | `/home/kziari/data/wordpress` | The WordPress website files |

Because these are backed by real folders on the host (via the `driver_opts`/`device` binding in `docker-compose.yml`), the data physically lives on disk at `/home/kziari/data/`, independent of the containers. This means:

- Removing a container (`make down`, or a crash) does **not** delete the data.
- Rebuilding the containers (`make re`) reconnects to the same volumes — the website and database come back exactly as they were.
- Only `make fclean` removes this data, since it explicitly deletes the volumes and the host directories.

To verify the data is really there, independent of Docker:
```bash
ls /home/kziari/data/mariadb
ls /home/kziari/data/wordpress
```