//
//  ApiPerformerFactory.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 26.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

public enum Interactors {
    
    enum Host {
        static let mockServer = "private-anon-db980a2721-cookbook3.apiary-mock.com"
        static let debuggingProxy = "private-anon-819a83e00e-cookbook3.apiary-proxy.com"
        static let production = "cookbook.ack.ee"
    }
    
    public static var debuggingProxy: Interactor {
        return UrlSessionSharedInteractor(version1Scheme: UriScheme.https, version1Host: Host.debuggingProxy)
    }
    
    public static var mockServer: Interactor {
        return UrlSessionSharedInteractor(version1Scheme: UriScheme.https, version1Host: Host.mockServer)
    }
    
    public static var production: Interactor {
        return UrlSessionSharedInteractor(version1Scheme: UriScheme.https, version1Host: Host.production)
    }
    
}
