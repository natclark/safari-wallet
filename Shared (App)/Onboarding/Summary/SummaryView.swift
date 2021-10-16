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
        
        VStack {
            Text("Summary View")
                .font(.title)
            
            Spacer()
            
            Text("Your wallet was created and stored successfully. Explore how to use Wallet and the Safari extension by clicking continue.")
            
            Spacer()
        
            HStack(spacing: 8) {
                Button("Skip") {
                    state = .dismiss
                }
                Spacer()
                Button("Continue") {
                    // progress to next tab
                    state = .appIntro
                }.disabled(false)
            }
            .padding(.bottom, 32)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SummaryView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .appIntro
    @State static var tabIndex: Int = 0
    static var previews: some View {
        SummaryView(state:$state, tabIndex: $tabIndex)
    }
}
