//
//  HabitCell.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 12/25/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import UIKit

// name: HabitCell
// desc: journal habits table view cell class
// last updated: 12/25/2020
// last update: moved to separate file 
class HabitCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var check: UIImageView!
}
