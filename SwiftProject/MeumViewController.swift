//
//  MeumViewController.swift
//  SwiftProject
//
//  Created by Xinbo Lian on 2020/7/9.
//  Copyright © 2020 Xinbo Lian. All rights reserved.
//

import UIKit

class MeumViewController<MenuItem:Hashable>: UIViewController,UITableViewDelegate,UIPopoverPresentationControllerDelegate where MenuItem : CaseIterable, MenuItem:RawRepresentable {
    
    struct MenuItemConfig {
        let preferredContentSize : CGSize = CGSize(width: 150, height: 200)
        let cornerRadius : CGFloat = 10
        let rowHeight : CGFloat = 44
        let backgroundColor : UIColor = UIColor.white
        let scrollEnable : Bool = true
    }
    
    enum Section {
        case menu
    }
    
    typealias MenuAction = (MenuItem)->(Void)
    
    required init(config: MenuItemConfig = MenuItemConfig()) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.config = MenuItemConfig()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        self.config = MenuItemConfig()
        super.init(coder: coder)
    }
    
    var action:MenuAction?
    
    var config : MenuItemConfig
    
    private let menuItems :[MenuItem] = MenuItem.allCases as! [MenuItem]
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: self.view.bounds,style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var dataSource : UITableViewDiffableDataSource<Section, MenuItem> = {
        let dataSource = UITableViewDiffableDataSource<Section,MenuItem>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = "\(item.rawValue)"
            cell.separatorInset = UIEdgeInsets.zero
            return cell
        }
        return dataSource
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        var snap = NSDiffableDataSourceSnapshot<Section,MenuItem>()
        snap.appendSections([.menu])
        snap.appendItems(menuItems, toSection: .menu)
        dataSource.apply(snap)
        
        tableView.rowHeight = config.rowHeight
        tableView.backgroundColor = config.backgroundColor
        view.backgroundColor = config.backgroundColor
        tableView.isScrollEnabled = config.scrollEnable
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: config.preferredContentSize.width, height: config.preferredContentSize.height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menuItem = dataSource.itemIdentifier(for: indexPath ){
            self.action?(menuItem)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func show(sourceVc:UIViewController,sourceRect:CGRect = CGRect.zero,sourceView:UIView? = nil,barButtonItem:UIBarButtonItem? = nil ,arrowDirections:UIPopoverArrowDirection = .up){
        self.modalPresentationStyle = .popover
        self.preferredContentSize = self.config.preferredContentSize
        let popover = self.popoverPresentationController
        popover?.permittedArrowDirections = arrowDirections
        popover?.barButtonItem = barButtonItem
        popover?.sourceView = sourceView
        popover?.sourceRect = sourceRect
        popover?.delegate = self
        sourceVc.present(self, animated: true, completion: nil)
    }
}


