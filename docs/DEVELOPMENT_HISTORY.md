# Development history

Copyright 2024-2026 Matt1tech. All rights reserved. Not licensed under MIT.

This describes the software's evolution; it is not a copy of the private FYP
submission.

## 2024: first product implementation

The recorded Git history begins in July 2024. The Flutter/Django product grew
iteratively around daily health records, meal nutrition, physical activity and
stress input, monthly risk charts, user profiles, password reset, dietary
customization, recommendations, and reports. A Random Forest risk workflow and
its feature preparation were integrated into Django.

During August 2024, the interface and app identity were refined, profile-image
handling was completed, the recommendation data model and filtering logic were
added, and activity, risk, and health reports were completed.

## 2024-2025: persistence and deployment work

The backend was migrated toward PostgreSQL in November 2024. Deployment host,
CORS, and Flutter API-address configuration changed during February and March
2025 as the product moved beyond local-only execution.

## 2026: open-source security hardening

A clean public repository was created rather than publishing the historical
working tree. Personal media, database exports, tunnel credentials, FYP files,
editor state, datasets, and the trained model were excluded. Configuration was
moved to environment variables and `.private/`; authentication became the API
default; ownership checks, throttling, upload validation, safer OTP handling,
reduced logging, secure response serialization, and server-side food-analysis
credential handling were introduced.

Clinical validation, privacy/compliance work, penetration testing, and model
governance remain required before real-world medical use.
