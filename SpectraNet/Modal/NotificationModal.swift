//
//  NotificationModal.swift
//  My Spectra
//
//  Created by shubam garg on 22/12/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import Foundation


public class NotificationModel {
    public var data : Array<NotificationData>?
    public var message : String?
    public var statusCode : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationModel]
    {
        var models:[NotificationModel] = []
        for item in array
        {
            models.append(NotificationModel(dictionary: item as! NSDictionary)!)
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

        if (dictionary["data"] != nil) { data = NotificationData.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
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


public class NotificationData {
    public var _id : Notification_id?
    public var notification_info : Array<Notification_info>?
    public var created_at : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationData]
    {
        var models:[NotificationData] = []
        for item in array
        {
            models.append(NotificationData(dictionary: item as! NSDictionary)!)
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

        if (dictionary["_id"] != nil) { _id = Notification_id(dictionary: dictionary["_id"] as! NSDictionary) }
        if (dictionary["notification_info"] != nil) { notification_info = Notification_info.modelsFromDictionaryArray(array: dictionary["notification_info"] as! NSArray) }
        created_at = dictionary["created_at"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self._id?.dictionaryRepresentation(), forKey: "_id")
        dictionary.setValue(self.created_at, forKey: "created_at")

        return dictionary
    }

}


public class Notification_info {
    public var to : String?
    public var can_id : String?
    public var priority : String?
    public var notification : NotificationPayLoad?
    public var order_info : Order_info?
    public var is_archieved : Bool?
    public var is_read : Bool?
    public var _id : String?
    public var image_url : String?
    public var pdf_url : String?
    public var video_url : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let notification_info_list = Notification_info.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Notification_info Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notification_info]
    {
        var models:[Notification_info] = []
        for item in array
        {
            models.append(Notification_info(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let notification_info = Notification_info(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Notification_info Instance.
*/
    required public init?(dictionary: NSDictionary) {

        to = dictionary["to"] as? String
        
        
        can_id = dictionary["can_id"] as? String
        priority = dictionary["priority"] as? String
        if (dictionary["notification"] != nil) { notification = NotificationPayLoad(dictionary: dictionary["notification"] as! NSDictionary) }
        if let data = dictionary["data"] as? [String: Any] {
            image_url = data["image_url"] as? String
            pdf_url = data["pdf_url"] as? String
            video_url  = data["video_url"] as? String
                    if (data["order_info"] != nil) { order_info = Order_info(dictionary: data["order_info"] as! NSDictionary) }
        }
        is_archieved = dictionary["is_archieved"] as? Bool
        is_read = dictionary["is_read"] as? Bool
        _id = dictionary["_id"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.to, forKey: "to")
        dictionary.setValue(self.can_id, forKey: "can_id")
        dictionary.setValue(self.priority, forKey: "priority")
        dictionary.setValue(self.notification?.dictionaryRepresentation(), forKey: "notification")
        dictionary.setValue(self.order_info?.dictionaryRepresentation(), forKey: "order_info")
        dictionary.setValue(self.is_archieved, forKey: "is_archieved")
        dictionary.setValue(self.is_read, forKey: "is_read")
        dictionary.setValue(self._id, forKey: "_id")

        return dictionary
    }

}

public class NotificationPayLoad {
    public var title : String?
    public var body : String?
    public var sound : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let notification_list = Notification.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Notification Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationPayLoad]
    {
        var models:[NotificationPayLoad] = []
        for item in array
        {
            models.append(NotificationPayLoad(dictionary: item as! NSDictionary)!)
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

        title = dictionary["title"] as? String
        body = dictionary["body"] as? String
        sound = dictionary["sound"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.body, forKey: "body")
        dictionary.setValue(self.sound, forKey: "sound")

        return dictionary
    }

}

public class Order_info {
    public var title : String?
    public var sort_description : String?
    public var detailed_description : String?
    public var type : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let order_info_list = Order_info.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Order_info Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Order_info]
    {
        var models:[Order_info] = []
        for item in array
        {
            models.append(Order_info(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let order_info = Order_info(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Order_info Instance.
*/
    required public init?(dictionary: NSDictionary) {

        title = dictionary["title"] as? String
        sort_description = dictionary["sort_description"] as? String
        detailed_description = dictionary["detailed_description"] as? String
        type = dictionary["type"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.sort_description, forKey: "sort_description")
        dictionary.setValue(self.detailed_description, forKey: "detailed_description")
        dictionary.setValue(self.type, forKey: "type")

        return dictionary
    }

}

public class Notification_id {
    public var month : Int?
    public var day : Int?
    public var year : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let _id_list = _id.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of _id Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notification_id]
    {
        var models:[Notification_id] = []
        for item in array
        {
            models.append(Notification_id(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let _id = _id(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: _id Instance.
*/
    required public init?(dictionary: NSDictionary) {

        month = dictionary["month"] as? Int
        day = dictionary["day"] as? Int
        year = dictionary["year"] as? Int
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.month, forKey: "month")
        dictionary.setValue(self.day, forKey: "day")
        dictionary.setValue(self.year, forKey: "year")

        return dictionary
    }

}
