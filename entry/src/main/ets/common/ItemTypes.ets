import deviceManager from '@ohos.distributedHardware.deviceManager';

export class SettingItem {
  img: Resource;
  title: string | Resource;
  need_toggle: Boolean;

  constructor(
    img: Resource, title: string | Resource, need_toggle: Boolean) {
    this.title = title;
    this.img = img;
    this.need_toggle = need_toggle;
  }
}

export class DeviceItem {
  public device_info: deviceManager.DeviceInfo;
  public connext_status: number; //0未连接，1连接，-1错误

  constructor(
    info: deviceManager.DeviceInfo, status: number = 0) {
    this.device_info = info;
    this.connext_status = status;
  }

  getDeviceImage(): Resource {
    switch (this.connext_status) {
      case 1: {
        return $r("app.media.matebook_connect")
      }
      case -1: {
        return $r("app.media.matebook_error")
      }
      case 0:
      default: {
        return $r("app.media.matebook_noconnect")
      }
    }
  }

  getDeviceNameColor(): string {
    switch (this.connext_status) {
      case 1: {
        return "#0091FF";
      }
      case -1: {
        return "#E02020";
      }
      case 0:
      default: {
        return "#000000";
      }
    }
  }

  getDeviceConnectStatus(): string {
    switch (this.connext_status) {
      case 1: {
        return "已连接";
      }
      case -1: {
        return "连接错误";
      }
      case 0:
      default: {
        return "未连接";
      }
    }
  }
}

export class TerminalInfo {
  public terminal_name: string;
  public terminal_ip: string;
  public device_name: string;
  public device_id: string;

  constructor(Tname: string, Tip: string, Dname: string, Did: string) {
    this.terminal_name = Tname;
    this.terminal_ip = Tip;
    this.device_name = Dname;
    this.device_id = Did;
  }
}

export class TerminalItem {
  public terminal_info: TerminalInfo;
  public connection_status: number; //0未连接，1连接，-1错误

  constructor(
    info: TerminalInfo,
    status: number = 0) {
    this.terminal_info = info;
    this.connection_status = status;
  }

  getTerminalImage(): Resource {
    switch (this.connection_status) {
      case 1: {
        return $r("app.media.wireless_connect")
      }
      case -1: {
        return $r("app.media.wireless_error")
      }
      case 0:
      default: {
        return $r("app.media.wireless_noconnection")
      }
    }
  }

  getTerminalNameColor(): string {
    switch (this.connection_status) {
      case 1: {
        return "#0091FF";
      }
      case -1: {
        return "#E02020";
      }
      case 0:
      default: {
        return "#000000";
      }
    }
  }

  getTerminalConnectStatus(): string {
    switch (this.connection_status) {
      case 1: {
        return "已连接";
      }
      case -1: {
        return "连接错误";
      }
      case 0:
      default: {
        return "未连接";
      }
    }
  }
}