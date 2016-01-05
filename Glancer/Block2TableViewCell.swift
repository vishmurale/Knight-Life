//
//  Block2TableViewCell.swift
//  Glancer
//
//  Created by Cassandra Kane on 12/30/15.
//  Copyright © 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class Block2TableViewCell: UITableViewCell {

    @IBOutlet weak var blockLetter: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTimes: UILabel!
    
    var label: Label? {
        didSet {
            if let label = label, blockLetter = blockLetter, className = className, classTimes = classTimes {
                //sets up note table cell
                self.blockLetter.text = label.blockLetter
                self.className.text = label.className
                self.classTimes.text = label.classTimes
            }
        }
    }


}
