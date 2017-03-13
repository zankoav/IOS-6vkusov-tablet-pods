//
//  JsonHelperLoad.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 2/24/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation

class JsonHelperLoad:NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    private let url: String
    private let name: String?
    private let params: Dictionary<String,String>?
    private let act: LoadJson
    private var jsonData = Data()
    
    init(url:String, params:Dictionary<String,String>?, act: LoadJson, sessionName:String?){
        self.url = url;
        self.params = params;
        self.act = act;
        self.name = sessionName;
    }
    
    func startSession() {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        session.sessionDescription = self.name
        let request = self.getRequestPostWithBodyJSON() as URLRequest
        session.dataTask(with: request).resume()
    }
    
    private func getRequestPostWithBodyJSON() -> NSURLRequest {
        let url = NSURL(string: self.url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            if self.params != nil {
                request.httpBody = try JSONSerialization.data(withJSONObject: self.params!, options: [])
            }else{
                request.httpBody = nil
            }
        } catch let error as NSError {
            print("Error in request post: \(error)")
            request.httpBody = nil
        } catch {
            print("Catch all error: \(error)")
        }
        return request
    }
    
    private func convertJSONToDictionary(data: Data) -> Dictionary<String,AnyObject>? {
        if let str = String(data: data, encoding: .utf8) {
            if let data = str.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,AnyObject>
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        return nil
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if(error != nil) {
            print("Download completed with error: \(error?.localizedDescription)");
        } else {
            let dict = convertJSONToDictionary(data: jsonData)
            act.loadComplete(obj: dict, sessionName: self.name)
            print("Download finished successfully")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        jsonData.append(data)
    }
    
}
