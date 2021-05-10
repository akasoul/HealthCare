//
//  Offset.swift
//  Lotus
//
//  Created by Anton Voloshuk on 05.03.2021.
//  Copyright © 2021 User. All rights reserved.
//

import Foundation
import SwiftUI

struct chartOffset{
    var dx: CGFloat
    var dy: CGFloat
    var x: CGFloat
    var y: CGFloat
    init(dy: CGFloat, dx: CGFloat, x: CGFloat=0,y: CGFloat=0){
        self.dx=dx
        self.dy=dy
        self.x=x
        self.y=y
    }
    static func == (lhs: chartOffset, rhs: chartOffset) -> Bool{
        return lhs.dx==rhs.dx && lhs.dy==rhs.dy
    }
}
