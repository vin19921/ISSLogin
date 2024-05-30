//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 30/05/2024.
//

import ISSTheme
import SwiftUI

struct WeeklyCalendarView: View {
    @Binding var selectedIndices: [Int]
    @Binding var isSelected: [Bool]
    @Binding var buttonText: [String]
    @Binding var recurring: Bool
    var onSelectDate: ((String, Int) -> Void)?
    
    @State private var selectedButtonIndex: Int? = -1
    @State private var selectedDate = Date()
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                HStack(alignment: .top, spacing: 8) {
                    
                    ForEach(buttonText.indices, id: \.self) { index in
                        let part = buttonText[index].split(separator: "\n", maxSplits: 1)
                        
                        VStack(spacing: .zero) {
                            if recurring {
                                Button(action: {
                                    toggleSelection(index: index)
                                    onSelectDate?(formattedDate(index), index)
                                }) {
                                    HStack(spacing: 8) {
                                        Text(part[0])
                                            .foregroundColor(isSelected[index] ? .white : .black)
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                    }
                                    .frame(width: getButtonWidth(), height: 77)
                                }
                                .background(isSelected[index] ? Color.red : Color.clear)
                                .clipShape(Circle())

                            } else {
                                Text(part[0])
                                    .foregroundColor(.black)
                                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                        verticalPadding: 0)

                                Button(action: {
                                    toggleSelection(index: index)
                                    onSelectDate?(formattedDate(index), index)
                                }) {
                                    HStack(spacing: 8) {
                                        Text(part[1])
                                            .foregroundColor(isSelected[index] ? .white : .black)
                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                verticalPadding: 0)
                                    }
                                    .frame(width: getButtonWidth(), height: 77)
                                }
                                .background(isSelected[index] ? Color.red : Color.clear)
                                .clipShape(Circle())
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: recurring)
                    }
                }
                .padding(.top)
//                .padding(.horizontal)
            }
        }
        .background(Theme.current.issWhite.color)
    }

    private func toggleSelection(index: Int) {
        isSelected[index].toggle()
        if isSelected(index: index) {
            selectedIndices.removeAll(where: { $0 == index })
//            selectedIndices.removeAll { $0 == index }
        } else {
            selectedIndices.append(index)
//            selectedIndices.sort()
        }
    }

    private func isSelected(index: Int) -> Bool {
        selectedIndices.contains(index)
    }

    private func formattedDate(_ index: Int) -> String {
        let currentDate = Date()
        // Create a Calendar instance
        let calendar = Calendar.current

        if let selectedDate = calendar.date(byAdding: .day, value: index, to: currentDate) {
            // Create a DateFormatter instance
            let dateFormatter = DateFormatter()
            
            // Set the desired date format
            dateFormatter.dateFormat = "M/d/yyyy"
            
            // Format the date using the date formatter
            if let formattedSelectedDate = dateFormatter.string(for: selectedDate) {
                // Print tomorrow's date
                print("Formatted selected date is: \(formattedSelectedDate)")
                return formattedSelectedDate
            } else {
                print("Failed to format selected date.")
                return ""
            }
        } else {
            print("Failed to calculate selected date.")
            return ""
        }
    }

    private func getButtonWidth() -> CGFloat {
        (UIScreen.main.bounds.width - CGFloat((buttonText.count - 1) * 8) - 48) / CGFloat(buttonText.count)
    }
}

