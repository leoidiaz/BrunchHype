//
//  BrunchSpotListTableViewController.swift
//  BrunchHype
//
//  Created by Leonardo Diaz on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit
import CoreData

class BrunchSpotListTableViewController: UITableViewController {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BrunchSpotController.shared.fetchedResultsController.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return BrunchSpotController.shared.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BrunchSpotController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // logic for "complete" and "incomplete" headers
        var name = ""
        switch BrunchSpotController.shared.fetchedResultsController.sections?[section].name{
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "brunchSpotCell", for: indexPath) as? BrunchSpotTableViewCell else { return UITableViewCell()}
        let brunchSpot = BrunchSpotController.shared.fetchedResultsController.object(at: indexPath)
        cell.updateViews(withBrunchSpot: brunchSpot)
        cell.delegate = self
        return cell
    }
    //MARK: - Delete tableView
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let brunchSpot = BrunchSpotController.shared.fetchedResultsController.object(at: indexPath)
                BrunchSpotController.shared.remove(brunchSpot: brunchSpot)
            }
        }
    //MARK: - Helper Methods
    func presentAddBrunchSpotAlert(){
        let alertController = UIAlertController(title: "Add a Brunch Spot", message: "Doesn't even need to be good.", preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Whats your Brunch Spots Name?"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addBrunchSpot = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text else { return }
            BrunchSpotController.shared.create(brunchSpotWith: name)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addBrunchSpot)
        
        present(alertController, animated: true)
    }
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddBrunchSpotAlert()
    }
}

extension BrunchSpotListTableViewController: BrunchSpotTableViewCellDelegate {
    func brunchSpotTierUpdated(_ sender: BrunchSpotTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let brunchSpot = BrunchSpotController.shared.fetchedResultsController.object(at: indexPath)
        // Update the model
        var tier = ""
        switch sender.brunchTierSegmentedControl.selectedSegmentIndex {
        case 0:
            tier = "S"
        case 1:
            tier = "A"
        case 2:
            tier = "Meh"
        case -1:
            tier = "Unrated"
        default:
            tier = "Unrated"
        }
        BrunchSpotController.shared.changeTier(for: brunchSpot, with: tier)
        
        // Update the cell
        sender.updateViews(withBrunchSpot: brunchSpot)
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
                tableView.reloadData()
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
