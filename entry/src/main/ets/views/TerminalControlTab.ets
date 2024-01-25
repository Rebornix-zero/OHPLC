import { TerminalItemList } from '../common/ConstData'
import { TerminalItem,getTerminalImage,getConnectColor,getConnectStatus } from '../common/ItemTypes'
import router from '@ohos.router';

@Component
export default struct TerminalControlTab {
  @Builder TerminalCell(item: TerminalItem) {
    Row() {
      Row() {
        Image(getTerminalImage(item.connection_status))
          .width("30pv")
        Text(item.terminal_info.terminal_name)
          .fontSize("20pv")
          .padding({ left: "6pv" })
          .fontColor(getConnectColor(item.connection_status))
      }

      Text(getConnectStatus(item.connection_status))
        .fontColor(getConnectColor(item.connection_status))
    }
    .onClick(()=>router.pushUrl({url:"pages/TerminalPage",params:item}))
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: "4%",
      right: "4%"
    })
  }

  build() {
    Column() {
      Text("终端控制")
        .margin({ top: "6%" })
        .fontWeight("bolder")
        .fontSize("24pv")
      List() {
        ForEach(TerminalItemList, (item: TerminalItem) => {
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