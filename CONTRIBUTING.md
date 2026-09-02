# Contributing

Use the repository workflow:

`feature/{name}` → `dev` → `master`/`main` → `release`

Before opening a pull request:

1. Keep the change focused and link its issue.
2. Add or update tests for changed behavior.
3. Run the backend tests, Flutter analysis, and repository security scans.
4. Confirm the diff contains no secret, personal data, model binary, database,
   generated output, or unlicensed asset.
5. Explain security, privacy, and medical-safety implications in the pull
   request description.

Never include real patient or user data in tests. Use clearly fictional fixtures.
