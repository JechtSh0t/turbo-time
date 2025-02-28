//
//  ConfigurationView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A screen for adjusted game configuration.
///
struct ConfigurationView: View {
    
    // MARK: - Properties -
    
    let viewModel: ConfigurationViewModel
    
    // MARK: - UI -
    
    var body: some View {
        VStack {
            configurationRows
            defaultsButton
        }
        .foregroundStyle(Color.text)
        .padding(.bottom, 24)
        .screenBackground()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.screenAppeared)
        .customPopover(
            isPresented: Binding(
                get: { viewModel.shouldShowPlayers },
                set: { _ in viewModel.inputPropertyDismissed() }
            ),
            content: { dismissAction in
                PlayersView(
                    players: viewModel.configuration.players,
                    dismissAction: dismissAction,
                    actionHandler: viewModel.playerActionSelected
                )
            }
        )
    }
}

// MARK: - Rows -

extension ConfigurationView {
    
    private var configurationRows: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(viewModel.configurationProperties.indices, id: \.self) { index in
                    let property = viewModel.configurationProperties[index]
                    if let property = property as? ConfigurationViewModel.IncrementConfigurationProperty {
                        IncrementRow(viewModel: viewModel, property: property)
                    } else if let property = property as? ConfigurationViewModel.InputConfigurationProperty {
                        InputRow(viewModel: viewModel, property: property)
                    } else if let property = property as? ConfigurationViewModel.ToggleConfigurationProperty {
                        ToggleRow(viewModel: viewModel, property: property)
                    }
                }
            }
            .padding(24)
        }
    }
    
    private struct IncrementRow: View {

        let viewModel: ConfigurationViewModel
        let property: ConfigurationViewModel.IncrementConfigurationProperty
        
        var body: some View {
            HStack {
                explanationView(title: property.title, description: property.description)
                Spacer()
                IncrementerView(
                    value: Binding(
                        get: { property.currentValue },
                        set: { viewModel.incrementPropertyChanged(property, to: $0) }
                    ),
                    increment: property.increment,
                    minimum: property.minimum,
                    maximum: property.maximum,
                    font: (name: "Lexend", size: 24),
                    display: property.display
                )
            }
            .multilineTextAlignment(.leading)
        }
    }
    
    private struct InputRow: View {

        let viewModel: ConfigurationViewModel
        let property: ConfigurationViewModel.InputConfigurationProperty
        
        var body: some View {
            Button(action: {
                viewModel.inputPropertySelected(property)
            }, label: {
                HStack {
                    explanationView(title: property.title, description: property.description)
                    Spacer()
                    Text(property.display)
                        .font(.custom("Lexend", size: 24))
                }
                .multilineTextAlignment(.leading)
            })
        }
    }
    
    private struct ToggleRow: View {
        
        let viewModel: ConfigurationViewModel
        let property: ConfigurationViewModel.ToggleConfigurationProperty
        
        var body: some View {
            Button(action: {
                viewModel.togglePropertyChanged(property)
            }, label: {
                HStack {
                    explanationView(title: property.title, description: property.description)
                    Spacer()
                    Text(property.currentOption.display)
                        .font(.custom("Lexend", size: 24))
                }
                .multilineTextAlignment(.leading)
            })
        }
    }
    
    private static func explanationView(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Lexend", size: 18))
                .bold()
            Text(description)
                .font(.custom("Lexend", size: 14))
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
    }
}

// MARK: - Defaults Button -

extension ConfigurationView {
    
    private var defaultsButton: some View {
        Button(action: {
            viewModel.defaultsButtonSelected()
        }, label: {
            Text("Restore Defaults")
                .font(.custom("Lexend", size: 24))
        })
    }
}

// MARK: - Previews -

#Preview {
    let viewModel = ConfigurationViewModel(
        audioService: AudioServiceMock(),
        configurationService: ConfigurationServiceMock(),
        coordinator: nil
    )
    ConfigurationView(viewModel: viewModel)
}
