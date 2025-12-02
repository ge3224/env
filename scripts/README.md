# Scripts

Standalone scripts meant to be run directly, independent of the profile workflow.

Unlike scripts in `runs/` which are designed to be run via `./run` as part of a profile, these are one-off tools and utilities.

## Usage

Run scripts directly:
```bash
./scripts/timezone
```

Or add this directory to your PATH for easier access.

## Scripts

- `timezone` - Detect and update system timezone based on IP geolocation (useful when traveling)
