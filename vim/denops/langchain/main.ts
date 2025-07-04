import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import { assert, is, isBoolean } from "jsr:@core/unknownutil@3.18.1";
import { ChatOpenAI } from "npm:@langchain/openai";
import { ChatPromptTemplate } from "npm:@langchain/core/prompts";

function stringToHexBytes(s: string): string[] {
    return [...s].map((c) =>
        `0x${c.charCodeAt(0).toString(16).padStart(2, "0")}`
    );
}

enum State {
    Human = "human",
    AI = "ai",
}

// Compare arr1 and arr2
function arrayEquals(arr1: any[], arr2: any[]): boolean {
    const arr1Length = arr1.length;
    const arr2Length = arr2.length;

    if (arr1Length !== arr2Length) {
        return false;
    }

    for (let i = 0; i < arr1Length; i++) {
        if (arr1[i] !== arr2[i]) {
            return false;
        }
    }

    return true;
}

export const main: Entrypoint = (denops: Denops) => {
    let controller = new AbortController();

    denops.dispatcher = {
        /**
         * Initialize the plugin.
         */
        async init() {
            const { name } = denops;
            await denops.cmd(
                `command! -nargs=? LangChain call denops#request_async('${name}', 'invoke', [<q-args>], {val -> v:true}, {val -> v:true })`,
            );
            await denops.cmd(
                `command! LangChainTerminate call denops#request_async('${name}', 'terminate', [], {val -> v:true}, {val -> v:true })`,
            );
        },
        terminate() {
            try {
                controller.abort();
            } catch (error) {
                console.error(error);
            }
        },
        /**
         * Invoke the command asynchronously.
         * @param {string} text - The command to invoke.
         */
        async invoke(text) {
            try {
                assert(text, is.String);

                controller = new AbortController();

                if (await fn.bufexists(denops, "denops-langchain")) {
                    denops.cmd("drop denops-langchain");
                } else {
                    denops.cmd("new");
                    denops.cmd("file denops-langchain");
                    denops.cmd("set buftype=nofile");
                    denops.cmd("set ft=markdown");
                    await denops.cmd(
                        "nnoremap <buffer> <C-c> <Cmd>LangChainTerminate<CR>",
                    );
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

                const lines = await fn.getbufline(
                    denops,
                    "denops-langchain",
                    1,
                    "$",
                );

                let messages: any[] = [];
                if (arrayEquals(lines, [""])) {
                    await fn.setbufline(
                        denops,
                        "denops-langchain",
                        "$",
                        ["# USER:", "", text, ""],
                    );
                } else {
                    let state = State.Human;
                    let lastState: string | null = null;
                    let content: string = "";
                    lines.forEach((elem) => {
                        if (elem === "# USER:") {
                            state = State.Human;
                        } else if (elem === "# AI:") {
                            state = State.AI;
                        }
                        if (lastState !== state) {
                            if (lastState !== null) {
                                messages.push([lastState, content]);
                                content = "";
                            }
                        } else {
                            content = content + elem;
                        }
                        lastState = state;
                    });
                    messages.push([lastState, content]);

                    await fn.appendbufline(
                        denops,
                        "denops-langchain",
                        "$",
                        ["", "# USER:", "", text],
                    );
                }
                messages.push([State.Human, text]);
                console.log(messages);

                const promptTemplate = ChatPromptTemplate.fromMessages(
                    messages,
                );

                const promptValue = await promptTemplate.invoke({
                    text: text,
                });
                const stream = await model.stream(promptValue, {
                    signal: controller.signal,
                });
                const chunks = [];

                await fn.appendbufline(
                    denops,
                    "denops-langchain",
                    "$",
                    ["", "# AI:", "", ""],
                );

                for await (const chunk of stream) {
                    const content = await fn.getbufoneline(
                        denops,
                        "denops-langchain",
                        "$",
                    );
                    const combined = content + chunk.content;
                    const lines = combined.split("\n");

                    if (lines.length > 0) {
                        await fn.setbufline(
                            denops,
                            "denops-langchain",
                            "$",
                            lines[0],
                        );
                        for (let i = 1; i < lines.length; i++) {
                            await fn.appendbufline(
                                denops,
                                "denops-langchain",
                                "$",
                                lines[i],
                            );
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
            } catch (error: any) {
                console.error(`Caught an error:`, error.name);
                console.error(`Error message:`, error.message);
            }
        },
    };
};
