import type { Entrypoint } from "jsr:@denops/std@^7.0.0";
import * as fn from "jsr:@denops/std@^7.0.0/function";
import { assert, is } from "jsr:@core/unknownutil@3.18.1";
import * as fs from "node:fs";
import { platform } from "node:os";
import { exec } from "node:child_process";

interface GroupCache {
    [gid: number]: string;
}

interface UserCache {
    [uid: number]: string;
}

const userCache: UserCache = {};
const groupCache: GroupCache = {};

// This exported `main` function is automatically called by denops.vim.
//
// Note that this function is called on Vim startup, so it should execute as quickly as possible.
// Try to avoid initialization code in this function; instead, define an `init` API and call it from Vim script.
export const main: Entrypoint = (denops) => {
    // Overwrite `dispatcher` to define APIs.
    //
    // APIs are invokable from Vim script through `denops#request()` or `denops#notify()`.
    // Refer to `:help denops#request()` or `:help denops#notify()` for more details.
    // console.log("Hello, Denops from TypeScript!");
    denops.dispatcher = {
        async init() {
            const { name } = denops;
            await denops.cmd(
                `command! -nargs=? DenopsMymisc echomsg denops#request('${name}', 'hello', [<q-args>])`,
            );
        },

        hello(name) {
            assert(name, is.String);
            return `Hello Mymisc, ${name || "Denops"}!`;
        },

        async getRenderStrings(
            prev_text_list,
            max_prev_text_length,
            node_list,
        ) {
            assert(node_list, is.ArrayOf(is.Any));
            assert(prev_text_list, is.ArrayOf(is.String));
            assert(max_prev_text_length, is.Number);

            // const path_list = node_list.map((node) => node["_path"]);
            // console.log(path_list);

            // Python's zip
            const zipped = prev_text_list.map((
                val,
                idx,
            ) => [val, node_list[idx]]);

            const promises = zipped.map(async (elem) =>
                await this.getRenderStringsForEachNode(
                    max_prev_text_length,
                    elem,
                )
            );

            const result_list = await Promise.all(promises);

            // const result_list = prev_text_list.map((e) => e + " aaaa");
            return JSON.stringify(result_list);
        },

        async getRenderStringsForEachNode(max_prev_text_length, elem) {
            assert(elem, is.ArrayOf(is.Any));
            assert(max_prev_text_length, is.Number);
            const prev_text = elem[0];
            const path = elem[1]["_path"];

            const propertyString = await getPropertyString(path);

            const prev_text_length = await denops.call(
                "strdisplaywidth",
                prev_text,
            );
            assert(prev_text_length, is.Number);

            return prev_text +
                " ".repeat(max_prev_text_length - prev_text_length) +
                propertyString;
        },
    };
};

