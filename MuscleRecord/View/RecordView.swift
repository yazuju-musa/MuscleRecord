//
//  InputView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/03/29.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    @ObservedObject private var viewModel = ViewModel()
    @State private var weight = 0
    @State private var rep = 0
    var event: Event
    
    var body: some View {
        SimpleNavigationView(title: event.name) {
            VStack{
                //重量入力
                HStack{
                    Text(R.string.localizable.weightTitle()).fontWeight(.bold)
                    Picker(R.string.localizable.weight(), selection: $weight, content: {
                        ForEach(1..<1001) { num in
                            Text(String(Float(num)/2)).font(.headline)
                        }
                    })
                    .frame(width: 100)
                    .clipped()
                    .pickerStyle(WheelPickerStyle())
                    .onAppear {
                        weight = Int(event.latestWeight*2) - 1
                    }
                    Text(R.string.localizable.kg()).fontWeight(.bold)
                }
                //回数入力
                HStack{
                    Text(R.string.localizable.repTitle()).fontWeight(.bold)
                    Picker(R.string.localizable.rep(), selection: $rep, content: {
                        ForEach(1..<100) { num in
                            Text(String(num)).font(.headline)
                        }
                    })
                    .frame(width: 100)
                    .clipped()
                    .pickerStyle(WheelPickerStyle())
                    .onAppear {
                        rep = event.latestRep - 1
                    }
                    Text(R.string.localizable.rep()).fontWeight(.bold)
                }
                //記録ボタン
                Button( action: {
                    //既に記録している場合記録を更新
                    if viewModel.dateFormat(date: Date()) == viewModel.dateFormat(date: event.latestDate) {
                        firebaseViewModel.updateRecord(event: event, weight: Float(weight)/2 + 0.5, rep: rep + 1)
                    } else {
                        firebaseViewModel.addRecord(event: event, weight: Float(weight)/2 + 0.5, rep: rep + 1)
                    }
                    dismiss()
                }, label: {
                    if viewModel.dateFormat(date: Date()) == viewModel.dateFormat(date: event.latestDate) {
                        ButtonView(text: R.string.localizable.updateRecord())
                    } else {
                        ButtonView(text: R.string.localizable.record())
                    }
                })
                Spacer()
            }.padding(20)
        }
    }
}
