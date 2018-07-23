//
//  Stub.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

struct Stub {
    static var apodJson : [String: Any] {
        return ["date":"2018-07-22", "explanation":"What is our universe made of? To help find out, ESA launched the Planck satellite from 2009 to 2013 to map, in unprecedented detail, slight temperature differences on the oldest optical surface known -- the background sky when our universe first became transparent to light. Visible in all directions, this cosmic microwave background is a complex tapestry that could only show the hot and cold patterns observed were the universe to be composed of specific types of energy that evolved in specific ways. The final results, reported last week, confirm again that most of our universe is mostly composed of mysterious and unfamiliar dark energy, and that even most of the remaining matter energy is strangely dark. Additionally, the \"final\" 2018 Planck data impressively peg the age of the universe at about 13.8 billion years and the local  expansion rate -- called the Hubble constant -- at 67.4 (+/- 0.5) km/sec/Mpc. Oddly, this early-universe determined Hubble constant is slightly lower than that determined by other methods in the late-universe, creating a tension that is causing much discussion and speculation", "hdurl": "https://apod.nasa.gov/apod/image/1807/CMB2018_Planck_4672.jpg", "media_type":"image", "service_version":"v1", "title": "Planck Maps the Microwave Background", "url":"https://apod.nasa.gov/apod/image/1807/CMB2018_Planck_1080.jpg"]
    }
    
    static var apodDataSource: [APOD] {
        return [APOD(json: apodJson)!, APOD(json: apodJson)!, APOD(json: apodJson)!]
    }
}
