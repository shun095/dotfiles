import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
import { assert, is } from "jsr:@core/unknownutil@3.18.1";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";

interface Cache {
  [key: number]: string;
}

const userCache: Cache = {};
const groupCache: Cache = {};

export const main: Entrypoint = (denops: Denops) => {
  denops.dispatcher = {
    async init() {
      const { name } = denops;
      await denops.cmd(
        `command! -nargs=? ThemisDenops echomsg denops#request('${name}', 'hello', [<q-args>])`,
      );
    },

    hello(name) {
      assert(name, is.String);
      return `ThemisDenops Enabled!: ${name || "Denops"}`;
    },

  };
};

