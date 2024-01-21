import { getUserID } from "../utils/UserDB"
import common from '@ohos.app.ability.common';

export class loginCheckResult {
  //如果验证成功，userid将会返回数据库中对应条目的ID，message为空
  //否则，userid返回-1，且message附带验证失败的信息
  userid: number;
  message: string;

  constructor(id: number, mess: string) {
    this.userid = id;
    this.message = mess;
  }
}

export async function loginCheck(
    context: common.UIAbilityContext, acc: string, pass: string
): Promise<loginCheckResult> {
  //TODO:完成登录验证
  if (acc === "") {
    return new loginCheckResult(-1, "账号不能为空！");
  }
  if (pass === "") {
    return new loginCheckResult(-1, "密码不能为空！");
  }
  let result = await getUserID(context, acc, pass);
  if (result == -1) {
    //无匹配
    return new loginCheckResult(-1, "没有匹配的账号！");
  } else {
    //唯一匹配成功
    return new loginCheckResult(result, "")
  }
}