//
//  DrawingArea.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/19.
//

import SwiftUI

struct DrawingArea: View {
    @Binding var currentDrawing: DrawPoint
    @Binding var drawings: [DrawPoint]
    @Binding var color: Color // erase일 때 문제 - 지금 Color들을 한번에 바꾸기 때문
    @Binding var lineWidth: CGFloat
    @Binding var drawingStatus: DrawingType
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for drawing in self.drawings {
                    self.add(drawing: drawing, toPath: &path)
                }
                self.add(drawing: self.currentDrawing, toPath: &path)
            }
            .stroke(self.color, lineWidth: self.lineWidth) // Stroke문제. 
            .background(Color.white) // Color(white: 0.95)
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged({ (value) in
                        let current = value.location
                        if current.y >= 0 && current.y < geometry.size.height {
                            self.currentDrawing.points.append(current)
                        }
                })
                .onEnded({ (_) in
                    self.drawings.append(self.currentDrawing)
                    self.currentDrawing = DrawPoint()
                })
            )
        }
        .frame(maxHeight: .infinity)
    }
    private func add(drawing: DrawPoint, toPath path: inout Path) {
        let points = drawing.points
        if points.count > 1 {
            for index in 0..<points.count-1 {
                let current = points[index]
                let next = points[index+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }
}
/*
struct DrawingArea_Previews: PreviewProvider {
    static var previews: some View {
        // DrawingArea() // 변수들 추가되면서 preview를 쓰기 위해설정해야 하는데, 방법을 몰라서 일단 없엠.
        DrawingArea(currentDrawing: <#Binding<Drawing>#>, drawings: <#Binding<[Drawing]>#>, color: <#Binding<Color>#>, lineWidth: <#Binding<CGFloat>#>)
    }
}
*/
