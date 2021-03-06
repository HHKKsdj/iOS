//
//  DetialViewController.swift
//  test
//
//  Created by HK on 2021/2/5.
//

import UIKit

class DetialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        refreshControl()
        
    }

    var item = DetailDataModel()
    var contentView : UIView!
    var inInfoLabel : UILabel!
    var outInfoLabel : UILabel!
    var inLabel : UILabel!
    var outLabel : UILabel!
    
    func setUI()  {
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        contentView = UIView(frame: CGRect.zero)
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        inLabel = UILabel(frame: CGRect.zero)
        inLabel.text = "入:"
        inLabel.font = UIFont.systemFont(ofSize: 25)
        inLabel.textColor = UIColor.link
        inLabel.center.x = self.view.bounds.width/2
        contentView.addSubview(inLabel)
        inLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
        }

        inInfoLabel = UILabel(frame: CGRect.zero)
        inInfoLabel.numberOfLines = 0
        contentView.addSubview(inInfoLabel)
        inInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        outLabel = UILabel(frame: CGRect.zero)
        outLabel.text = "出:"
        outLabel.font = UIFont.systemFont(ofSize: 25)
        outLabel.textColor = UIColor.link
        contentView.addSubview(outLabel)
        outLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inInfoLabel.snp.bottom).offset(8)
        }

        outInfoLabel = UILabel(frame: CGRect.zero)
        outInfoLabel.numberOfLines = 0
        contentView.addSubview(outInfoLabel)
        outInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(outLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualTo(contentView).offset(-15)
        }
    }
    
    var refresh : UIRefreshControl!
    
    
    func refreshControl()  {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        contentView.addSubview(refresh)
    }
    @objc func refreshData()  {
        let city_id = Int(item.city_id)
        
        Network.shared.DetailList(from: city_id!, to: city_id!) { [self](error,allDataList) in
            if let error = error {
                print(error)
                return
            }
            guard let list = allDataList else {
                print("nil")
                return
            }
            self.item = list[0]
            self.inInfoLabel.text = self.item.high_in_desc
            self.outInfoLabel.text = self.item.out_desc
        }
        
        refresh.endRefreshing()
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var returnItem: UIBarButtonItem!
    @IBOutlet weak var safeItem: UIBarButtonItem!
    @IBAction func `return`(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func safe(_ sender: Any) {
        var safedList = [DetailDataModel]()
        let getdata = UserDefaults.standard.data(forKey: "safedList")
        
        if getdata != nil {
            safedList = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(getdata!) as! [DetailDataModel]

        }

        if UserDefaults.standard.string(forKey: headTitle.text!) == nil {
            UserDefaults.standard.set(headTitle.text, forKey: headTitle.text!)
            safeItem.image = UIImage(systemName: "star.fill")
            safedList.append(item)
        } else {
            UserDefaults.standard.removeObject(forKey: headTitle.text!)
            safeItem.image = UIImage(systemName: "star")
            for i in 0...safedList.count {
                if safedList[i].city == item.city {
                    safedList.remove(at: i)
                    break
                }
            }
        }
        
        let safedata = try? NSKeyedArchiver.archivedData(withRootObject: safedList, requiringSecureCoding: false)
        
        UserDefaults.standard.set(safedata, forKey: "safedList")
        UserDefaults.standard.synchronize()

    }
    
}

