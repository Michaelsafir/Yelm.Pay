//
//  File.swift
//
//
//  Created by Michael on 22.01.2021.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON
import SystemConfiguration


let version : String = "3.1"


public class Settings: ObservableObject, Identifiable {
    var domain : String = "https://rest.yelm.io/api/mobile/"
    var domain_beta : String = "https://dev.yelm.io/api/mobile/"
    
    public var id: Int = 0
    public var platform : String = ""
    public var debug : Bool = true
    
    private var develope : Bool = false
    
    public var payment_url : String = ""
    public var auth : String = ""
    public var charge : String = ""
    public var d3ds : String = ""
    public var user : String = ""
    
    
    public var position : String = ""

    
    
    /// Get url to connect rest api
    /// - Parameter method: Method Name - example m-application
    /// - Returns: Ready string
    
    func url(method: String, dev: Bool = false) -> String {
        var url : String = ""
        if (Locale.current.regionCode != nil && Locale.current.languageCode != nil){
            
            if (self.develope == false){
                url = self.domain
            }else{
                url = self.domain_beta
            }
           
            url += method
            url += "?version=\(version)&region_code=\(Locale.current.regionCode!)&language_code=\(Locale.current.languageCode!)&platform=\(self.platform)"
            if (self.position == ""){
                url += "&lat=0&lon=0"
            }else{
                url += ("&"+position)
            }
          
            
        }else{

            if (self.develope == false){
                url = self.domain
            }else{
                url = self.domain_beta
            }
            
            url += method
            url += "?version=\(version)&region_code=US&language_code=en&platform=\(self.platform)"
            if (self.position == ""){
                url += "&lat=0&lon=0"
            }else{
                url += ("&"+position)
            }
            
        }
        
        if (self.debug){
            print(url)
        }
        return url
    }
    
    
    func internet() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(SCNetworkReachabilityCreateWithName(nil, "https://yelm.io")!, &flags)
        
        let reachable = flags.contains(.reachable)
        let connection = flags.contains(.connectionRequired)
        let automated = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let connection_noninteraction = automated && !flags.contains(.interventionRequired)
        
       return reachable && (!connection || connection_noninteraction)
    }
    
}
