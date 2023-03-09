//
//  HistoryView.swift
//  Soda
//
//  Created by Adam on 3/6/23.
//

import SwiftUI

struct HistoryView: View {
    
    @State var showEditView = false
    @ObservedObject var cdvm: PersistenceController

    var body: some View {
        VStack {
            Text("History")
                .font(.largeTitle)
                .padding(.top)
            List{
                ForEach (cdvm.savedEntries) { entry in
                    HStack {
                        
                        Text(entry.date?.formatted() ?? "")
                        Text(" - ")
//                        Image(systemName: cdvm.sodaImages[Int(entry.assignedSoda?.shape ?? 0)])
//                            .foregroundColor(Color(
//                                red: CGFloat(entry.assignedSoda?.colorRed ?? 0.0),
//                                green: CGFloat(entry.assignedSoda?.colorGreen ?? 0.0),
//                                blue: CGFloat(entry.assignedSoda?.colorBlue ?? 1.0)))
                        Text(entry.assignedSoda?.name ?? "")
                    }
                    .onTapGesture(perform: {
                        showEditView.toggle()
                    })
                    .sheet(isPresented: $showEditView) {
                        EditEntryView(cdvm: cdvm, currentEntry: entry)
                    }
                }
                .onDelete(perform: cdvm.deleteEntryObject)
            }
            .listStyle(.plain)
        }
      
    }
}

struct EditEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var cdvm: PersistenceController
    @State var selectedDate: Date = Date()
    @State var currentEntry: EntryEntity
    
    var body: some View {
        VStack{
            Text(currentEntry.assignedSoda?.name ?? "")
                .font(.largeTitle)
                .padding(.top)
            
            DatePicker("Select a new date", selection: $selectedDate)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onAppear(){
                    selectedDate = currentEntry.date ?? Date()
                }
                .onDisappear(){
                    currentEntry.date = selectedDate
                    cdvm.saveObject()
                }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Update")
            }
            .buttonStyle(.borderedProminent)

            
            Spacer()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(cdvm: PersistenceController())
    }
}
