import ItemDataExample from '../common/Data'
import { SettingItem } from '../common/ItemTypes'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction';
import { getUserByID, updateUser, User } from "../utils/UserDB"
import common from '@ohos.app.ability.common';

@CustomDialog
struct ModifyDialog {
  private controller?: CustomDialogController;
  private uiAbilityContext = getContext() as common.UIAbilityContext
  @Link oldUser: User;
  @Link mode: number;
  private value: string = "";

  handleModify() {
    //构造出newUser
    let newUser = new User(this.oldUser.ID, this.oldUser.ACCOUNT,
      this.oldUser.PASSWORD, this.oldUser.AUTHORITY, this.oldUser.NAME,
      this.oldUser.EMAIL);
    switch (this.mode) {
      case 1: {
        newUser.NAME = this.value;
        break;
      }
      case 2: {
        newUser.EMAIL = this.value;
        break;
      }
      case 3: {
        newUser.ACCOUNT = this.value;
        break;
      }
      case 4: {
        newUser.PASSWORD = this.value;
        break;
      }
    }
    updateUser(this.uiAbilityContext, newUser)
      .then(
        (response) => {
          if (response) {
            promptAction.showToast({ message: "修改成功！" })
            this.oldUser = newUser;
            this.mode = 0;
            this.controller.close();
          } else {
            promptAction.showToast({ message: "修改失败！" })
          }
        }
      )
  }

  handleCancel() {
    this.controller.close();
  }

  modeToStr(): string {
    switch (this.mode) {
      case 1: {
        return "修改用户名";
      }
      case 2: {
        return "修改邮箱";
      }
      case 3: {
        return "修改账号";
      }
      case 4: {
        return "修改密码";
      }
      default: {
        return "ERROR";
      }
    }
  }

  build() {
    Column() {
      Text(this.modeToStr())
        .fontWeight("bold")
        .fontSize("20pv")
        .padding({ top: "20pv" })
      Column() {
        TextInput()
          .onChange((value: string) => {
            this.value = value;
          })
      }
      .width("100%")
      .padding({ left: "4%", right: "4%" })
      .margin({ top: "10pv" })
      .alignItems(HorizontalAlign.Start)

      Row() {
        Button("确定")
          .onClick(() => this.handleModify())
          .backgroundColor(0xffffff)
          .fontColor("blue")
          .fontSize("18pv")
        Button("取消")
          .onClick(() => this.handleCancel())
          .backgroundColor(0xffffff)
          .fontColor("red")
          .fontSize("18pv")
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding("10pv")
    }
    .width("100%")
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}


@Component
export default struct SettingTab {
  @State user: User = new User();
  private uiAbilityContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  @State mode: number = 0; //0正常，1修改用户名，2修改邮箱，3修改账号，4修改密码
  private modifyDialogController: CustomDialogController = new CustomDialogController({
    builder: ModifyDialog({ oldUser: $user, mode: $mode }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  })

  aboutToAppear() {
    getUserByID(this.uiAbilityContext, router.getParams()["userid"])
      .then(
        (response) => {
          this.user = response;
        }
      )
  }

  exitLogin(): void {
    promptAction.showDialog({
      title: "确定退出登录吗？",
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
          router.replaceUrl({ url: "pages/LoginPage" });
        }
      })
  }

  @Builder settingCell(item: SettingItem, index: number) {
    Row() {
      Row() {
        Image(item.img)
          .width("26pv")
        Text(item.title)
          .fontSize("18pv")
          .padding({ left: "8pv" })
      }

      if (item.need_toggle) {
        Toggle({ type: ToggleType.Switch, isOn: false })
      } else {
        Image($r("app.media.right"))
          .width("26pv")
      }
    }
    .onClick(() => {
      this.mode = index + 1;
      this.modifyDialogController.open();
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "16pv",
      right: "16pv",
      top: "4pv",
      bottom: "4pv"
    })
  }

  build() {
    Column() {
      Text("设置中心")
        .margin({ top: "6%" })
        .fontWeight("bolder")
        .fontSize("24pv")
      Row() {
        Image($r("app.media.user"))
          .width("15%")
        Column() {
          Text(this.user.NAME)
            .fontSize("22pv")
            .fontWeight("bold")
          Text(this.user.EMAIL)
            .fontColor("#BEBEBE")
        }
        .padding({ left: "5%" })
        .alignItems(HorizontalAlign.Start)
      }
      .width("90%")
      .backgroundColor(Color.White)
      .borderRadius("20pv")
      .padding("20pv")
      .margin({ top: "4%" })

      List() {
        ForEach(ItemDataExample.getSettingItemData(),
          (item: SettingItem, index) => {
            ListItem() {
              this.settingCell(item, index)
            }
            .height("48pv")
          })
      }
      .backgroundColor(Color.White)
      .width("90%")
      .margin({
        top: "6%",
      })
      .divider({
        strokeWidth: "0.5pv",
        color: Color.Grey,
        startMargin: "10pv",
        endMargin: "10pv"
      })
      .borderRadius("20pv")

      Button("退出登录")
        .fontColor(Color.Red)
        .fontSize("20pv")
        .backgroundColor(Color.White)
        .width("60%")
        .margin({ top: "30%" })
        .onClick(() => this.exitLogin())
    }
    .size({ width: "100%", height: "100%" })
  }
}