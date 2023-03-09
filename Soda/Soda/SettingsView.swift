//
//  SettingsView.swift
//  Soda
//
//  Created by Adam on 3/6/23.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var cdvm: PersistenceController
    @AppStorage("defaultAmount") var defaultAmount: Double = 12.0
    @State var sliderValue: Double = 12.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding(.top)
                Form {
                    NavigationLink {
                        SodasView(cdvm: cdvm)
                    } label: {
                        Text("Sodas")
                    }
                    Text("Default Ounces: \(Int(sliderValue))")
                    Slider(value: $sliderValue, in: 1...32)
                        .onAppear(){
                            sliderValue = defaultAmount
                        }
                        .onDisappear() {
                            defaultAmount = sliderValue
                        }

                }
                
                
                Spacer()
                
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(cdvm: PersistenceController())
    }
}
