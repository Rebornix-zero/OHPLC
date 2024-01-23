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
  device_name: string;
  device_id: string;
  device_ip: string;
  status: number; //0无连接，1连接，-1错误

  constructor(
    device_name: string, device_id: string, device_ip: string, status: number) {
    this.device_name = device_name;
    this.device_id = device_id;
    this.device_ip = device_ip;
    this.status = status;
  }

  getDeviceImage(): Resource {
    switch (this.status) {
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
    switch (this.status) {
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
    switch (this.status) {
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

export class TerminalItem {
  terminal_name: string;
  terminal_id: string;
  terminal_ip: string;
  status: number; //0无连接，1连接，-1错误

  constructor(
    terminal_name: string, terminal_id: string, terminal_ip: string,
    status: number) {
    this.terminal_name = terminal_name;
    this.terminal_id = terminal_id;
    this.terminal_ip = terminal_ip;
    this.status = status;
  }

  getTerminalImage(): Resource {
    switch (this.status) {
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
    switch (this.status) {
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
    switch (this.status) {
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