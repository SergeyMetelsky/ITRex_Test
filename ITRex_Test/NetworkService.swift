//
//  Download.swift
//  ITRex_Test
//
//  Created by Sergey on 2/15/21.
//
import UIKit
import Foundation

//struct DownloadedFile {
final class DownloadedFile {
    static let shared = DownloadedFile() //все что подписано static живет всю жизнь приложения
     
    func getImageFile(at url: String, completionBlock: @escaping (_: UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completionBlock(nil)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data else {
                completionBlock(nil)
                return
            }
            
            let image = UIImage(data: data)
            completionBlock(image)
        }.resume()
    }
    
    func getJsonFile(at url: String, completionBlock: @escaping (_: Any?) -> Void) {
        guard let jsonURL = URL(string: url) else {
            completionBlock(nil)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: jsonURL) { (data, response, error) in
            guard let data = data else {
                completionBlock(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                completionBlock(json)
            } catch {
                print(error)
            }
        }.resume()
    }
}


