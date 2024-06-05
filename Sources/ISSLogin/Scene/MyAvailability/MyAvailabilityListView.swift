//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/06/2024.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct MyAvailabilityListView: View {
    
    @ObservedObject private var presenter: MyAvailabilityListPresenter

    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: MyAvailabilityListPresenter) {
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
                            
                        }
                    Spacer()
                case .success:
                    ScrollView {
                        VStack(spacing: 16) {
                            VStack(spacing: 4) {
                                HStack {
                                    Text("Select day and time preferences")
                                        .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                            lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                            verticalPadding: 0)
                                    Spacer()
                                }
                                HStack {
                                    Text("Specify your availability to ensure it aligns with the task requirements and your schedule.")
                                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                            verticalPadding: 0)
                                    Spacer()
                                }
                            }

                            Spacer()
                            Button(action: {
                                print("add new")
                            }) {
                                HStack {
                                    LoginImageAssets.addCircle.image
                                        .resizable()
//                                                .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.vertical, 12)

                                    Text("Add New")
                                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                            verticalPadding: 8)
                                }
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .cornerRadius(20)
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 24)
                    }
                case let .failure(type):
                    Text("Error")
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
            }
            .build()
        let centerAlignedItem = ToolBarItemDataBuilder()
            .setTitleString("My Availability")
            .setTitleFont(Theme.current.subtitle.font)
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
            .setCenterAlignedItem(centerAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setBackgroundColor(Color.clear)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }
}