import { DeviceItemList } from '../common/ConstData'
import { DeviceItem } from '../common/ItemTypes'
import common from '@ohos.app.ability.common';
import router from '@ohos.router';

@Component
export default struct ConnectionTab {
  private uiAbilityContext = getContext() as common.UIAbilityContext;

  @Builder DeviceCell(item: DeviceItem) {
    Row() {
      Row() {
        Image(item.getDeviceImage())
          .width("30pv")
        Text(item.device_info.deviceName)
          .fontSize("20pv")
          .padding({ left: "6pv" })
          .fontColor(item.getDeviceNameColor())
      }

      Text(item.getDeviceConnectStatus())
        .fontColor(item.getDeviceNameColor())
    }
    .onClick(()=>router.pushUrl({url:"pages/DevicePage"}))
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "4%",
      right: "4%"
    })
  }

  build() {
    Column() {
      Text("连接状态")
        .margin({ top: "6%" })
        .fontWeight("bolder")
        .fontSize("24pv")

      List() {
        ForEach(DeviceItemList, (item: DeviceItem) => {
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