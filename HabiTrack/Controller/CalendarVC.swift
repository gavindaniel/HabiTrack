//
//  CalendarVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 5/1/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import UIKit


// name: JournalDateCVCell
// desc: date selection collection view cell class
// last updated: 4/28/2020
// last update: cleaned up
class ChangeDateCVCell: UICollectionViewCell {
    @IBOutlet weak var dowUILabel: UILabel!
    @IBOutlet weak var dayUILabel: UILabel!
}


// name: CalendarVC
// desc: calendar view controller class
// last updated: 5/16/2020
// last update: cleaned up, added a few functions
class CalendarVC: UIViewController {
    // variables
    var changeDateCV: ChangeDateCV?
    // IBOutlet connections
    @IBOutlet weak var dateUICollectionView: UICollectionView!
    @IBOutlet weak var saveUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    @IBOutlet weak var todayUIButton: UIButton!
    
    

    
    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.changeDateCV = ChangeDateCV(dateUICollectionView)
        do {
            // set the dataSource and delegate
            self.dateUICollectionView.dataSource = changeDateCV
            self.dateUICollectionView.delegate = changeDateCV
        }
        debugPrint("CalendarVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("CalendarVC", "viewWillAppear", "start", false)
        let defaultColor = getColor("System")
        saveUIButton?.tintColor = defaultColor
        cancelUIButton?.tintColor = defaultColor
        // reload the views
        self.dateUICollectionView.reloadData()
        debugPrint("CalendarVC", "viewWillAppear", "end", false)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 5/4/2020
    // last update: new
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("CalendarVC", "viewDidAppear", "start", false)
        // update views
        changeDateCV?.dateUICollectionView.reloadData()
//        changeDateCV?.updateUICollectionView(dateUICollectionView)
        debugPrint("CalendarVC", "viewDidAppear", "end", false)
        print("******************************************************")
    }
    
    
    // name: viewDidDisappear
    // desc:
    // last updated: 5/4/2020
    // last update: new
    override func viewDidDisappear(_ animated: Bool) {
        debugPrint("CalendarVC", "viewDidDisappear", "start", false)
        debugPrint("CalendarVC", "viewDidDisappear", "end", false)
        print("******************************************************")
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("CalendarVC", "traitCollectionDidChange", "start", true)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.dateUICollectionView.reloadData()
        }
        debugPrint("CalendarVC", "traitCollectionDidChange", "end", true)
    }
}
