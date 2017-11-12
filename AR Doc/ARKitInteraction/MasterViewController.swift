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
    var symptoms = [Symptom(name: "Headache", category: "cat1", file: "NeckPain"), Symptom(name: "Neck Pain", category: "cat1", file: "NeckPain"), Symptom(name: "Back Pain", category: "cat2", file: "NeckPain")]
    var filteredSymptoms = [Symptom]()
    let searchController = UISearchController(searchResultsController: nil)
    let greenColor = UIColor(red: 94.0/255.0, green: 210.0/255.0, blue: 163.0/255.0, alpha: 1.0)
    
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
        
        //searchController.searchBar.backgroundColor = lightBlue
        UISearchBar.appearance().tintColor = greenColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.blue
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "cat1", "cat2"]
        searchController.searchBar.delegate = self
        
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

