//
//  ThirdViewController.swift
//  test
//
//  Created by HK on 2021/1/28.
//

import UIKit

class ThirdViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 100))
        tableView.tableHeaderView = headerView
        
        Set()
        get()
        
        let itemNib = UINib(nibName: "ListItemCell", bundle: nil)
        tableView.register(itemNib, forCellReuseIdentifier: ListItemCell.cellIdentifer)
    }
    
    var headerView : UIView!
    var done : UIButton!
    var from : UIPickerView!
    var to : UIPickerView!
    var image : UIImageView!
    var cityList = [String]()
    var city_idList = [String]()
    
    var model : [CityDataModel]? {
        didSet{
            guard let model = model else { return }
            for item in model {
                cityList.append(item.city)
                city_idList.append(item.city_id)
            }
        }
    }
    
    func Set() {
        done = UIButton.init(frame: CGRect(x: 330, y: 30, width: 50, height: 25))
        done.setTitle("确定", for: .normal)
        done.layer.backgroundColor = UIColor.link.cgColor
        done.addTarget(self,action:#selector(self.showDetail(sender:)), for: .touchUpInside)
        
        from = UIPickerView.init(frame: CGRect(x: 10, y: 5, width: 100, height: 75))
        from.dataSource = self
        from.delegate = self
        
        to = UIPickerView.init(frame: CGRect(x: 210, y: 5, width: 100, height: 75))
        to.dataSource = self
        to.delegate = self
        
        image = UIImageView.init(image: UIImage(systemName: "arrow.left.and.right"))
        image.frame = CGRect(x: 110, y: 30, width: 100, height: 25)
        self.headerView.addSubview(done)
        self.headerView.addSubview(from)
        self.headerView.addSubview(to)
        self.headerView.addSubview(image)
    }
    
    func get() {
        let getdata = UserDefaults.standard.data(forKey: "cityList")
        if getdata != nil {
            self.model = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(getdata!) as! [CityDataModel]
        } else {
            Network.shared.CityList{ (error,cityList) in
                if let error = error {
                    print(error)
                    return
                }
                guard let list = cityList else {
                    print("nil")
                    return
                }
                self.model = list
                let safedata = try? NSKeyedArchiver.archivedData(withRootObject: list, requiringSecureCoding: false)
                UserDefaults.standard.set(safedata, forKey: "cityList")
                UserDefaults.standard.synchronize()
            }
        }
    }


    var data = [DetailDataModel]() {
        didSet{
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    var listItem = [DetailDataModel]()
    
    func getData(from_id:Int, to_id:Int) {
        
        Network.shared.DetailList(from: from_id, to: to_id) { [self](error,allDataList) in
            if let error = error {
                print(error)
                return
            }
            guard let list = allDataList else {
                print("nil")
                return
            }
            self.data = list
            addItem()
        }

    }
    
    @objc func showDetail(sender:UIButton) {
        let fromRow = from.selectedRow(inComponent: 0)
        let toRow = to.selectedRow(inComponent: 0)
        let from_id = Int(city_idList[fromRow])
        let to_id = Int(city_idList[toRow])
        data.removeAll()
        listItem.removeAll()
        getData(from_id: from_id!, to_id: to_id!)
    }
    
    func addItem() {
        for item in data {
            let newRowIndex = listItem.count
            listItem.append(item)
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
}



extension ThirdViewController:UITableViewDelegate,UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
        return cityList[row]
    }
}
