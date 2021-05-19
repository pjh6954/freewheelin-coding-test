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
        let guide = view.safeAreaLayoutGuide
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        contentView.view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        contentView.view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
    /*
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CanvasForSwiftUIView())
    }
    */
}
