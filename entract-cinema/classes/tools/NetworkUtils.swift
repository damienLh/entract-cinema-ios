//
//  WifiUtils.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 29/07/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

public class NetworkUtils {
    
    public static func isWifiEnabled() -> Bool {
        
        let set = NSCountedSet()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let flags = Int32(ptr!.pointee.ifa_flags)
                let name = String(validatingUTF8: ptr!.pointee.ifa_name)
                if (flags & IFF_UP) == IFF_UP {
                    set.add(name ?? "")
                }
            }
            freeifaddrs(ifaddr)
        }
        return set.count(for: "awdl0") > 1 ? true : false
    }
    
    public static func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    public static func isUserConnectedToWifi() -> Bool {
        return NetworkUtils.isWifiEnabled() ? NetworkUtils.getWiFiSsid() != nil : false
    }
    
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
