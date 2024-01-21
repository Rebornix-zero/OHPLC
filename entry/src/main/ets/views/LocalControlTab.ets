import ItemDataExample from '../common/data/Data'
import { TerminalItem } from '../common/type/ItemTypes'

@Component
export default struct LocalControlTab{

  @Builder TerminalCell(item: TerminalItem) {
    Row() {
      Row() {
        Image(item.getTerminalImage())
          .width("30pv")
        Text(item.terminal_name)
          .fontSize("20pv")
          .padding({ left: "6pv" })
          .fontColor(item.getTerminalNameColor())
      }

      Text(item.getTerminalConnectStatus())
        .fontColor(item.getTerminalNameColor())
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
      Text("本地控制")
        .margin({ top: "6%" })
        .fontWeight("bolder")
        .fontSize("24pv")
      List() {
        ForEach(ItemDataExample.getTerminalItemData(), (item: TerminalItem) => {
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