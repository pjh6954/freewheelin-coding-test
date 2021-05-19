//
//  CanvasViewModel.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/19.
//

import UIKit

protocol CanvasProtocl {
    // 그리는 도구들과 관련된 설정값
    var penColor: UIColor { get }
    var penWidht: CGFloat { get }
    var eraseWidth : CGFloat { get }
    var isDrawing: Bool { get set }
    var drawingStatus : DrawingType { get set }
    // drawing 객체 저장하는 부분
    var undoObj: [DrawingObjectsModel] { get set } // drawingObj
    var redoObj: [DrawingObjectsModel] { get set }
    var lastPoint : CGPoint { get set }
    // functions
    func renderGraphicsImage(view: UIView) -> UIImageView?
    func mergeImages(defaultCanvas : UIImageView, drawView: UIImageView, bgImageView: UIImageView) -> UIImage?
    func redoUndo(isUndo: Bool, completion: () -> Void)
    func redrawing(mulipleCompletion: (_ from: CGPoint, _ to: CGPoint, _ withType: DrawingType) -> Void)
}

public class CanvasViewModel: CanvasProtocl {
    init() { }
    deinit {
        NSLog("deinit in canvas view model")
    }
    // 그리는 도구들과 관련된 설정값
    var penColor: UIColor = .black // 색상을 바꾸는 기능이 있을 경우 편하게 바꿀 수 있도록 하기 위함.
    var penWidht: CGFloat = 2.0 // 그리는 펜의 크기를 변경할 경우 편하게 바꿀 수 있도록 하기 위함
    var eraseWidth : CGFloat = 10.0 // 지우는 크기를 변경할 경우 편하게 하기 위함
    public var isDrawing: Bool = false // 새로운 이미지(라인)객체를 그리게되는 경우
    public var drawingStatus: DrawingType = .noType
    public var undoObj: [DrawingObjectsModel] = []
    public var redoObj: [DrawingObjectsModel] = []
    public var lastPoint : CGPoint = .zero
    // UIView를 Image로 rendering
    public func renderGraphicsImage(view: UIView) -> UIImageView? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let renderImg = renderer.image { (ctx) in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            let renderingImgView = UIImageView(frame: view.bounds)
            renderingImgView.image = renderImg
            return renderingImgView
        } else {
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(view: view)
            return imageView
        }
    }
    public func mergeImages(defaultCanvas : UIImageView, drawView: UIImageView, bgImageView: UIImageView) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(x: 0, y: defaultCanvas.frame.minY, width: defaultCanvas.frame.size.width, height: defaultCanvas.frame.size.height))
        imageView.image = bgImageView.image
        imageView.contentMode = bgImageView.contentMode
        imageView.addSubview(drawView)
        UIGraphicsBeginImageContextWithOptions(drawView.bounds.size, false, 0.0)
        drawView.superview?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapShotStillImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let snapShotStillImg = snapShotStillImg {
            return snapShotStillImg
        } else {
            return nil
        }
    }
    public func redoUndo(isUndo: Bool, completion: () -> Void) {
        if isUndo {
            guard !self.undoObj.isEmpty, let current = self.undoObj.last, current.type != .noType else {
                return
            }
            self.redoObj.append(current)
            _ = self.undoObj.popLast()
            completion()
        }else{
            guard !self.redoObj.isEmpty, let current = self.redoObj.last, current.type != .noType else {
                return
            }
            self.undoObj.append(current)
            _ = self.redoObj.popLast()
            completion()
        }
    }
    func redrawing(mulipleCompletion: (_ from: CGPoint, _ to: CGPoint, _ withType: DrawingType) -> Void) {
        self.undoObj.forEach { element in
            guard (element.type ?? .noType) != .noType else {
                return
            }
            element.objects.forEach { drawObj in
                guard let drawType = element.type, drawType != .noType else {
                    return
                }
                guard let from = drawObj.from, let to = drawObj.to else {
                    return
                }
                mulipleCompletion(from, to, drawType)
            }
        }
    }
    
}
