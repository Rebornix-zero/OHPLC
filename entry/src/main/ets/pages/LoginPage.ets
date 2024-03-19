import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { loginCheck, loginCheckResult } from '../utils/Login'

@Entry
@Component
struct LoginPage {
  @State account: string = "";
  @State password: string = "";
  private  uiAbilityContext: common.UIAbilityContext =getContext() as common.UIAbilityContext;

  exit() {
    this.uiAbilityContext.terminateSelf();
  }

  onBackPress() {
    promptAction.showDialog({
      title: "确定退出OHPLC吗？",
      buttons: [{
        text: '退出',
        color: 'red',
      }, {
        text: '取消',
        color: '#007DFF',
      }]
    })
      .then((data) => {
        if (data.index == 0) {
          this.exit();
        }
      })
    return true;
  }

  async login(): Promise<void> {
    let re:loginCheckResult=await loginCheck(this.uiAbilityContext,this.account,this.password);
    if(re.userid==-1){
      promptAction.showToast({
        message: re.message
      });
      return;
    }
    promptAction.showDialog({
      title: "登录成功!",
      message: `用户 ${this.account}，欢迎！`,
      buttons: [{
        text: '确认登录',
        color: '#007DFF',
      }, {
        text: '取消登录',
        color: 'red',
      }]
    })
      .then((data) => {
        if (data.index == 0) {
          router.replaceUrl({ url: "pages/MainPage",
            params: {
              userid :re.userid
              // userid:0
            }
          });
        }
      })
    return;
  }

  routeToAccountManager(){
    router.pushUrl({url:"pages/AccountManagerPage"});
  }

  build() {
    Column() {
      Image($r("app.media.icon"))
        .width("25%")
      Text("欢迎使用OHPLC")
        .fontSize("24pv")
        .fontWeight("bold")
        .margin({ top: "4%" })
      Text("登录账号以获取更多服务")
        .fontSize("16pv")
        .fontColor("#BEBEBE")
        .margin({ top: "2%" })
      TextInput({ placeholder: "账号" })
        .onChange((value: string) => {
          this.account = value;
        })
        .type(InputType.Normal)
        .margin({ top: "10%", left: "5%", right: "5%" })
        .padding({ top: "12pv", bottom: "12pv" })
      TextInput({ placeholder: "密码" })
        .onChange((value: string) => {
          this.password = value;
        })
        .type(InputType.Password)
        .margin({ top: "8%", left: "5%", right: "5%" })
        .padding({ top: "12pv", bottom: "12pv" })
      Button("登录")
        .onClick(() => this.login())
        .width("40%")
        .margin({ top: "12%" })
      Text("账号管理")
        .onClick(() => promptAction.showToast({ message: "注册" }))
        .fontColor("#007DFF")
        .margin({ top: "5%" })
        .decoration({ type: TextDecorationType.Underline })
        .onClick(()=>this.routeToAccountManager())
    }
    .alignItems(HorizontalAlign.Center)
    .width("100%")
    .height("100%")
    .backgroundColor("#F0FFFF")
    .padding({
      top: "20%"
    })
  }
}
