//
//  ProfileImageAddLocal.swift
//  My Spectra
//
//  Created by Bhoopendra on 11/6/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation

import UIKit
extension UIViewController
{
// Save image in local Directry
func saveImageInLocalDirectory(withUsercanID: String,userImage: UIImage)
  {
     // get the documents directory url
      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      // choose a name for your image
      let fileName = String(format: "%@image.jpg", withUsercanID)

      // create the destination file url to save your image
      let fileURL = documentsDirectory.appendingPathComponent(fileName)
      // get your UIImage jpeg data representation and check if the destination file url already exists
      if let data = userImage.jpegData(compressionQuality:  1.0),
        !FileManager.default.fileExists(atPath: fileURL.path) {
          do {
              // writes the image data to disk
              try data.write(to: fileURL)
              print_debug(object: "file saved")
          } catch {
              print("error saving file:", error)
          }
      }
  }
  
// Remove image from Local Directory
  func removeImageLocalPath(localPathName:String) {
             let filemanager = FileManager.default
             let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
             let destinationPath = documentsPath.appendingPathComponent(localPathName)
  do {
         try filemanager.removeItem(atPath: destinationPath)
          print_debug(object: "Local path removed successfully")
     } catch let error as NSError {
         print("------Error",error.debugDescription)
     }
     }
  
// Get image from local Directory
  func getImageFromLocalDirectory(nameOfUserName:String) -> UIImage
  {
      let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
      let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
      let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
      var image = UIImage()
      if let dirPath          = paths.first
      {
         let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfUserName)
         image    = UIImage(contentsOfFile: imageURL.path)!
      }
      return image
  }

// Set image in user profile from local and set status message
func setImageFromLocalDirectory(fileName: String, imageView: UIImageView,withImageLblStatus: UILabel)
{
       let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
           let url = NSURL(fileURLWithPath: path)
           if let pathComponent = url.appendingPathComponent(fileName) {
               let filePath = pathComponent.path
               let fileManager = FileManager.default
               if fileManager.fileExists(atPath: filePath) {
                 let image = getImageFromLocalDirectory(nameOfUserName: fileName)
                 imageView.image = image
                 imageView.layer.masksToBounds = false
                 imageView.layer.cornerRadius = imageView.frame.height/2
                 imageView.clipsToBounds = true;
                 withImageLblStatus.text = profileUserB2B.userPhotoStatusD
               }
               else
               {
                 withImageLblStatus.text = profileUserB2B.userPhotoStatusDEmpty
               }
           } else {
                print_debug(object: "FILE PATH NOT AVAILABLE")
           }
}

// crop image with width and height
func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

    let cgimage = image.cgImage!
    let contextImage: UIImage = UIImage(cgImage: cgimage)
    let contextSize: CGSize = contextImage.size
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)

    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

    // Create bitmap image from context using the rect
    let imageRef: CGImage = cgimage.cropping(to: rect)!

    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

    return image
}

// crop image in squre type
func cropImageToSquare(image: UIImage) -> UIImage? {
    var imageHeight = image.size.height
    var imageWidth = image.size.width

    if imageHeight > imageWidth {
        imageHeight = imageWidth
    }
    else {
        imageWidth = imageHeight
    }

    let size = CGSize(width: imageWidth, height: imageHeight)

    let refWidth : CGFloat = CGFloat(image.cgImage!.width)
    let refHeight : CGFloat = CGFloat(image.cgImage!.height)

    let x = (refWidth - size.width) / 2
    let y = (refHeight - size.height) / 2

    let cropRect = CGRectMake(x, y, size.height, size.width)
    if let imageRef = image.cgImage!.cropping(to: cropRect) {
        return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
    }

   return nil
}

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
      return CGRect(x: x, y: y, width: width, height: height)
  }
}
