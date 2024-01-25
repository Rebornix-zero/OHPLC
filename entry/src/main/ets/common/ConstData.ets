import {
  DeviceItem,
  SettingItem,
  TerminalInfo,
  TerminalItem
} from './ItemTypes'
import deviceManager from '@ohos.distributedHardware.deviceManager';

export const SettingItemList: SettingItem[] = [
  new SettingItem($r("app.media.things"), "修改用户名", false),
  new SettingItem($r("app.media.things"), "修改邮箱", false),
  new SettingItem($r("app.media.things"), "修改账号", false),
  new SettingItem($r("app.media.things"), "修改密码", false),
// new SettingItem($r("app.media.things"),"夜间模式",true),
];

export const DeviceItemList: DeviceItem[] = [
  new DeviceItem({
    deviceId: "ss",
    deviceName: "ss",
    deviceType: 0,
    networkId: "ss",
    range: 1
  }, 1), new DeviceItem({
  deviceId: "ss",
  deviceName: "ss",
  deviceType: 0,
  networkId: "ss",
  range: 1
}, 0), new DeviceItem({
  deviceId: "ss",
  deviceName: "ss",
  deviceType: 0,
  networkId: "ss",
  range: 1
}, -1),
]

export const TerminalItemList: TerminalItem[] = [
  new TerminalItem(new TerminalInfo("ss", "ss", "ss", "ss"), 1),
  new TerminalItem(new TerminalInfo("ss", "ss", "ss", "ss"), 0),
  new TerminalItem(new TerminalInfo("ss", "ss", "ss", "ss"), -1),
]

