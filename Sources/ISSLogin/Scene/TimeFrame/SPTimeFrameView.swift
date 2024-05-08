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
    @State private var isShowingPicker = false
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
//                    VStack {
                        Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                        
                        DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()

                        Text("Selected Option: \(options[selectedOptionIndex])")
                           .padding()

                        Button("Show Picker") {
                            isShowingPicker.toggle()
                        }
//                    }
//                    .padding()
//                    Spacer()
                case let .failure(type):
                    Text("Error")
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)

        BottomSheetView(isSheetPresented: $isShowingPicker, content: {
            CustomPicker(options: options, selectedOptionIndex: $selectedOptionIndex)
        }, onDismiss: {
            print("Dismiss")
        })
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


struct CustomPicker: View {
    let options: [String]
    @Binding var selectedOptionIndex: Int

    var body: some View {
        VStack {
            Picker("", selection: $selectedOptionIndex) {
                ForEach(0..<options.count) { index in
                    Text(self.options[index])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            .clipped()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

struct BottomSheetView<Content: View>: View {
    @Binding var isSheetPresented: Bool
    @ViewBuilder var content: () -> Content
    var onDismiss: (() -> Void)?
    @State private var offset: CGFloat = .zero
    @State private var size: CGSize = .zero

    var body: some View {
        ZStack {
            if isSheetPresented {
                Color.black
                    .opacity(0.3)
                    .transition(.opacity)
                    .onTapGesture {
                        isSheetPresented.toggle()
                        onDismiss?()
                    }
            }
            VStack {
                Spacer()
                if isSheetPresented {
                    VStack(spacing: .zero) {
                        HStack {
                            Capsule()
                                .frame(width: 50, height: 5)
                                .foregroundColor(Color.gray)
                                .padding(.vertical)
                                .onTapGesture {
                                    isSheetPresented.toggle()
                                }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .background(Color.white)
                        content()
                    }
                    .saveSize(in: $size)
                    .transition(.move(edge: .bottom))
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                }
            }
        }
        .ignoresSafeArea()
        .animation(.easeOut(duration: 0.2), value: isSheetPresented)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct SizeCalculator: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
