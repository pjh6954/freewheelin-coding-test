//
//  CanvasSwiftUIContainViewController.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit
import SwiftUI

class CanvasSwiftUIContainViewController: UIViewController {
    let contentView = UIHostingController(rootView: CanvasForSwiftUIView())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView.view)
        setupConstraint()
    }
    private func setupConstraint() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    /*
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CanvasForSwiftUIView())
    }
    */
}
