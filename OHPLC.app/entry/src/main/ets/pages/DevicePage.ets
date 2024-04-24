import {
  DeviceItem,
  getDeviceImage,
  getConnectStatus,
  ConnectionState,
  getConnectColor,
  deviceTypeToName
} from "../common/ItemTypes"
import router from '@ohos.router';
import deviceManager from '@ohos.distributedHardware.deviceManager';
import { DeviceManagerInstance } from "../utils/DeviceManager"
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct DevicePage {
  private deviceId: string = router.getParams()["deviceId"];
  private deviceName: string = router.getParams()["deviceName"];
  private deviceType: deviceManager.DeviceType = router.getParams()["deviceType"];
  private networkId: string = router.getParams()["networkId"];
  private range: string = router.getParams()["range"];
  @State private state: ConnectionState = router.getParams()["state"];

  handleConnect() {
    DeviceManagerInstance.Connect(this.deviceId)
      .then(
        (re) => {
          if (re) {
            promptAction.showToast({ message: "连接成功！" })
            this.state = ConnectionState.CONNECT
          } else {
            promptAction.showToast({ message: "连接失败，请重试！" })
          }
        }
      )
  }

  handleDisconnect() {
    DeviceManagerInstance.DisConnect()
      .then(
        (re) => {
          if (re) {
            promptAction.showToast({ message: "连接已断开！" })
            this.state = ConnectionState.NO_CONNECT
          }
        }
      )
  }

  @Builder ConnectionButton() {
    Button(this.state == ConnectionState.CONNECT ? "断开连接" : "连接")
      .margin({ top: "50pv", bottom: "50pv" })
      .fontSize("18pv")
      .fontWeight("bold")
      .width("40%")
      .fontColor(this.state == ConnectionState.CONNECT ? "#E02020" : "#0091FF")
      .backgroundColor("white")
      .onClick(() => {
        if (this.state == ConnectionState.CONNECT)
          this.handleDisconnect(); else this.handleConnect();
      })
  }

  @Builder InfoCell(key: string, value: string) {
    Row() {
      Text(key)
        .fontSize("20pv")
      Text(value)
        .width("50%")
        .fontSize("20pv")
        .fontColor(getConnectColor(value))
    }
    .width("96%")
    .margin({ left: "2%", right: "2%", top: "20pv" })
    .padding({ left: "2%", right: "2%" })
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      style: { bottom: BorderStyle.Solid },
      color: "#ffdcdcdc",
      width: { bottom: 0.5 }
    })
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Image($r("app.media.left"))
            .width("40pv")
            .onClick(() => router.back())
        }
        .width("100%")
        .justifyContent(FlexAlign.Start)
        .padding({ left: "4%", right: "4%" })

        Image(getDeviceImage(this.state))
          .width("20%")
        Text(this.deviceName)
          .fontWeight("bold")
          .fontSize("32pv")
        Column() {
          this.InfoCell("设备名称", this.deviceName)
          this.InfoCell("设备ID", this.deviceId)
          this.InfoCell("设备类型",
            deviceTypeToName(this.deviceType))
          this.InfoCell("网络ID", this.networkId)
          this.InfoCell("设备距离", this.range)
          this.InfoCell("连接状态",
              this.state == ConnectionState.CONNECT ? "已连接" : (this.state == ConnectionState.NO_CONNECT ? "未连接" : "连接失败"))
        }
        .backgroundColor("white")
        .width("92%")
        .margin({ left: "4%", right: "4%", top: "20pv" })
        .padding({ bottom: "20pv" })
        .borderRadius("20pv")

        this.ConnectionButton()
      }
      .alignItems(HorizontalAlign.Center)
      .width("100%")
      .backgroundColor("#1887ceff")
      .padding({
        top: "4%"
      })
    }
    .scrollable(ScrollDirection.Vertical)
  }
}