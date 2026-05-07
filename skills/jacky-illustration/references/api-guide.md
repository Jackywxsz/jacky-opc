# Image API Guide

This repository does not ship any API key.

If your runtime supports image generation, configure the key outside the repository:

```bash
export GOOGLE_API_KEY="your-key"
```

For scripts or custom integrations:

1. Read the key from `GOOGLE_API_KEY`.
2. Never write the key to generated files.
3. Never print the full key in logs.
4. Add generated images to an ignored `output/` directory unless you intentionally want to publish them.

