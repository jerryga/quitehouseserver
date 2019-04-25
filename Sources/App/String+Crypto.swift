//
//  String+Crypto.swift
//  App
//
//  Created by baidu on 2019/4/24.
//  Copyright © 2019 Asa. Ga. All rights reserved.
//

import Foundation
import Crypto

extension String {
    func MD5() -> String {
        
        let digest = Digest.init(algorithm: .md5)
        do {
            let result = try digest.hash(self)
            return result.hexEncodedString()
        }catch {
            return ""
        }
    }
}
