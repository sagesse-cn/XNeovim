//
//  Helper.swift
//  XNeovim
//
//  Created by SAGESSE on 10/2/17.
//  Copyright © 2017 Austin Rude. All rights reserved.
//

import Foundation

internal extension NSResponder {
    
    @objc dynamic var xvim_window: XNeovimView? {
        set { return Runtime.Property.set(self, selector: #selector(getter: self.xvim_window), newValue: newValue) }
        get { return Runtime.Property.get(self, selector: #selector(getter: self.xvim_window)) }
    }
}

