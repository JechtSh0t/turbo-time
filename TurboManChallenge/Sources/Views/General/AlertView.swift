//
//  AlertView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A popover alert view skeleton.
///
struct AlertView<Content: View>: View {
    
    // MARK: - Properties -
    
    var title: String?
    @ViewBuilder var content: Content
    var buttonText: String = "Done"
    var buttonAction: () -> Void = {}
    
    // MARK: - UI -
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            if let title = title {
                Text(title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.alertTitle)
            }
            
            content
            
            Divider()
            
            Button(action: {
                buttonAction()
            }, label: {
                Text(buttonText)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.alertTitle)
            })
        }
        .frame(maxWidth: 300)
        .padding()
        .background(Color.alertBackground)
        .cornerRadius(10)
        .transition(.scale)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.alertTitle, lineWidth: 5)
        )
        .shadow(radius: 10, x: 5, y: 5)
    }
}

struct AlertView_Previews: PreviewProvider {
    
    static var previews: some View {
        AlertView(title: "New Event!", content: {}).preferredColorScheme(.light)
        AlertView(title: "New Event!", content: {}).preferredColorScheme(.dark)
    }
}

