//
//  Intro3View.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI

struct Intro3View: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack {
            Text("how to use the Safari extension part 3")
                .font(.title)
            
            Spacer()
            
            Text("placeholder for image")
            Spacer()
            
            HStack(spacing: 8) {
                Button("Previous") {
                    tabIndex -= 1
                }
                Spacer()
                Button("Done") {
                    state = .dismiss
                }
            }
        }
        .padding()
    }
}

struct Intro3View_Previews: PreviewProvider {
    @State static var state: OnboardingState = .appIntro
    @State static var tabIndex: Int = 0
    static var previews: some View {
        Intro3View(state:$state, tabIndex: $tabIndex)
    }
}
