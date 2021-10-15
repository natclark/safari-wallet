//
//  ShortcutView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI

struct ShortcutView: View {
    
    let tokens = ShortcutItem.tokens()

       let columns = [
           GridItem(.adaptive(minimum: 80))
       ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 30) {

                ForEach(tokens) { token in
                    VStack {
                        
                        AsyncImage(url: token.iconURL()) { phase in
                            switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 75, maxHeight: 75)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    Image(systemName: "photo")
                            }
                        }
                        
                        Text(token.name)
                            .font(.callout)
                    }
                }
            }
            .padding()
        }
    }
}

struct ShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutView()
    }
}
