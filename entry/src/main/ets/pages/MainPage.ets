import LocalControlTab from '../views/LocalControlTab';
import MultiControlTab from '../views/MultiControlTab';
import SettingTab from '../views/SettingTab';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';


@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  private uiAbilityContext:common.UIAbilityContext=getContext() as common.UIAbilityContext;

  exit() {
    this.uiAbilityContext.terminateSelf();
  }

  onBackPress() {
    promptAction.showDialog({
      title: "确定退出OHPLC吗？",
      buttons: [{
        text: '退出',
        color: 'red',
      }, {
        text: '取消',
        color: '#007DFF',
      }]
    })
      .then((data) => {
        if (data.index == 0) {
          this.exit();
        }
      })
    return true;
  }

  @Builder TabBuilder(
    title: string, index: number, activeImg: Resource, inactiveImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? activeImg : inactiveImg)
        .width("26pv")
      Text(title)
        .fontSize("12pv")
        .fontColor(this.currentIndex === index ? "#0091FF" : "#000000")
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor("white")
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
    .width("100%")
    .padding({top:"10pv",bottom:"10pv"})
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {
        LocalControlTab()
      }
      .tabBar(this.TabBuilder("本地控制", 0, $r("app.media.app_active"),
        $r("app.media.app_inactive")))

      TabContent() {
        MultiControlTab()
      }
      .tabBar(this.TabBuilder("多端协同", 1, $r("app.media.cloud_active"),
        $r("app.media.cloud_inactive")))

      TabContent() {
        SettingTab()
      }
      .tabBar(this.TabBuilder("设置", 2, $r("app.media.settings_active"),
        $r("app.media.settings_inactive")))

    }
    .height("100%")
    .width("100%")
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .backgroundColor("#4687ceff")
  }
}
