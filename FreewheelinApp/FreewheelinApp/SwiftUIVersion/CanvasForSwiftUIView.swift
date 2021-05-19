//
//  CanvasForSwiftUIView.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import SwiftUI

struct CanvasForSwiftUIView: View {
    @State private var currentDrawing: DrawPoint = DrawPoint()
    @State private var undo: [DrawPoint] = [DrawPoint]()
    @State private var redo: [DrawPoint] = [DrawPoint]()
    @State private var color: Color = Color.black
    @State private var lineWidth: CGFloat = 3.0
    @State private var drawingStatus: DrawingType = .noType {
        willSet {
            NSLog("Check newvalue : \(newValue)")
        }
    }
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            DrawingNaviArea(color: $color, undo: $undo, redo: $redo, drawingStatus: $drawingStatus)
            DrawingArea(currentDrawing: $currentDrawing,
                       drawings: $undo,
                       color: $color,
                       lineWidth: $lineWidth, drawingStatus: $drawingStatus)
        }
    }
    /*
    // TODO: ViewModel로 만들던 중 남은 코드 - 차후 공부하면서 수정
    // @ObservedObject var viewModel : CanvasSwiftUIViewModel = .init()
    
    @State private var currentDrawing : Drawing = Drawing()
    @State private var drawings: [Drawing] = [Drawing]()
    @State private var penColor: Color = Color.black {
        willSet {
            NSLog("Check new value: \(newValue)")
        }
        didSet {
            NSLog("Check after : \(self.penColor) :: \(oldValue)")
        }
    } // Storyboard와 최대한 동일하게 구현하기 위해 일단 설정
    @State private var penWidht: CGFloat = 2.0 // 그리는 펜의 크기를 변경할 경우 편하게 바꿀 수 있도록 하기 위함
    @State private var eraseWidth : CGFloat = 10.0 // 지우는 크기를 변경할 경우 편하게 하기 위함
    @State private var isDrawing: Bool = false {
        willSet {
            NSLog("Called in drawing \(newValue)")
        }
    }
    @State private var drawingStatus: DrawingType = .noType {
        willSet {
            NSLog("Check new value : \(newValue)")
            if newValue == .erase {
                self.penColor = .clear
            } else if newValue == .pen {
                self.penColor = .black
            }
        }
        didSet {
            NSLog("Check data : \(oldValue):: \(self.drawingStatus)")
        }
    }
    
    var body: some View {
        return VStack(spacing: 0) {
            // top area. 나중에 파일 따로 분리해야 함.
            DrawingNaviArea(drawings: $drawings, drawingType: $drawingStatus, isDrawing: $isDrawing)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .leading)
            .padding(.all, 0)
            .background(Color.yellow)
            DrawingArea(currentDrawing: $currentDrawing, drawings: $drawings, color: $penColor, lineWidth: $penWidht)
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.green)
        .onAppear(perform: defaultSetting)
    }
    
    private func defaultSetting() {
        
    }
    */
}

struct CanvasForSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        // CanvasForSwiftUIView(viewModel: CanvasSwiftUIViewModel())
        CanvasForSwiftUIView()
    }
}
