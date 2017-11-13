/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class MasterViewController: UITableViewController {
    
    // MARK: - Properties
    var symptoms = [Symptom(name: "General", category: "All", file: "General"), Symptom(name: "Abdominal Pain", category: "Physical Pain", file: "AbdominalPain"), Symptom(name: "Back Pain", category: "Physical Pain", file: "BackPain"), Symptom(name: "Cough", category: "Symptoms", file: "Cough"), Symptom(name: "Dizziness", category: "Symptoms", file: "Dizziness"), Symptom(name: "Earache", category: "Phsyical Pain", file: "Earache"), Symptom(name: "Fever", category: "Symptoms", file: "Fever"), Symptom(name: "Headache", category: "Symptoms", file: "Headache"), Symptom(name: "Muscle Pain", category: "Physical Pain", file: "MusclePain"), Symptom(name: "Neck Pain", category: "Physical Pain", file: "NeckPain"), Symptom(name: "Rash", category: "Physical Pain", file: "Rash")]
    var filteredSymptoms = [Symptom]()
    let searchController = UISearchController(searchResultsController: nil)
    let blueColor = UIColor(red: 100.0/255.0, green: 157.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        //self.navigationController?.navigationBar.tintColor = greenColor
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: yellow]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //searchController.searchBar.backgroundColor = blueColor
        UISearchBar.appearance().tintColor = blueColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.blue
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Physical Pain", "Symptoms"]
        searchController.searchBar.delegate = self
        
        let backbutton = UIButton(type: .custom)
        backbutton.setTitle("Done", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backbutton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filteredSymptoms.count
        }
        return symptoms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var s = Symptom()
        if searchController.isActive{
            s = filteredSymptoms[indexPath.row]
        } else {
            s = symptoms[indexPath.row]
        }
        cell.textLabel!.text = s.name
        cell.detailTextLabel!.text = s.category
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var s = Symptom()
        if searchController.isActive{
            s = filteredSymptoms[indexPath.row]
        } else {
            s = symptoms[indexPath.row]
        }
        
        print(s.name)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showChecklist", sender: s.file)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSymptoms = symptoms.filter({( s : Symptom) -> Bool in
            let categoryMatch = (scope == "All") || (s.category == scope)
            if searchText.isEmpty {
                return categoryMatch
            }
            return categoryMatch && s.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "masterUnwind", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChecklist" {
            if let nextVC = segue.destination as? SurveyViewController {
                nextVC.jsonFile = sender as! String
            }
        }
    }
    
}

extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

struct Symptom {
    var name = ""
    var category = ""
    var file = ""
}

