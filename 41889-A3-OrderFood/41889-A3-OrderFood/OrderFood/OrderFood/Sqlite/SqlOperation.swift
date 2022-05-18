//
//  UserData.swift
//  OrderFood
//
//  Created by Lin on 2022/5/16.
//

import Foundation
import SQLite3

final class SqlOperation{
    private var m_db: OpaquePointer? = nil
    init(){
        let _ = sqlite3_open_v2("\(NSHomeDirectory())/Documents/restaurant.data", &m_db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, nil)
        #if DEBUG
        print("\(NSHomeDirectory())/Documents")
        #endif
        let _ = initTables()
    }
    
    deinit{
        closeDbFile()
    }
    
    private func closeDbFile(){
        if m_db != nil {
            sqlite3_close_v2(m_db)
            m_db = nil
        }
    }
    
    private func initTables() -> Bool {
        if sqlite3_exec(m_db,
           """
           CREATE TABLE IF NOT EXISTS ACCOUNT                 (\
           ID               INTEGER PRIMARY KEY AUTOINCREMENT ,\
           USERNAME         TEXT NOT NULL                     ,\
           PASSWORD         TEXT NOT NULL                     ,\
           TYPE             INTEGER NOT NULL                  );
           """,
           nil,nil,nil) != SQLITE_OK {
            return false
        }
        
        if sqlite3_exec(m_db,
           """
           CREATE TABLE IF NOT EXISTS MENU                    (\
           ID               INTEGER PRIMARY KEY AUTOINCREMENT ,\
           NAME             TEXT NOT NULL                     ,\
           PRICE            DOUBLE NOT NULL                   ,\
           RECOMMEND        INTEGER NOT NULL                  );
           """,
           nil,nil,nil) != SQLITE_OK {
            return false
        }
        
        if sqlite3_exec(m_db,
           """
           CREATE TABLE IF NOT EXISTS ORDERED                 (\
           ID               INTEGER PRIMARY KEY AUTOINCREMENT ,\
           MENU_ID          INTEGER NOT NULL                  ,\
           DATE             DOUBLE NOT NULL                   ,\
           ACCOUNT_ID       INTEGER NOT NULL                  );
           """,
           nil,nil,nil) != SQLITE_OK {
            return false
        }
        
        createAdminAccount()
        
        return true
    }
    
    private func createAdminAccount() {
        if(!isTheAccountNameExist(username: "Admin")){
            let _ = createAccount(createAccountInfo: CreateAccountInfo(username: "Admin", password: "123456"), type: 1)
        }
    }
    
    func signIn(signInInfo: SignInInfo) -> UserInfo {
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            SELECT ID , TYPE FROM ACCOUNT WHERE USERNAME = ? AND PASSWORD = ?
            """,
            -1, &statement, nil)
        bindString(statement, 1, signInInfo.username)
        bindString(statement, 2, signInInfo.password)
        var userInfo = UserInfo()
        if (sqlite3_step(statement) == SQLITE_ROW) {
            userInfo.userId = Int(sqlite3_column_int(statement, 0))
            userInfo.userType = Int(sqlite3_column_int(statement, 1)) == 1 ? .Manager : .Customer
            userInfo.userName = signInInfo.username
        }
       
        sqlite3_finalize(statement)
        
        return userInfo
    }
    
    func isTheAccountNameExist(username: String) -> Bool {
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            SELECT COUNT(*) FROM ACCOUNT WHERE USERNAME = ?
            """,
            -1, &statement, nil)
        bindString(statement, 1, username)
        sqlite3_step(statement)
        let res = sqlite3_column_int(statement, 0)
        sqlite3_finalize(statement)
        
