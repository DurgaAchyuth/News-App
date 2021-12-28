//
//  Enviroment.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import Foundation

protocol EnviromentType {
    var baseURL: String { get }
}

enum Enviroment {
    static let current = Develop()

    struct Develop: EnviromentType {
        //  use https
        var baseURL: String { "https://api.nytimes.com/svc/" }
    }
}
