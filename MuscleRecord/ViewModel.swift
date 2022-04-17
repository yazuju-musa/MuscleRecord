//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import SwiftUI
import Firebase

class ViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var records = [Record]()
    @Published var records3 = [Record]()
    @Published var records9 = [Record]()
    @Published var records27 = [Record]()
    @Published var weightArray = [Float]()
    @Published var maxWeight: Float = 0.0
    @Published var latestID: String = ""
    @Published var latestID3: String = ""
    @Published var latestID9: String = ""
    @Published var latestID27: String = ""
    @Published var oldRecord: Record?
    @Published var fontColor = Color("FontColor")
    @Published var cellColor = Color("CellColor")
    @Published var backgroundColor = Color("BackgroundColor")
    
    func getThemeColor() -> Color {
        switch UserDefaults.standard.integer(forKey: "themeColorNumber") {
        case 0:
            return Color("ThemeColor0")
        case 1:
            return Color("ThemeColor1")
        case 2:
            return Color("ThemeColor2")
        case 3:
            return Color("ThemeColor3")
        case 4:
            return Color("ThemeColor4")
        case 5:
            return Color("ThemeColor5")
        default:
            return Color("ThemeColor0")
        }
    }

    func dateFormat(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
    
    func updateEvent(event: Event, newName: String) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).updateData(["name": newName])
    }
    
    func deleteEvent(event: Event) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func addEvent(_ name: String) {
        let db = Firestore.firestore()
        db.collection("user").document(name).setData(["latestWeight": 0, "latestRep": 0, "latestDate": Date(timeInterval: -60*60*24, since: .now)])
    }
    
    func getEvent() {
        let db = Firestore.firestore()
            db.collection("user").getDocuments { snapshot, error in
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.events = snapshot.documents.map { d in
                            let timeStamp = d["latestDate"] as! Timestamp
                            return Event(id: d.documentID, latestWeight: d["latestWeight"] as! Float, latestRep: d["latestRep"] as! Int, latestDate: timeStamp.dateValue())
                        }
                    }
                }
            }
    }
    
    func getRecord(event: Event) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).collection("records").order(by: "date").getDocuments { (snapshot, error) in
            if let snapshot = snapshot{
                DispatchQueue.main.async {
                    snapshot.documents.forEach { d in
                        self.latestID = d.documentID
                        let timeStamp: Timestamp = d["date"] as? Timestamp ?? Timestamp()
                        let date = timeStamp.dateValue()
                        if let newRecord = self.oldRecord {
                            var dateDifference = (Calendar.current.dateComponents([.day], from: newRecord.date, to: timeStamp.dateValue())).day! - 1
                            while dateDifference > 0 {
                                self.records.append(Record(id: UUID().uuidString, date: Date(timeInterval: TimeInterval(-60*60*24*dateDifference), since: date), weight: newRecord.weight, rep: newRecord.rep, dummy: true))
                                dateDifference -= 1
                            }
                        }
                        let record = Record(id: d.documentID, date: date, weight: d["weight"] as? Float ?? 0, rep: d["rep"] as? Int ?? 0, dummy: false)
                        self.oldRecord = record
                        self.records.append(record)
                    }
                    
                    var dataCount = 0
                    var totalWeight: Float = 0
                    var totalRep = 0
                    var remainder = self.records.count % 3
                    var created = false
                    self.records.forEach { record in
                        totalWeight += record.weight
                        totalRep += record.rep
                        dataCount += 1
                        if remainder != 0 && remainder == dataCount && created == false {
                            let recordID = UUID().uuidString
                            self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(dataCount), rep: totalRep/dataCount, dummy: false))
                            self.latestID3 = recordID
                            created = true
                            totalWeight = 0
                            totalRep = 0
                            dataCount = 0
                        }
                        if dataCount == 3 {
                            let recordID = UUID().uuidString
                            self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/3, rep: totalRep/3, dummy: false))
                            self.latestID3 = recordID
                            totalWeight = 0
                            totalRep = 0
                            dataCount = 0
                        }
                    }
                    
                    dataCount = 0
                    totalWeight = 0
                    totalRep = 0
                    remainder = self.records.count % 9
                    created = false
                    self.records.forEach { record in
                        totalWeight += record.weight
                        totalRep += record.rep
                        dataCount += 1
                        if remainder != 0 && remainder == dataCount && created == false {
                            let recordID = UUID().uuidString
                            self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(dataCount), rep: totalRep/dataCount, dummy: false))
                            self.latestID9 = recordID
                            created = true
                            totalWeight = 0
                            totalRep = 0
                            dataCount = 0
                        }
                        if dataCount == 9 {
                            let recordID = UUID().uuidString
                            self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/9, rep: totalRep/9, dummy: false))
                            self.latestID9 = recordID
                            totalWeight = 0
                            totalRep = 0
                            dataCount = 0
                        }
                    }
                    
                    dataCount = 0
                    totalWeight = 0
                    totalRep = 0
                    remainder = self.records.count % 27
                    created = false
                    self.records.forEach { record in
                        totalWeight += record.weight
                        totalRep += record.rep
                        dataCount += 1
                        if remainder != 0 && remainder == dataCount && created == false {
                            let recordID = UUID().uuidString
                            self.records27.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(dataCount), rep: totalRep/dataCount, dummy: false))
                            self.latestID27 = recordID
                            created = true
                            totalWeight = 0
                            totalRep = 0
                            dataCount = 0
                        }
                        if dataCount == 27 {
                            let recordID = UUID().uuidString
                            self.records27.append(Record(id: recordID, date: record.date, weight: totalWeight/27, rep: totalRep/27, dummy: false))
                            self.latestID27 = recordID
                            totalWeight = 0
                            totalRep = 0
                            dataCount = 0
                        }
                    }
                    
                    self.weightArray = snapshot.documents.map { d in
                        if self.maxWeight < d["weight"] as? Float ?? 0.0 {
                            self.maxWeight = d["weight"] as? Float ?? 0.0
                        }
                        return d["weight"] as? Float ?? 0.0
                    }
                }
            }
        }
    }
    
    func addRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).setData(["latestWeight": weight, "latestRep": rep, "latestDate": Date()])
        db.collection("user").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep])
    }
    
    func updateRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).collection("records").order(by: "date", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let snapshot = snapshot {
                snapshot.documents.forEach { d in
                    let latestRecordID = d.documentID
                    db.collection("user").document(event.id).collection("records").document(latestRecordID).delete()
                }
                db.collection("user").document(event.id).setData(["latestWeight": weight, "latestRep": rep,"latestDate": Date()])
                db.collection("user").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep])
            }
        }
    }
}
