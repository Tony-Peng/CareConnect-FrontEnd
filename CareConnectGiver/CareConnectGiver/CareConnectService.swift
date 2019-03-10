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
}
