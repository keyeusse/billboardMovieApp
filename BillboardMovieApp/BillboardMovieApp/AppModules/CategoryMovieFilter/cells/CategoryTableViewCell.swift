//
//  CategoryTableViewCell.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

class CategoryTableViewCell: UITableViewCell, UITableViewCellReusableView {
  
  @IBOutlet private weak var label: UILabel!
  
  private var item: Genre? {
    didSet {
      self.label?.text = item?.name
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    self.backgroundColor = UIColor.clear
  }
  
  func setupView(item: Genre, color: UIColor, select: Bool = false) {
    self.item = item
    setup(selected: select)
    self.label.textColor = UIColor.blue
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    setup(selected: selected)
  }
  
  private func setup(selected: Bool) {
    self.label.font = selected ? UIFont.boldSystemFont(ofSize: 17.0) : UIFont.systemFont(ofSize: 15.0)
    self.label.textColor = selected ? UIColor.systemBlue : UIColor.blue
  }
}
