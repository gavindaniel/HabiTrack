//
//  FirstViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var habitUILabel: UILabel!
    @IBOutlet weak var timeUILabel: UILabel!
    @IBOutlet weak var streakUILabel: UILabel!
    
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var list = ["Brush teeth","Workout/Yoga","Code/Paint","Something really thing that hopefully wraps around"]
    var timeList = ["Morning","Afternoon","Evening","Evening"]
    
    var streakArray = [0,0,0,0]
    
    @IBOutlet weak var habitTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HabitTableViewCell
        
        cell.habitUILabel?.text = list[indexPath.row]
        
        cell.timeUILabel?.text = timeList[indexPath.row]
        
        cell.streakUILabel?.text = String(streakArray[indexPath.row])
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            list.remove(at: indexPath.row)
            habitTableView.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                streakArray[indexPath.row] -= 1
            }
            else {
                cell.accessoryType = .checkmark
                streakArray[indexPath.row] += 1
            }
        }
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
        let delayInSeconds = 0.1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            // here code perfomed with delay
            self.habitTableView.reloadData()
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }


}

