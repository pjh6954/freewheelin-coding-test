//
//  LoadPastDatasViewController.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

protocol LoadDataDelegate: AnyObject {
    func selectItemID(uuid: String)
    func selectItem(data : DrawingDatas)
}

class LoadPastDatasViewController : UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    // variables
    public weak var delegate: LoadDataDelegate?
    // lazy buttons
    lazy var rightButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionBtnRight(_:)))
        return button
    }()
    var datas : [DrawingDatas] = []
    var selectedIndex: IndexPath?
    // MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.rightButton
        let cellNib = UINib(nibName: "StoryboardCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "StoryboardCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        guard let getDatas = DatabaseManager.shared.getDrawingData(), !getDatas.isEmpty else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        datas = Array(getDatas)
        NSLog("Checkd atas : \(datas.count)")
        let layout : UICollectionViewFlowLayout = .init()
        let device = UIDevice()
        var width: CGFloat
        if device.userInterfaceIdiom == .phone {
            width = (collectionView.frame.width - (10 * 2)) / 3
        } else {
            width = (collectionView.frame.width - (10 * 5)) / 6
        }
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: width, height: width)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    // MARK: - Actions
    @objc private func actionBtnRight(_ sender: Any) {
        // self.delegate?.selectItemID(uuid: "TEST")
        guard let indexPath = self.selectedIndex, indexPath.row < self.datas.count else {
            return
        }
        delegate?.selectItem(data: datas[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoadPastDatasViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Check index and data : \(indexPath.row) :: \(datas[indexPath.row])")
        selectedIndex = indexPath
    }
}

extension LoadPastDatasViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryboardCollectionViewCell", for: indexPath) as? StoryboardCollectionViewCell else {
            return StoryboardCollectionViewCell()
        }
        cell.setData(data: datas[indexPath.row])
        return cell
    }
}
