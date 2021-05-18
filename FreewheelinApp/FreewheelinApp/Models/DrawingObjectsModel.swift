//
//  DrawingObjectsModel.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

/**
 그리는 상태에 대한 enum
 erase, pen, noType을 갖고있다.
 - Parameters:
    - erase: 지우기 상태
    - pen: 그리기 상태
    - noType: 그리기도 지우기도 아닌 상태
 */
public enum DrawingType: String {
    /// 지우기 상태
    case erase = "erase"
    /// 그리기 상태
    case pen = "pen"
    /// 그리기도 지우기도 아닌 상태
    case noType = "noType"
}
/**
 drawing 관련된 Object를 정의하는 부분. save, load에도 이용하고, undo, redo에도 이용하게 된다.
 */
public class DrawingObjectsModel: NSObject {
    /** 그려지는 것의 포인트 array */
    var objects: [DrawingObjectElement] = []
    var type: DrawingType?
    init(type : DrawingType) {
        self.type = type
    }
}

public class DrawingObjectElement: NSObject {
    var from: CGPoint?
    var to : CGPoint?
    init(_ from: CGPoint, _ to: CGPoint) {
        self.from = from
        self.to = to
    }
}
