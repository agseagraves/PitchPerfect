//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Anita Seagraves on 4/10/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    // initializer for class
    init(filePathUrl: NSURL, title: String)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
