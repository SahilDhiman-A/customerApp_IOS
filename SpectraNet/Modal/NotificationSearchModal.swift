//
//  NotificationSearchModal.swift
//  My Spectra
//
//  Created by shubam garg on 23/12/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import Foundation

public class NotificationSearchModal {
    public var data : Array<NotificationSearchData>?
    public var message : String?
    public var statusCode : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationSearchModal]
    {
        var models:[NotificationSearchModal] = []
        for item in array
        {
            models.append(NotificationSearchModal(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
    required public init?(dictionary: NSDictionary) {

        if (dictionary["data"] != nil) { data = NotificationSearchData.modelsFromDictionaryArray(array: dictionary["data"] as? NSArray ?? NSArray()) }
        message = dictionary["message"] as? String
        statusCode = dictionary["statusCode"] as? Int
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.statusCode, forKey: "statusCode")

        return dictionary
    }

}


public class NotificationSearchData {
    public var _id : String?
    public var can_id : String?
    public var created_at : String?
    public var order_info : Order_info?
    public var image_url : String?
    public var is_archieved : Bool?
    public var is_read : Bool?
    public var notification : SearchNotification?
    public var pdf_url : String?
    public var video_url : String?
    public var priority : String?
    public var to : String?
    public var updated_at : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationSearchData]
    {
        var models:[NotificationSearchData] = []
        for item in array
        {
            models.append(NotificationSearchData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let data = Data(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Data Instance.
*/
    required public init?(dictionary: NSDictionary) {

        _id = dictionary["_id"] as? String
        can_id = dictionary["can_id"] as? String
        created_at = dictionary["created_at"] as? String
        if let data = dictionary["data"] as? [String: Any] {
            if let orderInfo = data["order_info"] as? [String: Any] {
                order_info = Order_info(dictionary: orderInfo as NSDictionary)
            }
        }
        image_url = dictionary["image_url"] as? String
        is_archieved = dictionary["is_archieved"] as? Bool
        is_read = dictionary["is_read"] as? Bool
        if (dictionary["notification"] != nil) { notification = SearchNotification(dictionary: dictionary["notification"] as! NSDictionary) }
        pdf_url = dictionary["pdf_url"] as? String
        video_url = dictionary["video_url"] as? String
        priority = dictionary["priority"] as? String
        to = dictionary["to"] as? String
        updated_at = dictionary["updated_at"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.can_id, forKey: "can_id")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.order_info?.dictionaryRepresentation(), forKey: "order_info")
        dictionary.setValue(self.image_url, forKey: "image_url")
        dictionary.setValue(self.is_archieved, forKey: "is_archieved")
        dictionary.setValue(self.is_read, forKey: "is_read")
        dictionary.setValue(self.notification?.dictionaryRepresentation(), forKey: "notification")
        dictionary.setValue(self.pdf_url, forKey: "pdf_url")
        dictionary.setValue(self.priority, forKey: "priority")
        dictionary.setValue(self.to, forKey: "to")
        dictionary.setValue(self.updated_at, forKey: "updated_at")

        return dictionary
    }

}

public class SearchNotification {
    public var body : String?
    public var sound : String?
    public var title : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let notification_list = Notification.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Notification Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [SearchNotification]
    {
        var models:[SearchNotification] = []
        for item in array
        {
            models.append(SearchNotification(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let notification = Notification(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Notification Instance.
*/
    required public init?(dictionary: NSDictionary) {

        body = dictionary["body"] as? String
        sound = dictionary["sound"] as? String
        title = dictionary["title"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.body, forKey: "body")
        dictionary.setValue(self.sound, forKey: "sound")
        dictionary.setValue(self.title, forKey: "title")

        return dictionary
    }

}
