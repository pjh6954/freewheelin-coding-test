//
//  DrawingDatas.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import Foundation

import RealmSwift

class DrawingDatas: Object {
    /// 고유 식별자
    @objc dynamic var id : String = UUID().uuidString
    @objc dynamic var thumbPath: String = ""
    @objc dynamic var backgroundImagePath: String?
    var drawingLines: List<DrawingLine> = .init()
    override init() { }
    convenience init(datas : [DrawingObjectsModel], thumbPath: String, backgroundPath: String? = nil) {
        self.init()
        self.thumbPath = thumbPath
        self.backgroundImagePath = backgroundPath
        datas.forEach { element in
            guard (element.type ?? .noType) != .noType else {
                return
            }
            drawingLines.append(.init(drawingDataSetting: element))
        }
    }
    func getDrawingObjectModel() -> [DrawingObjectsModel] {
        var returnObjs : [DrawingObjectsModel] = []
        drawingLines.forEach { line in
            guard line.type != .noType, let obj = line.getData() else {
                return
            }
            returnObjs.append(obj)
        }
        return returnObjs
    }
}

class DrawingLine: Object {
    /// 고유 식별자 - 삭제 수정용
    @objc dynamic var id : String = UUID().uuidString
    @objc dynamic private var typeData : String = DrawingType.noType.toString()//DrawingType.noType.rawValue
    var type: DrawingType {
        get {
            return DrawingType(rawValue: DrawingType.toInt(str: typeData)) ?? .noType
        }
        set {
            typeData = newValue.toString()
        }
    }
    var drawingObjects: List<DrawingObject> = List<DrawingObject>()
    override init() { }
    convenience init(drawingDataSetting data : DrawingObjectsModel) {
        self.init()
        self.type = data.type ?? .noType
        data.objects.forEach { element in
            guard element.from != nil, element.to != nil else {
                return
            }
            let newObj : DrawingObject = .init()
            _ = newObj.drawingObjectConvert(cgToNS: true, cgFrom: element.from!, cgTo: element.to!)
            self.drawingObjects.append(newObj)
        }
    }
    func getData() -> DrawingObjectsModel? {
        guard type != .noType else {
            return nil
        }
        let data : DrawingObjectsModel = .init(type: self.type)
        drawingObjects.forEach { element in
            guard let points = element.drawingObjectConvert(cgToNS: false) else {
                return
            }
            let drawingElement : DrawingObjectElement = .init(points.0, points.1)
            data.objects.append(drawingElement)
        }
        return data
    }
}
class DrawingObject: Object {
    /// 고유 식별자 - 삭제 수정용
    @objc dynamic var id: String = UUID().uuidString
    //https://stackoverflow.com/a/26252124/13049349 nsvalue to cgpoint, cgpoint to nsvalue
    @objc dynamic var from : DrawingPoint?
    @objc dynamic var to : DrawingPoint?
    static override func primaryKey() -> String? {
        return "id"
    }
    override init() {
        
    }
    /**
     - parameters:
        - cgToNS: Boolean, CGPoint -> NSValue(true, return nil), NSValue -> CGPoint(false, return CGPoint?)
        - cgFrom: CGPoint? cgToNS 값이 true일 경우 무조건 있어야 한다.
        - cgTo: CGPoint? cgToNS 값이 true일 경우 무조건 있어야 한다.
     */
    /// cgToNS : CGPoint -> NSValue(true, return nil), NSValue -> CGPoint(false, return CGPoint?)
    func drawingObjectConvert(cgToNS : Bool, cgFrom: CGPoint? = nil, cgTo: CGPoint? = nil) -> (CGPoint, CGPoint)? {
        if cgToNS {
            guard cgFrom != nil, cgTo != nil else {
                return nil
            }
            from = .init(point: cgFrom!) // NSValue(cgPoint: cgFrom!)
            to = .init(point: cgTo!) // NSValue(cgPoint: cgTo!)
            return nil
        }else{
            guard let from = from, let to = to else {
                return nil
            }
            return (from.cgPointValue, to.cgPointValue)
        }
    }
}

class DrawingPoint : Object {
    @objc dynamic var xPoint : Float = 0.0
    @objc dynamic var yPoint : Float = 0.0
    override init() {
        
    }
    convenience init(point: CGPoint) {
        self.init()
        xPoint = Float(point.x)
        yPoint = Float(point.y)
    }
    var cgPointValue : CGPoint {
        get {
            return .init(x: CGFloat(xPoint), y: CGFloat(yPoint))
        }
    }
}
