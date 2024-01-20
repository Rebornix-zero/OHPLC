import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl,{Permissions} from '@ohos.abilityAccessCtrl';


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

export async function checkPermissions(): Promise<Boolean> {
  const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[0]);

  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
    return true;
  } else {
    // 尚未授权，需要申请跨设备同应用数据同步权限
    return false;
  }
}

export function reqPermissionsFromUser(object:any): void {
  const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
  let context: Context = getContext(object) as Context;
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  atManager.requestPermissionsFromUser(context, permissions)
    .then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          console.log("FFFFF")
          return;
        }
      }
      // 授权成功
      console.log("TTTTT")
    })
    .catch((error) => {
      console.error(`Failed to request permissions from user.`);
    })
}