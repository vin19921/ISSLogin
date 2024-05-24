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
    let timeSlotPptions = ["10:00 a.m. - 11:00 a.m", "11:00 a.m. - 12:00 p.m", "12:00 p.m. - 01:00 p.m", "01:00 p.m. - 02:00 p.m"]
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var isRecurringToggled = false
    @State private var isAvailabilityToggled = false

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
                case let .success(viewModel):
//                    VStack {
//                        Text("Selected time: \(selectedDate, formatter: dateFormatter)")
//
//                        DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
//                            .datePickerStyle(WheelDatePickerStyle())
//                            .labelsHidden()
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
                            
                            VStack(spacing: .zero) {
                                HStack {
                                    Text("Saturday (this week)")
                                        .fontWithLineHeight(font: Theme.current.subtitle.uiFont,
                                                            lineHeight: Theme.current.subtitle.lineHeight,
                                                            verticalPadding: 0)
                                    Spacer()
                                }
                            }

                            VStack(spacing: 12) {
                                Text("from")
                                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                        verticalPadding: 0)
                                HStack {
                                    Text(viewModel.timeFrameList[selectedOptionIndex].startTime)
                                        .fontWithLineHeight(font: Theme.current.bodyOneRegular.uiFont,
                                                            lineHeight: Theme.current.bodyOneRegular.lineHeight,
                                                            verticalPadding: 0)
                                }
                                .frame(height: 47)

                                Text("until")
                                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                        verticalPadding: 0)
                                HStack {
                                    Text(viewModel.timeFrameList[selectedOptionIndex].endTime)
                                        .fontWithLineHeight(font: Theme.current.bodyOneRegular.uiFont,
                                                            lineHeight: Theme.current.bodyOneRegular.lineHeight,
                                                            verticalPadding: 0)
                                }
                                .frame(height: 47)
                            }
                            .onTapGesture {
                                isShowingPicker.toggle()
                            }

                            HStack(spacing: 16) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Set recurring")
                                            .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                                lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("Recruiters can find you weekly on your specified day and time")
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width - 32 - 48 - 50)

                                Toggle("", isOn: $isRecurringToggled)
                                    .toggleStyle(CustomToggleStyle(onColor: Color(hex: 0x002ED0),
                                                                   offColor: Color(hex: 0x707070)))
                            }

                            HStack(spacing: 16) {
                                VStack {
                                    HStack {
                                        Text("Enable availability")
                                            .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                                lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                    }

                                    HStack {
                                        Text("Enable potential task recruiters to view, contact, and recruit you.")
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                        Spacer()
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width - 32 - 48 - 50)

                                Toggle("", isOn: $isAvailabilityToggled)
                                    .toggleStyle(CustomToggleStyle(onColor: Color(hex: 0x002ED0),
                                                                   offColor: Color(hex: 0x707070)))
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 24)
                    }
//                    VStack {
//                        DatePicker("From", selection: $startTime, displayedComponents: .hourAndMinute)
//                            .padding()
//                        
//                        DatePicker("To", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
//                            .padding()
//                        
//                        Text("Start Time: \(formattedTime(date: startTime))")
//                        Text("End Time: \(formattedTime(date: endTime))")
//                    }
//                    }
//                    .padding()
//                    Spacer()
                case let .failure(type):
                    Text("Error")
                    Spacer()
                }
            }

            BottomSheetView(isSheetPresented: $isShowingPicker, content: {
                CustomPicker(options: presenter.timeFrameListViewModel?.timeFrameList ?? [],
                             selectedOptionIndex: $selectedOptionIndex)
                .frame(width: UIScreen.main.bounds.width, height: 200)
                .background(Color.white)
            }, onDismiss: {
                print("Dismiss")
            })
        }
        .edgesIgnoringSafeArea(.vertical)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    func formattedTime(date: Date) -> String {
       let formatter = DateFormatter()
       formatter.timeStyle = .short
       return formatter.string(from: date)
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


struct CustomPicker: View {
    let options: [TimeFrameDataModel]
    @Binding var selectedOptionIndex: Int

    var body: some View {
        ZStack {
            Picker("", selection: $selectedOptionIndex) {
                ForEach(0..<options.count) { index in
                    Text(self.options[index].name)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            .clipped()
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
                    .frame(height: UIScreen.main.bounds.height)
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
                                    onDismiss?()
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

extension Color {
    init(hex: UInt) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct CustomToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .overlay(
                            Circle()
                                .stroke(configuration.isOn ? onColor : offColor, lineWidth: 1)
                        )
                        .shadow(radius: 1)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2))
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
//        .padding(.horizontal)
    }
}
