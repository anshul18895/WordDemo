//
//  File.swift
//  WordDemo
//
//  Created by anshul shah on 12/06/21.
//

import Foundation

var alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

class Level: Codable{
    var image : URL?
    var name  : String?
    
    private enum CodingKeys: String, CodingKey{
        case image = "imgUrl", name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _image = try? values.decode(String.self, forKey: .image){
            self.image = URL.init(string: _image)
        }
        name = try? values.decode(String.self, forKey: .name)
            
    }
    
    func getAlphabetsArray() -> [String]{
        guard let name = name else {return []}
        var array: [String] = Array(name).map({"\($0.uppercased())"})
        if array.count < 16{
            for i in 0..<(16 - array.count){
                array.append(alphabets.randomElement() ?? "A")
            }
        }
        return array
    }
}


