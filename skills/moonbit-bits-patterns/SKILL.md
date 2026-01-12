---
name: moonbit-bits-patterns
description: Handle MoonBit bit-level parsing and pattern matching over BytesView slices, including using bytes[start:end] and bit patterns like [u1(i), u2(j), ..] or mixed-width fields. Use when extracting or validating packed fields from Bytes/BytesView with bit patterns.
---

# MoonBit bit pattern handling

Use this skill to parse or validate packed bits from `Bytes` via `BytesView` slices. Focus on bit patterns over `BytesView` and explicit bit widths, with clear endianness.

## Quick workflow

1. Slice `Bytes` to `BytesView` with `bytes[start:end]`.
2. Pattern match the `BytesView` using bit patterns like `[u1be(i), u2be(j), ..]`.
3. Bind bit fields to locals for decoding or validation, or use literal patterns to validate.

## Common patterns

- **Fixed header fields**
  - Match exact widths and bind names: `[u1be(flag), u3be(kind), u4be(ver), ..]`.
  - Use `_` to ignore fields you do not need: `[u1(_), u7(code), ..]`.

- **Validate leading bits**
  - Use literals for fixed values: `[u4be(0b1101), u4be(ver), ..]`.
  - If a pattern fails, add a fallback arm for error handling.

- **Capture tail data**
  - Use `..` to keep the remainder unparsed: `[u8be(tag), ..rest]`.
  - Recurse or pass `rest` to the next parser.

## Endianness and widths

- Prefer explicit bit-width patterns with `be`/`le` suffixes; plain `u<width>` is deprecated.
- Keep widths small and explicit to match protocol specs and avoid off-by-one bit errors.
- Use `u1be` for single-bit flags and group remaining bits into aligned fields.

## Pattern length and alignment

- Without `..`, patterns must consume the entire `BytesView`; extra bytes make the match fail.
- Bit patterns advance by bits; sub-byte widths leave you mid-byte, so match the remaining bits explicitly if the next field must be byte-aligned (for example `u1be(flag), u7be(rest)`).
- Little-endian bit patterns are only defined for byte-aligned widths (`u8le`, `u16le`, `u24le`, `u32le`, ...); unaligned `u<width>le` (like `u1le`) is deprecated.

## Result types

- Bit patterns return wider core types rather than width-specific ones:
  - `u8be`, `u16le`, `u32le` -> `UInt`
  - `i16le`, `i32le` -> `Int`
  - `u64le` -> `UInt64`
  - `i64le` -> `Int64`

## BytesView usage notes

- Always slice `Bytes` before matching so the pattern operates on `BytesView`.
- Keep slices tight for each parse step; do not match more data than needed.
- If you need length checks, match on a slice of a known length or add a guard before matching.

## Composition tips

- Separate parse stages by returning `(field, rest)` from a match; chain parsers on `rest`.
- For validation-only steps, match to `true/false` and return early on failure.
- Prefer explicit fallback arms to keep failures visible and intentional.

## Examples

- See `skills/moonbit-bits-patterns/references/examples.mbt.md` for `moonbit check` fenced snippets (run with `moon check`).

## BytesView usage notes

- Always slice `Bytes` before matching so the pattern operates on `BytesView`.
- Prefer local, small slices for each parse step to keep pattern matching clear.
- When working with protocol specs, keep widths explicit in the pattern for readability.
