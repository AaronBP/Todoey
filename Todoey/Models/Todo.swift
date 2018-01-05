//
//  TodoModel.swift
//  Todoey
//
//  Created by Aaron Phillips on 05/01/2018.
//  Copyright © 2018 Aaron Phillips. All rights reserved.
//

import Foundation

class Todo : Encodable, Decodable {
    var isChecked : Bool = false
    var label : String = ""
}
