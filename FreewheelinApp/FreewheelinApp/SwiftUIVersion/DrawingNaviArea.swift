//
//  DrawingNaviArea.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/19.
//

import SwiftUI

struct DrawingNaviArea: View {
    @Binding var color: Color
    @Binding var undo: [DrawPoint]
    @Binding var redo: [DrawPoint]
    @Binding var drawingStatus: DrawingType
    private let spacing: CGFloat = 10
    var body: some View {
        HStack(spacing: spacing) {
            HStack(spacing: 5) {
                Button("SAVE") { }
                Button("LOAD") { }
            }
            Spacer(minLength: 0)
            Button("ADD") { }
            Spacer(minLength: 0)
            HStack(spacing: 5) {
                Button("UNDO") {
                    if !self.undo.isEmpty {
                        let obj = self.undo.removeLast()
                        self.redo.append(obj)
                    }
                }
                Button("REDO") {
                    if !self.redo.isEmpty {
                        let obj = self.redo.removeLast()
                        self.undo.append(obj)
                    }
                }
            }
            Spacer(minLength: 0)
            HStack(spacing: 5) {
                Button("PEN") {
                    if self.drawingStatus != .pen {
                        self.drawingStatus = .pen
                    } else {
                        self.drawingStatus = .noType
                    }
                }
                Button("ERASE") {
                    if self.drawingStatus != .erase {
                        self.drawingStatus = .erase
                    } else {
                        self.drawingStatus = .noType
                    }
                }
                /*
                Button("CLEAR") {
                    self.undo = [Drawing]()
                    self.redo = [Drawing]()
                }
                */
            }
        }
        .frame(height: 50) // (height: 200)
    }
}
/*
// TODO: 원하는대로 구현이 안되어서 일단 주석처리 한 부분. 다시 고민.
struct DrawingNaviArea: View {
    @Binding var drawings: [DrawPoint]
    @Binding var drawingType: DrawingType
    @Binding var isDrawing : Bool
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("SAVE")
                })
                .aspectRatio(1, contentMode: .fill).frame(minWidth: 50 ,minHeight: 50, alignment: .center)
                Button(action: {
                    
                }, label: {
                    Text("LOAD")
                })
                .aspectRatio(1, contentMode: .fill).frame(minWidth: 50 ,minHeight: 50, alignment: .center)
            }
            Spacer()
            Spacer()
            Button(action: {
                
            }, label: {
                Text("ADD")
            })
            Spacer()
            Spacer()
            Spacer()
            HStack {
                Button(action: {
                    if !$drawings.wrappedValue.isEmpty {
                        $drawings.wrappedValue.removeLast()
                    }
                }) {
                    Image(systemName: "arrow.backward") // undo
                }
                Button(action: {
                    
                }) {
                    Image(systemName: "arrow.forward") // redo
                }
            }
            Spacer()
            HStack {
                Button(action: {
                    // NSLog("Check action : pen :: \($drawingType)")
                    self.isDrawing.toggle()
                    if $drawingType.wrappedValue == .pen {
                        $drawingType.wrappedValue = .noType
                    } else {
                        $drawingType.wrappedValue = .pen
                    }
                }, label: {
                    Text("PEN")
                })
                Button(action: {
                    // NSLog("Check action : Erase :: \($drawingType)")
                    $isDrawing.wrappedValue.toggle()
                    if $drawingType.wrappedValue == .erase {
                        $drawingType.wrappedValue = .noType
                    } else {
                        $drawingType.wrappedValue = .erase
                    }
                }, label: {
                    Text("ERASE")
                })
            }
        }
    }
}
*/
/*
struct DrawingNaviArea_Previews: PreviewProvider {
    static var previews: some View {
        DrawingNaviArea()
    }
}
*/