        return res >= 1
    }
    
    func createAccount(createAccountInfo: CreateAccountInfo, type: Int = 0) -> Bool {
        if (isTheAccountNameExist(username: createAccountInfo.username)){
            return false
        }
        
        var statement: OpaquePointer?
        
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            INSERT INTO ACCOUNT  \
            (USERNAME, PASSWORD, TYPE) \
            VALUES (?,?,?)
            """,
            -1, &statement, nil)
        bindString(statement, 1, createAccountInfo.username)
        bindString(statement, 2, createAccountInfo.password)
        sqlite3_bind_int(statement, 3, Int32(type))

        sqlite3_step(statement)
        sqlite3_finalize(statement)
        
        return true
    }
    
    func searchMenu() -> [SingleDishInMenu] {
        var dishes: [SingleDishInMenu] = []
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            SELECT * FROM MENU
            """,
            -1, &statement, nil)
        while(sqlite3_step(statement) == SQLITE_ROW) {
            dishes.append(
                SingleDishInMenu(
                    dishId: Int(sqlite3_column_int(statement, 0)),
                    name: getString(statement, 1),
                    price: sqlite3_column_double(statement, 2),
                    recommend: sqlite3_column_int(statement, 3) == 1
                )
            )
        }
        sqlite3_finalize(statement)
        return dishes
    }
    
    func addDish(dish: SingleDish) {
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            INSERT INTO MENU         \
            (NAME, PRICE, RECOMMEND) \
            VALUES (?,?,?)
            """,
            -1, &statement, nil)
        bindString(statement, 1, dish.name)
        sqlite3_bind_double(statement,2, dish.price)
        sqlite3_bind_int(statement, 3, dish.recommend ? 1 : 0)
        
        sqlite3_step(statement)
        sqlite3_finalize(statement)
    }
    
    func updateDish(dish: SingleDish) {
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            UPDATE MENU \
            SET NAME = ? , PRICE = ? , RECOMMEND = ? \
            WHERE ID = ?
            """,
            -1, &statement, nil)
        bindString(statement, 1, dish.name)
        sqlite3_bind_double(statement, 2, dish.price)
        sqlite3_bind_int(statement, 3, dish.recommend ? 1 : 0)
        sqlite3_bind_int(statement, 4, Int32(dish.dishId))
        
        sqlite3_step(statement)
        sqlite3_finalize(statement)
    }
    
    func deleteDish(ids: [Int]) {
        if (ids.isEmpty){
            return
        }
        
        let marksStr = makeQuestionMarksStr(ids.count)
        
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            "DELETE FROM MENU WHERE ID IN " + marksStr,
            -1, &statement, nil)
        for i in 0..<ids.count {
            sqlite3_bind_int(statement, Int32(i+1), Int32(ids[i]))
        }

        sqlite3_step(statement)
        sqlite3_finalize(statement)
    }
    
    func addOrdered(menuId: Int, date: Date, accountId: Int ) {
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            INSERT INTO ORDERED         \
            (MENU_ID, DATE, ACCOUNT_ID) \
            VALUES (?,?,?)
            """,
            -1, &statement, nil)
        sqlite3_bind_int(statement, 1, Int32(menuId))
        sqlite3_bind_double(statement, 2, date.timeIntervalSinceReferenceDate)
        sqlite3_bind_int(statement, 3, Int32(accountId))
        
        sqlite3_step(statement)
        sqlite3_finalize(statement)
    }
    
    func searchOrdered(accountId: Int) ->  [SingleDishInOrdered]{
        var dishes: [SingleDishInOrdered] = []
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            """
            SELECT \
            ORDERED.ID, MENU.NAME, MENU.PRICE, MENU.RECOMMEND, ORDERED.MENU_ID, ORDERED.DATE \
            FROM ORDERED LEFT JOIN MENU \
            ON ORDERED.MENU_ID = MENU.ID \
            WHERE ORDERED.ACCOUNT_ID = ?
            """,
            -1, &statement, nil)
        
        sqlite3_bind_int(statement, 1, Int32(accountId))
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            dishes.append(
                SingleDishInOrdered(
                    orderId: Int(sqlite3_column_int(statement, 0)),
                    name: getString(statement, 1),
                    price: sqlite3_column_double(statement, 2),
                    recommend: sqlite3_column_int(statement, 3) == 1,
                    dishId: Int(sqlite3_column_int(statement, 4)),
                    orderTime: Date(timeIntervalSinceReferenceDate: sqlite3_column_double(statement, 5))
                )
            )
        }
        sqlite3_finalize(statement)
        return dishes
    }
    
    func deleteOrdered(accountId: Int, ids: [Int]) {
        if (ids.isEmpty){
            return
        }
        
        let marksStr = makeQuestionMarksStr(ids.count)
        print(ids)
        var statement: OpaquePointer?
        let _ = sqlite3_prepare_v2(
            m_db,
            "DELETE FROM ORDERED WHERE ACCOUNT_ID = ? AND ID IN " + marksStr,
            -1, &statement, nil)
        sqlite3_bind_int(statement, 1, Int32(accountId))
        for i in 0..<ids.count {
            sqlite3_bind_int(statement, Int32(i+2), Int32(ids[i]))
        }

        sqlite3_step(statement)
        sqlite3_finalize(statement)
    }
    
    private func getString(_ statement: OpaquePointer? , _ index: Int32) -> String {
        return String(cString: sqlite3_column_text(statement, index))
    }
    
    private func bindString(_ statement: OpaquePointer? , _ index: Int32, _ string: String) {
        let cstr = (string as NSString).utf8String
        sqlite3_bind_text(statement, index, cstr, -1, nil)
    }
    
    private func makeQuestionMarksStr(_ num: Int) -> String {
        var res = "("
        for _ in 0..<num {
            res += "?,"
        }
        let range = res.index(res.endIndex , offsetBy: -1)..<res.endIndex
        res.replaceSubrange(range, with: ")")
        return res
    }
}
