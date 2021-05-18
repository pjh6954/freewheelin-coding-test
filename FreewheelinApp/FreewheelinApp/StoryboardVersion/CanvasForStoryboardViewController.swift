//
//  CanvasForStoryboardViewController.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

class CanvasForStoryboardViewController: UIViewController {

    @IBOutlet weak var bgImageCanvas: UIImageView!
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonLoad: UIButton!
    @IBOutlet weak var buttonAddBackground: UIButton!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var buttonRedo: UIButton!
    @IBOutlet weak var buttonPen: UIButton!
    @IBOutlet weak var buttonErase: UIButton!
    // image picker(album에서 이미지 갖고 오기)
    var imagePicker = UIImagePickerController()
    // 그리는 도구들과 관련된 설정값
    var penColor: UIColor = .black // 색상을 바꾸는 기능이 있을 경우 편하게 바꿀 수 있도록 하기 위함.
    var penWidht: CGFloat = 2.0 // 그리는 펜의 크기를 변경할 경우 편하게 바꿀 수 있도록 하기 위함
    // drawing 관련 status 해당하는 변수들
    var isDrawing: Bool = false // 새로운 이미지(라인)객체를 그리게되는 경우
    // var isPenDrawing: Bool = false // pen을 눌러서 지우는 상태인 경우.
    // var isErase: Bool = false // Erase를 눌러서 각 객체를 지우는 상태인 경우.
    var drawingStatus : DrawingType = .noType
    // drawing 객체 저장하는 부분
    var undoObj: [DrawingObjectsModel] = [] // drawingObj
    var redoObj: [DrawingObjectsModel] = []
    var lastPoint : CGPoint = .zero
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonSave.addTarget(self, action: #selector(actionBtnSave(_:)), for: .touchUpInside)
        buttonLoad.addTarget(self, action: #selector(actionBtnLoad(_:)), for: .touchUpInside)
        buttonAddBackground.addTarget(self, action: #selector(actionBtnAdd(_:)), for: .touchUpInside)
        buttonUndo.addTarget(self, action: #selector(actionBtnUndo(_:)), for: .touchUpInside)
        buttonRedo.addTarget(self, action: #selector(actionBtnRedo(_:)), for: .touchUpInside)
        buttonPen.addTarget(self, action: #selector(actionBtnPen(_:)), for: .touchUpInside)
        buttonErase.addTarget(self, action: #selector(actionBtnErase(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - Functions
    // redo, undo, 또는 Load일 경우에 사용한다.
    func reDrawing() {
        canvas.image = nil
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(canvas.frame)
        }
        undoObj.forEach { element in
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
                drawLine(from: from, to: to, withType: drawType)
            }
        }
    }
    func drawLine(from: CGPoint, to: CGPoint, withType: DrawingType? = nil) {
        let withDrawType : DrawingType = (withType != nil ? withType! : self.drawingStatus)
        var blenderMode: CGBlendMode?
        if withDrawType == .pen {
            blenderMode = .normal
        }
        if withDrawType == .erase {
            blenderMode = .clear
        }
        guard withDrawType != .noType else {
            return
        }
        UIGraphicsBeginImageContext(canvas.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        canvas.image?.draw(in: canvas.bounds)
        if let mode = blenderMode {
            context.setBlendMode(mode)
        }
        context.setLineCap(.round)
        context.setLineWidth(penWidht)
        context.setStrokeColor(penColor.cgColor)
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    // UIView를 Image로 rendering
    fileprivate func renderGraphicsImage(view: UIView) -> UIImageView? {
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
    func mergeImages(drawView: UIImageView, bgImageView: UIImageView) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(x: 0, y: canvas.frame.minY, width: canvas.frame.size.width, height: canvas.frame.size.height))
        imageView.image = self.bgImageCanvas.image
        imageView.contentMode = self.bgImageCanvas.contentMode
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
    @objc func imageCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // we got back an error!
            // showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            // showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    private func saveMethod() {
        // 그려진 이미지를 저장(realm에 저장 - 각 그림 객체들, 배경이미지가 있는 경우 그것도 app data에 저장을 한다.)
        // 1. 만약 background가 있다면 해당 이미지도 저장을 한다.
        // 2. 이미지를 합성한다.
        // 3. 합성한 이미지를 이용해서 image로 만들고 path를 지정해서 저장한다.
        // 4. 성공하면 데이터들과 해당 패스, backgroundimage path까지 해서 db에 저장한다.
        guard let drawView = renderGraphicsImage(view: canvas) else {
            return
        }
        var bgImagePath : String?
        // 배경 저장
        if let image = bgImageCanvas.image, let path = Utils.saveImageToAppData(image: image, quality: 1) {
            bgImagePath = path
        }
        // 이미지 합성 후 image로 반환
        guard let imgWithRendering = mergeImages(drawView: drawView, bgImageView: bgImageCanvas) else {
            return
        }
        // app data에 저장
        guard let savedImagePath = Utils.saveImageToAppData(image: imgWithRendering) else {
            return
        }
        DatabaseManager.shared.saveDrawingData(saveImagePath: savedImagePath, bgPath: bgImagePath, drawingObj: undoObj)
        // photo libraray에 저장
        UIImageWriteToSavedPhotosAlbum(
            imgWithRendering, self,
            #selector(imageCompletion(_:didFinishSavingWithError:contextInfo:)), nil
        )
        // 저장 후
    }
}

extension CanvasForStoryboardViewController {
    // MARK: - Actions(Button)
    @objc private func actionBtnSave(_ sender: UIButton) {
        NSLog("canvas :: \(canvas.frame) ::: \(canvas.frame.minY), \(canvas.bounds)")
        saveMethod()
    }
    @objc private func actionBtnLoad(_ sender: UIButton) {
        // 저장된 객체를 불러와서 그리도록 하는 부분 - Realm에서 불러온 후 해당 객체들을 그려준다.
        // undo, redo 가능하도록 하기 위해서.(다만 redo는 최초 로드 시 하지 못한다.)
        guard let vc = UIStoryboard(name: "LoadPastDatasViewController", bundle: nil).instantiateViewController(withIdentifier: "LoadPastDatasViewController") as? LoadPastDatasViewController else {
            return
        }
        vc.delegate = self
        guard let navi = self.navigationController else {
            return
        }
        navi.pushViewController(vc, animated: true)
    }
    @objc private func actionBtnAdd(_ sender: UIButton) {
        // image를 불러와서 설정하는 부분
        // save를 누를 때 해당 이미지가 존재하는 경우 같이 저장하도록 해줘야 한다.
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true) { }
        }
    }
    @objc private func actionBtnUndo(_ sender: UIButton) {
        guard !undoObj.isEmpty, let current = undoObj.last, current.type != .noType else {
            return
        }
        redoObj.append(current)
        _ = undoObj.popLast()
        reDrawing()
        /*
        guard !undoObj.objects.isEmpty, let current = undoObj.objects.last, current.from != nil, current.to != nil, (current.type ?? .noType) != .noType else {
            return
        }
        redoObj.objects.append(current)
        _ = undoObj.objects.popLast() // removeLast는 optional이 아니라서 죽는 상황에 대비하기 위해.
        reDrawing()
        */
    }
    @objc private func actionBtnRedo(_ sender: UIButton) {
        guard !redoObj.isEmpty, let current = redoObj.last, current.type != .noType else {
            return
        }
        undoObj.append(current)
        _ = redoObj.popLast()
        reDrawing()
        /*
        guard !redoObj.objects.isEmpty, let current = redoObj.objects.last, current.from != nil, current.to != nil, (current.type ?? .noType) != .noType else {
            return
        }
        undoObj.objects.append(current)
        _ = redoObj.objects.popLast() // removeLast는 optional이 아니라서 죽는 상황에 대비하기 위해.
        reDrawing()
        */
    }
    @objc private func actionBtnPen(_ sender: UIButton) {
        // isPenDrawing = !isPenDrawing
        // isErase = false
        drawingStatus = (drawingStatus == .pen ? .noType : .pen)
    }
    @objc private func actionBtnErase(_ sender: UIButton) {
        // isErase = !isErase
        // isPenDrawing = false
        drawingStatus = (drawingStatus == .erase ? .noType : .erase)
    }
}

extension CanvasForStoryboardViewController {
    // MARK: - Functions - Drawing(Touch)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touch 시작 한 경우
        // isPenDrawing이 true인 경우에만 시작을 한다.
        // guard isPenDrawing || isErase else {
        guard drawingStatus != .noType else {
            return
        }
        redoObj.removeAll() // redo는 새로 그려질 경우에는 없어져야 한다.
        isDrawing = false
        if let touch = touches.first {
            self.lastPoint = touch.location(in: self.canvas)
            self.undoObj.append(.init(type: drawingStatus))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // guard isPenDrawing || isErase else {
        guard drawingStatus != .noType else {
            return
        }
        isDrawing = true // 실질적으로 그려지기 시작하는 부분이기 때문
        if let touch = touches.first {
            let nowPoint = touch.location(in: canvas)
            drawLine(from: lastPoint, to: nowPoint)
            // undoObj.objects.append(.init(lastPoint, nowPoint, type: drawingStatus))
            self.undoObj.last!.objects.append(.init(lastPoint, nowPoint))
            lastPoint = nowPoint
            // reDrawing()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // guard isPenDrawing || isErase else {
        guard drawingStatus != .noType else {
            return
        }
        if !isDrawing {
            drawLine(from: lastPoint, to: lastPoint)
            // undoObj.objects.append(.init(lastPoint, lastPoint, type: drawingStatus))
            self.undoObj.last!.objects.append(.init(lastPoint, lastPoint))
            // reDrawing()
        }
        isDrawing = false
    }
}
extension CanvasForStoryboardViewController: LoadDataDelegate {
    func selectItemID(uuid: String) {
        NSLog("Checkuuid : \(uuid)")
    }
    func selectItem(data: DrawingDatas) {
        //load data
        undoObj = data.getDrawingObjectModel()
        NSLog("Checkd undo : \(undoObj.count) :: \(data.drawingLines.count)")
        if let bgPath = data.backgroundImagePath, !bgPath.isEmpty {
            guard let filePath = Utils.getFileURL(fileName: bgPath) else {
                return
            }
            let test = filePath.absoluteString.replacingOccurrences(of: "file://", with: "")
            let image = UIImage(contentsOfFile: test)
            self.bgImageCanvas.image = image
        }
        redoObj.removeAll()
        drawingStatus = .noType
        isDrawing = false
        reDrawing()
    }
}
extension CanvasForStoryboardViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { }
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        bgImageCanvas.image = image
    }
}
