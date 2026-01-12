moonbit-skill-creator:
    moon build -C scripts/moonbit-skill-creator
    cp scripts/moonbit-skill-creator/target/wasm/release/build/mbt_exec.wasm skills/moonbit-skill-creator/scripts/script.wasm

install-skills:
    #!/usr/bin/env python3
    import os
    import shutil

    src_root = "skills"
    dst_root = os.path.expanduser("~/.codex/skills")

    os.makedirs(dst_root, exist_ok=True)
    for name in os.listdir(src_root):
        src = os.path.join(src_root, name)
        if not os.path.isdir(src):
            continue
        dst = os.path.join(dst_root, name)
        if os.path.exists(dst):
            shutil.rmtree(dst)
        shutil.copytree(src, dst)
