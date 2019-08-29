//
//  ViewController.swift
//  HomePhone
//
//  Created by HaiPhan on 8/26/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

//    let names = [
//        "Amy", "Bill", "Zack", "Steven", "Jack", "Jill", "Mary"
//    ]
//    let anotherListOfNames = [
//        "Carl", "Chistinano", "Camero", "Chill"
//    ]
    //tạo 1 array
//    var twoDimensionalArray = [
//        //tạo hàm struct để check mảng nào đước close
//        //map từng phần từ của mảng name >>> contact
//        ExpandableNames(isExpand: true, names: ["Amy", "Bill", "Zack", "Steven", "Jack", "Jill", "Mary"].map({ FavoritesContact(name: $0, hasFavorite: false )
//        })),
//        ExpandableNames(isExpand: true, names: ["Carl", "Chistinano", "Camero", "Chill"].map({ FavoritesContact(name: $0, hasFavorite: false)
//        })),
//        ExpandableNames(isExpand: true, names: [FavoritesContact(name: "Daniel", hasFavorite: false),
//                                                FavoritesContact(name: "Dian", hasFavorite: false)
//
//            ]),
//    ]
    //tạo 1 mảng là biến ExpandableNames
    var twoDimensionalArray: [ExpandableNames] = [ExpandableNames]()
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
        fetchContacts()
    }
    
    //lấy dữ liệu contacts
    func fetchContacts(){
        let contactStore = CNContactStore()
        //yêu cầu truy cập contacs
        contactStore.requestAccess(for: .contacts) { (granted, err) in
            if err != nil {
                print("\(err?.localizedDescription)")
                return
            }
            if granted {
                //tạo 1 mảng để add contacts
                var favoritesContact = [FavoritesContact]()
                do {
                    //tạo 1 keys để truy cập thuộc tính của contact
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                    //tạo 1 biến request
                    let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                    //truỳen tham số request vào
                    try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, hihi) in
                        //add vảo mảng
                       favoritesContact.append(FavoritesContact(name: contact, hasFavorite: false))
                    })
                    let names = ExpandableNames(isExpand: true, names: favoritesContact)
                    self.twoDimensionalArray = [names]
                    var arrayText: [String] = [String]()
                    for i in favoritesContact{
                        var a = i.name.givenName.prefix(1)
                        if arrayText.contains(String(a)) {
                            
                        }
                        else {
                            arrayText.append(String(a))
                        }
                        
                    }
                    print(arrayText)
                }catch let err as NSError {
                    print(err)
                }

            }
            else {

            }
        }
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactCell
//        let name = self.names[indexPath.row]
//        let anotherName = self.anotherListOfNames[indexPath.row]
//        let name = indexPath.section == 0 ? self.names[indexPath.row] : self.anotherListOfNames[indexPath.row]
        //truy cập tới phần tử của section.row
        //bật biến viewController, để khi cell đá về viewVC thì VC hứng nó
        let cell = ContactCell(style: .subtitle, reuseIdentifier: "cell")
        cell.viewController = self
        let contact = self.twoDimensionalArray[indexPath.section].names[indexPath.row]
        if isShowSection {
            cell.textLabel?.text = contact.name.givenName + " Section \(indexPath.section)" + "   \(indexPath.row)"
        }
        else{
            cell.textLabel?.text = contact.name.givenName
            cell.detailTextLabel?.text = contact.name.phoneNumbers.first?.value.stringValue
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

