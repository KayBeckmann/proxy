# Tor Hidden Service Reverse Proxy

A Docker-based Tor hidden service that forwards traffic from the Tor network to a local service. Supports vanity .onion address generation.

## Features

- Easy configuration via `.env` file
- Vanity address generation (custom .onion prefix)
- Persistent keys across container restarts
- Lightweight Debian-based image

## Quick Start

1. Copy the example configuration:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` to your needs:
   ```bash
   nano .env
   ```

3. Start the container:
   ```bash
   docker-compose up -d
   ```

4. Get your .onion address:
   ```bash
   cat hidden_service/hostname
   ```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `VANITY_PREFIX` | *(empty)* | Prefix for the .onion address (a-z, 2-7). Leave empty for random. |
| `LOCAL_PORT` | `8080` | Port of the local service to forward to |
| `ONION_PORT` | `80` | Port exposed on the Tor network |

### Vanity Address Generation Time

| Prefix Length | Approximate Time |
|---------------|------------------|
| 3 characters | Seconds |
| 4 characters | Minutes |
| 5 characters | Hours |
| 6 characters | Days |

## Files

```
hidden_service/
├── hostname                  # Your .onion address
├── hs_ed25519_public_key     # Public key
└── hs_ed25519_secret_key     # Private key (keep secret!)
```

## Security Notes

- The `hidden_service/` directory contains your private keys. **Never share these!**
- Back up your keys if you want to keep your .onion address.
- The `.env` file and `hidden_service/` directory are excluded from git via `.gitignore`.

## License

MIT

---

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-support-yellow?style=flat&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/snuppedelua)
