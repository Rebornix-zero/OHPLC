import { DeviceItemList } from '../common/ConstData'
import {
  DeviceItem,
  getDeviceImage,
  getConnectStatus,
  getConnectColor
} from '../common/ItemTypes'
import common from '@ohos.app.ability.common';
import router from '@ohos.router';

@Component
export default struct ConnectionTab {
  private uiAbilityContext = getContext() as common.UIAbilityContext;

  @Builder DeviceCell(item: DeviceItem) {
    Row() {
      Row() {
        Image(getDeviceImage(item.connection_status))
          .width("30pv")
        Text(item.device_info.deviceName)
          .fontSize("20pv")
          .padding({ left: "6pv" })
          .fontColor(getConnectColor(item.connection_status))
      }

      Text(getConnectStatus(item.connection_status))
        .fontColor(getConnectColor(item.connection_status))
    }
    .onClick(() => router.pushUrl({
      url: "pages/DevicePage",
      params: item
    }))
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "4%",
      right: "4%"
    })
  }

  build() {
    Column() {
      Text("设备连接")
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