import { DeviceItem, SettingItem, TerminalInfo, TerminalItem } from './ItemTypes'

export const BUNDLE = "com.example.ohplc"

export const ABILITY = "EntryAbility"

export const SettingItemList: SettingItem[] = [
  new SettingItem($r("app.media.things"), "修改用户名", false),
  new SettingItem($r("app.media.things"), "修改邮箱", false),
  new SettingItem($r("app.media.things"), "修改账号", false),
  new SettingItem($r("app.media.things"), "修改密码", false),
// new SettingItem($r("app.media.things"),"夜间模式",true),
];


