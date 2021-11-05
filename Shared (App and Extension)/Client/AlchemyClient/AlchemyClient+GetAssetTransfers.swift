//
//  AlchemyClient+GetAssetTransfers.swift
//  Wallet
//
//  Created by Tassilo von Gerlach on 10/31/21.
//

import Foundation

extension AlchemyClient {
   
   enum TransferCategory: String, CaseIterable {
      case external
      case `internal`
      case token
   }
   
   struct GetAssetTransfersResponse: Codable {
      let uuid: String?
      let transfers: [AssetTransfer]
   }
   
   struct RawContract: Codable {
      let value: String
      let address: String?
      let decimal: String
   }
   
   struct AssetTransfer: Codable {
      let blockNum: String
      let hash: String
      let from: String
      let to: String
      let value: Double
      let erc721TokenId: String?
      let erc1155Metadata: String?
      let asset: String
      let category: String
      let rawContract: RawContract
   }
   
   /// Returns an array of asset transfers based on the specified paramaters.
   /// - Parameters:
   ///   - fromBlock: in hex string or "latest". optional (default to latest)
   ///   - toBlock:  in hex string or "latest". optional (default to latest)
   ///   - fromAddress: in hex string. optional
   ///   - toAddress:  in hex string. optional.
   ///   - contractAddresses:  list of hex strings. optional.
   ///   - transferCategory: list of any combination of external, token. optional, if blank, would include both.
   ///   - excludeZeroValue:  aBoolean . optional (default true)
   ///   - maxCount: max number of results to return per call. optional (default 1000)
   ///   - pageKey: for pagination. optional
   /// - Returns: Returns an array of asset transfers based on the specified paramaters.
   public func getAlchemyAssetTransfers(fromBlock: EthereumBlock = EthereumBlock(rawValue: 0),
                                        toBlock: EthereumBlock = .latest,
                                        fromAddress: EthereumAddress? = nil,
                                        toAddress: EthereumAddress? = nil,
                                        contractAddresses: [EthereumAddress]? = nil,
                                        transferCategory: [TransferCategory]? = nil,
                                        excludeZeroValue: Bool = true,
                                        maxCount: Int? = nil,
                                        pageKey: Int? = nil) async throws -> [AssetTransfer] {
      
      struct CallParams: Encodable {
         let fromBlock: String? // in hex string or "latest". optional (default to latest)
         let toBlock: String? //in hex string or "latest". optional (default to latest)
         let fromAddress: String? // in hex string. optional
         let toAddress: String? // in hex string. optional.
         let contractAddresses: [String]? // list of hex strings. optional.
         let category: [String]? // list of any combination of external, token. optional, if blank, would include both.
         let excludeZeroValue: Bool // aBoolean . optional (default true)
         let maxCount: String? // max number of results to return per call. optional (default 1000)
         let pageKey: String? // for pagination. optional
      }
      
      let params = CallParams(fromBlock: fromBlock.stringValue,
                              toBlock: toBlock.stringValue,
                              fromAddress: fromAddress?.address.addHexPrefix(),
                              toAddress: toAddress?.address.addHexPrefix(),
                              contractAddresses: contractAddresses?.map{ $0.address.addHexPrefix() },
                              category: transferCategory?.map{ $0.rawValue },
                              excludeZeroValue: excludeZeroValue,
                              maxCount: maxCount?.hexString,
                              pageKey: pageKey?.hexString)
      
      //The CallParams are not being decoded properly by Alchemy
      
      
      let response = try await self.jsonRpcClient.makeRequest(method: "alchemy_getAssetTransfers",
                                                              params: [params],
                                                              resultType: GetAssetTransfersResponse.self)
      return response.transfers
   }
   
}
