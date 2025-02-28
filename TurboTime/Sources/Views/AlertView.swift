//
//  AlertView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A reusable alert view.
///
struct AlertView<Content: View>: View {
    
    // MARK: - Properties -
    
    var title: String?
    @ViewBuilder var content: Content
    var buttonText: String = "Done"
    var buttonAction: () -> Void
    
    // MARK: - UI -
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                headerView
                content
            }
            footerView
        }
        .padding(24)
        .frame(width: 300)
        .foregroundStyle(Color.text)
        .background(Color.mainBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.text, lineWidth: 3)
        )
    }
}

// MARK: - Header -

extension AlertView {
    
    @ViewBuilder
    private var headerView: some View {
        if let title = title {
            Text(title)
                .font(.custom("Lexend", size: 20))
                .bold()
        }
    }
}

// MARK: - Footer -

extension AlertView {
    
    private var footerView: some View {
        Button(action: {
            buttonAction()
        }, label: {
            Text(buttonText)
                .font(.custom("Lexend", size: 20))
                .bold()
        })
    }
}

// MARK: - Previews -

#Preview("Message") {
    AlertView(
        title: nil,
        content: {
            Text("Put that cookie down! NOW!")
                .font(.custom("Lexend", size: 14))
                .multilineTextAlignment(.center)
        },
        buttonAction: {})
}

#Preview("Full") {
    AlertView(
        title: "I'm Not a Pervert!",
        content: {
            Text("I was just looking for a Turbo Man doll.")
                .font(.custom("Lexend", size: 14))
                .multilineTextAlignment(.center)
        },
        buttonText: "Ok",
        buttonAction: {})
}
