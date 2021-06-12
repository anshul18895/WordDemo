//
//  Extensions.swift
//  WordDemo
//
//  Created by anshul shah on 12/06/21.
//

import Foundation
import UIKit

extension Array where Element: UITextField{
    
    func joined() -> String{
        var string = ""
        self.forEach { (tf) in
            string.append(tf.text ?? "")
        }
        return string
    }
    
}
