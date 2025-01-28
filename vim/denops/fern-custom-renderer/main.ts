import type { Denops, Entrypoint } from "jsr:@denops/std@^7.0.0";
import { assert, is } from "jsr:@core/unknownutil@3.18.1";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as fs from "node:fs";
import { platform } from "node:os";
import { execSync } from "node:child_process";

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
        `command! -nargs=? FernCustomRenderer echomsg denops#request('${name}', 'hello', [<q-args>])`,
      );
    },

    hello(name) {
      assert(name, is.String);
      return `Fern Custom Renderer Enabled!: ${name || "Denops"}`;
    },

    async getRenderStrings(
      prevTextList,
      nodeList,
    ) {
      assert(nodeList, is.ArrayOf(is.Any));
      assert(prevTextList, is.ArrayOf(is.String));

      prevTextList = await Promise.all(
        prevTextList.map((prevText, idx) =>
          getSymlinkString(prevText, nodeList[idx]["_path"])
        ),
      );

      assert(prevTextList, is.ArrayOf(is.String));

      const prevTextLengthList = await Promise.all(
        prevTextList.map((prevText) => fn.strdisplaywidth(denops, prevText)),
      );

      const drawer_width = await vars.g.get(denops, "fern#drawer_width");
      assert(drawer_width, is.Number);

      const maxPrevTextLength = Math.max(
        Math.max(...prevTextLengthList) + 1,
        drawer_width + 2,
      );

      const promises = prevTextList.map((prevText, idx) =>
        getRenderStringsForEachNode(denops, maxPrevTextLength, [
          prevText,
          nodeList[idx],
        ])
      );

      const resultList = await Promise.all(promises);
      return JSON.stringify(resultList);
    },
  };
};

// deno-lint-ignore no-explicit-any
async function getRenderStringsForEachNode(denops: Denops, maxPrevTextLength: number, elem: any[]) {
  const prevText = elem[0];
  const path = elem[1]["_path"];

  const propertyString = await getPropertyString(path);

  const prevTextLength = await fn.strdisplaywidth(denops, prevText);
  assert(prevTextLength, is.Number);

  return prevText +
    " ".repeat(maxPrevTextLength - prevTextLength) +
    propertyString;
}

// deno-lint-ignore require-await
async function getSymlinkString(
  prevText: string,
  filePath: string,
): Promise<string> {
  try {
    const stats = fs.lstatSync(filePath);
    if (stats.isSymbolicLink()) {
      return prevText + " -> " + fs.readlinkSync(filePath);
    }
    return prevText;
  } catch (error) {
    assert(error, is.Any);
    console.error(`Error checking path: ${error.message}`);
    return prevText;
  }
}

// ファイルの詳細情報を表示する関数
async function getPropertyString(filePath: string): Promise<string> {
  assert(filePath, is.String);
  try {
    const stats = fs.lstatSync(filePath);

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
    return `${fileType}${permissionString} ${nlinkFormatted} ${owner} ${group} ${sizeFormatted} ${formattedDate}`;
  } catch (err) {
    assert(err, is.Any);
    console.error(
      `Error retrieving stats. Path=${filePath} Message=${err}\nStackTrace:\n${err.stack}`,
    );
    return "Error retrieving stats.";
  }
}

// パーミッションをrwx形式で表示する関数
function getPermissionString(mode: number): string {
  // Unixファイルモードのビットマスク
  const S_ISUID = 0o4000; // set-user-ID
  const S_ISGID = 0o2000; // set-group-ID
  const S_ISVTX = 0o1000; // sticky bit
  const S_IRUSR = 0o0400; // user read
  const S_IWUSR = 0o0200; // user write
  const S_IXUSR = 0o0100; // user execute
  const S_IRGRP = 0o0040; // group read
  const S_IWGRP = 0o0020; // group write
  const S_IXGRP = 0o0010; // group execute
  const S_IROTH = 0o0004; // other read
  const S_IWOTH = 0o0002; // other write
  const S_IXOTH = 0o0001; // other execute

  const checkBit = (flag: number, mask: number): boolean => (flag & mask) !== 0;

  // ユーザー、グループ、その他の権限を処理
  const userPermissions = [
    checkBit(mode, S_IRUSR) ? "r" : "-",
    checkBit(mode, S_IWUSR) ? "w" : "-",
    checkBit(mode, S_IXUSR)
      ? (checkBit(mode, S_ISUID) ? "s" : "x")
      : (checkBit(mode, S_ISUID) ? "S" : "-"),
  ].join("");

  const groupPermissions = [
    checkBit(mode, S_IRGRP) ? "r" : "-",
    checkBit(mode, S_IWGRP) ? "w" : "-",
    checkBit(mode, S_IXGRP)
      ? (checkBit(mode, S_ISGID) ? "s" : "x")
      : (checkBit(mode, S_ISGID) ? "S" : "-"),
  ].join("");

  const otherPermissions = [
    checkBit(mode, S_IROTH) ? "r" : "-",
    checkBit(mode, S_IWOTH) ? "w" : "-",
    checkBit(mode, S_IXOTH)
      ? (checkBit(mode, S_ISVTX) ? "t" : "x")
      : (checkBit(mode, S_ISVTX) ? "T" : "-"),
  ].join("");

  return userPermissions + groupPermissions + otherPermissions + " ";
}

// ファイルタイプを判定する関数
function getFileType(mode: number): string {
  const fileType = mode & fs.constants.S_IFMT;

  switch (fileType) {
    case fs.constants.S_IFREG: // Regular file
      return "-";
    case fs.constants.S_IFBLK: // Block special file
      return "b";
    case fs.constants.S_IFCHR: // Character special file
      return "c";
    case fs.constants.S_IFDIR: // Directory
      return "d";
    case fs.constants.S_IFLNK: // Symbolic link
      return "l";
    case fs.constants.S_IFIFO: // FIFO (named pipe)
      return "p";
    case fs.constants.S_IFSOCK: // Socket
      return "s";
    default:
      return "?";
  }
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
      try {
        const stdout = execSync("whoami").toString();
        const userName = stdout.trim();
        userCache[uid] = userName;
        resolve(userName);
      } catch (_err) {
        reject("ユーザー名の取得に失敗しました");
      }
    } else if (
      currentPlatform === "darwin" || currentPlatform === "linux"
    ) {
      // Unix系（Mac, Linux）では、`id -nu`コマンドを使用
      try {
        const stdout = execSync(`id -nu ${uid}`).toString();
        const userName = stdout.trim();
        userCache[uid] = userName;
        resolve(userName);
      } catch (_err) {
        reject("ユーザー名の取得に失敗しました");
      }
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
      try {
        const stdout = execSync(
          `dscl . -search /Groups PrimaryGroupID ${gid}`,
        )
          .toString();
        const groupName = stdout.split("\n")[0].split(" ")[0].split("\t")[0]; // 最初の行の最初のフィールドがグループ名
        groupCache[gid] = groupName; // キャッシュに保存
        resolve(groupName);
      } catch (_err) {
        reject("グループ名の取得に失敗しました");
      }
    } else if (currentPlatform === "linux") {
      // Linuxでは`getent group`を使用
      try {
        const stdout = execSync(`getent group ${gid}`).toString();
        // getent groupの出力は `group_name:x:GID:users` の形式
        const groupName = stdout.split(":")[0];
        groupCache[gid] = groupName; // キャッシュに保存
        resolve(groupName);
      } catch (_err) {
        reject("グループ名の取得に失敗しました");
      }
    } else {
      reject("対応していないプラットフォームです");
    }
  });
}
// vim: sw=2 sts=2:
