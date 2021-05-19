//
//  CanvasSwiftUIViewModel.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/19.
//

import Foundation
import Combine

// TODO: MVVM Model
class CanvasSwiftUIViewModel: ObservableObject {
    let willChange = PassthroughSubject<Void, Never>()
    @Published var isEdited = false
    /*
    var undoObj: [DrawingObjectsModel] = [DrawingObjectsModel]()
    var redoObj: [DrawingObjectsModel] = [DrawingObjectsModel]()
    */
}
