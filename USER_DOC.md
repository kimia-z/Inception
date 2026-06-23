# User Documentation
## Services provided by the stack

This project runs a WordPress website behind an NGINX web server, with a MariaDB database storing all the site's content and users. Together they provide a fully working website, accessible securely over HTTPS.

## Start and stop the project

**Start:**
1. Start the Virtual Machine dedicated to this project.
2. After cloning the git repository, set up the environment file: copy `.env.example`, then fill in the required values for WordPress and the database.
3. Create the secret files in the `secrets/` folder (the passwords — see "Locate and manage credentials" below).
4. Run the project with:
```bash
   make
```
5. If no error appears in the terminal, open a browser and go to the domain name `https://kziari.42.fr` to see the website.

**Stop:**
- `make clean` — stops the running containers and cleans unused volumes/containers.
- `make fclean` — stops everything and removes images, volumes, and data directories (a full reset).

## Access the website and the administration panel

- **Website:** `https://kziari.42.fr` — note that plain `http://` will not work; only HTTPS on port 443 is allowed.
- **Administration panel:** `https://kziari.42.fr/wp-admin` — log in with the WordPress admin credentials.

## Locate and manage credentials

Credentials are split across two places:

- **`secrets/` folder** — contains the sensitive password files, which you must create yourself before running the project. The program reads them to set up the website:
  - `db_password` — the WordPress database user's password
  - `db_root_password` — the MariaDB root password
  - `wp_admin_password` — the WordPress administrator's password
  - `wp_user_password` — the second WordPress user's password
- **`srcs/.env` file** — contains only non-sensitive configuration as key/value pairs: the domain name (stays as `kziari.42.fr`) and the WordPress user/admin information (usernames, not passwords).

To change a credential, edit the matching file, then run `make fclean` followed by `make`. A full rebuild is required because the database stores its passwords on first initialization, destroying the volume forces it to re-initialize with the new values. These files (both `secrets/` and `.env`) are **never pushed to the git repository** — the project forbids storing credentials in git, and this is enforced by the `.gitignore` file.

## Check that the services are running correctly

**1. Confirm all containers are running:**
```bash
docker ps
```
All three containers — `nginx`, `wordpress`, and `mariadb` — should show status **"Up"**.

**2. Confirm HTTPS works (and HTTP is blocked):**
- `https://kziari.42.fr` should load the website.
- Plain `http://kziari.42.fr` should **not** work — only HTTPS on port 443 is allowed.

**3. Confirm data persistence (the database survives a restart):**
1. Create a test post on the website.
2. Run `make re` (stops the containers, then rebuilds and restarts them).
3. Check that your test post is still there — if it survived, MariaDB and the volumes are working correctly.

**4. Confirm containers restart automatically after a crash:**
```bash
docker exec mariadb kill 1    # simulate a real crash (kills the main process)
docker ps                     # wait a few seconds — mariadb returns to "Up"
```
This confirms the `restart: always` policy works — a crashed container comes back on its own.