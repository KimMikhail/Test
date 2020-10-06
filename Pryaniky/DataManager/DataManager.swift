//
//  DataManager.swift
//  Pryaniky
//
//  Created by  Mikhail on 27.09.2020.
//  Copyright © 2020  Mikhail. All rights reserved.
//

import Foundation


    
class DataManager {
    
    static var shared = DataManager()
    var onCompletion : ((DataModel) -> ())?
    
    private let jsonURL = "https://pryaniky.com/static/json/sample.json"
    var dataModel : DataModel?

    func fetchData() {
        
        guard let url = URL(string: jsonURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let dataModel = try JSONDecoder().decode(DataModel.self,
                                                         from: data)
                DataManager.shared.dataModel = dataModel
                self.onCompletion?(dataModel)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}


