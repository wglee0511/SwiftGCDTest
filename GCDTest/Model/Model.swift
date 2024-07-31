//
//  Model.swift
//  GCDTest
//
//  Created by racoon on 7/31/24.
//

import UIKit

class PhotoData {
    let url: URL
    var image: UIImage?
    
    init(url: String) {
        self.url = URL(string: url)!
    }
}

struct PhotoDataSource {
    var list:[PhotoData]
    
    init() {
        var list = [PhotoData]()
        
        for number in 1 ... 20 {
            let url = "https://kxcodingblob.blob.core.windows.net/mastering-ios/\(number).jpg"
            
            let data = PhotoData(url: url)
            
            list.append(data)
        }
        
        self.list = list
    }
}

