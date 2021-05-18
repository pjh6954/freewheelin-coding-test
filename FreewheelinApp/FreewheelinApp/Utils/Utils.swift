//
//  Utils.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

open class Utils: NSObject {
    // MARK: - Random String
    open class func createUUID() -> String {
        // 임의 문자 UUID 생성 , 호출할 때 마다 다른 값 생성
        // UUID에서 - 삭제
        var uuid = NSUUID().uuidString
        uuid = uuid.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        return uuid
    }
    open class func getFileURL(fileName: String) -> URL? {
        let appDataURL = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AppData")
        if !FileManager.default.fileExists(atPath: appDataURL.path) {
            // Library/AppData 폴더가 없으면 디렉토리 생성
            do {
                try FileManager.default.createDirectory(at: appDataURL, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                NSLog("Error - AppData Folder isn't in Library directory. : \(error.localizedDescription)")
            }
        }
        return appDataURL.appendingPathComponent("\(fileName)")
    }
    open class func saveImageToAppData(image : UIImage, quality: CGFloat = 0.5) -> String? {
        let imageName : String = Utils.createUUID() + ".jpg"
        guard let imgURL = Utils.getFileURL(fileName: imageName) else {
            return nil
        }
        if let data = image.jpegData(compressionQuality: quality) {//UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: imgURL)
            return imageName
        } else {
            NSLog("Failed to save image")
            return nil
        }
    }
}
