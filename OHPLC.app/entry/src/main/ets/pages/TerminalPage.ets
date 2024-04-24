import {
  TerminalItem,
  getTerminalImage,
  getConnectStatus,
  ConnectionState,
  Variable
} from "../common/ItemTypes";
import {
  DistributeTerminalDataManagerInstance
} from '../utils/DistributedDataManager';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import {
  pause_or_resume_plc_program,
  reset_plc_program,
  start_plc_program,
  stop_plc_program
} from '../../cpp/types/libentry';

@Entry
@Component
struct TerminalPage {
  @State terminal: TerminalItem = (router.getParams() as TerminalItem);
  @State variable_list: Variable[] = [new Variable("VAR NAME", "TYPE",
  "VALUE"),new Variable("VAR1", "BOOL",
    "TRUE"), new Variable("VAR2", "UINT", "666")];

  handleConnect() {
    // console.log("Connect");
    // TODO: Need success check
    // start_plc_program(this.terminal.terminal_info.softplc_name);
    promptAction.showToast({ message: "连接成功" });
    this.terminal.connection_status = ConnectionState.CONNECT;
    DistributeTerminalDataManagerInstance.setItemConnectState(this.terminal.terminal_info.softplc_name,
      ConnectionState.CONNECT);
  }

  handleDisconnect() {
    // console.log("Disconnect");
    // TODO: Need success check
    // stop_plc_program(this.terminal.terminal_info.softplc_name);
    promptAction.showToast({ message: "断开连接" });
    this.terminal.connection_status = ConnectionState.NO_CONNECT;
    DistributeTerminalDataManagerInstance.setItemConnectState(this.terminal.terminal_info.softplc_name,
      ConnectionState.NO_CONNECT);
  }

  handleStop() {
    // TODO: Need success check
    // pause_or_resume_plc_program(this.terminal.terminal_info.softplc_name, 0);
    promptAction.showToast({ message: "程序暂停" });
  }

  handleContinue() {
    // TODO: Need success check
    // pause_or_resume_plc_program(this.terminal.terminal_info.softplc_name, 1);
    promptAction.showToast({ message: "程序继续" });
  }

  handleReset() {
    // TODO: Need success check
    // reset_plc_program(this.terminal.terminal_info.softplc_name);
    promptAction.showToast({ message: "程序重置" });
  }

  @Builder ConnectionButton() {
    Button(this.terminal.connection_status == ConnectionState.CONNECT ? "断开连接" : "连接")
      .margin({ top: "20pv", bottom: "20pv" })
      .fontSize("18pv")
      .fontWeight("bold")
      .width("40%")
      .fontColor(this.terminal.connection_status == ConnectionState.CONNECT ? "#FF0000" : "#0091FF")
      .backgroundColor("white")
      .onClick(() => {
        if (this.terminal.connection_status == ConnectionState.CONNECT)
          this.handleDisconnect(); else this.handleConnect();
      })
  }

  @Builder ControlButtonList() {
    Row() {
      Button("暂停")
        .margin({ left: "6pv", right: "6pv" })
        .width("26%")
        .fontSize("18pv")
        .fontWeight("bold")
        .backgroundColor("white")
        .fontColor("#FF0000")
        .onClick(() => this.handleStop())
      Button("继续")
        .margin({ left: "6pv", right: "6pv" })
        .width("26%")
        .fontSize("18pv")
        .fontWeight("bold")
        .backgroundColor("white")
        .fontColor("#32CD32")
        .onClick(() => this.handleContinue())
      Button("重置")
        .margin({ left: "6pv", right: "6pv" })
        .width("26%")
        .fontSize("18pv")
        .fontWeight("bold")
        .backgroundColor("white")
        .fontColor("#EEC900")
        .onClick(() => this.handleReset())
    }
    .width("92%")
    .justifyContent(FlexAlign.SpaceEvenly)
    .alignItems(VerticalAlign.Center)
    .margin({ top: "20pv", bottom: "10pv", left: "4%", right: "4%" })
  }

  @Builder InfoCell(key: string, value: string, link: boolean = false) {
    Row() {
      Text(key)
        .fontSize("20pv")
      if (!link) {
        Text(value)
          .fontSize("20pv")
      } else {
        Text(this.terminal.connection_status == ConnectionState.CONNECT ? "已连接" : "未连接")
          .fontSize("20pv")
          .fontColor(this.terminal.connection_status == ConnectionState.CONNECT ? "#0091FF" : "#000000")
      }

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

        Image(getTerminalImage(this.terminal.connection_status))
          .width("20%")
        Text(this.terminal.terminal_info.softplc_name)
          .fontWeight("bold")
          .fontSize("32pv")
        Column() {
          this.InfoCell("SoftPLC程序名",
            this.terminal.terminal_info.softplc_name)
          this.InfoCell("Socket端口",
            String(this.terminal.terminal_info.socket_port))
          this.InfoCell("通信协议", this.terminal.terminal_info.protocol)
          this.InfoCell("通信协议详情",
            this.terminal.terminal_info.protocol_info)
          this.InfoCell("连接状态",
            "", true)
        }
        .backgroundColor("white")
        .width("92%")
        .margin({ left: "4%", right: "4%", top: "20pv" })
        .padding({ bottom: "20pv" })
        .borderRadius("20pv")

        Column() {
          Text(this.terminal.terminal_info.softplc_info)
            .fontSize("20pv")
            .alignSelf(ItemAlign.Start)
        }
        .backgroundColor("white")
        .width("92%")
        .margin({ left: "4%", right: "4%", bottom: "20pv", top: "20pv" })
        .padding({ left: "4%", right: "4%", bottom: "10pv", top: "10pv" })
        .borderRadius("20pv")

        if (this.terminal.connection_status == ConnectionState.CONNECT) {
          this.ControlButtonList()
        }
        this.ConnectionButton()

        List() {
          ForEach(this.variable_list, (item: Variable,index) => {
            ListItem() {
              Row() {
                Text(item.variable_name)
                  .textAlign(TextAlign.Center)
                  .width("30%")
                  .fontWeight(index==0?FontWeight.Bold:FontWeight.Normal)
                Text(item.variable_type)
                  .textAlign(TextAlign.Center)
                  .width("30%")
                  .fontWeight(index==0?FontWeight.Bold:FontWeight.Normal)
                Text(item.variable_value)
                  .textAlign(TextAlign.Center)
                  .width("30%")
                  .fontWeight(index==0?FontWeight.Bold:FontWeight.Normal)
              }
              .width("100%")
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width("96%")
            .margin({ left: "2%", right: "2%" })
            .padding({ left: "2%", right: "2%",top:"6pv",bottom:"6pv" })
          })
        }
        .width("92%")
        .margin({ left: "4%", right: "4%",bottom:"40pv" })
        .backgroundColor("white")

      }
      .alignItems(HorizontalAlign.Center)
      .width("100%")
      .padding({
        top: "4%"
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#1887ceff")
    .scrollable(ScrollDirection.Vertical)
  }
}