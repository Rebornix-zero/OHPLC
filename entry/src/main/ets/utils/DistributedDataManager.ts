import distributedObject from '@ohos.data.distributedDataObject'
import { TerminalInfo, TerminalItem } from "../common/ItemTypes"

type terminal_array = TerminalItem[];

class DistributeTerminalDataManager {
  public distributedTerminalDataObject: any = null;
  public terminalListLink: SubscribedAbstractProperty<terminal_array> = AppStorage.SetAndLink("TerminalList", []);
  public terminalSessionIDLink: SubscribedAbstractProperty<string> = AppStorage.SetAndLink("TerminalSessionID", "");
  public changeCallback: () => void = () => {
    let new_list = this.distributedTerminalDataObject.terminalItemList as terminal_array;
    this.terminalListLink.set(new_list);
  };
  public statusCallback: (sessionId: string, networkId: string, status: 'online' | 'offline') => void;

  constructor() {
    this.distributedTerminalDataObject = distributedObject.createDistributedObject({
      terminalItemList: [],
    })
    this.distributedTerminalDataObject.on('change', this.changeCallback);
  }

  finalize() {
  }

  genSessionID(): string {
    return distributedObject.genSessionId();
  }

  setSessionID(sessionID: string) {
    this.distributedTerminalDataObject.setSessionId(sessionID);
    this.terminalSessionIDLink.set(sessionID);
  }

  getSessionID() {
    let sessionId = this.terminalSessionIDLink.get();
    if (sessionId === "") {
      sessionId = this.genSessionID();
      this.setSessionID(sessionId);
      return sessionId;
    } else {
      return sessionId;
    }
  }

  clearData() {
    this.distributedTerminalDataObject.terminalItemList = []
    this.terminalListLink.set([]);
  }

  addItem() {
    this.distributedTerminalDataObject.terminalItemList = [...this.distributedTerminalDataObject.terminalItemList,
      new TerminalItem(new TerminalInfo("", "", "", ""), 0)
    ]
    this.terminalListLink.set(this.distributedTerminalDataObject.terminalItemList);
  }
}

// class DistributeConnectDeviceDataManager {
//   constructor() {
//   }
//
//   finalize() {
//   }
//
//   //返回sessionID，如果为空则生成一个新的
//   GetSessionID(): string {
//     return "";
//   }
// }

export const DistributeTerminalDataManagerInstance = new DistributeTerminalDataManager();

// export const DistributeConnectDeviceDataManagerInstance = new DistributeConnectDeviceDataManager();