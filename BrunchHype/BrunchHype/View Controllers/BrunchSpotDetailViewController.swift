//
//  BrunchSpotDetailViewController.swift
//  BrunchHype
//
//  Created by Karl Pfister on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

class BrunchSpotDetailViewController: UIViewController {

    var brunchSpot: BrunchSpot?

    @IBOutlet weak var brunchNameTextField: UITextField!
    @IBOutlet weak var brunchTierSegmentedControl: UISegmentedControl!
    @IBOutlet weak var brunchSummaryTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }

    func updateViews() {
        guard let brunchSpot = brunchSpot else {return}
        brunchNameTextField.text = brunchSpot.name
        brunchSummaryTextView.text = brunchSpot.summary
        
        switch brunchSpot.tier {
            case "S":
                brunchTierSegmentedControl.selectedSegmentIndex = 0
            case "A":
                brunchTierSegmentedControl.selectedSegmentIndex = 1
            case "Meh":
                brunchTierSegmentedControl.selectedSegmentIndex = 2
            case "Unrated":
                brunchTierSegmentedControl.selectedSegmentIndex = -1
            default:
                break
        }
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        brunchNameTextField.text = ""
        brunchSummaryTextView.text = ""
        brunchTierSegmentedControl.selectedSegmentIndex = -1
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let brunchSpotName = brunchNameTextField.text, let brunchSpotSummary = brunchSummaryTextView.text, let brunchSpot = brunchSpot else {return}
        //update tier
        var tier = ""
        switch brunchTierSegmentedControl.selectedSegmentIndex {
            case 0:
                tier = "S"
            case 1:
                tier = "A"
            case 2:
                tier = "Meh"
            default:
                tier = "Unrated"
        }

        BrunchController.sharedInstance.update(brunch: brunchSpot, name: brunchSpotName, tier: tier, summary: brunchSpotSummary)
        navigationController?.popViewController(animated: true)

    }
}
