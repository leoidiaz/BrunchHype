//
//  BrunchSpotListTableViewController.swift
//  BrunchHype
//
//  Created by Karl Pfister on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit
import CoreData

class BrunchSpotListTableViewController: UITableViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        /// Assign the TaskListTableViewController to be the delegate of the fetchedResultsController
        BrunchController.sharedInstance.fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return BrunchController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // logic for "complete" and "incomplete" headers
        var name = ""
        switch BrunchController.sharedInstance.fetchedResultsController.sections?[section].name{
            case "S":
                name = "That good good"
            case "A":
                name = "Preety okay"
            case "Meh":
                name = "Only if they have mamosas"
            case "Unrated":
                name = "Unrated"
            default:
                name = "idk"
        }
        return name

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // sets height for header
        return 30.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BrunchController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "brunchSpotCell", for: indexPath) as? BrunchSpotTableViewCell else {return UITableViewCell()}

        let brunchSpot = BrunchController.sharedInstance.fetchedResultsController.object(at: indexPath)

        cell.updateCell(withBrunchSpot: brunchSpot)
        cell.delegate = self

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let brunchSpot = BrunchController.sharedInstance.fetchedResultsController.object(at: indexPath)
            BrunchController.sharedInstance.remove(brunchSpot: brunchSpot)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        //identifier: what segue was triggered?
        if segue.identifier == "toDetailVC" {
            //index: what cell triggered the segue?
            //destination: where am I trying to go?
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? BrunchSpotDetailViewController else { return }
            //object to send: What am I trying to pass?
            let brunchSpot = BrunchController.sharedInstance.fetchedResultsController.object(at: indexPath)
            //object to receive it: who's going to "catch this object?
            destinationVC.brunchSpot = brunchSpot
        }
    }

    func presentCreateAlert() {
        let alert = UIAlertController(title: "Add a Brunch Spot!", message: "this is a message", preferredStyle: .alert)
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Whats your Brunch Spots Name?"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alert.textFields?[0].text else {return}
            BrunchController.sharedInstance.add(brunchSpotwith: name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func addBrunchSpotButtonTapped(_ sender: Any) {
        presentCreateAlert()
    }
}

extension BrunchSpotListTableViewController: BrunchSpotTableViewCellDelegate {
    func brunchSpotTierUpdated(_ sender: BrunchSpotTableViewCell) {
        // Conform to Button Delegate
        // Get the indexPath of the the sender; I.E. the cell
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        // Use that index to get the brunch we need
        let brunchSpot = BrunchController.sharedInstance.fetchedResultsController.object(at: indexPath)
        //update tier
        var tier = ""
        switch sender.brunchTierSegmentedControl.selectedSegmentIndex {
            case 0:
                tier = "S"
            case 1:
                tier = "A"
            case 2:
                tier = "Meh"
            default:
                tier = "Unknown"
        }

        BrunchController.sharedInstance.changeTier(for: brunchSpot, with: tier)
        sender.updateCell(withBrunchSpot: brunchSpot)
    }
}

extension BrunchSpotListTableViewController: NSFetchedResultsControllerDelegate {
    // Conform to the NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    //sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type{
            case .delete:
                guard let indexPath = indexPath else { break }
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else { break }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { break }
                tableView.reloadRows(at: [indexPath], with: .automatic)

            @unknown default:
                fatalError()
        }
    }

    //additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            @unknown default:
                fatalError()
        }
    }
}

