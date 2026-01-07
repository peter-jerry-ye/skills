///|
fn main {
  try {
    let args = @parse_args.parse(
      @wasi.args_get()[1:],
      flags=["help"],
      aliases={ "h": "help" },
      stop_early=true,
    )
    if args.flags.get("help") is Some(true) {
      @stdio.stdout.write_sync(helper_message)
      return
    }
    match args.positional {
      ["init-skill", skill_name] => {
        init_skill(skill_name)
        @stdio.stdout.write_sync(
          "Skill '\{skill_name}' initialized successfully.\n",
        )
      }
      arg =>
        @stdio.stdout.write_sync(
          (
            $|Unknown command: \{arg}
            $|
            $|\{helper_message}
          ),
        )
    }
  } catch {
    e => {
      try! @stdio.stderr.write_sync("Error: \{e}\n")
      @wasi.proc_exit(1)
    }
  }
}

///|
let helper_message : String =
  #|Usage : <execute wasm> <command> <options>
  #|
  #|The available commands are:
  #|- init-skill <skill_name> : Initializes a new skill with the given name
  #|
  #|To execute wasm, the directory where the skills will be put must be available with the name `skills`
  #|or under the current working directory with the name `skills`. For example:
  #|- `wasmtime run --dir=./path/to/skills::skills ./path/to/self.wasm`
  #|- `wasmer run --dir . ./path/to/self.wasm` where `./skills` exists
  #|- `node run script.js` where the `script.js` is:
  #|
  #|```js
  #|import { readFile } from 'node:fs/promises';
  #|import { WASI } from 'node:wasi';
  #|import { argv, env } from 'node:process';
  #|const wasi = new WASI({
  #|  version: 'preview1',
  #|  args: argv.slice(1), // eliminate `script.js`
  #|  env,
  #|  preopens: {
  #|    'skills': 'path/to/skills',
  #|  },
  #|});
  #|const wasm = await WebAssembly.compile(
  #|  await readFile(new URL('./path/to/self.wasm', import.meta.url)),
  #|);
  #|const instance = await WebAssembly.instantiate(wasm, wasi.getImportObject());
  #|wasi.start(instance);
  #|```
  #|
