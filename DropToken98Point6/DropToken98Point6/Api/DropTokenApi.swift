//
//  DropTokenApi.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/23/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
public class DropTokenApi {
    public static let endPointUrl : String = "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production"
    
    public static func makeAMoveByAI(_ apiMoves: [Int], Complition: @escaping ((_ returnedMoves: [Int]?) -> ())) {
        let param = "?moves=[" + apiMoves.map{String($0)}.joined(separator: ",") + "]"
        guard let requestURL = URL(string: self.endPointUrl + param) else { fatalError() }
        let dataTask = URLSession.shared.dataTask(with: requestURL) {
            data, response, error in
            guard let jsonData = data else {
                Complition(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                if let moves = json as? [Int] {
                    Complition(moves)
                    return
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    
}