// ファイルの詳細情報を表示する関数
async function getPropertyString(filePath: string) {
    assert(filePath, is.String);
    try {
        const stats = fs.statSync(filePath);

        const permissionStringPromise = getPermissionString(stats.mode);
        const fileTypePromise = getFileType(stats.mode);
        // UID と GID をユーザー名とグループ名に変換
        const ownerPromise = getUserName(stats.uid);
        const groupPromise = getGroupName(stats.gid);
        const [permissionString, fileType, owner, group] = await Promise.all([
            permissionStringPromise,
            fileTypePromise,
            ownerPromise,
            groupPromise,
        ]);

        const size = stats.size; // ファイルサイズ（バイト）
        const sizeFormatted = String(size).padStart(10, " "); // 10桁で右寄せ（スペースで埋める）
        const nlinkFormatted = String(stats.nlink).padStart(4, " ");

        // 更新日時の取得（Locale形式に変換）
        const updatedAt = stats.mtime;

        // 日付の各部分を取得
        const year = updatedAt.getFullYear();
        const month = String(updatedAt.getMonth() + 1).padStart(2, "0"); // 月は0から始まるので1足す
        const day = String(updatedAt.getDate()).padStart(2, "0");
        const hours = String(updatedAt.getHours()).padStart(2, "0");
        const minutes = String(updatedAt.getMinutes()).padStart(2, "0");
        const seconds = String(updatedAt.getSeconds()).padStart(2, "0");

        // フォーマット化して返す
        const formattedDate =
            `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;

        // 結果を表示
        return `${fileType}${permissionString} ${nlinkFormatted} ${owner}:${group} ${formattedDate} ${sizeFormatted} byte`;
    } catch (err) {
        assert(err, is.Any);
        console.error(
            `Error retrieving stats. path: ${filePath} message: ${err}`,
        );
        return "プロパティの取得に失敗";
    }
}

// パーミッションをrwx形式で表示する関数
function getPermissionString(mode: number) {
    return new Promise((resolve, _) => {
        const permissions = [
            (mode & fs.constants.S_IRUSR) ? "r" : "-",
            (mode & fs.constants.S_IWUSR) ? "w" : "-",
            (mode & fs.constants.S_IXUSR) ? "x" : "-",
            (mode & fs.constants.S_IRGRP) ? "r" : "-",
            (mode & fs.constants.S_IWGRP) ? "w" : "-",
            (mode & fs.constants.S_IXGRP) ? "x" : "-",
            (mode & fs.constants.S_IROTH) ? "r" : "-",
            (mode & fs.constants.S_IWOTH) ? "w" : "-",
            (mode & fs.constants.S_IXOTH) ? "x" : "-",
        ];

        resolve(permissions.join(""));
    });
}

// ファイルタイプを判定する関数
function getFileType(mode: number) {
    return new Promise((resolve, _) => {
        if (mode & fs.constants.S_IFDIR) resolve("d"); // ディレクトリ
        if (mode & fs.constants.S_IFLNK) resolve("l"); // シンボリックリンク
        if (mode & fs.constants.S_IFREG) resolve("-"); // 通常ファイル
        resolve("?"); // その他のタイプ
    });
}

// 非同期関数を使って、コマンド実行結果を返すPromiseを作成します
/**
 * UIDからユーザー名を取得
 * @param {number} uid - ユーザーID
 * @returns {Promise<string>} ユーザー名
 */
function getUserName(uid: number): Promise<string> {
    return new Promise((resolve, reject) => {
        // もしキャッシュにUID/GIDの情報がある場合は、それを返す
        if (userCache[uid]) {
            resolve(userCache[uid]);
            return;
        }
        if (groupCache[uid]) {
            resolve(groupCache[uid]);
            return;
        }

        const currentPlatform = platform();

        if (currentPlatform === "win32") {
            // Windowsの場合、"whoami"コマンドでユーザー名を取得
            exec("whoami", (err, stdout, stderr) => {
                if (err || stderr) {
                    reject("ユーザー名の取得に失敗しました");
                } else {
                    const userName = stdout.trim();
                    userCache[uid] = userName;
                    resolve(userName);
                }
            });
        } else if (
            currentPlatform === "darwin" || currentPlatform === "linux"
        ) {
            // Unix系（Mac, Linux）では、`id -nu`コマンドを使用
            exec(`id -nu ${uid}`, (err, stdout, stderr) => {
                if (err || stderr) {
                    reject("ユーザー名の取得に失敗しました");
                } else {
                    const userName = stdout.trim();
                    userCache[uid] = userName;
                    resolve(userName);
                }
            });
        } else {
            reject("対応していないプラットフォームです");
        }
    });
}

/**
 * GIDからグループ名を取得
 * @param {number} gid - グループID
 * @returns {Promise<string>} グループ名
 */
function getGroupName(gid: number): Promise<string> {
    return new Promise((resolve, reject) => {
        // もしキャッシュにUID/GIDの情報がある場合は、それを返す
        if (groupCache[gid]) {
            resolve(groupCache[gid]);
            return;
        }
        if (userCache[gid]) {
            resolve(userCache[gid]);
            return;
        }

        const currentPlatform = platform();

        if (currentPlatform === "win32") {
            // Windowsではグループ名の取得は未対応
            reject("Windowsでのグループ名の取得は未対応");
        } else if (currentPlatform === "darwin") {
            // macOSでは`dscl`コマンドを使用してGIDからグループ名を取得
            exec(
                `dscl . -search /Groups PrimaryGroupID ${gid}`,
                (err, stdout, stderr) => {
                    if (err || stderr) {
                        reject("グループ名の取得に失敗しました");
                    } else {
                        const groupName =
                            stdout.split("\n")[0].split(" ")[0].split("\t")[0]; // 最初の行の最初のフィールドがグループ名
                        groupCache[gid] = groupName; // キャッシュに保存
                        resolve(groupName);
                    }
                },
            );
        } else if (currentPlatform === "linux") {
            // Linuxでは`getent group`を使用
            exec(`getent group ${gid}`, (err, stdout, stderr) => {
                if (err || stderr) {
                    reject("グループ名の取得に失敗しました");
                } else {
                    // getent groupの出力は `group_name:x:GID:users` の形式
                    const groupName = stdout.split(":")[0];
                    groupCache[gid] = groupName; // キャッシュに保存
                    resolve(groupName);
                }
            });
        } else {
            reject("対応していないプラットフォームです");
        }
    });
}
