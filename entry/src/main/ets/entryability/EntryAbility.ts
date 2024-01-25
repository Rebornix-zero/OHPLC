import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { createUserTable, addUser, User } from '../utils/UserDB'
import Want from '@ohos.app.ability.Want';
import { checkAppPermission } from "../utils/Permission"

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    // 为终端信息和设备信息创建应用级状态变量

    // 创建或启动存储User所用的数据库
    let result = createUserTable(this.context);
    result.then((isSuccess) => {
      if (isSuccess) {
        console.log("UserDB start successfully!");
        addUser(this.context, new User(-1, "1", "1", 0, "WHC", "123@123"))
      } else {
        console.log("UserDB start failed!");
      }
    })
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // 检查权限
    checkAppPermission(this.context)
    // 创建好窗口，并加载入口页面
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/LoginPage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onNewWant(want: Want) {

  }
};
