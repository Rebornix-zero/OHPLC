import deviceManager from '@ohos.distributedHardware.deviceManager';

export enum ConnectionState {
  FAILED = -1,
  NO_CONNECT = 0,
  CONNECT = 1,
}

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
  public connection_status: ConnectionState; //0未连接，1连接，-1错误

  constructor(
    info: deviceManager.DeviceInfo, status: ConnectionState = 0) {
    this.device_info = info;
    this.connection_status = status;
  }
}

export class Variable{
  public variable_name:string;
  public variable_type:string;
  public variable_value:string;

  constructor(va_name:string,va_type:string,va_value:string) {
    this.variable_name=va_name;
    this.variable_type=va_type;
    this.variable_value=va_value;
  }
}


export class TerminalInfo {
  public softplc_name: string;
  public socket_port : number;
  public protocol:string;
  public protocol_info:string;
  public softplc_info:string;

  constructor(soft_name: string, sock_port: number, proto: string, proto_info: string,soft_info:string) {
    this.softplc_name=soft_name;
    this.socket_port=sock_port;
    this.protocol=proto;
    this.protocol_info=proto_info;
    this.softplc_info=soft_info;
  }
}

export class TerminalItem {
  public terminal_info: TerminalInfo;
  public connection_status: ConnectionState; //0未连接，1连接，-1错误

  constructor(
    info: TerminalInfo,
    status: ConnectionState = 0) {
    this.terminal_info = info;
    this.connection_status = status;
  }
}

export function getDeviceImage(connext_status: ConnectionState): Resource {
  switch (connext_status) {
    case ConnectionState.CONNECT: {
      return $r("app.media.matebook_connect")
    }
    case ConnectionState.FAILED: {
      return $r("app.media.matebook_error")
    }
    case ConnectionState.NO_CONNECT:
    default: {
      return $r("app.media.matebook_noconnect")
    }
  }
}

export function getTerminalImage(connection_status: ConnectionState): Resource {
  switch (connection_status) {
    case ConnectionState.CONNECT: {
      return $r("app.media.wireless_connect")
    }
    case ConnectionState.FAILED: {
      return $r("app.media.wireless_error")
    }
    case ConnectionState.NO_CONNECT:
    default: {
      return $r("app.media.wireless_noconnection")
    }
  }
}

export function getConnectStatus(connection_status: ConnectionState): string {
  switch (connection_status) {
    case ConnectionState.CONNECT: {
      return "已连接";
    }
    case ConnectionState.FAILED: {
      return "连接失败";
    }
    case ConnectionState.NO_CONNECT:
    default: {
      return "未连接";
    }
  }
}

export function getConnectColor(connection_status: number | string): string {
  switch (connection_status) {
    case 1:
    case "已连接": {
      return "#0091FF";
    }
    case -1:
    case "连接失败": {
      return "#E02020";
    }
    case 0:
    default: {
      return "#000000";
    }
  }
}

export function deviceTypeToName(type: deviceManager.DeviceType): string {
  switch (type) {
    case deviceManager.DeviceType.SPEAKER:
      return "智能音箱";
    case deviceManager.DeviceType.PHONE:
      return "手机";
    case deviceManager.DeviceType.TABLET:
      return "平板";
    case deviceManager.DeviceType.WEARABLE:
      return "智能穿戴";
    case deviceManager.DeviceType.TV:
      return "智慧屏";
    case deviceManager.DeviceType.CAR:
      return "车";
    case deviceManager.DeviceType.UNKNOWN_TYPE:
    default:
      return "开发板或未知设备";
  }
}

export const sortMethod: (
  a: DeviceItem | TerminalItem, b: DeviceItem | TerminalItem) => number = (a, b) => {
  if (a.connection_status == b.connection_status) {
    //a b优先级一致,返回0
    return 0;
  }
  if (a.connection_status > b.connection_status) {
    //a优先级高于b,返回负数
    return -1;
  } else {
    //b优先级高于a,返回负数
    return 1;
  }
}