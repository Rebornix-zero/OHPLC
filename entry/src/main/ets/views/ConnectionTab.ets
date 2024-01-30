import { DeviceManagerInstance } from "../utils/DeviceManager"
import {
  DeviceItem,
  getDeviceImage,
  getConnectStatus,
  getConnectColor
} from '../common/ItemTypes'
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Component
export default struct ConnectionTab {
  private uiAbilityContext = getContext() as common.UIAbilityContext;
  @StorageLink("DeviceList") deviceList: DeviceItem[] = [];

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
    .onClick(() => {
      router.pushUrl({
        url: "pages/DevicePage",
        params: {
          deviceId: item.device_info.deviceId,
          deviceName: item.device_info.deviceName,
          deviceType: item.device_info.deviceType,
          networkId: item.device_info.networkId,
          // 未知原因，range发送字段可能为空，这会导致应用崩溃
          range: item.device_info.range ? item.device_info.range.toString() : "未知",
          state: item.connection_status,
        }
      })
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "4%",
      right: "4%"
    })
  }

  build() {
    Column() {
      Row() {
        Text()
        Text("设备连接")
          .fontWeight("bolder")
          .fontSize("24pv")
        Image($r("app.media.refresh"))
          .width("32pv")
          .onClick(() => {
            DeviceManagerInstance.reFetchTrustDeviceList()
              .then(
                (response) => {
                  if (response) {
                    promptAction.showToast({ message: "刷新成功！" })
                  } else {
                    promptAction.showToast({ message: "刷新失败，请重试！" })
                  }
                }
              )
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("84%")
      .margin({ left: "8%", top: "6%" })

      List() {
        ForEach(this.deviceList, (item: DeviceItem) => {
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