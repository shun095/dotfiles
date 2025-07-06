enum State {
    Human = "human",
    AI = "ai",
}

export const parseBufferLines = (lines: string[]) => {
    const messages: string[][] = [];
    let state = undefined;
    let lastState: string | undefined = undefined;
    let content: string | undefined = undefined;
    let skipEmptyLine: boolean = false;
    for (let index = 0; index < lines.length; index++) {
        const elem = lines[index];
        if (elem === "# USER:") {
            state = State.Human;
            skipEmptyLine = false;
        } else if (elem === "# AI:") {
            state = State.AI;
            skipEmptyLine = false;
        }

        if (lastState !== state) { // When role is changed.
            if (lastState !== undefined) {
                // For the non-first message
                if (content === undefined) {
                    content = "";
                }
                if (content.endsWith("\n")) {
                    content = content.slice(0, -1);
                }
                messages.push([lastState, content]);
                content = undefined;
                skipEmptyLine = true;
            } else {
                // For the first message
                content = undefined;
                skipEmptyLine = true;
            }
        } else { // When role is not changed.
            if (skipEmptyLine && elem === "") {
                // Skip to add empty line.
                skipEmptyLine = false;
            } else {
                if (content === undefined) {
                    content = elem;
                } else {
                    content = content + "\n" + elem;
                }
            }
        }
        lastState = state;
    }
    if (lastState !== undefined) {
        if (content === undefined) {
            content = "";
        }
        messages.push([lastState, content]);
    }
    return messages;
};
