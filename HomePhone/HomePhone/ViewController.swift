//
//  ViewController.swift
//  HomePhone
//
//  Created by HaiPhan on 8/26/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

//    let names = [
//        "Amy", "Bill", "Zack", "Steven", "Jack", "Jill", "Mary"
//    ]
//    let anotherListOfNames = [
//        "Carl", "Chistinano", "Camero", "Chill"
//    ]
    //tạo 1 array
    var twoDimensionalArray = [
        //tạo hàm struct để check mảng nào đước close
        //map từng phần từ của mảng name >>> contact
        ExpandableNames(isExpand: true, names: ["Amy", "Bill", "Zack", "Steven", "Jack", "Jill", "Mary"].map({ Contact(name: $0, hasFavorite: false )
        })),
        ExpandableNames(isExpand: true, names: ["Carl", "Chistinano", "Camero", "Chill"].map({ Contact(name: $0, hasFavorite: false)
        })),
        ExpandableNames(isExpand: true, names: [Contact(name: "Daniel", hasFavorite: false),
                                                Contact(name: "Dian", hasFavorite: false)
            
            ]),
    ]
    var tb: UITableView!
    var isShowSection: Bool = false
    var btClose: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        ImplementCode()
        
    }
    
    func ImplementCode(){
        setupNavigation()
        setupTableData()
    }
    
    
    
    func setupTableData(){
        tb = UITableView()
        self.view.addSubview(tb)

        tb.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        tb.delegate = self
        tb.dataSource = self
        tb.register(ContactCell.self, forCellReuseIdentifier: "cell")

    }
    
    func setupNavigation(){
        self.SetUpNavigation(text: "Contacts")
        let bt = self.RightButtonSetup()
        bt.addTarget(self, action: #selector(handleReloadRow), for: .touchUpInside)
    }
    
    
    @objc func handleReloadRow(){
        var arrayIndexPath: [IndexPath] = [IndexPath]()
        //fetch each data section
        for section in twoDimensionalArray.indices {
            //fetch each data
            for row in twoDimensionalArray[section].names.indices{
                let indexPath = IndexPath(row: row, section: section)
                arrayIndexPath.append(indexPath)
            }
        }
        //bât cờ show Section
        isShowSection = true
        let animation = isShowSection ? UITableView.RowAnimation.right : .left
        tb.reloadRows(at: arrayIndexPath, with: .right)
    }
    
    func MethodCheckFavoriteWhenClick(cell: UITableViewCell){
        let indexPath = tb.indexPath(for: cell)
        guard let index = indexPath else { return }
        var isCheckFavorite = twoDimensionalArray[index.section].names[index.row].hasFavorite
        if isCheckFavorite {
            twoDimensionalArray[index.section].names[index.row].hasFavorite = false
            cell.accessoryView?.tintColor = .lightGray
        }
        else{
            cell.accessoryView?.tintColor = .red
            twoDimensionalArray[index.section].names[index.row].hasFavorite = true
            print(twoDimensionalArray[index.section].names[index.row].hasFavorite)
        }
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //return số section
        return twoDimensionalArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpand{
            return 0
        }
        return twoDimensionalArray[section].names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactCell
//        let name = self.names[indexPath.row]
//        let anotherName = self.anotherListOfNames[indexPath.row]
//        let name = indexPath.section == 0 ? self.names[indexPath.row] : self.anotherListOfNames[indexPath.row]
        //truy cập tới phần tử của section.row
        //bật biến viewController, để khi cell đá về viewVC thì VC hứng nó
        cell.viewController = self
        let name = self.twoDimensionalArray[indexPath.section].names[indexPath.row]
        if isShowSection {
            cell.textLabel?.text = name.name + " Section \(indexPath.section)" + "   \(indexPath.row)"
        }
        else{
            cell.textLabel?.text = name.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //thêm button Close cho header
//        let lb = UILabel()
//        lb.text = "Header"
//        lb.backgroundColor = .lightGray
//        return lb
        btClose = UIButton(type: .system)
        btClose.setTitle("Close", for: .normal)
        btClose.backgroundColor = .orange
        btClose.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btClose.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        //đáng dấu tag để biết cái đang click là tag thứ mấy
        btClose.tag = section
        return btClose
    }
    
    @objc func handleExpandClose(button: UIButton){
        //lấy biến tag ra là section
        let section = button.tag
        //tạo mảng index để xoá
        var arrayDeleteSectionRow: [IndexPath] = [IndexPath]()
        //duỵet từ phần tử của section với thuộc tính là names
        for row in twoDimensionalArray[section].names.indices{
            let indexPath = IndexPath(row: row, section: section)
            //thêm vào mảng xoá phần tử
            arrayDeleteSectionRow.append(indexPath)
        }
        //kiểm tra nếu đang là thì show "open"
        button.setTitle(twoDimensionalArray[section].isExpand ? "Open" : "Close", for: .normal)
        if twoDimensionalArray[section].isExpand{
            twoDimensionalArray[section].isExpand = false
            tb.deleteRows(at: arrayDeleteSectionRow, with: .fade)
            
        }
        else {
            twoDimensionalArray[section].isExpand = true
            tb.insertRows(at: arrayDeleteSectionRow, with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    
}

