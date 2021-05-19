//
//  RootViewController.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

class RootViewController : UIViewController {
    @IBOutlet weak var buttonStoryboard: UIButton!
    @IBOutlet weak var buttonWithSwiftUI: UIButton!
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStoryboard.addTarget(self, action: #selector(actionBtnStoryboard(_:)), for: .touchUpInside)
        buttonWithSwiftUI.addTarget(self, action: #selector(actionBtnWithSwiftUI(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - Actions
    @objc func actionBtnStoryboard(_ sender : UIButton) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "CanvasStorboardVC") as? CanvasForStoryboardViewController else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func actionBtnWithSwiftUI(_ sender: UIButton) {
        // CanvasSwiftUIVC
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CanvasSwiftUIVC") as? CanvasSwiftUIContainViewController else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
