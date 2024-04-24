import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';

//加载或者创建数据库及对应的表
const SQL_CONFIG = {
  name: "OHPLC_SQLDB.db",
  securityLevel: relationalStore.SecurityLevel.S1
}
//
const TABLE_NAME = "USER";
//表USER的结构: ID ACCOUNT PASSWORD AUTHORITY NAME EMAIL
const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (ID INTEGER PRIMARY KEY AUTOINCREMENT,ACCOUNT TEXT NOT NULL,PASSWORD TEXT NOT NULL,AUTHORITY INTEGER,NAME TEXT NOT NULL,EMAIL TEXT NOT NULL)`;

export class User {
  ID: number;
  ACCOUNT: string;
  PASSWORD: string;
  AUTHORITY: number;
  NAME: string;
  EMAIL: string;

  constructor(id: number = -1, acc: string = "", pass: string = "", auth: number = 0, name: string = "", email: string = "") {
    this.ID = id;
    this.ACCOUNT = acc;
    this.PASSWORD = pass;
    this.AUTHORITY = auth;
    this.NAME = name;
    this.EMAIL = email;
  }
}

export async function getUserByID(context: common.UIAbilityContext, userId: number): Promise<User> {
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  let pred = new relationalStore.RdbPredicates(TABLE_NAME);
  pred.equalTo("ID", userId);
  let resultSet = await db.query(pred, []);
  if (resultSet.rowCount != 1) {
    //如果rowCount为0，则代表没有匹配的userid
    return new User(-1, "", "", 0, "", "");
  }
  //由于数据库主键自增特性，不可能出现两个及以上数量的行同时匹配一个ID
  resultSet.goToFirstRow();
  return new User(
    resultSet.getLong(resultSet.getColumnIndex("ID")),
    resultSet.getString(resultSet.getColumnIndex("ACCOUNT")),
    resultSet.getString(resultSet.getColumnIndex("PASSWORD")),
    resultSet.getLong(resultSet.getColumnIndex("AUTHORITY")),
    resultSet.getString(resultSet.getColumnIndex("NAME")),
    resultSet.getString(resultSet.getColumnIndex("EMAIL")),
  );
}

export async function getAllUser(context: common.UIAbilityContext
): Promise<Array<User>> {
  let resultArray = new Array<User>();
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  let resultSet = await db.querySql(`SELECT * FROM ${TABLE_NAME}`);
  let rowsize = resultSet.rowCount;
  if (rowsize != 0) {
    resultSet.goToFirstRow();
    for (let i = 0;i < rowsize; ++i) {
      resultArray.push(new User(
        resultSet.getLong(resultSet.getColumnIndex("ID")),
        resultSet.getString(resultSet.getColumnIndex("ACCOUNT")),
        resultSet.getString(resultSet.getColumnIndex("PASSWORD")),
        resultSet.getLong(resultSet.getColumnIndex("AUTHORITY")),
        resultSet.getString(resultSet.getColumnIndex("NAME")),
        resultSet.getString(resultSet.getColumnIndex("EMAIL")),
      ));
      resultSet.goToNextRow();
    }
  }
  resultSet.close()
  return resultArray;
}

function userFormatCheck(user: User): boolean {
  //TODO: 完成对输入用户信息的格式检查
  return true;
}

export async function getUserID(context: common.UIAbilityContext, acc: string, pass: string): Promise<number> {
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  let pred = new relationalStore.RdbPredicates(TABLE_NAME);
  pred.equalTo("ACCOUNT", acc).and().equalTo("PASSWORD", pass);
  let resultSet = await db.query(pred, []);
  if (resultSet.rowCount != 1) {
    //如果rowCount为0，则代表没有匹配的账号-密码对
    //如果rowCount大于1，则代表有多对匹配（理论上不应该出现）
    return -1;
  }
  resultSet.goToFirstRow();
  let id = resultSet.getLong(resultSet.getColumnIndex("ID"));
  return id;
}

export async function addUser(context: common.UIAbilityContext, user: User
): Promise<number> {
  //FIXME: 不允许出现两个用户，其account和password完全一样
  //FIXME: 添加的用户的部分内容需要符合某些格式，但目前尚未检查
  const newUser = {
    "ACCOUNT": user.ACCOUNT,
    "PASSWORD": user.PASSWORD,
    "AUTHORITY": user.AUTHORITY,
    "NAME": user.NAME,
    "EMAIL": user.EMAIL
  }
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  let result = await db.insert(TABLE_NAME, newUser);
  return result
}

export async function updateUser(
    context: common.UIAbilityContext, user: User
): Promise<boolean> {
  // TODO:完成对用户信息的更新
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  //使用user中的id定位需要修改的User，并进行修改
  const modifiedUser = {
    "ACCOUNT": user.ACCOUNT,
    "PASSWORD": user.PASSWORD,
    "AUTHORITY": user.AUTHORITY,
    "NAME": user.NAME,
    "EMAIL": user.EMAIL
  }
  let pred = new relationalStore.RdbPredicates(TABLE_NAME);
  pred.equalTo("ID", user.ID);
  let result = await db.update(modifiedUser, pred);
  return result == 1;
}

export async function deleteUser(context: common.UIAbilityContext, user: User
): Promise<boolean> {
  // NOTE: 未进行错误处理
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  let pred = new relationalStore.RdbPredicates(TABLE_NAME);
  pred.equalTo("ACCOUNT", user.ACCOUNT).and().equalTo("PASSWORD", user.PASSWORD)
  await db.delete(pred);
  return true;
}

export async function createUserTable(context: common.UIAbilityContext
): Promise<boolean> {
  let db = await relationalStore.getRdbStore(context, SQL_CONFIG);
  // 如果尚未创建表，则通过此语句创建
  await db.executeSql(SQL_CREATE_TABLE);
  return true;
}



