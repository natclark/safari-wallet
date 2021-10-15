//
//  TransactionsView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI
import web3

struct TransactionsView: View {
   
   private enum Constants {
      static let clientUrl: String = "Your_AlchemyApi_OR_Infura_URL"
      static let ethAccountAddress: String? = nil
   }
   
   @State private var displayText: String = "Loading balance"
   
   let ethClient: EthereumClient
   
   init() {
      guard let clientUrl = URL(string: Constants.clientUrl) else { fatalError("You need to set a valid url") }
      self.ethClient = EthereumClient(url: clientUrl)
   }
   
   var body: some View {
      Text(displayText).task {
         self.fetchAccountBalance()
      }
   }
   
   func fetchAccountBalance() {
      guard let address = Constants.ethAccountAddress else {
         self.displayText = "Make sure to set an account address"
         return
      }
      ethClient.eth_getBalance(address: EthereumAddress(address),
                                block: EthereumBlock(rawValue: "latest")) { error, value in
         guard let value = value else {
            self.displayText = "There was an error loading your balance \(String(describing: error))"
            if let error = error { print(error) }
            return
         }
         self.displayText = "Balance: \(value) Gwei for account \(address)"
      }
   }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
