//
//  TransactionsView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI

struct TransactionsView: View {
    @ObservedObject var Transactions: TransactionsViewModel
    @State private var filter = 0
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    Picker("Mode", selection: $filter, content: {
                        Text("All").tag(0)
                        Text("Sent").tag(1)
                        Text("Received").tag(2)
                        Text("Interactions").tag(3)
                        Text("Failed").tag(4)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    List {
                        ForEach(Transactions.transactions) { tx in
                            TransactionRow(tx: tx)
                        }
                    }
                }
            }
        }
    }
}

struct TransactionRow: View {
    var tx: Transaction
    var body: some View {
        let numberFormatter = NumberFormatter()
        let wei = numberFormatter.number(from: tx.value!)
        let eth = wei!.floatValue / pow(10, 18)
        ScrollView(.vertical, showsIndicators: true) {
            HStack {
                Image(uiImage: UIImage(named: "C5B03133-CA85-405F-A41C-57DE52803FC2.png") ?? .init())
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .clipped()
                    .padding(.leading)
                if tx.to_address != nil {
                    VStack(alignment: .leading) {
                        Text("Sent ETH to")
                            .multilineTextAlignment(.leading)
                            .font(Font.system(.headline, design: .rounded))
                        Text(tx.to_address!)
                            .font(Font.system(.subheadline, design: .monospaced))
                            .frame()
                            .clipped()
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(eth.description) ETH")
                        .font(Font.system(.headline, design: .monospaced))
                    Text("$\(tx.value_quote!)")
                        .font(Font.system(.subheadline, design: .monospaced))
                }
                .padding()
            }
        }
        .frame()
        .clipped()
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(Transactions: TransactionsViewModel(chain: "1", address: "ric.eth", currency: "USD", symbol: "$"))
    }
}
