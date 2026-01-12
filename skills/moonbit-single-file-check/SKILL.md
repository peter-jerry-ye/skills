---
name: moonbit-single-file-check
description: MoonBit single-file mode for .mbt.md files.
---

# MoonBit single-file checks for .mbt.md

Use this skill to validate a standalone `.mbt.md` file with MoonBit’s single-file mode.

## What single-file mode means

Single-file mode is the `moon check`/`moon test` path that runs directly on a single `.mbt.md` file outside a MoonBit project.

- It applies only when the file is **not** inside a project.
- A project is present if a `moon.mod.json` exists above the file or a `moon.pkg.json` exists next to it.
- Execution (`moon run`) is not supported for `.mbt.md` single-file mode.

## Quick workflow

1. Confirm the file is truly standalone:
   - No `moon.mod.json` in parent directories.
   - No `moon.pkg.json` in the same directory as the `.mbt.md`.
2. Run `moon check <file>.mbt.md`.
3. Run `moon test <file>.mbt.md`.

## Non-standalone files

If the file sits inside a MoonBit project (a `moon.mod.json` above it and `moon.pkg.json` next to it), single-file mode does not apply.

- Do not use this skill’s commands in that case.
- Ask whether to run project-level `moon check`/`moon test` instead or relocate the file.

## Notes and conventions

- Single-file mode is for `.mbt.md` only; do not use it for `.mbt` sources here.
- Execution (`moon run`) is not supported for `.mbt.md` single-file mode.
- If warnings are expected in examples, prefer `#warnings("-<warning_id>")` scoped to the snippet.
