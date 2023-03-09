//
//  Persistence.swift
//  Soda
//
//  Created by Adam on 3/6/23.
//

import CoreData

class PersistenceController: ObservableObject {
//    static let shared = PersistenceController()

//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
////        for _ in 0..<10 {
////            let newItem = Item(context: viewContext)
////            newItem.timestamp = Date()
////        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()


//    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "Soda")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
////        fetchSodas()
//    }
    
    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "Soda")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading core data: \(error)")
            }
        }
        fetchSodas()
        fetchEntries()
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //    MARK: Fetch Sodas
    
    @Published var savedSodas: [SodaEntity] = []
    
    func fetchSodas() {
        
        var returnedList: [SodaEntity] = []
        
        let request = NSFetchRequest<SodaEntity>(entityName: "SodaEntity")
        
        let sort = [NSSortDescriptor(key: "name", ascending: true)]
        request.sortDescriptors = sort
        
        do {
            returnedList = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetch: \(error)")
        }
        
        savedSodas = returnedList
        
    }
        
    //    MARK: Fetch Entries
    
    @Published var savedEntries: [EntryEntity] = []
    
    func fetchEntries() {
        
        var returnedList: [EntryEntity] = []
        
        let request = NSFetchRequest<EntryEntity>(entityName: "EntryEntity")
        
        let sort = [NSSortDescriptor(key: "date", ascending: false)]
        request.sortDescriptors = sort
        
        do {
            returnedList = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetch: \(error)")
        }
        
        savedEntries = returnedList
        
    }
    
    func loadSampleSodas() {
        addSoda(name: "Coke", red: 0.9271586537361145, green: 0.02076026238501072, blue: 0, alpha: 1)
        addSoda(name: "Sprite", red: 0, green: 0.7442476749420166, blue: 0.018933096900582314, alpha: 1)
        addSoda(name: "Coffee", red: 0.3526390790939331, green: 0.23222410678863525, blue: 0, alpha: 1, sodaImage: 0)
        }
    
    @Published var newSodaName = ""
    @Published var sodaImages = ["cup.and.saucer.fill", "mug.fill" , "wineglass.fill"]

    func addSoda(name: String, red: Float = 0.0, green: Float = 0.0, blue: Float = 1.0, alpha: Float = 1.0, sodaImage: Int = 1) {
        let newSoda = SodaEntity(context: container.viewContext)
        newSoda.name = name
        newSoda.colorRed = red
        newSoda.colorGreen = green
        newSoda.colorBlue = blue
        newSoda.colorAlpha = alpha
        newSoda.shape = Int64(sodaImage)
        
        saveObject()
        newSodaName = ""
        fetchSodas()
    }
    
    //    MARK: Save
    func saveObject() {
        let context = container.viewContext
        
        do {
            try context.save()
        } catch {
        }
    }
    //    MARK: Delete Soda
    func deleteSodaObject(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedSodas[index]
        container.viewContext.delete(entity)
        saveObject()
        self.fetchSodas()
    }
    
    //    MARK: Delete Entry
    func deleteEntryObject(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntries[index]
        container.viewContext.delete(entity)
        saveObject()
        self.fetchEntries()
    }
    
    // MARK: Log Soda
    
    func logSoda(soda: SodaEntity) {
        let newEntry = EntryEntity(context: container.viewContext)
        newEntry.date = Date()
        newEntry.assignedSoda = soda
        
        saveObject()
        newSodaName = ""
        fetchEntries()
    }
}
