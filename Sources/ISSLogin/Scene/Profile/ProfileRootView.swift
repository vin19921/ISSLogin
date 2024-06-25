//
//  ProfileRootView.swift
//
//
//  Copyright by iSoftStone 2024.
//

import ISSCommonUI
import ISSTheme
import SwiftUI
import AVFoundation

public struct ProfileRootView: View {
    
    @ObservedObject private var presenter: ProfileRootPresenter
    
    @State private var isLoading = false

    @State private var email = ""
    
    @State private var isLoggedIn = false

    // QR Scanner
    @State private var scannedCode: String?
    @State private var isShowingScanner = false
    @State private var isShowingCameraAlert = false
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: ProfileRootPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)
                if presenter.isLoggedIn {
                    ScrollView {
                        VStack(spacing: .zero) {
                            VStack {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 54, height : 54)
                                    
                                    VStack(spacing: .zero) {
                                        HStack {
                                            Text(presenter.getUserName())
                                                .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                                    lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                                    verticalPadding: 0)
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack {
                                            Text("0129665980")
                                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                    verticalPadding: 0)
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                                .padding([.top, .horizontal])

                                HStack(spacing: .zero) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 6) {
                                            LoginImageAssets.wallet.image
                                                .resizable()
                                                .renderingMode(.original)
                                                .frame(width: 16, height: 16)
                                                .aspectRatio(contentMode: .fit)

                                            Text("Total Earnings")
                                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                    verticalPadding: 0)
                                                .foregroundColor(Color.white)
                                        }
                                        Text("RM230.90")
                                            .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                                lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                                verticalPadding: 0)
                                            .foregroundColor(Color.white)
                                        
                                    }
                                    .padding(.leading, 20)

                                    Spacer()
                                    Button(action: {
                                        print("addCircle btn")
                                    }) {
                                        HStack {
                                            LoginImageAssets.addCircle.image
                                                .resizable()
//                                                .renderingMode(.template)
                                                .frame(width: 18, height: 18)
                                                .aspectRatio(contentMode: .fit)
                                                .padding(.all, 7)
                                                .foregroundColor(Color.black)
                                        }
                                        .frame(width: 32, height: 32)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                    }

                                    Button(action: {
                                        print("importCircle btn")
                                    }) {
                                        HStack {
                                            LoginImageAssets.importCircle.image
                                                .resizable()
                                                .frame(width: 18, height: 18)
                                                .aspectRatio(contentMode: .fit)
                                                .padding(.all, 7)
                                                .foregroundColor(Color.black)
                                        }
                                        .frame(width: 32, height: 32)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                    }
                                    .padding(.leading, 13)
                                    .padding(.trailing, 20)
                                }
                                .frame(height: 69)
                                .background(Color.red)
                                .cornerRadius(12)
                                .padding()
                            }
                            .background(Theme.current.lightGray.color)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Theme.current.lightGrayBorder.color, lineWidth: 1)
                            )
                            .padding(.horizontal)

                            VStack(spacing: .zero) {
                                Button(action: {
                                    presenter.routeToViewProfile()
                                }) {
                                    HStack {
                                        LoginImageAssets.profile.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("View Profile")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .foregroundColor(Theme.current.issBlack.color)
                                    .padding()
                                }

                                Rectangle().frame(height: 1).foregroundColor(Theme.current.lightGrayBorder.color)
                                
                                Button(action: {
                                    presenter.routeToChangePassword()
                                }) {
                                    HStack {
                                        LoginImageAssets.lock.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("Change Password")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .foregroundColor(Theme.current.issBlack.color)
                                    .padding()
                                }
                                
                                Rectangle().frame(height: 1).foregroundColor(Theme.current.lightGrayBorder.color)
                                
                                Button(action: {
                                    presenter.routeToUserPreference()
                                }) {
                                    HStack {
                                        LoginImageAssets.love.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("Task Preferences")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .foregroundColor(Theme.current.issBlack.color)
                                    .padding()
                                }

                                if presenter.isServiceProvider {
                                    Rectangle().frame(height: 1).foregroundColor(Theme.current.lightGrayBorder.color)
                                    
                                    Button(action: {
                                        presenter.routeToTimeFrame()
                                    }) {
                                        HStack {
                                            LoginImageAssets.love.image
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 22, height: 22)
                                                .aspectRatio(contentMode: .fit)
                                            Text("Set Available Time")
                                                .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                    lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                                    verticalPadding: 0)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                    verticalPadding: 0)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 36)
                                        .foregroundColor(Theme.current.issBlack.color)
                                        .padding()
                                    }
                                }

                                Rectangle().frame(height: 1).foregroundColor(Theme.current.lightGrayBorder.color)

                                if let scannedCode = scannedCode {
                                    Text("Scanned QR Code: \(scannedCode)")
                                        .padding()
                                }

                                Button(action: {
                                    checkCameraAccessAndScan()
                                }) {
                                    HStack {
                                        LoginImageAssets.lock.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("Scan QR")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .foregroundColor(Theme.current.issBlack.color)
                                    .padding()
                                }
                                .sheet(isPresented: $isShowingScanner) {
                                    QRScannerView {
                                        scannedCode = $0
                                        isShowingScanner = false
                                    }
                                }
                            }
                            .background(Theme.current.lightGray.color)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Theme.current.lightGrayBorder.color, lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(" You are not logged in")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                            Spacer()
                        }
                        Button(action: {
                            presenter.routeToLogin()
                        }) {
                            Text("Click Here to Login")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                        }
                        Spacer()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            presenter.updateLoginStatus()
            presenter.getIsServiceProvider()
        }
        .sheet(isPresented: $isShowingScanner) {
            QRScannerView {
                scannedCode = $0
                isShowingScanner = false
            }
        }
        .alert(isPresented: $isShowingCameraAlert) {
            Alert(
                title: Text("Camera Access Denied"),
                message: Text("Please allow camera access in settings to scan QR codes."),
                primaryButton: .default(Text("Settings"), action: {
                    openAppSettings()
                }),
                secondaryButton: .cancel()
            )
        }

        if presenter.isLoggedIn {
            ZStack {
                Button(action: {
                    presenter.logOut()
                }) {
                    HStack {
                        LoginImageAssets.exit.image
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 22, height: 22)
                            .aspectRatio(contentMode: .fit)
                        Text("Log Out")
                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                verticalPadding: 0)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                verticalPadding: 0)
                    }
                    .foregroundColor(Color.red)
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
                }
            }
            .frame(alignment: .bottom)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.red, lineWidth: 1)
            )
            .padding()
        }
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let centerAlignedItem = ToolBarItemDataBuilder()
            .setTitleString("Profile")
            .setTitleFont(Theme.current.subtitle.font)
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setCenterAlignedItem(centerAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }

    private func checkCameraAccessAndScan() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isShowingScanner = true
        case .notDetermined:
            requestCameraAccess()
        case .denied, .restricted:
            isShowingCameraAlert = true
        @unknown default:
            // Handle unknown cases appropriately
            break
        }
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    if granted {
                        self.isShowingScanner = true
                    } else {
                        // Show alert for denied access
                        self.isShowingCameraAlert = true
                    }
                }
            }
        }
    }

    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { success in
                print("Settings opened: \(success)") // Prints true if successfully opened
            })
        }
    }
}
