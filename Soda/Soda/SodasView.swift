//
//  SodasView.swift
//  Soda
//
//  Created by Adam on 3/6/23.
//

import SwiftUI

struct SodasView: View {
    
    @ObservedObject var cdvm: PersistenceController
    @FocusState private var isFocusedTextField: Bool

    var body: some View {
        List{
            TextField("New Soda", text: $cdvm.newSodaName)
                .focused($isFocusedTextField)
                .onSubmit {
                    cdvm.addSoda(name: cdvm.newSodaName)
                    isFocusedTextField = true
                }
            ForEach(cdvm.savedSodas) { soda in
                colorSelection(cdvm: cdvm, soda: soda)
//                Text(soda.name ?? "")
            }
            .onDelete(perform: cdvm.deleteSodaObject)

        }
        .onAppear(){
            if cdvm.savedSodas.isEmpty {
                cdvm.loadSampleSodas()
            }
        }
        .navigationTitle("Sodas")
    }
}

struct SodasView_Previews: PreviewProvider {
    static var previews: some View {
        SodasView(cdvm: PersistenceController())
    }
}

struct colorSelection: View {

    @ObservedObject var cdvm: PersistenceController

    @State var tempColor = Color.red
    var soda: SodaEntity
    
    @State var red: CGFloat = 0.0
    @State var green: CGFloat = 0.0
    @State var blue: CGFloat = 0.0
    @State var alpha: CGFloat = 0.0

    var body: some View {
        HStack{
            
            Menu {
                ForEach(cdvm.sodaImages.indices, id: \.self) { index in
                    Button {
                        soda.shape = Int64(index)
                    } label: {
                        Image(systemName: cdvm.sodaImages[index])
                    }

                }

            } label: {
                Image(systemName: cdvm.sodaImages[Int(soda.shape)])
            }
            
            
            Text(soda.name ?? "")
            ColorPicker("", selection: $tempColor)
        }
        .onChange(of: tempColor) { _ in
           print( UIColor(tempColor).rgba)
            (red,green,blue,alpha) = UIColor(tempColor).rgba
            soda.colorRed = Float(red)
            soda.colorGreen = Float(green)
            soda.colorBlue = Float(blue)
            soda.colorAlpha = Float(alpha)
            cdvm.fetchSodas()
            cdvm.saveObject()
        }
        .onAppear() {
            tempColor = Color(red: CGFloat(soda.colorRed), green: CGFloat(soda.colorGreen), blue: CGFloat(soda.colorBlue))
        }
    }

}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
