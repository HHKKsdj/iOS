//
//  ListItemCell.swift
//  test
//
//  Created by HK on 2021/2/26.
//

import UIKit
import SnapKit

class ListItemCell: UITableViewCell {

    static let cellIdentifer = "HeaderCell"
    
    var model : DetailDataModel?{
        didSet{
            guard let model = model else { return }
            inInfo.numberOfLines = 0
            outInfo.numberOfLines = 0
            cityLabel.text = "\(model.province)·\(model.city)"
            inInfo.text = model.high_in_desc
            outInfo.text = model.out_desc
            switch model.risk_level {
            case "1":
                levelLabel.text = "低风险"
                levelLabel.backgroundColor = UIColor.green
            case "2":
                levelLabel.text = "中风险"
                levelLabel.backgroundColor = UIColor.brown
            case "3":
                levelLabel.text = "高风险"
                levelLabel.backgroundColor = UIColor.red
            case "4":
                levelLabel.text = "部分地区中风险"
                levelLabel.backgroundColor = UIColor.brown
            case "5":
                levelLabel.text = "部分地区高风险"
                levelLabel.backgroundColor = UIColor.red
            case "6":
                levelLabel.text = "部分地区中、高风险"
                levelLabel.backgroundColor = UIColor.red
            default:
                levelLabel.text = "低风险"
                levelLabel.backgroundColor = UIColor.green
            }

        }
    }
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var inInfo: UILabel!
    @IBOutlet weak var outInfo: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
    }
}
