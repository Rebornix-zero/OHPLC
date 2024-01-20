export class loginCheckResult {
  isValid: boolean;
  message: string;

  constructor(va: boolean=true, mess: string="") {
    this.isValid = va;
    this.message = mess;
  }
}

export function loginCheck(acc: string, pass: string):loginCheckResult {
  if(acc===""){
    return new loginCheckResult(false,"账号不能为空");
  }
  if(pass===""){
    return new loginCheckResult(false,"密码不能为空");
  }
  return new loginCheckResult();
}