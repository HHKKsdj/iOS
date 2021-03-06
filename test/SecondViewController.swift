//
//  SecondViewController.swift
//  test
//
//  Created by HK on 2021/1/28.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        let nib = UINib(nibName: "ListItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ListItemCell.cellIdentifer)
        addItem()
        refreshControl()
    }
    
    var safedList = [DetailDataModel](){
        didSet{
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    var listItem = [DetailDataModel]()
    
    func getData() {
        let data = UserDefaults.standard.data(forKey: "safedList")
        if data != nil {
            safedList = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! [DetailDataModel]
        }
    }
    
    func addItem() {
        for info in safedList {
            let newRowIndex = listItem.count
            listItem.append(info)
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    var refresh : UIRefreshControl!
    
    func refreshControl()  {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.addSubview(refresh)
    }
    @objc func refreshData()  {
        safedList.removeAll()
        listItem.removeAll()
        getData()
        addItem()
        refresh.endRefreshing()
    }
    

    @IBOutlet weak var tableView: UITableView!
    
}

extension SecondViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListItemCell.cellIdentifer,for: indexPath) as! ListItemCell
        cell.model  = listItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let view = UIStoryboard(name: "Main", bundle: nil)
        let show = view.instantiateViewController(withIdentifier: "DetialView") as! DetialViewController

        self.present(show, animated: true, completion: nil)
        let info = listItem[indexPath.row]
        show.headTitle.text = "\(info.province)·\(info.city)"
        show.inInfoLabel.text = info.high_in_desc
        show.outInfoLabel.text = info.out_desc
        if UserDefaults.standard.object(forKey: show.headTitle.text!) == nil {
            show.safeItem.image = UIImage(systemName: "star")
        } else {
            show.safeItem.image = UIImage(systemName: "star.fill")
        }
        show.item.province = info.province
        show.item.city = info.city
        show.item.city_id = info.city_id
        show.item.high_in_desc = info.high_in_desc
        show.item.out_desc = info.out_desc
        show.item.risk_level = info.risk_level
    }
}
