//
//  CareConnectService.swift
//  CareConnectGiver
//
//  Created by Michael Chen on 3/9/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import Alamofire
import SwiftyJSON

public class CareConnectService {
    private static let baseURL = "https://mas-care-connect.herokuapp.com/"

    static func getElderlies(completion: @escaping (Any?, Error?) -> ()) {
        let url = baseURL + "elderlies/"
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print(json)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func postSurvey(completion: @escaping (Any?, Error?) -> ()) {
        let url = baseURL + "survey/"
        let parameters: Parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print(json)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
