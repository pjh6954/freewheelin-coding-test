//
//  CanvasForStoryboardViewController.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

protocol CanvasForStoryboardViewControllerProtocol {
    var viewModel: CanvasViewModel {get set}
    func config()
}

class CanvasForStoryboardViewController: UIViewController, CanvasForStoryboardViewControllerProtocol {
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
    // drawing 관련 status 해당하는 변수들
    var viewModel: CanvasViewModel = .init()
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
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: - config view model
    func config() {
        
    }
    // MARK: - Functions
    // redo, undo, 또는 Load일 경우에 사용한다.
    func reDrawing() {
        canvas.image = nil
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(canvas.frame)
        }
        viewModel.redrawing { (from, to, drawType) in
            drawLine(from: from, to: to, withType: drawType)
        }
    }
    // 라인을 화면에 그리는 용도
    func drawLine(from: CGPoint, to: CGPoint, withType: DrawingType? = nil) {
        let withDrawType : DrawingType = (withType != nil ? withType! : self.viewModel.drawingStatus)
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
        if withDrawType == .erase {
            context.setLineWidth(viewModel.eraseWidth)
        } else if withDrawType == .pen {
            context.setLineWidth(viewModel.penWidht)
        }
        context.setStrokeColor(viewModel.penColor.cgColor)
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    // 이미지 저장을 완료한 경우 호출되는 함수
    @objc func imageCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alertVC = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    private func saveMethod() {
        // 그려진 이미지를 저장(realm에 저장 - 각 그림 객체들, 배경이미지가 있는 경우 그것도 app data에 저장을 한다.)
        // 1. 만약 background가 있다면 해당 이미지도 저장을 한다.
        // 2. 이미지를 합성한다.
        // 3. 합성한 이미지를 이용해서 image로 만들고 path를 지정해서 저장한다.
        // 4. 성공하면 데이터들과 해당 패스, backgroundimage path까지 해서 db에 저장한다.
        guard let drawView = viewModel.renderGraphicsImage(view: canvas) else {
            return
        }
        var bgImagePath : String?
        // 배경 저장
        if let image = bgImageCanvas.image, let path = Utils.saveImageToAppData(image: image, quality: 1) {
            bgImagePath = path
        }
        // 이미지 합성 후 image로 반환
        guard let imgWithRendering = viewModel.mergeImages(defaultCanvas: canvas, drawView: drawView, bgImageView: bgImageCanvas) else {
            return
        }
        // app data에 저장
        guard let savedImagePath = Utils.saveImageToAppData(image: imgWithRendering) else {
            return
        }
        DatabaseManager.shared.saveDrawingData(saveImagePath: savedImagePath, bgPath: bgImagePath, drawingObj: viewModel.undoObj)
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
        viewModel.redoUndo(isUndo: true) {
            reDrawing()
        }
    }
    @objc private func actionBtnRedo(_ sender: UIButton) {
        viewModel.redoUndo(isUndo: false) {
            reDrawing()
        }
    }
    @objc private func actionBtnPen(_ sender: UIButton) {
        viewModel.drawingStatus = (viewModel.drawingStatus == .pen ? .noType : .pen)
    }
    @objc private func actionBtnErase(_ sender: UIButton) {
        viewModel.drawingStatus = (viewModel.drawingStatus == .erase ? .noType : .erase)
    }
}

extension CanvasForStoryboardViewController {
    // MARK: - Functions - Drawing(Touch)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touch 시작 한 경우
        // isPenDrawing이 true인 경우에만 시작을 한다.
        // guard isPenDrawing || isErase else {
        guard viewModel.drawingStatus != .noType else {
            return
        }
        viewModel.redoObj.removeAll() // redo는 새로 그려질 경우에는 없어져야 한다.
        viewModel.isDrawing = false
        if let touch = touches.first {
            viewModel.lastPoint = touch.location(in: self.canvas)
            viewModel.undoObj.append(.init(type: viewModel.drawingStatus))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard viewModel.drawingStatus != .noType else {
            return
        }
        viewModel.isDrawing = true // 실질적으로 그려지기 시작하는 부분이기 때문
        if let touch = touches.first {
            let nowPoint = touch.location(in: canvas)
            drawLine(from: viewModel.lastPoint, to: nowPoint)
            viewModel.undoObj.last!.objects.append(.init(viewModel.lastPoint, nowPoint))
            viewModel.lastPoint = nowPoint
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard viewModel.drawingStatus != .noType else {
            return
        }
        if !viewModel.isDrawing {
            drawLine(from: viewModel.lastPoint, to: viewModel.lastPoint)
            viewModel.undoObj.last!.objects.append(.init(viewModel.lastPoint, viewModel.lastPoint))
        }
        viewModel.isDrawing = false
    }
}
extension CanvasForStoryboardViewController: LoadDataDelegate {
    func selectItemID(uuid: String) {
        NSLog("Checkuuid : \(uuid)")
    }
    func selectItem(data: DrawingDatas) {
        viewModel.undoObj = data.getDrawingObjectModel()
        NSLog("Checkd undo : \(viewModel.undoObj.count) :: \(data.drawingLines.count)")
        if let bgPath = data.backgroundImagePath, !bgPath.isEmpty {
            guard let filePath = Utils.getFileURL(fileName: bgPath) else {
                return
            }
            let test = filePath.absoluteString.replacingOccurrences(of: "file://", with: "")
            let image = UIImage(contentsOfFile: test)
            self.bgImageCanvas.image = image
        }
        viewModel.redoObj.removeAll()
        viewModel.drawingStatus = .noType
        viewModel.isDrawing = false
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
