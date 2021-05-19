//
//  CanvasForSwiftUIView.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import SwiftUI

struct CanvasForSwiftUIView: View {
    var body: some View {
        return VStack {
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
                        
                    }, label: {
                        Text("ADD")
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("ADD")
                    })
                }
                Spacer()
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("PEN")
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("ERASE")
                    })
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .leading)
            .padding(.all, 0)
            .background(Color.yellow)
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.green)
    }
}

struct CanvasForSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasForSwiftUIView()
    }
}
