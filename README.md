# Checkout

```
git clone --recursive-submodules https://github.com/FIRO-Tethys/tethys_portal_firo.git
```

# Build

```
docker compose build web
```

# Run

1. Create Data Directories

```
mkdir -p data/db
mkdir -p data/tethys
mkdir -p logs/tethys
```

2. Create copies of the `.env` files in the `env` directory and modify the settings appropriately.

3. Update `env_file` sections in the `docker-compose.yml` to point to your copies of the `.env` files.

4. Start containers:

```
docker compose up -d
```