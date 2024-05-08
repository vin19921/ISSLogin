//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct SPTimeFrameView: View {
    
    @ObservedObject private var presenter: TimeFramePresenter
    @State private var selectedDate = Date()
    @State private var selectedOptionIndex = 0
    let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: TimeFramePresenter) {
        self.presenter = presenter
    }
    
    // MARK: View
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)

                switch presenter.state {
                case .isLoading:
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .onAppear {
                            presenter.fetchTimeFrameList(request: TimeFrame.Model.Request())
                        }
                    Spacer()
                case .success:
                    VStack {
                        Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                        
                        DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()

                        Text("Selected Option: \(options[selectedOptionIndex])")
                           .padding()

                        Picker(selection: $selectedOptionIndex, label: Text("Select Option")) {
                            ForEach(0..<options.count) { index in
                                Text(self.options[index]).tag(index)
                            }
                        }
                        .pickerStyle(CustomPickerStyle())
                    }
                    .padding()
                    Spacer()
                case let .failure(type):
                    Text("Error")
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
            }
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }
}


struct CustomPickerStyle: PickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Picker(configuration)
                .frame(height: 150)
                .clipped()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}
