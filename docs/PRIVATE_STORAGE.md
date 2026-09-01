# Private storage boundary

Copyright 2024-2026 Matt1tech. All rights reserved. Not licensed under MIT.

All material that must not be published belongs in one local directory at the
repository root: `.private/`. Git ignores the entire directory.

```text
.private/
├── .env
├── backend_media/
├── cloudflare/
├── database/
├── editor/
├── fyp_documents/
├── models/
└── tooling/
```

The backend reads `.private/.env` automatically. Its default SQLite, uploaded
media, and model paths also point inside `.private`. Deployments may override
`DIABETES_PRIVATE_DIR` and individual environment variables.

`.private` is an organization boundary, not encryption. Protect it with OS
permissions, full-disk encryption, encrypted backups, and a retention policy.
Never use real private data in screenshots, demos, tests, issues, or pull requests.

Public support contact values can be supplied to Flutter with
`--dart-define=SUPPORT_EMAIL=...` and `--dart-define=SUPPORT_PHONE=...`. These
values are visible in the built app, so use business contact details rather
than private personal details.
