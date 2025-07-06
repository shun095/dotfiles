export const stringToHexBytes = (s: string): string[] => {
    return [...s].map((c) =>
        `0x${c.charCodeAt(0).toString(16).padStart(2, "0")}`
    );
};
