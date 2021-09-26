//
//  CategoryFilterViewController.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

protocol CategoryFilterDelegate: AnyObject {
  func filteredSections(ids: [Int])
}
class CategoryFilterViewController: UIViewController {
  
  // IBOutlet of VC
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var filterButton: RoundButton!
  
  // Delegate
  var delegate: CategoryFilterDelegate?
  
  // Data from genre
  var items: [Genre] = []
  var selectedGenresIds: [Int] = []
  
  // cellId for table
  private lazy var cellId: String = CategoryTableViewCell.reuseIdentifier()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    //Select items previously selected
    defaultSelectedItems()
    setupTableView()
  }
  
  @IBAction func filter(_ sender: Any) {
    delegate?.filteredSections(ids: selectedGenresIds)
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func clearSelections(_ sender: Any) {
    selectedGenresIds = []
    delegate?.filteredSections(ids: selectedGenresIds)
    self.dismiss(animated: true, completion: nil)
  }
  
  private func setupTableView() {
    
    // Tableview setup
    self.tableView.backgroundColor = UIColor.white
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.estimatedRowHeight = 170.0
    self.tableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: cellId)
  }
}
extension CategoryFilterViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CategoryTableViewCell else
    { return UITableViewCell() }
    let item = items[indexPath.row]
    cell.setupView(item: item, select: item.selected)
    performSelectionAt(tableView, at: indexPath, select: items[indexPath.row].selected )
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let isSelected = !items[indexPath.row].selected
    performSelectionAt(tableView, at: indexPath, select: isSelected)
    items[indexPath.row].selected = isSelected
    saveSelectedItems(at: indexPath, select: isSelected)
  }
  
  private func performSelectionAt(_ tableView: UITableView, at indexPath: IndexPath, select: Bool) {
    if select {
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    } else {
      tableView.deselectRow(at: indexPath, animated: false)
    }
  }
  
  private func defaultSelectedItems() {
    for row in 0..<items.count {
      let item = self.items[row]
      self.items[row].selected = selectedGenresIds.contains(item.id)
    }
  }
  
  private func saveSelectedItems( at indexPath: IndexPath, select: Bool) {
    let id = items[indexPath.row].id
    if select {
      if !selectedGenresIds.contains(id) {
        selectedGenresIds.append(id)
      }
    } else {
      var index = 0
      selectedGenresIds.forEach { genre in
        if genre == id && index < selectedGenresIds.count{
          selectedGenresIds.remove(at: index)
        }
        index += 1
      }
    }
  }
}
