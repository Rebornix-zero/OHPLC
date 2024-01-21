import ItemDataExample from '../common/data/Data'
import { SettingItem } from '../common/type/ItemTypes'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction';

@Component
export default struct SettingTab {
  @State account: string = router.getParams()["account"];
  @State password: string = router.getParams()["password"];
  @State email: string = router.getParams()["email"];
  @State name: string = router.getParams()["name"];

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

  @Builder settingCell(item: SettingItem) {
    Row() {
      Row() {
        Image(item.img)
          .width("22pv")
        Text(item.title)
          .fontSize("16pv")
          .padding({ left: "4pv" })
      }

      if (item.need_toggle) {
        Toggle({ type: ToggleType.Switch, isOn: false })
      } else {
        Image($r("app.media.right"))
          .width("20pv")
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "10pv",
      right: "10pv"
    })
  }

  build() {
    Column() {
      Text("设置中心")
        .margin({ top: "8%" })
        .fontWeight("bolder")
        .fontSize("24pv")
      Row() {
        Image($r("app.media.user"))
          .width("15%")
        Column() {
          Text(this.name)
            .fontSize("20pv")
            .fontWeight("bold")
          Text(this.email)
            .fontColor("#BEBEBE")
        }
        .padding({ left: "5%" })
        .alignItems(HorizontalAlign.Start)
      }
      .width("90%")
      .backgroundColor(Color.White)
      .borderRadius("20pv")
      .padding("20pv")
      .margin({ top: "5%" })

      List() {
        ForEach(ItemDataExample.getSettingItemData(), (item: SettingItem) => {
          ListItem() {
            this.settingCell(item)
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
        .backgroundColor(Color.White)
        .width("60%")
        .margin({ top: "30%" })
        .onClick(() => this.exitLogin())
    }
    .size({ width: "100%", height: "100%" })
  }
}