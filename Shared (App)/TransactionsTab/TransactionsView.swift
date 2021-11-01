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
        VStack {
            HStack {
                Text(tx.from_address!)
                    .lineLimit(1)
                    .truncationMode(.middle)
                if tx.to_address != nil {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                    Text(tx.to_address!)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
            .padding(.vertical)
            Text("$\(tx.value_quote!)") // TOOD - interlopate symbol variable
                .font(.system(size: 24.0, weight: .bold, design: .rounded))
        }
        .padding(.vertical)
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(Transactions: TransactionsViewModel(chain: "1", address: "ric.eth", currency: "USD", symbol: "$"))
    }
}
