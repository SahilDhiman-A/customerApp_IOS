//
//  WiFiInfo.swift
//  My Spectra
//
//  Created by Chakshu on 28/09/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

enum WiFISignalStrength: Int {
    case weak = 0
    case ok = 1
    case veryGood = 2
    case excellent = 3

    func convertBarsToStength() -> String {
       switch self {
       case .weak:
        return wifiSignalStength.noWifi
       case .ok:
           return wifiSignalStength.weak
       case .veryGood:
        return wifiSignalStength.excellent
       case .excellent:
           return wifiSignalStength.excellent
       }
   }
}

enum AppKeys: String {
    case foregroundView         = "foregroundView"
    case numberOfActiveBars     = "numberOfActiveBars"
    case statusBar              = "statusBar"
    case wifiStrengthRaw        = "wifiStrengthRaw"
}


struct WiFiInfo {
    var rssi: String
    var networkName: String
    var macAddress: String
}



class WiFiInfoService: NSObject {
    
   
    //  MARK - WiFi info
    func getWiFiInfo() -> WiFiInfo? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        var wifiInfo: WiFiInfo? = nil
        var rssi: Int = 0
        if let strength = getWifiStrength() {
            rssi = strength
        }
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else {
                wifiInfo = WiFiInfo(rssi: WiFISignalStrength(rawValue: rssi)?.convertBarsToStength() ?? wifiSignalStength.weak, networkName: "Spectra", macAddress: "Spectra")
                return wifiInfo
            }
            guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
                wifiInfo = WiFiInfo(rssi: WiFISignalStrength(rawValue: rssi)?.convertBarsToStength() ?? wifiSignalStength.weak, networkName: "Spectra", macAddress: "Spectra")
                return wifiInfo
            }
            guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
                wifiInfo = WiFiInfo(rssi: WiFISignalStrength(rawValue: rssi)?.convertBarsToStength() ?? wifiSignalStength.weak, networkName: "Spectra", macAddress: "Spectra")
                return wifiInfo
            }
           
            wifiInfo = WiFiInfo(rssi: WiFISignalStrength(rawValue: rssi)?.convertBarsToStength() ?? wifiSignalStength.weak, networkName: ssid, macAddress: bssid)
            break
        }
        return wifiInfo
    }

    //  MARK - WiFi signal strength
    private func getWifiStrength() -> Int? {
        if #available(iOS 13.0, *) {
            
            if let statusBarManager = UIApplication.shared.keyWindow?.windowScene?.statusBarManager,
                let localStatusBar = statusBarManager.value(forKey: "createLocalStatusBar") as? NSObject,
                let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
                let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                let celluar = currentData.value(forKey: "wifiEntry") as? NSObject,
                let signalStrength = celluar.value(forKey: "displayValue") as? Int {
                return signalStrength
            } else {
                return 0
            }
        } else {
               
            
            return getWifiStrength12()
               }
        return nil
    }

    
    func isiPhoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
    switch UIScreen.main.nativeBounds.height {
    case 1136:
    //debugPrint(“iPhone 5 or 5S or 5C”)
    break
    case 1334:
    //debugPrint(“iPhone 6/6S/7/8”)
    break
    case 2208:
    //debugPrint(“iPhone 6+/6S+/7+/8+”)
    break
    case 2436:
    //debugPrint(“iPhone X”)
    return true
    default:
    break
    //debugPrint(“unknown”)
    }
    }
    return false
    }
    
    private func getWifiStrength12() -> Int? {
            return self.isiPhoneX() ? getWifiStrengthOnIphoneX() : getWifiStrengthOnDevicesExceptIphoneX()
        }
    
     func getWifiStrengthOnDevicesExceptIphoneX() -> Int? {
        
            var rssi: Int?
            guard let statusBar = UIApplication.shared.value(forKey: AppKeys.statusBar.rawValue) as? UIView,
                let foregroundView = statusBar.value(forKey: AppKeys.foregroundView.rawValue) as? UIView else {
                return rssi
            }
            for view in foregroundView.subviews {
               if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view.isKind(of: statusBarDataNetworkItemView) {
                  if let val = view.value(forKey: AppKeys.wifiStrengthRaw.rawValue) as? Int {
                      rssi = val
                      break
                  }
               }
            }
            return rssi
        }
    
    
    private func getWifiStrengthOnIphoneX() -> Int? {
            guard let numberOfActiveBars = getWiFiNumberOfActiveBars() else {
                return 0
            }
            return numberOfActiveBars
        
        
    }
    
    
     func getWiFiNumberOfActiveBars() -> Int? {
           var numberOfActiveBars: Int?
           guard let containerBar = UIApplication.shared.value(forKey: AppKeys.statusBar.rawValue) as? UIView else {
               return 0
           }
           guard let statusBarModern = NSClassFromString("UIStatusBar_Modern"), containerBar.isKind(of: statusBarModern),
                 let statusBar = containerBar.value(forKey: AppKeys.statusBar.rawValue) as? UIView else {
                 return 0
           }
           guard let foregroundView = statusBar.value(forKey: AppKeys.foregroundView.rawValue) as? UIView else {
               return 0
           }
           for view in foregroundView.subviews {
               for v in view.subviews {
                  if let statusBarWifiSignalView = NSClassFromString("_UIStatusBarWifiSignalView"), v.isKind(of: statusBarWifiSignalView) {
                      if let val = v.value(forKey: AppKeys.numberOfActiveBars.rawValue) as? Int {
                          numberOfActiveBars = val
                          break
                      }
                  }
               }
               if let _ = numberOfActiveBars {
                  break
               }
           }
           return numberOfActiveBars
       }
   
    
}

