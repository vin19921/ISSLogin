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
    @State private var isEditMode = false
    
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
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .onAppear {
                            presenter.fetchData(request: ViewProfile.Model.FetchRequest(mobileNo: "60129665980"))
                        }
                    Spacer()
                case let .success(viewModel):
                    ScrollView {
                        VStack {
                            ISSTextFieldSUI(inputString: $presenter.fullNameText,
                                            isErrorState: $presenter.fullNameErrorState,
                                            isDisabled: !$isEditMode,
                                            viewData: ISSTextFieldSUI.ViewData(placeholderText: "",
                                                                               isRequiredText: "Please enter full name")
                            )

                            ISSTextFieldSUI(inputString: $presenter.emailText,
                                            isErrorState: $presenter.emailErrorState,
                                            isDisabled: !$isEditMode,
                                            viewData: ISSTextFieldSUI.ViewData(placeholderText: "",
                                                                               validateText: "Please enter valid email",
                                                                               regEx: RegExConstants.emailRegEx,
                                                                               isRequiredText: "Please enter valid email")
                            )
                        }
                        .padding()
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
        let rightAlignedItem = ToolBarItemDataBuilder()
            .setTitleString(isEditMode ? "Save" : "Edit")
            .setTitleFont(Theme.current.bodyTwoMedium.font)
            .setCallback {
                isEditMode.toggle()
                if isEditMode {
                    print("in Edit mode")
                } else {
                    print("not in Edit mode")
                    presenter.updateData()
                }
            }
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
            .setRightAlignedItem(rightAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(false)
            .build()
        return issNavBarData
    }

    
}
