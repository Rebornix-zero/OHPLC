import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';

async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    console.error(`Failed to get bundle info for self.`);
  }
  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    console.error(`Failed to check access token.`);
  }
  return grantStatus;
}

async function checkPermissions(context: common.UIAbilityContext): Promise<Boolean> {
  const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[0]);

  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
    return true;
  } else {
    // 尚未授权，需要进行对应处理
    handlePoorPermission(context);
    return false;
  }
}

async function handlePoorPermission(context: common.UIAbilityContext) {
  try {
    await promptAction.showDialog({
      title: "\"多设备协同\" 权限尚未开启",
      message: "\t\t您尚未开启\"多设备协同\"权限，这会影响到应用正常运行\n\t\t请在设置>隐私>权限管理中找到对应权限并授权",
      buttons: [{
        text: '确认',
        color: 'red',
      }],
    });
  } catch (error) {
    // 当点击Dialog的遮罩层部分而关闭时，showDialog函数认为是发生了一次失败的Dialog交互，故会throw一个error
    // 需要在这一层拦截住error，后面的语句才能正确执行
  }
  context.terminateSelf()
}

async function reqPermissionsFromUser(context: common.UIAbilityContext): Promise<void> {
  const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  let data = await atManager.requestPermissionsFromUser(context, permissions);
  let grantStatus: Array<number> = data.authResults;
  let length: number = grantStatus.length;
  for (let i = 0; i < length; i++) {
    if (grantStatus[i] === 0) {
      // 用户授权，可以继续访问目标操作
    } else {
      // 用户拒绝授权
      return;
    }
  }
  // 授权成功
  return;
}

export async function checkAppPermission(context: common.UIAbilityContext) {
  await reqPermissionsFromUser(context);
  checkPermissions(context);
}