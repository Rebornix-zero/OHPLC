import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { addUser, getAllUser, User, deleteUser } from '../utils/UserDB'
import router from '@ohos.router';

@Component
struct InputCell {
  @Link value: string;
  private prompt: string = "";

  build() {
    Column() {
      Text(this.prompt)
        .fontSize("18pv")
        .fontWeight("bold")
      TextInput()
        .onChange((value: string) => {
          this.value = value;
        })
    }
    .width("100%")
    .padding({ left: "4%", right: "4%" })
    .margin({ top: "10pv" })
    .alignItems(HorizontalAlign.Start)
  }
}

@CustomDialog
struct AddUserDialog {
  private controller?: CustomDialogController;
  private uiAbilityContext = getContext() as common.UIAbilityContext
  @State Account: string = "";
  @State Password: string = "";
  @State Name: string = "";
  @State Email: string = "";
  private addUserInPage: (item: User) => void

  handleAdd() {
    let newUser = new User(-1, this.Account, this.Password, 0, this.Name,
      this.Email);
    addUser(this.uiAbilityContext, newUser
    )
      .then(
        (response) => {
          if (response != -1) {
            promptAction.showToast({ message: "用户添加成功！" });
            newUser.ID = response;
            this.addUserInPage(newUser);
            this.controller.close();
          } else {
            promptAction.showDialog({ message: "用户添加失败，请修改后重试！" });
          }
        }
      )
  }

  handleCancel() {
    this.controller.close();
  }

  build() {
    Column() {
      Text("创建新用户")
        .fontWeight("bold")
        .fontSize("20pv")
        .padding({ top: "20pv" })
      Column() {
        InputCell({ value: $Name, prompt: "用户名" })
        InputCell({ value: $Email, prompt: "邮箱" })
        InputCell({ value: $Account, prompt: "账号" })
        InputCell({ value: $Password, prompt: "密码" })
      }

      Row() {
        Button("确定")
          .onClick(() => this.handleAdd())
          .backgroundColor(0xffffff)
          .fontColor("blue")
          .fontSize("18pv")
        Button("取消")
          .onClick(() => this.handleCancel())
          .backgroundColor(0xffffff)
          .fontColor("red")
          .fontSize("18pv")
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding("10pv")
    }
    .width("100%")
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@Entry
@Component
struct AccountManagerPage {
  @State userList: User[] = [];
  private uiAbilityContext = getContext() as common.UIAbilityContext
  private addUserInPage = (user: User) => { //定义可以传入组件中执行的函数
    this.userList.push(user);
  }
  private addUserDialogController: CustomDialogController = new CustomDialogController({
    builder: AddUserDialog({ addUserInPage: this.addUserInPage }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  })

  @Builder UserCell(item: User, index: number) {
    Row() {
      Row() {
        Image($r("app.media.user_line"))
          .width("40pv")
          .margin({ right: "6pv" })
        Column() {
          Row() {
            Text(item.NAME)
              .fontWeight("bolder")
              .fontSize("20pv")
              .padding({ right: "6pv" })
            Text(item.EMAIL)
              .fontColor("#D3D3D3")
          }

          Text(item.ACCOUNT)
        }
        .alignItems(HorizontalAlign.Start)
      }

      Image($r("app.media.more_two"))
        .width("40pv")
        .bindMenu(this.MenuBuilder(index))
    }
    .width("100%")
    .height("100%")
    .padding({ left: "10pv", right: "10pv" })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder MenuBuilder(index: number) {
    Column() {
      Text("删除账号")
        .fontColor("red")
        .fontSize("18pv")
        .onClick(() => {
          promptAction.showDialog({ message: "确定删除账号吗？", buttons: [{
            text: '确定',
            color: 'red',
          }, {
            text: '取消',
            color: '#007DFF',
          }] })
            .then((data) => {
              if (data.index == 0) this.handleClickDelete(index);
            })
        })
    }
    .width("180pv")
    .padding("6pv")
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  handleClickDelete(index: number) {
    let acc = this.userList[index].ACCOUNT,
      pass = this.userList[index].PASSWORD;
    deleteUser(this.uiAbilityContext, this.userList[index])
      .then(
        (response) => {
          if (response) {
            //数据库存储成功，从页面中删除
            promptAction.showToast({ message: "删除成功！" });
            let leftData = this.userList.filter((item: User) => {
              return item.ACCOUNT !== acc || item.PASSWORD !== pass;
            })
            console.log("LEFT " + leftData.length);
            this.userList = leftData;
          } else {
            //删除失败
            promptAction.showToast({ message: "删除失败！" });
          }
        }
      )
  }

  onPageShow() {
    let promise = getAllUser(this.uiAbilityContext);
    promise.then((result) => {
      this.userList = result;
    })
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.left"))
          .width("48pv")
          .onClick(() => router.back())
        Text("账号管理")
          .fontWeight("bolder")
          .fontSize("26pv")
        Image($r("app.media.plus"))
          .width("32pv")
          .onClick(() => this.addUserDialogController.open())
      }
      .margin({ top: "8%" })
      .width("96%")
      .padding({ left: "2%", right: "2%" })
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        List() {
          ForEach(this.userList, (item: User, index) => {
            ListItem() {
              this.UserCell(item, index)
            }
            .height("60pv")
            .width("100%")
            .margin({ top: "6pv" })
            .padding("4pv")
            .backgroundColor(Color.White)
            .borderRadius("10pv")
          }, (item: User) => item.ID.toString())
        }
        .scrollBar(BarState.Auto)
        .width("92%")
        .height("100%")
        .margin({ left: "4%", right: "4%" })
      }
      .width("100%")
      .height("84%")
      .margin({ top: "6%" })
    }
    .alignItems(HorizontalAlign.Center)
    .width("100%")
    .height("100%")
    .backgroundColor("#F0FFFF")
  }
}