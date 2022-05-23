//
//  ButtonView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/17.
//

import SwiftUI

struct ButtonView: View {
    @ObservedObject var viewModel = ViewModel()
    var text: String
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 70, alignment: .center)
            .background(viewModel.getThemeColor())
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}
