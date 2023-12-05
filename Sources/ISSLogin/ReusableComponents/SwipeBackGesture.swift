//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/12/2023.
//

import SwiftUI

public struct SwipeBackGesture: ViewModifier {
    public var onSwipeBack: () -> Void

    public func body(content: Content) -> some View {
        content
            .background(SwipeBackGestureCoordinator(onSwipeBack: onSwipeBack))
    }

    public init(onSwipeBack: @escaping () -> Void) {
        self.onSwipeBack = onSwipeBack
    }
}

private struct SwipeBackGestureCoordinator: UIViewControllerRepresentable {
    var onSwipeBack: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: context.coordinator,
                                                                action: #selector(context.coordinator.handleSwipe(_:)))
        gestureRecognizer.edges = .left
        viewController.view.addGestureRecognizer(gestureRecognizer)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject {
        var parent: SwipeBackGestureCoordinator

        init(parent: SwipeBackGestureCoordinator) {
            self.parent = parent
        }

        @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
            if gestureRecognizer.state == .recognized {
                parent.onSwipeBack()
            }
        }
    }
}

