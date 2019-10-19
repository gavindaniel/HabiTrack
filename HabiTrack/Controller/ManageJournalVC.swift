//
//  ManageJournalVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/18/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorUIImageView: UIImageView!
}

class ManageTableViewCell: UITableViewCell {
    @IBOutlet weak var habitNameUILabel: UILabel!
    @IBOutlet weak var habitRepeatUILabel: UILabel!
}

class ManageJournalVC: UIViewController {
    
    
    var journal = Journal()
    
    var colorCollectionView: ManageColorView?
    var manageTableView: ManageTableView?
    @IBOutlet weak var manageUIView: UIView!
    @IBOutlet weak var colorUICollectionView: UICollectionView!
    @IBOutlet weak var manageUITableView: UITableView!
    @IBOutlet weak var closeUIButton: UIButton!
//    @IBOutlet weak var colorUIButton: UIButton!
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("viewDidAppear...")
        print()
        // update views
        manageTableView?.updateTableView(tableView: manageUITableView)
        colorCollectionView?.updateColorView(colorUICollectionView: colorUICollectionView)
    }

    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        // initialize views
        self.manageTableView = ManageTableView(journal: journal, manageTableView: manageUITableView)
        self.colorCollectionView = ManageColorView(colorUICollectionView: colorUICollectionView)
        
        // set the databases, dataSources and delegates
        do {
            // set the databases
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
            
            // set the dataSource and delegate
            self.manageUITableView.dataSource = manageTableView
            self.manageUITableView.delegate = manageTableView
            
            // set the dataSource and delegate
            self.colorUICollectionView.dataSource = colorCollectionView
            self.colorUICollectionView.delegate = colorCollectionView
            
            
        } catch {
            print(error)
        }
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
        print("viewWillAppear...")
        print()
        // testing
        let defaultColor = getSystemColor()
        closeUIButton?.tintColor = defaultColor
//        colorUIButton?.tintColor = defaultColor
        // reload the views
        self.manageUITableView.reloadData()
        self.colorUICollectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print()
        print("traitCollectionDidChange")
        print()
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.manageUITableView.reloadData()
            self.colorUICollectionView.reloadData()
        }
    }
    
    @IBAction func closeManageView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func changeColor(_ sender: Any) {
//        changeAccentColor()
//        let defaultColor = getSystemColor()
//        self.closeUIButton.tintColor = defaultColor
//        self.colorUIButton.tintColor = defaultColor
//        self.colorUIButton.setNeedsDisplay()
//        self.closeUIButton.setNeedsDisplay()
//    }
//
//    func changeAccentColor() {
//        let defaults = UserDefaults.standard
//        let currentColor = defaults.object(forKey: "defaultColor") as! String
//        switch currentColor {
//        case "blue":
//            UserDefaults.standard.set("red", forKey: "defaultColor")
//        case "red":
//            UserDefaults.standard.set("green", forKey: "defaultColor")
//        case "green":
//            UserDefaults.standard.set("yellow", forKey: "defaultColor")
//        case "yellow":
//            UserDefaults.standard.set("blue", forKey: "defaultColor")
//        default:
//            UserDefaults.standard.set("blue", forKey: "defaultColor")
//        }
//    }
}
