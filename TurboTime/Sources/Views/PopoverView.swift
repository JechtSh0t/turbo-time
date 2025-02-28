//
//  PopoverView.swift
//
//  Created by JechtSh0t on 7/25/24.
//  Copyright © 2024 Brook Street Games. All rights reserved.
//

import SwiftUI

typealias SingleOptionalClosure = (() -> Void)?
typealias DoubleOptionalClosure = ((SingleOptionalClosure) -> Void)?

///
/// A popover view that wraps other views to present.
///
struct PopoverView<Content: View>: View {

    // MARK: - Properties -

    @Binding var isPresented: Bool
    @ViewBuilder let content: (DoubleOptionalClosure) -> Content
    @State private var contentIsPresented: Bool = false

    // MARK: - UI -

    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
        .onAppear {
            withAnimation(.spring(duration: 0.3, bounce: 0.3)) {
                contentIsPresented = true
            }
        }
        .onTapGesture {
            dismiss(completion: nil)
        }
    }
}

// MARK: - Subviews -

extension PopoverView {

    private var backgroundView: some View {
        Color.black
            .opacity(0.7)
            .ignoresSafeArea()
    }

    private var contentView: some View {
        VStack {
            content { contentAction in
                dismiss(completion: contentAction)
            }
        }
        .scaleEffect(contentIsPresented ? 1.0 : 0.5)
        .opacity(contentIsPresented ? 1.0 : 0.0)
    }
}

// MARK: - Presentation -

extension PopoverView {

    private func dismiss(completion: SingleOptionalClosure) {
        withAnimation(.easeOut(duration: 0.2), completionCriteria: .removed, {
            contentIsPresented = false
        }, completion: {
            isPresented = false
            completion?()
        })
    }
}

// MARK: - Content Protocol -

protocol PopoverContentView: View {
    var dismissAction: DoubleOptionalClosure { get }
}

// MARK: - View Extension -

extension View {
    func customPopover<Content: View>(
        isPresented: Binding<Bool>, @ViewBuilder
        content: @escaping (DoubleOptionalClosure) -> Content
    ) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                PopoverView(isPresented: isPresented, content: content)
            }
        }
    }
}
