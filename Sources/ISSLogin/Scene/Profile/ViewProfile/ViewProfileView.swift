//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 26/10/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct ViewProfileView: View {
    
    @ObservedObject private var presenter: ViewProfilePresenter
    
    @State private var isLoading = false
    
    @State private var email = ""
    
    @State private var isLoggedIn = false
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: ViewProfilePresenter) {
        self.presenter = presenter
    }
    
    // MARK: View
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)

                switch presenter.state {
                case .isLoading:
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .onAppear {
                            presenter.fetchData(request: ViewProfile.Model.Request(mobileNo: "60129665980"))
                        }
                case let .success(viewModel):
                    ScrollView {
                        ISSTextFieldSUI(inputString: $presenter.fullNameText,
                                        isErrorState: $presenter.fullNameErrorState,
                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: ""))
                        Spacer()
                    }
                case let .failure(type):
                    Text("Error")
                    Spacer()
                }
            }
        }
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
            .includeStatusBarArea(false)
            .build()
        return issNavBarData
    }

    
}
