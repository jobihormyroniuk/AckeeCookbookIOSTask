//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

class Api {
    
    private let scheme: String
    private let host: String
    let version1: ApiVersion1
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
        let version1 = ApiVersion1(scheme: scheme, host: host)
        self.version1 = version1
    }
    
}
