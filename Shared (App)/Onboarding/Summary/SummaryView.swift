//
//  SummaryView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct SummaryView: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    
    var body: some View {
        Text("Summary View")
        
        HStack(spacing: 8) {
            Button("Skip") {
                state = .dismiss
            }

            Button("Continue") {
                // progress to next tab
                state = .appIntro
            }.disabled(false)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .appIntro
    @State static var tabIndex: Int = 0
    static var previews: some View {
        SummaryView(state:$state, tabIndex: $tabIndex)
    }
}
