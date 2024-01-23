import {DeviceItem, SettingItem, TerminalItem} from './ItemTypes'

export class ItemData {
  getSettingItemData(): Array<SettingItem> {
    let data = [
      new SettingItem($r("app.media.things"), "修改用户名", false),
      new SettingItem($r("app.media.things"), "修改邮箱", false),
      new SettingItem($r("app.media.things"), "修改账号", false),
      new SettingItem($r("app.media.things"), "修改密码", false),
      // new SettingItem($r("app.media.things"),"夜间模式",true),
    ]
    return data;
  }

  getDeviceItemData():Array<DeviceItem>{
    let data=[
      new DeviceItem("device 1","AAEFVGTDDE","192.168.1.125",1),
      new DeviceItem("device 2","QFFDERFVGTDDE","192.168.1.126",1),
      new DeviceItem("device 3","VHPWDFDSE","192.168.1.127",1),

      new DeviceItem("device 3","VHPWDFDSE","192.168.1.127",1),
      new DeviceItem("device 4","VHPWDFDSE","192.168.1.127",1),
      new DeviceItem("device 5","VHPWDFDSE","192.168.1.127",1),
      new DeviceItem("device 6","VHPWDFDSE","192.168.1.127",-1),
      new DeviceItem("device 7","VHPWDFDSE","192.168.1.127",-1),
      new DeviceItem("device 8","VHPWDFDSE","192.168.1.127",-1),
      new DeviceItem("device 9","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 10","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 11","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 12","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 13","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 14","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 15","VHPWDFDSE","192.168.1.127",0),
      new DeviceItem("device 16","VHPWDFDSE","192.168.1.127",0),
    ];
    return data;
  }

  getTerminalItemData():Array<TerminalItem>{
    let data=[
      new TerminalItem("device 1","AAEFVGTDDE","192.168.1.125",1),
      new TerminalItem("device 2","QFFDERFVGTDDE","192.168.1.126",-1),
      new TerminalItem("device 3","VHPWDFDSE","192.168.1.127",0),
      new TerminalItem("device 3","VHPWDFDSE","192.168.1.127",0),
    ];
    return data;
  }
}

export default new ItemData();