import {
  DeviceItem,
  getDeviceImage,
  getConnectStatus,
  ConnectionState,
  getConnectColor,
  deviceTypeToName
} from "../common/ItemTypes"
import router from '@ohos.router';

@Entry
@Component
struct DevicePage {
  @State device: DeviceItem = (router.getParams() as DeviceItem);

  handleConnect() {
    console.log("Connect")
  }

  handleDisconnect() {
    console.log("Disconnect")
  }

  @Builder ConnectionButton() {
    Button(this.device.connection_status == ConnectionState.CONNECT ? "断开连接" : "连接")
      .margin({ top: "100pv" })
      .fontSize("18pv")
      .fontWeight("bold")
      .width("40%")
      .fontColor(this.device.connection_status == ConnectionState.CONNECT ? "#E02020" : "#0091FF")
      .backgroundColor("white")
      .onClick(() => {
        if (this.device.connection_status == ConnectionState.CONNECT)
          this.handleDisconnect(); else this.handleConnect();
      })
  }

  @Builder InfoCell(key: string, value: string) {
    Row() {
      Text(key)
        .fontSize("20pv")
      Text(value)
        .fontSize("20pv")
        .fontColor(getConnectColor(value))
    }
    .width("96%")
    .margin({ left: "2%", right: "2%", top: "20pv" })
    .padding({ left: "2%", right: "2%" })
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      style: { bottom: BorderStyle.Solid },
      color: Color.Grey,
      width: { bottom: 0.5 }
    })
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.left"))
          .width("40pv")
          .onClick(() => router.back())
      }
      .width("100%")
      .justifyContent(FlexAlign.Start)
      .padding({ left: "4%", right: "4%" })

      Image(getDeviceImage(this.device.connection_status))
        .width("20%")
      Text(this.device.device_info.deviceName)
        .fontWeight("bold")
        .fontSize("32pv")
      Column() {
        this.InfoCell("设备名称", this.device.device_info.deviceName)
        this.InfoCell("设备ID", this.device.device_info.deviceId)
        this.InfoCell("设备类型",
          deviceTypeToName(this.device.device_info.deviceType))
        this.InfoCell("网络ID", this.device.device_info.networkId)
        this.InfoCell("设备距离", this.device.device_info.range.toString())
        this.InfoCell("连接状态",
          getConnectStatus(this.device.connection_status))
      }
      .backgroundColor("white")
      .width("92%")
      .margin({ left: "4%", right: "4%", top: "20pv" })
      .padding({bottom:"20pv"})
      .borderRadius("20pv")

      this.ConnectionButton()
    }
    .alignItems(HorizontalAlign.Center)
    .width("100%")
    .height("100%")
    .backgroundColor("#1887ceff")
    .padding({
      top: "4%"
    })
  }
}