# Security Policy

## Do Not Commit Secrets

Never commit API keys, provider tokens, passwords, private keys, cookies, account screenshots, private analytics exports, or unpublished client data.

Use environment variables instead:

```bash
export OPC_ROOT="$HOME/Documents/OPC-System"
```

## If You Find a Secret

1. Remove it from the working tree immediately.
2. Rotate or revoke the exposed key at the provider side.
3. Treat Git history as compromised if the secret was committed.
4. Open an issue only after redacting the secret.

## Content Privacy

Jacky-OPC is designed to help creators accumulate content assets. That also means your workspace may contain private strategy, revenue data, customer feedback, personal stories, and unpublished drafts. Keep those in your local workspace, not in the public repository.
