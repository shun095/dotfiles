import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import { assert, is } from "jsr:@core/unknownutil@3.18.1";
import { ChatOpenAI } from "npm:@langchain/openai";
import { ChatPromptTemplate } from "npm:@langchain/core/prompts";
import { MessageContent } from "npm:@langchain/core/messages";
import { getTools } from "./agent_tools.ts";
import { stringToHexBytes } from "./debug_utils.ts";
import { arrayEquals } from "./common_utils.ts";
import { parseBufferLines } from "./agent_utils.ts";

/**
 * Main entry point method for Denos.
 * @param {Denops} denops - Denops instance.
 */
export const main: Entrypoint = (denops: Denops) => {
    let controller: AbortController;
    let model: ChatOpenAI;
    let lastUsedBuffer: string;

    // Functions which uses denops instance
    const appendBuffer = async (newMessageContent: MessageContent) => {
        assert(newMessageContent, is.String);

        const content = await fn.getbufoneline(
            denops,
            "denops-langchain",
            "$",
        );
        const combined = content + newMessageContent;
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
    };

    const prepareBuffer = async () => {
        if (await fn.bufexists(denops, "denops-langchain")) {
            await denops.cmd("drop denops-langchain");
        } else {
            await denops.cmd("rightbelow vs new");
            await denops.cmd("set buftype=nofile");
            await denops.cmd("file denops-langchain");
            await denops.cmd("set ft=markdown");
            await denops.cmd(
                "nnoremap <buffer> <C-c> <Cmd>LangChainTerminate<CR>",
            );
            await denops.cmd(
                "nnoremap <buffer> <CR> <Cmd>LangChainSubmit<CR>",
            );
        }
    };

    // Main dispatcher
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
            await denops.cmd(
                `command! LangChainSubmit call denops#request_async('${name}', 'invokeOnChat', [], {val -> v:true}, {val -> v:true })`,
            );

            const baseURL = "http://localhost:8080/v1";
            const apiKey = await vars.environment.get(
                denops,
                "CODECOMPANION_API_KEY",
            ) as string;

            model = new ChatOpenAI({
                configuration: {
                    baseURL: baseURL,
                    apiKey: apiKey,
                },
                modelName: "gpt-4o",
                maxTokens: -1,
                streaming: true,
            });
        },
        /**
         * Terminate the plugin.
         */
        terminate() {
            try {
                controller.abort();
            } catch (error) {
                console.error(error);
            }
        },
        async invokeOnChat() {
            let messages: any[] = [];
            const linesNew = await fn.getbufline(
                denops,
                "denops-langchain",
                1,
                "$",
            );
            messages = parseBufferLines(linesNew);
            console.debug(messages);

            const promptTemplate = ChatPromptTemplate.fromMessages(
                messages,
            );

            const promptValue = await promptTemplate.invoke({});
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
                await appendBuffer(chunk.content);
                console.debug(
                    `chunk.content: ${chunk.content} - ${
                        stringToHexBytes(chunk.content.toString())
                    }`,
                );
                chunks.push(chunk);
            }

            await fn.appendbufline(
                denops,
                "denops-langchain",
                "$",
                ["", "# USER:", "", ""],
            );
            console.debug(chunks);
        },
        /**
         * Invoke the command asynchronously.
         * @param {string} text - The command to invoke.
         */
        async invoke(text) {
            try {
                assert(text, is.String);

                controller = new AbortController();

                await prepareBuffer();

                const lines = await fn.getbufline(
                    denops,
                    "denops-langchain",
                    1,
                    "$",
                );

                // If the buffer is empty, add user prompt
                if (arrayEquals(lines, [""])) {
                    await fn.setbufline(
                        denops,
                        "denops-langchain",
                        "$",
                        ["# USER:", "", ""],
                    );
                }

                await appendBuffer(text);

                await this.invokeOnChat();
            } catch (error: any) {
                console.error(`Caught an error:`, error.name);
                console.error(`Error message:`, error.message);
            }
        },
    };
};
