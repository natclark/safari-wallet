//
//  Intro1View.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI

struct Intro1View: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack {
            Text("how to use the Safari extension part 1")
                .font(.title)
            
            Spacer()
            
            Text("placeholder for image")
            Spacer()
            
            HStack(spacing: 8) {
                Button("Previous") {
                    
                }.disabled(true)
                Spacer()
                Button("Next") {
                    tabIndex += 1
                }
            }
        }
        .padding()        
    }
}

struct Intro1View_Previews: PreviewProvider {
    @State static var state: OnboardingState = .appIntro
    @State static var tabIndex: Int = 0
    static var previews: some View {
        Intro1View(state:$state, tabIndex: $tabIndex)
    }
}
