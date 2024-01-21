import ItemDataExample from '../common/data/Data'
import { DeviceItem } from '../common/type/ItemTypes'

@CustomDialog
struct CustomDialogExample {
  textValue: string = "222"
  cancel: () => void
  confirm: () => void
  controller: CustomDialogController

  build() {
    Column() {
      Text(this.textValue)
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
      }
      .margin({ bottom: 10 })
    }
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }
}

@Component
export default struct MultiControlTab {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: this.onCancel,
      confirm: this.onAccept,
      textValue: "333333",
    }), autoCancel: true
  })

  onCancel() {

  }

  onAccept() {

  }

  @Builder DeviceCell(item: DeviceItem) {
    Row() {
      Row() {
        Image(item.getDeviceImage())
          .width("30pv")
        Text(item.device_name)
          .fontSize("20pv")
          .padding({ left: "6pv" })
          .fontColor(item.getDeviceNameColor())
      }

      Text(item.getDeviceConnectStatus())
        .fontColor(item.getDeviceNameColor())
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "4%",
      right: "4%"
    })
  }

  build() {
    Column() {
      Text("多端协同")
        .margin({ top: "6%" })
        .fontWeight("bolder")
        .fontSize("24pv")
      List() {
        ForEach(ItemDataExample.getDeviceItemData(), (item: DeviceItem) => {
          ListItem() {
            this.DeviceCell(item)
          }
          .height("50pv")
          .margin({ bottom: "4pv" })
          .backgroundColor(Color.White)
          .borderRadius("10pv")
        })
      }
      .scrollBar(BarState.Auto)
      .width("100%")
      .height("88%")
      .margin({
        top: "4%",
      })
      .padding({
        left: "1%", right: "1%"
      })
    }
    .size({ width: "100%", height: "100%" })
  }
}