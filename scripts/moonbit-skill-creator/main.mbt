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
      [unknown_command, ..] =>
        @stdio.stdout.write_sync(
          (
            $|Unknown command: \{unknown_command}
            $|
            $|\{helper_message}
          ),
        )
      [] =>
        @stdio.stdout.write_sync(
          (
            $|No command provided.
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
  #|Usage : [OPTIONS] <command>
  #|
  #|The available commands are:
  #|- init-skill <skill_name> : Initializes a new skill with the given name
  #|
  #|The available options are:
  #|- -h, --help : Show this help message
  #|
  #|To execute wasm, the directory where the skills will be put must be available with the name `skills`
  #|or under the current working directory with the name `skills`. For example:
  #|- `wasmtime run --dir=./path/to/skills::skills ./path/to/self.wasm`
  #|- `wasmer run --dir . ./path/to/self.wasm` where `./skills` exists
  #|- `node script.js ./path/to/skills` with the `script.js` next to this wasm file
  #|
