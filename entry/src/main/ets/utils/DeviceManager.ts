import deviceManager from '@ohos.distributedHardware.deviceManager';
import { BUNDLE, ABILITY } from "../common/ConstData";
import { ConnectionState, DeviceItem } from "../common/ItemTypes";
import { LoggerInstance } from "../utils/Logger"
import { DistributeTerminalDataManagerInstance } from "../utils/DistributedDataManager"
import common from '@ohos.app.ability.common';

type device_array = DeviceItem[];
const LOG_TAG = "DeviceManager "

class DeviceManager {
  // 设备管理器类
  public deviceManager: deviceManager.DeviceManager = null;
  // 与AppStorage中的相关存储数据建立双向连接
  public deviceListLink: SubscribedAbstractProperty<device_array> = AppStorage.SetAndLink("DeviceList", []);
  public connectionDeviceListLink: SubscribedAbstractProperty<string[]> = AppStorage.SetAndLink("ConnectionDeviceList", []);
  public context: common.UIAbilityContext = undefined;

  //构造函数 创建deviceManager
  constructor() {
    try {
      deviceManager.createDeviceManager(BUNDLE, (error, value) => {
        //创建成功后，返回的value为创建的设备管理器实例
        this.deviceManager = value;
        LoggerInstance.info("creating DeviceManager successfully");
      })
    } catch (error) {
      LoggerInstance.info("creating DeviceManager failed!")
    }
  }

  // 同步的更新可信设备列表，但异步返回结果
  async reFetchTrustDeviceList(): Promise<boolean> {
    try {
      let newTrustDeviceInfoList = this.deviceManager.getTrustedDeviceListSync();
      //创建新的设备列表
      let newTrustDeviceList: device_array = []
      newTrustDeviceInfoList.forEach((item) => {
        newTrustDeviceList.push(new DeviceItem(item, ConnectionState.NO_CONNECT));
      })
      //根据之前的情况，更新连接状态
      // newTrustDeviceList.forEach((item) => {
      //   this.connectionDeviceListLink.get().forEach((id) => {
      //     if (id === item.device_info.deviceId) {
      //       item.connection_status = ConnectionState.CONNECT
      //     }
      //   })
      // })
      // 更新设备列表
      this.deviceListLink.set(newTrustDeviceList);
      // 若正常，返回true
      return true;
    } catch (error) {
      // 若出错，在日志输出，并返回false
      console.error("reFetchTrustDeviceList failed");
      return false;
    }
  }

  // 与某个设备进行连接
  async Connect(deviceId: string): Promise<boolean> {
    let sessionID = "";
    // //清空本地数据
    // DistributeTerminalDataManagerInstance.clearData();
    //获取sessionID
    sessionID = DistributeTerminalDataManagerInstance.getSessionID();
    //创建新的want
    let want = {
      deviceId: deviceId,
      bundleName: BUNDLE,
      abilityName: ABILITY,
      parameters: {
        sessionID: sessionID,
      }
    }
    try {
      await this.context.startAbility(want);
      return true;
    } catch (paramError) {
      // 处理入参错误异常
      LoggerInstance.error("connect " + deviceId + " error")
    }
    return false;
  }

  // 断开连接
  async DisConnect(): Promise<boolean> {
    try {
      // 将自己的ID从DistributeConnectDeviceDataManager的数据中删除
      return true;
    } catch (error) {
      // 若出错，在日志输出，并返回false
      console.error("DisConnect " + " failed");
      return false;
    }
  }
}

export const DeviceManagerInstance = new DeviceManager();