# Contributing

Jacky-OPC welcomes contributions that make the production system easier to use, easier to adapt, and safer to publish.

## Good Contributions

- Clearer templates for user research, topic research, benchmark analysis, and review.
- Better scripts that keep paths configurable and avoid hard-coded personal directories.
- More practical examples using fictional data.
- Safer publishing checks and privacy guidance.
- Documentation that helps non-technical creators understand the workflow.

## Contribution Rules

- Do not submit real API keys, account tokens, analytics exports, customer records, or unpublished private drafts.
- Use fictional examples when demonstrating workflow.
- Keep scripts portable. Read `OPC_ROOT` from the environment instead of hard-coding a local path.
- Keep skill instructions specific and executable.
- Avoid adding dependencies unless they remove real friction.

## Local Checks

Before opening a pull request, run:

```bash
bash -n scripts/*.sh
rg -n "/Users/|API Key|api_key|token|secret|password|AIza" .
```

The second command may find documentation examples. Make sure no real credential or personal path is present.

