//
//  BrunchSpotTableViewCell.swift
//  BrunchHype
//
//  Created by Leonardo Diaz on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

protocol BrunchSpotTableViewCellDelegate: class {
    func brunchSpotTierUpdated(_ sender: BrunchSpotTableViewCell)
}

class BrunchSpotTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var brunchSpotNameLabel: UILabel!
    @IBOutlet weak var brunchTierSegmentedControl: UISegmentedControl!
    
    weak var delegate: BrunchSpotTableViewCellDelegate?
    
    func updateViews(withBrunchSpot brunchSpot: BrunchSpot) {
        brunchSpotNameLabel.text = brunchSpot.name
        switch brunchSpot.tier {
        case "S":
            brunchTierSegmentedControl.selectedSegmentIndex = 0
            backgroundColor = .cyan
        case "A":
            brunchTierSegmentedControl.selectedSegmentIndex = 1
            backgroundColor = .orange
        case "Meh":
            brunchTierSegmentedControl.selectedSegmentIndex = 2
            backgroundColor = .yellow
        case "Unrated":
            brunchTierSegmentedControl.selectedSegmentIndex = -1
            backgroundColor = .lightGray
        default:
            break
        }
    }
    
    //MARK: - Actions
    @IBAction func tierChanged(_ sender: Any) {
        delegate?.brunchSpotTierUpdated(self)
    }
    
}
