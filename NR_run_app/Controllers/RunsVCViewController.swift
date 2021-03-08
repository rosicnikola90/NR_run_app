//
//  RunsVCViewController.swift
//  NR_run_app
//
//  Created by MacBook on 3/5/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 11.0, *)
class RunsVCViewController: UITableViewController {
    
    var runs = [Run]()
    var indexForRun:Int?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NRTableViewCell", bundle: nil), forCellReuseIdentifier: "runCell")
        self.title = "History"
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        tableView.rowHeight = 150
        loadData()
    }
    
    private func loadData() {
        let request:NSFetchRequest<Run> = Run.fetchRequest()
        do { runs = try context.fetch(request)
            print("loaded")
        }
        catch { print(error.localizedDescription) }
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runDetails" {
            let vc = segue.destination as! RunDetailViewController
            if indexForRun != nil {
                vc.runForDetal = runs[indexForRun!]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt indexPath")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "runCell", for: indexPath) as! NRTableViewCell
        cell.distanceLabel.text = runs[indexPath.row].distance
        cell.durationLabel.text = runs[indexPath.row].duration
        cell.timeLabel.text = runs[indexPath.row].date
        cell.avrPaceLabel.text = runs[indexPath.row].avrPace
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForRun = indexPath.row
        performSegue(withIdentifier: "runDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(runs[indexPath.row])
        runs.remove(at: indexPath.row)
        tableView.deleteRows(at:[indexPath], with: .bottom)
        do {try context.save()}
        catch {print(error.localizedDescription)}
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        print("deinit RunsVCViewController")
    }
    
}
