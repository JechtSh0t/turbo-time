//
//  EventConfigurationView.swift
//
//  Created by JechtSh0t on 2/27/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import SwiftUI

struct EventConfigurationView: View {
    
    // MARK: - Properties -
    
    let viewModel: EventConfigurationViewModel
    
    // MARK: - UI -
    
    var body: some View {
        VStack {
            blueprintRows
        }
        .foregroundStyle(Color.text)
        .screenBackground()
        .navigationBarBackButtonHidden()
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationButton(type: .back, action: viewModel.backButtonSelected)
            }
        }
    }
}

// MARK: - Rows -

extension EventConfigurationView {
    
    private var blueprintRows: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.sections, id: \.self.title) { section in
                    if !section.events.isEmpty {
                        Section {
                            VStack(spacing: 16) {
                                ForEach(section.events) { blueprint in
                                    BlueprintRow(viewModel: viewModel, blueprint: blueprint)
                                }
                            }
                        } header: {
                            HeaderView(text: section.title)
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
            .padding(24)
        }
        // Prevent the tab bar from changing color when scrolling behind it.
        .padding(.vertical, 1)
    }
    
    private struct HeaderView: View {
        
        let text: String
        
        var body: some View {
            HStack {
                Text(text)
                    .font(.custom("Lexend", size: 32))
                Spacer()
            }
            .padding(.bottom, 8)
        }
    }
    
    private struct BlueprintRow: View {
        
        let viewModel: EventConfigurationViewModel
        let blueprint: EventBlueprint
        
        var body: some View {
            Button(action: {
                viewModel.frequencyToggled(for: blueprint)
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(blueprint.text)
                            .font(.custom("Lexend", size: 14))
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                    Spacer()
                    Text(viewModel.valueDisplay(for: blueprint))
                        .font(.custom("Lexend", size: 24))
                }
                .multilineTextAlignment(.leading)
                .opacity(viewModel.blueprintIsEnabled(blueprint) ? 1 : 0.5)
            })
        }
    }
}

// MARK: - Preview -

#Preview {
    let viewModel = EventConfigurationViewModel(
        configurationService: ConfigurationServiceMock(),
        coordinator: nil
    )
    EventConfigurationView(viewModel: viewModel)
}
