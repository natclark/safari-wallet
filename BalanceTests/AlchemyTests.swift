//
//  AlchemyTests.swift
//  BalanceTests
//
//  Created by Ronald Mannak on 10/26/21.
//

import XCTest
import MEWwalletKit
import BigInt
@testable import Balance

class AlchemyTests: XCTestCase {
    
    var ropstenClient: AlchemyClient!
    var mainnetClient: AlchemyClient!
//    var account: Account!
    let uniswapTokenContract = Address(address: "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.ropstenClient = AlchemyClient(network: .ropsten)
        self.mainnetClient = AlchemyClient(network: .ethereum)
        
//        EthereumClient(url: URL(string: TestConfig.clientUrl)!)
//        self.mainnetClient = EthereumClient(url: URL(string: TestConfig.mainnetClientUrl)!)
//        self.account = try? EthereumAccount(keyStorage: TestEthereumKeyStorage(privateKey: TestConfig.privateKey))
//        print("Public address: \(self.account?.address.value ?? "NONE")")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testTokenAllowance() async throws {
        
        // This is a random Ethereum address that recently had approved tokens on Uniswap
        // Since Uniswap always allows the maxInt amount, the allowance is always the same
        let tokenContract = Address(address: "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")!
        let owner = Address(address: "0x99a16cec9e0c5f3421da53b83b6649a85b3f4054")!
        let spender = Address(address: "0x2faf487a4414fe77e2327f0bf4ae2a264a776ad2")!
        
        let allowance = try await mainnetClient.alchemyTokenAllowance(tokenContract: tokenContract, owner: owner, spender: spender)
        XCTAssertEqual(allowance, BigUInt("79228162514264337593543950335")) // maxValue
        XCTAssertEqual(allowance, "79228162514264337593543950335")
        print("allowance: \(allowance)")
    }
    
    func testEth_maxPriorityFeePerGas() async throws {
        let fee = try await mainnetClient.maxPriorityFeePerGas()
        XCTAssertGreaterThan(fee, 0)
    }

}


/*



func testDefaultTokenBalances() async throws {
    let owner = EthereumAddress("0xb739D0895772DBB71A89A3754A160269068f0D45")
    let balances = try await mainnetClient.alchemyTokenBalances(address: owner)
    XCTAssertEqual(balances.count, 100)
}

func testTokenBalances() async throws {
    
    let owner = EthereumAddress("0xb739D0895772DBB71A89A3754A160269068f0D45")
    let tokens = [
        EthereumAddress("0x1f9840a85d5af5bf1d1762f925bdaddc4201f984"), // Uniswap
        EthereumAddress("0xE41d2489571d322189246DaFA5ebDe1F4699F498"), // ZRX
        EthereumAddress("0x85Eee30c52B0b379b046Fb0F85F4f3Dc3009aFEC"), // KEEP
        EthereumAddress("0x04Fa0d235C4abf4BcF4787aF4CF447DE572eF828"), // UMA token
    ]
    let balances = try await mainnetClient.alchemyTokenBalances(address: owner, tokenAddresses: tokens)

    XCTAssertEqual(tokens.count, balances.count)
}

func testErc20Balance() async throws {
    let erc20 = ERC20(client: mainnetClient)
    let balance = try await erc20.balanceOf(tokenContract: uniswapTokenContract, address: EthereumAddress("0xb739D0895772DBB71A89A3754A160269068f0D45"))
    XCTAssertGreaterThan(balance, 0)
}

func testTokenMetadata() async throws {
    let gysrAddress = EthereumAddress("0xbea98c05eeae2f3bc8c3565db7551eb738c8ccab")
    let metadata = try await mainnetClient.alchemyTokenMetadata(tokenAddresss: gysrAddress)
    XCTAssertEqual(metadata.name, "GYSR")
    XCTAssertEqual(metadata.symbol, "GYSR")
    XCTAssertEqual(metadata.logo, URL(string: "https://static.alchemyapi.io/images/assets/7661.png")!)
    XCTAssertEqual(metadata.decimals, 18)
}

func testAssetTransfers() async throws {
    let fromAddress = EthereumAddress("0x99a16cec9e0c5f3421da53b83b6649a85b3f4054")
    let contractAddresses = [EthereumAddress("0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")]
    let transfers = try await mainnetClient.alchemyAssetTransfers(fromAddress: fromAddress, contractAddresses: contractAddresses, excludeZeroValue: true)
    XCTAssertGreaterThan(transfers.count, 1)
}

func testFeeHistory() async throws {
    let history = try await mainnetClient.feeHistory(blockRange: 1, startingBlock: .latest, percentiles: [25, 50, 75])
//        XCTAssertEqual(history.reward.count, 3)
}
*/
