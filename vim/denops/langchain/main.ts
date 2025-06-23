import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import { assert, is } from "jsr:@core/unknownutil@3.18.1";
import { ChatOpenAI } from "npm:@langchain/openai";
import { ChatPromptTemplate } from "npm:@langchain/core/prompts";

function stringToHexBytes(s: string): string[] {
    return [...s].map((c) =>
        `0x${c.charCodeAt(0).toString(16).padStart(2, "0")}`
    );
}

export const main: Entrypoint = (denops: Denops) => {
    denops.dispatcher = {
        /**
         * Initialize the plugin.
         */
        async init() {
            const { name } = denops;
            await denops.cmd(
                `command! -nargs=? LangChain echomsg denops#request_async('${name}', 'invoke', [<q-args>], {val -> v:true}, {val -> v:true })`,
            );
        },
        /**
        * Invoke the command asynchronously.
        * @param {string} text - The command to invoke.
        */
        async invoke(text) {
            try {
                assert(text, is.String);

                await denops.cmd("noremap <C-c> <Cmd>call denops#interrupt()<CR><C-c>")
                // const systemTemplate = "You are a helpful AI assistant.";

                const promptTemplate = ChatPromptTemplate.fromMessages([
                    ["user", "{text}"],
                ]);

                const promptValue = await promptTemplate.invoke({
                    text: text,
                });

                if (await fn.expand(denops, "%") !== "denops-langchain") {
                    if (await fn.bufexists(denops, "denops-langchain")) {
                        denops.cmd("drop denops-langchain");
                    } else {
                        denops.cmd("new");
                        denops.cmd("file denops-langchain");
                    }
                }

                const OPENAI_API_BASE = "http://localhost:8080/v1";
                const OPENAI_API_KEY = await vars.environment.get(
                    denops,
                    "CODECOMPANION_API_KEY",
                ) as string;
                const model = new ChatOpenAI({
                    configuration: {
                        baseURL: OPENAI_API_BASE,
                        apiKey: OPENAI_API_KEY,
                    },
                    modelName: "gpt-4o",
                    maxTokens: -1,
                    streaming: true,
                });

                const stream = await model.stream(promptValue);
                const chunks = [];

                for await (const chunk of stream) {
                    const content = await fn.getline(denops, "$");
                    const combined = content + chunk.content;
                    const lines = combined.split("\n");

                    if (lines.length > 0) {
                        await fn.setline(denops, "$", lines[0]);
                        for (let i = 1; i < lines.length; i++) {
                            await fn.append(denops, "$", lines[i]);
                        }
                    }
                    console.debug(
                        `chunk.content: ${chunk.content} - ${
                            stringToHexBytes(chunk.content.toString())
                        }`,
                    );
                    chunks.push(chunk);
                }

                console.debug(chunks);
            } catch (error) {
                console.error(error);
            }
        },
    };
};
