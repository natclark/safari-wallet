//
//  SummaryView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct SummaryView: View {
    
    @Binding var state: OnboardingState
    
    var body: some View {
        Text("Summary View")
    }
}

struct SummaryView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .appIntro
    static var previews: some View {
        SummaryView(state: $state)
    }
}
