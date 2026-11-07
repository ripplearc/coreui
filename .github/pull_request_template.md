## What and why
<!-- Two or three sentences on what changed and why. Ticket: CA-... -->

## Size
<!-- Lines changed in production code, without tests and generated files. -->
<!-- Count inserted lines in lib/**/*.dart only; leave out the component .md files. -->

## How it was tested
<!-- The command you ran and its result. -->
`fvm flutter analyze --no-fatal-infos` →
`fvm flutter test` →
<!-- On macOS, golden tests fail outside Docker. See "Golden Tests with Docker" in the README. -->

## Checklist
- [ ] I read the PR text again after the last change, and every sentence is still true.
- [ ] Every "later" or "out of scope" item has a CA ticket number.
- [ ] Every TODO has its own ticket and link.
- [ ] New public code has `///` docs.
- [ ] For a UI change: I compared the screen with the storyboard frame at the same size.
- [ ] I replied on every review thread with what I changed, or why I did not change it.
