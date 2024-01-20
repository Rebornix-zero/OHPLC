import promptAction from '@ohos.promptAction';

@Entry
@Component
struct AccountManagerPage {
  @State sss:string="";

  onPageShow(){
  }

  build() {
    Column() {
        Text(this.sss)
    }
    .alignItems(HorizontalAlign.Center)
    .width("100%")
    .height("100%")
    .backgroundColor("#F0FFFF")
  }
}