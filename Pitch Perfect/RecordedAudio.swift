//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Li Yin on 9/5/15.
//  Copyright (c) 2015 Li Yin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}

