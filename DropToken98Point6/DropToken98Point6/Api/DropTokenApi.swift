//
//  DropTokenApi.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/23/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
public class DropTokenApi {
    let endPointUrl : String
    
    init() {
        self.endPointUrl = "https://w0ayb2ph1k.execute‐api.us‐west‐2.amazonaws.com/production"
    }
    
    func makeAMoveByAI(Complition: @escaping ((_ returnedMoves: [Int]?) -> ())) {
        let param = "?moves=[" + DropTokenService.apiMoves.map{String($0)}.joined(separator: ",") + "]"
        guard let requestURL = URL(string: self.endPointUrl + param) else { fatalError() }
        let dataTask = URLSession.shared.dataTask(with: requestURL) {
            data, response, error in
            guard let jsonData = data else {
                Complition(nil)
                return
            }
            
            //Complition(jsonData)
        }
        dataTask.resume()
    }
    
    
}
