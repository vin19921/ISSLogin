//
//  ViewProfileView.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
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
                        VStack(alignment: .leading, spacing: .zero) {
                            Text("Full Name")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                                .padding(.bottom, 8)
                            ISSTextFieldSUI(inputString: $presenter.fullNameText,
                                            isErrorState: $presenter.fullNameErrorState,
                                            isDisabled: $presenter.isDisabled,
                                            viewData: ISSTextFieldSUI.ViewData(placeholderText: "",
                                                                               isRequiredText: "Please enter full name")
                            )
                            .onReceive(Just(presenter.fullNameText)) { newValue in
                                let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                                if filtered != newValue {
                                    presenter.fullNameText = filtered
                                }
                            }

                            Text("Email")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                                .padding(.top)
                                .padding(.bottom, 8)

                            ISSTextFieldSUI(inputString: $presenter.emailText,
                                            isErrorState: $presenter.emailErrorState,
                                            isDisabled: $presenter.isDisabled,
                                            viewData: ISSTextFieldSUI.ViewData(placeholderText: "",
                                                                               validateText: "Please enter valid email",
                                                                               regEx: RegExConstants.emailRegEx,
                                                                               isRequiredText: "Please enter valid email")
                            )

                            Text("Mobile No.")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                                .padding(.top)
                                .padding(.bottom, 8)
                            ISSTextFieldSUI(inputString: $presenter.phoneText,
                                            isErrorState: .constant(false),
                                            isDisabled: .constant(true),
                                            viewData: ISSTextFieldSUI.ViewData(placeholderText: "")
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
        .alert(isPresented: $presenter.showingAlert) {
            AlertSUI(alertInfo: AlertInfo(title: "", message: presenter.alertMessage, dismissText: "OK", onDismiss: {
                print("Dismiss")
            }))
        }
        .loading(isLoading: $isLoading)
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
            }
            .build()
        let rightAlignedItem = ToolBarItemDataBuilder()
            .setTitleString(presenter.isDisabled ? "Edit" : "Save")
            .setTitleFont(Theme.current.bodyTwoMedium.font)
            .setCallback {
                presenter.isDisabled.toggle()
                if presenter.isDisabled {
                    print("update Data")
                    isLoading.toggle()
                    presenter.updateData(completionHandler: {
                        isLoading.toggle()
                     })
                } else {
                    print("not in Edit mode")
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
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }

    
}
