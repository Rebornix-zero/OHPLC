import {
  TerminalItem,
  getTerminalImage,
  getConnectStatus,
  ConnectionState,
  getConnectColor
} from "../common/ItemTypes"
import router from '@ohos.router';

@Entry
@Component
struct TerminalPage {
  @State terminal: TerminalItem = (router.getParams() as TerminalItem)

  handleConnect() {
    console.log("Connect")
  }

  handleDisconnect() {
    console.log("Disconnect")
  }

  @Builder ConnectionButton() {
    Button(this.terminal.connection_status == ConnectionState.CONNECT ? "断开连接" : "连接")
      .margin({ top: "100pv" })
      .fontSize("18pv")
      .fontWeight("bold")
      .width("40%")
      .fontColor(this.terminal.connection_status == ConnectionState.CONNECT ? "#E02020" : "#0091FF")
      .backgroundColor("white")
      .onClick(() => {
        if (this.terminal.connection_status == ConnectionState.CONNECT)
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

      Image(getTerminalImage(this.terminal.connection_status))
        .width("20%")
      Text(this.terminal.terminal_info.terminal_name)
        .fontWeight("bold")
        .fontSize("32pv")
      Column() {
        this.InfoCell("终端名称", this.terminal.terminal_info.terminal_name)
        this.InfoCell("终端IP", this.terminal.terminal_info.terminal_ip)
        this.InfoCell("所属设备名称", this.terminal.terminal_info.device_name)
        this.InfoCell("所属设备ID", this.terminal.terminal_info.device_id)
        this.InfoCell("连接状态",
          getConnectStatus(this.terminal.connection_status))
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