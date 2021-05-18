//
//  DatabaseManager.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import Foundation

import RealmSwift

class DatabaseManager {
    private var realm : Realm?
    static let shared = DatabaseManager()
    // Initialized
    private init() {
        if realm == nil {
            realm = try! Realm()
            self.refresh()
        }
    }
    // MARK: Refresh realm db
    func refresh() {
        realm!.refresh()
    }
    // MARK: Drawing Data
    // save drawing data
    func saveDrawingData(saveImagePath: String, bgPath: String?, drawingObj: [DrawingObjectsModel]) {
        let drawingDatas : DrawingDatas = .init(datas: drawingObj, thumbPath: saveImagePath, backgroundPath: bgPath)
        do {
            try realm?.write({
                realm?.add(drawingDatas)
            })
        } catch {
            NSLog("Save drawingdata error")
        }
    }
    // get drawing datas
    func getDrawingData(uuid : String? = nil) -> Results<DrawingDatas>? {
        if let dataUUID = uuid, !dataUUID.isEmpty {
            let filter = "id == \"\(dataUUID)\""
            return realm?.objects(DrawingDatas.self).filter(filter)
        }else{
            return realm?.objects(DrawingDatas.self)
        }
    }
}
