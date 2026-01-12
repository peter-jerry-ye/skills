---
title: MoonBit bit pattern examples
---

# Examples

Note: bit pattern bindings return wider core types (e.g., `u16le` -> `UInt`, `i16le` -> `Int`). Use `moonbit check` fences; run them with `moon check`. Unaligned `u<width>le` (non-byte multiples) is deprecated; byte-aligned `u8le`, `u16le`, `u24le`, `u32le` are fine.

```moonbit check
#warnings("-unused_value")
fn parse_header(bytes : Bytes) -> (UInt, UInt, UInt) {
  let view = bytes[0:1]
  match view {
    [u1be(flag), u3be(kind), u4be(ver)] => (flag, kind, ver)
    _ => (0, 0, 0)
  }
}
```

```moonbit check
#warnings("-unused_value")
fn parse_tag_and_rest(bytes : Bytes) -> (UInt, BytesView) {
  let view = bytes[0:2]
  match view {
    [u8be(tag), ..rest] => (tag, rest)
    _ => (0, bytes[0:0])
  }
}
```

```moonbit check
#warnings("-unused_value")
fn parse_magic(bytes : Bytes) -> Bool {
  let view = bytes[0:1]
  match view {
    [u4be(0b1101), u4be(_)] => true
    _ => false
  }
}
```

```moonbit check
///|
test "pattern length and bit alignment" {
  let one = b"\x80"[:]
  let two = b"\x80\x00"[:]
  let two_bits = b"\x80\x02"[:]

  let exact_len_match = match one {
    [u8be(_)] => true
    _ => false
  }
  let extra_len_match = match two {
    [u8be(_)] => true
    _ => false
  }
  let extra_len_with_rest = match two {
    [u8be(_), ..] => true
    _ => false
  }
  inspect(exact_len_match, content="true")
  inspect(extra_len_match, content="false")
  inspect(extra_len_with_rest, content="true")

  let bit_only_value = match one {
    [u1be(bit)] => bit
    _ => 0
  }
  let bit_and_rest_bit = match one {
    [u1be(bit), u7be(_)] => bit
    _ => 0
  }
  let bit_and_rest_rest = match one {
    [u1be(_), u7be(rest)] => rest
    _ => 0
  }
  let bit_follow_bit = match two_bits {
    [u1be(bit), u8be(_)] => bit
    _ => 0
  }
  let bit_follow_next = match two_bits {
    [u1be(_), u8be(next)] => next
    _ => 0
  }
  let bit_aligned_next = match two_bits {
    [u1be(_), u7be(_), u8be(next)] => next
    _ => 0
  }
  inspect(bit_only_value, content="1")
  inspect(bit_and_rest_bit, content="1")
  inspect(bit_and_rest_rest, content="0")
  inspect(bit_follow_bit, content="1")
  inspect(bit_follow_next, content="0")
  inspect(bit_aligned_next, content="2")
}
```
