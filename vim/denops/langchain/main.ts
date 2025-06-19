import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
import { assert, is } from "jsr:@core/unknownutil@3.18.1";
import { ChatOpenAI } from "npm:@langchain/openai";
import { HumanMessage, SystemMessage } from "npm:@langchain/core/messages";
import { ChatPromptTemplate } from "npm:@langchain/core/prompts";

export const main: Entrypoint = (denops: Denops) => {
    const OPENAI_API_BASE = "http://localhost:8080/v1";
    const OPENAI_API_KEY = "none";
    const model = new ChatOpenAI({
        configuration: {
            baseURL: OPENAI_API_BASE,
            apiKey: OPENAI_API_KEY,
        },
        modelName: "gpt-4o",
        maxTokens: -1,
        streaming: true,
    });

    denops.dispatcher = {
        async init() {
            const { name } = denops;
            await denops.cmd(
                `command! -nargs=? LangChain echomsg denops#request('${name}', 'invoke', [<q-args>])`,
            );
        },
        async invoke(text) {
            try {
                assert(text, is.String);

                const systemTemplate =
                    "Translate the following from English into {language}";

                const promptTemplate = ChatPromptTemplate.fromMessages([
                    ["system", systemTemplate],
                    ["user", "{text}"],
                ]);

                const promptValue = await promptTemplate.invoke({
                    language: "italian",
                    text: "hi!",
                });

                // const stream = await model.stream(promptValue);

                // iterate 1 to 10 and log for each 1 sec.
                for (let i = 0; i < 10; i++) {
                    await new Promise((resolve) => setTimeout(resolve, 1000)); // 1秒待機
                    console.log(i);
                }

                // const chunks = [];
                // for await (const chunk of stream) {
                //     chunks.push(chunk);
                //     console.log(`${chunk.content}|`);
                // }
            } catch (error) {
                console.error(error);
            }
        },
    };
};
