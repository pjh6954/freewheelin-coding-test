//
//  AppDelegate.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

import RealmSwift

@UIApplicationMain // @main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // realm migraion setting
        realmMigration(1)
        if UIDevice().userInterfaceIdiom == .phone {
            
        } else {
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
extension AppDelegate {
    func realmMigration(_ version :UInt64) {
        // Realm Migration
        let config = Realm.Configuration(
            // 새로운 스키마 버전을 세팅한다. 이 값은 이전에 사용했던 버전보다 반드시 커야한다.
            // 이전에 사용하지 않았다면 schemaVersion == 0
            schemaVersion: version,
            // 세팅한 스키마 버전보다 낮을 때 자동으로 호출되는 코드 블럭을 세팅한다.
            migrationBlock: { migration, oldSchemaVersion in
                // 역시 건들지 않았다면 so oldSchemaVersion == 0
                debugPrint("REALM old Schema Version \(oldSchemaVersion)")
                if (oldSchemaVersion < 1) {
                    // 아무것도 안해도 됨!
                    // 렘은 자동으로 새 프로퍼티와 지워진 프로퍼티를 감지하고 디스크의 스키마를 자동으로 업데이트 할 것이다.
                    // 무언가를 변경해줘야 한다면, 아래와 같은 식으로
                    // migration.enumerateObjects(ofType: SwingRecord.className()) { (oldObj, newObj) in
                    //   newObj?[“is_download”] = false
                    // }
                }
            })
        // 기존 렘에서 새 설정 오브젝트를 사용하라고 전달
        Realm.Configuration.defaultConfiguration = config
        // Realm에 스키마 변경을 처리하는 방법을 알려 주었으므로 파일을 열면 자동으로 마이그레이션이 수행됩니다.
        let _ = try! Realm()
        // 최소한 Realm이 스키마를 (자동으로) 업그레이드했음을 나타내기 위해 빈 블록으로 버전을 업데이트해야합니다.
    }
}
