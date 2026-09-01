# Security policy

## Supported version

Security fixes are applied to the latest `main` branch. This academic product
has not undergone independent clinical or penetration-test certification.

## Report a vulnerability

Do not open a public issue containing credentials, personal health data, or an
exploit. Contact the maintainer privately through the security contact on the
GitHub profile and include reproduction steps, affected versions, and impact.

## Security expectations

- Never commit `.private/`, `.env`, databases, media uploads, FYP submissions,
  provider credentials, datasets, or trained model binaries.
- Put production secrets in a managed secret store or deployment environment.
- Rotate any credential that has ever appeared in source control; deleting the
  current file does not remove it from old commits.
- Run Django behind TLS and a reverse proxy with request-size and rate limits.
- Use a dedicated least-privilege database account and encrypted backups.
- Treat model files as executable supply-chain artifacts. Load only reviewed
  files from trusted storage and record their hash and provenance.
- Do not send production health data to third parties without consent, a lawful
  basis, a retention policy, and an appropriate data-processing agreement.

## Medical safety

Predictions and recommendations are informational only. They must not diagnose,
treat, or replace a qualified healthcare professional. A production release
requires clinical validation, privacy review, threat modeling, monitoring, and
compliance analysis for every jurisdiction where it is offered.
