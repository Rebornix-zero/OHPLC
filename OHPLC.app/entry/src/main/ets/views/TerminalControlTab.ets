import {
  TerminalItem,
  getTerminalImage,
  getConnectColor,
  getConnectStatus,
  sortMethod,
} from '../common/ItemTypes'
import router from '@ohos.router';
import { DeviceManagerInstance } from "../utils/DeviceManager"
import {
  DistributeTerminalDataManagerInstance
} from '../utils/DistributedDataManager';
import promptAction from '@ohos.promptAction';

@Component
export default struct TerminalControlTab {
  @StorageLink("TerminalList") terminalList: TerminalItem[] = [];
  @StorageLink("TerminalNum") terminalNum: number = 0;

  aboutToAppear() {
    let newList = this.terminalList.concat([]);
    newList.sort(sortMethod);
    this.terminalList = newList;
  }

  @Builder TerminalCell(item: TerminalItem) {
    Row() {
      Row() {
        Image(getTerminalImage(item.connection_status))
          .width("30pv")
        Text(item.terminal_info.softplc_name)
          .fontSize("20pv")
          .padding({ left: "6pv" })
          .fontColor(getConnectColor(item.connection_status))
      }

      Text(getConnectStatus(item.connection_status))
        .fontColor(getConnectColor(item.connection_status))
    }
    .onClick(() => router.pushUrl({ url: "pages/TerminalPage", params: item }))
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
        Text("终端控制")
          .fontWeight("bolder")
          .fontSize("24pv")
        Image($r("app.media.refresh"))
          .width("36pv")
          .onClick(() => {
            DistributeTerminalDataManagerInstance.refreshItem();
            promptAction.showToast({ message: "刷新成功！" });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("84%")
      .margin({ left: "8%", top: "6%" })


      List() {
        ForEach(this.terminalList, (item: TerminalItem) => {
          ListItem() {
            this.TerminalCell(item)
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