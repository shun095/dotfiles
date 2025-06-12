// import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
// import { assert, is } from "jsr:@core/unknownutil@3.18.1";
// import { ChatOpenAI } from "npm:@langchain/openai";
// import { ChatPromptTemplate } from "npm:@langchain/core/prompts";
// import { AgentExecutor, createReactAgent } from "npm:@langchain/agents";
// import { createReactAgent } from "npm:@langchain/langgraph/prebuilt";

// import { pull } from "npm:@langchain/hub";

// export const main: Entrypoint = (denops: Denops) => {
//     denops.dispatcher = {
//         async init() {
//             const { name } = denops;
//             await denops.cmd(
//                 `command! -nargs=? LangChain echomsg denops#request('${name}', 'hello', [<q-args>])`,
//             );
//         },
//         hello(name) {
//             assert(name, is.String);
//             return `LangChain Enabled!: ${name || "Denops"}`;


// // Define the tools the agent will have access to.
// const tools = [
//   {
//     name: "webSearch",
//     description: "A tool to perform web search",
//     invoke: async (input) => {
//       const results = await simpleWebSearch(input);
//       return results;
//     },
//   },
// ];

// // Get the prompt to use - you can modify this!
// // If you want to see the prompt in full, you can at:
// // https://smith.langchain.com/hub/hwchase17/react
// const prompt = await pull<PromptTemplate>("hwchase17/react");

// // Default Llama.cpp URL
// const OPENAI_API_BASE = "http://localhost:8080/v1";
// // Dummy key is fine for local API (not needed for Llama.cpp)
// const OPENAI_API_KEY = "none";
// const llm = new ChatOpenAI({
//     configuration: {
//         baseURL: OPENAI_API_BASE,
//         apiKey: OPENAI_API_KEY,
//     },
//     modelName: "gpt-4o",
//     maxTokens: -1,
//     streaming: true,
// });


// const agent = await createReactAgent({
//   llm,
//   tools,
//   prompt,
// });

// const agentExecutor = new AgentExecutor({
//   agent,
//   tools,
// });

// const result = await agentExecutor.invoke({
//   input: "What is LangChain?",
// });

// console.log(result);



//         },
//     };
// };
