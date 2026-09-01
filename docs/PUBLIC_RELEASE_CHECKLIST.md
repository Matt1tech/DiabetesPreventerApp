# Public release checklist

Copyright 2024-2026 Matt1tech. All rights reserved. Not licensed under MIT.

## Credentials and history

- Rotate the two Foodvisor keys that appeared in the original source.
- Rotate the original Django secret, database password, email app password, and
  tunnel credential, even if they are no longer active.
- Publish this clean repository, not the original repository history.
- Run a secret scanner against all commits before changing visibility.

## Privacy and intellectual property

- Confirm there are no user images, health records, email addresses, database
  dumps, FYP submissions, private diagrams, or identifying screenshots.
- Verify licenses for every image, icon, font, dataset, dependency, and model.
- Complete every pending entry in `docs/ASSET_PROVENANCE.md`.
- Keep evidence of dataset consent/provenance and model training parameters.
- Review university IP rules before selling or licensing FYP documentation.

## Application security

- Use unique production secrets from a managed secret store.
- Set `DJANGO_DEBUG=False`, explicit hosts/origins, TLS redirect, HSTS, secure
  cookies, a least-privilege PostgreSQL account, and encrypted backups.
- Add reverse-proxy request limits; Django upload limits are not a substitute.
- Run `python manage.py check --deploy`, tests, `pip-audit`, Bandit, Flutter
  tests, `flutter analyze`, and a mobile dependency audit.
- Prove with tests that one user cannot access another user's data.
- Complete an independent penetration test before processing real health data.

## Product and medical safety

- Define intended use, contraindications, risk classification, and escalation.
- Validate model performance on representative external data, including
  calibration, subgroup performance, uncertainty, and drift monitoring.
- Give users a privacy notice, consent flow, deletion/export controls, retention
  rules, and third-party data-use disclosure.
- Obtain legal and clinical review for each launch jurisdiction.
