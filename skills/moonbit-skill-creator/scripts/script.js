import { readFile } from 'node:fs/promises';
import * as fs from 'node:fs/promises';
import { WASI } from 'node:wasi';
import { argv, env, exit } from 'node:process';

// Expected arg : `node script.js <skills_directory> [args...]`
if (argv.length < 3 || argv[2] === '--help' || argv[2] === '-h') {
    console.log(`Usage: node script.js <skills_directory> [args...]`)
    exit(0);
};
try {
    using _ = await fs.opendir(argv[2]);
} catch (e) {
    console.error(`Error: Directory '${argv[2]}' does not exist.`);
    exit(1);
}

const wasi = new WASI({
    version: 'preview1',
    args: argv.slice(2), // eliminate `node` `script.js` '<skills_directory>'
    env,
    preopens: {
        'skills': argv[2],
    },
});

const wasm = await WebAssembly.compile(
    await readFile(new URL('./script.wasm', import.meta.url)),
);
const instance = await WebAssembly.instantiate(wasm, wasi.getImportObject());
wasi.start(instance);