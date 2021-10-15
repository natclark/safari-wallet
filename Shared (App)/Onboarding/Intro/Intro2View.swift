//
//  Intro2View.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI

struct Intro2View: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack {
            Text("how to use the Safari extension part 2")
                .font(.title)
            
            Spacer()
            
            Text("placeholder for image")
            Spacer()
            
            HStack(spacing: 8) {
                Button("Previous") {
                    tabIndex -= 1
                }
                Spacer()
                Button("Next") {
                    tabIndex += 1
                }
            }
        }
        .padding()
    }
}

struct Intro2View_Previews: PreviewProvider {
    @State static var state: OnboardingState = .appIntro
    @State static var tabIndex: Int = 0
    static var previews: some View {
        Intro2View(state:$state, tabIndex: $tabIndex)
    }
}
