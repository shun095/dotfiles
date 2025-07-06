export const arrayEquals = (arr1: any[], arr2: any[]): boolean => {
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
};

