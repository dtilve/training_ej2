//
//  AccountService.swift
//  ej2
//
//  Created by Dana Neyra on 1/20/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import Accounts
import ReactiveCocoa


protocol AccountServiceType {

    func accessTwitterAccount() -> SignalProducer<ACAccount, NSError>
}

final class AccountService : AccountServiceType {
    
    private let _accountStore: ACAccountStore
    
    init(accountStore: ACAccountStore = ACAccountStore()) {
        _accountStore = accountStore
    }
    
    func accessTwitterAccount() -> SignalProducer<ACAccount, NSError> {
        return _accountStore.requestAccessToTwitterAccounts()
    }
    
}

private extension ACAccountStore {
   
    func requestAccessToTwitterAccounts() -> SignalProducer<ACAccount, NSError> {
        let accountType = self.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        return SignalProducer { observable, disposable in
            self.requestAccessToAccountsWithType(accountType, options: nil){ (granted, error) in
                if granted {
                    let accounts = self.accountsWithAccountType(accountType) as! [ACAccount]!
                    if (accounts.count > 0) {
                        observable.sendNext(accounts.first!)
                        observable.sendCompleted()
                    }
                  else {
                        observable.sendFailed(error)
                        
                    }
                }
            }
        }
    }
    
}