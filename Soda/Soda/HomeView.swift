//
//  HomeView.swift
//  Soda
//
//  Created by Adam on 3/6/23.
//

import SwiftUI

struct HomeView: View {
//    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var cdvm = PersistenceController()
    
    @State var dateSelected: DateComponents?
    @State var displayEvents = false
    
    @State var showSettings = false
    @State var showHistory = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "list.clipboard")
                    .onTapGesture {
                        showHistory.toggle()
                    }
                Image(systemName: "gear")
                    .padding(.horizontal)
                    .onTapGesture {
                        showSettings.toggle()
                }
            }.font(.title)
            Text("Soda Tracker")
                .font(.largeTitle)
            ScrollView(.horizontal) {
                HStack(alignment: .center){
                    ForEach (cdvm.savedSodas) { soda in
                        
                        Button {
                            cdvm.logSoda(soda: soda)
                        } label: {
                            
                            ZStack {
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.clear)
                                    .background(.ultraThickMaterial)
                                    .cornerRadius(15)
                                VStack {
                                    Image(systemName: cdvm.sodaImages[Int(soda.shape)])
                                        .font(.title) 
                                        .foregroundColor(Color(
                                            red: CGFloat(soda.colorRed ),
                                            green: CGFloat(soda.colorGreen ),
                                            blue: CGFloat(soda.colorBlue )))
                                    Text(soda.name ?? "")
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.horizontal, 10)
                            
//                            ZStack {
//                                Rectangle()
//                                    .frame(width: 100, height: 50)
//                                    .cornerRadius(20.0)
//                                    .foregroundColor(.black)
//                                Text(soda.name ?? "")
//                                    .foregroundColor(.red)
//                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            ScrollView {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), cdvm: cdvm, dateSelected: $dateSelected, displayEvents: $displayEvents)
            }
            DaysEventsListView(cdvm: cdvm, dateSelected: $dateSelected)
                .frame(height: 150)
            
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(cdvm: cdvm)
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(cdvm: cdvm)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(cdvm: PersistenceController())
    }
}




struct CalendarView: UIViewRepresentable {
    
    let interval: DateInterval
    @ObservedObject var cdvm: PersistenceController
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar (identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, cdvm: _cdvm)
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        
    }
    
}

    
class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

    
        var parent: CalendarView
        @ObservedObject var cdvm: PersistenceController
        
        init(parent: CalendarView, cdvm: ObservedObject<PersistenceController>) {
            self.parent = parent
            self._cdvm = cdvm
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            let foundEvents = cdvm.savedEntries
                .filter { $0.date?.startOfDay == dateComponents.date?.startOfDay }
            if foundEvents.isEmpty { return nil }
            
//            if foundEvents.count == 1 {
//                let singleEvent = UILabel()
////                icon.text = singleEvent.EventType.icon
//                return .customView {
////                    Image(systemName: "mug.fill")
//                    EmojiView()
//                }
////                foundEvents.first!
//            }
            else {
                return .image(UIImage(systemName: ".doc.on.doc.fill"), color: .red, size: .medium)
                    
            }
            
            
        }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        parent.dateSelected = dateComponents
        guard let dateComponents else { return }
        let foundEvents = cdvm.savedEntries
            .filter { $0.date?.startOfDay == dateComponents.date?.startOfDay }
        if !foundEvents.isEmpty {
            parent.displayEvents.toggle()
        }
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
    }
    

struct DaysEventsListView: View {
    
    @ObservedObject var cdvm: PersistenceController
    @Binding var dateSelected: DateComponents?
//    @State private var formType: EventFormType?
    
    var body: some View {
        Group {
            if let dateSelected {
                let foundEvents = cdvm.savedEntries
                    .filter { $0.date?.startOfDay == dateSelected.date!.startOfDay}
                
                HStack {

                    ForEach(foundEvents, id: \.self) { event in
                        VStack{
                            Image(systemName: cdvm.sodaImages[Int(event.assignedSoda?.shape ?? 0)])
                                .font(.title) 
                                .foregroundColor(Color(
                                    red: CGFloat(event.assignedSoda?.colorRed ?? 0.0),
                                    green: CGFloat(event.assignedSoda?.colorGreen ?? 0.0),
                                    blue: CGFloat(event.assignedSoda?.colorBlue ?? 1.0)))
                            Text(event.assignedSoda?.name ?? "")
                        }
                    }
                    
                }
                .listStyle(.plain)
            }
        }
    }
}



extension Date {
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
    

//import UIKit

//class EmojiView: UIView {
//    var body: some View {
//        Image(systemName: "mug.fill")
//    }
//}
