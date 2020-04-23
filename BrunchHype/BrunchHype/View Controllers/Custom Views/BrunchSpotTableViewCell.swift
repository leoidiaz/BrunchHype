//
//  BrunchSpotTableViewCell.swift
//  BrunchHype
//
//  Created by Karl Pfister on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

protocol BrunchSpotTableViewCellDelegate: class {
    func brunchSpotTierUpdated(_ sender: BrunchSpotTableViewCell)
}

class BrunchSpotTableViewCell: UITableViewCell {

    @IBOutlet weak var brunchSpotNameLabel: UILabel!
    @IBOutlet weak var brunchTierSegmentedControl: UISegmentedControl!

    var delegate: BrunchSpotTableViewCellDelegate?

    func updateCell(withBrunchSpot brunchSpot: BrunchSpot) {
        brunchSpotNameLabel.text = brunchSpot.name
        switch brunchSpot.tier {
            case "S":
                brunchTierSegmentedControl.selectedSegmentIndex = 0
                backgroundColor = .cyan
            case "A":
            brunchTierSegmentedControl.selectedSegmentIndex = 1
            backgroundColor = .yellow
            case "Meh":
            brunchTierSegmentedControl.selectedSegmentIndex = 2
            backgroundColor = .darkGray
            case "Unrated":
                brunchTierSegmentedControl.selectedSegmentIndex = -1
                backgroundColor = .green
            default:
            break
        }
    }

    @IBAction func tierChanged(_ sender: Any) {
        delegate?.brunchSpotTierUpdated(self)
    }

}
