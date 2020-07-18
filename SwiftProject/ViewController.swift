

import UIKit
import CoreData


enum Section :Int16 {
    case teacher,student,message
}

class ViewController: UIViewController{
    
    var managedObjectContext: NSManagedObjectContext!
    
    var tableView : UITableView!
    
    var dataSouece : SchoolDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "nullify"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(leftBarButtonItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.rowHeight = 60
        view.addSubview(tableView)
        dataSouece = SchoolDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
            let sec = Section(rawValue: Int16(indexPath.section))!
            switch sec {
            case .message:
                if let model = item as? Message
                {
                    cell?.textLabel?.text = "Message Type : \(model.type)"
                }
            case .student:
                if let model = item as? Student
                {
                    cell?.textLabel?.text = "ID: \(model.id) TeacherId: \(model.teacher.id)"
                }
            case .teacher:
                if let model = item as? Teacher
                {
                    cell?.textLabel?.text = "ID: \(model.id) studentsCount :\(model.students.count)"
                }
            }
            cell?.textLabel?.textColor = .black
            return cell
        })
        refresh()
    }
    
    @objc func leftBarButtonItem()
    {
        
        let teacherId = Int16(arc4random() % 10 + 1)
        let teacherName = "\(teacherId) name"
        managedObjectContext.performChanges {
            let _ = Student.insert(into: self.managedObjectContext, name: "ss", id: Int16(arc4random() % 16 + 1), teacherID: teacherId,teacherName:teacherName)
            self.refresh()
        }
        
        managedObjectContext.performChanges {
            let _ = Message.insert(into: self.managedObjectContext, type: .image)
            let _ = Student.insert(into: self.managedObjectContext, name: "ss", id: Int16(arc4random() % 16 + 1), teacherID: teacherId,teacherName:teacherName)
            self.refresh()
        }
        
        
    }
    
    @objc func refresh()
    {
        do {
            let stuReq = Student.fetchRequest()
            stuReq.returnsObjectsAsFaults = false
            stuReq.sortDescriptors = Student.defaultSortDescriptors
            let teaReq = Teacher.fetchRequest()
            teaReq.returnsObjectsAsFaults = false
            teaReq.sortDescriptors = Teacher.defaultSortDescriptors
            
            let msgReq = Message.fetchRequest()
            msgReq.returnsObjectsAsFaults = false
            msgReq.includesPendingChanges = true
            
            
            //            Message.insert(into: self.managedObjectContext, type: .text)
            
            if let students = try self.managedObjectContext.fetch(stuReq) as? [Student] ,let teachers = try self.managedObjectContext.fetch(teaReq) as? [Teacher], let msgs = try self.managedObjectContext.fetch(msgReq) as? [Message]
            {
                var snap = NSDiffableDataSourceSnapshot<Section,NSManagedObject>()
                snap.appendSections([.teacher,.student,.message])
                snap.appendItems(teachers, toSection: .teacher)
                snap.appendItems(students, toSection: .student)
                snap.appendItems(msgs, toSection: .message)
                dataSouece.apply(snap)
                
            }
        } catch  {
            print(error)
        }
    }
    
}

extension Sequence where Iterator.Element == UIColor {
    public var moodData: Data {
        let rgbValues = flatMap { $0.rgb }
        return rgbValues.withUnsafeBufferPointer {
            return Data(bytes: UnsafePointer<UInt8>($0.baseAddress!),
                        count: $0.count)
        }
    }
}

extension UIColor {
    fileprivate var rgb: [UInt8] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return [UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255)]
    }
}


extension ViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
            if let obj = self.dataSouece.itemIdentifier(for: indexPath){
                self.managedObjectContext.performChanges {
                    self.managedObjectContext.delete(obj)
                    self.refresh()
                }
            }
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

class SchoolDataSource :UITableViewDiffableDataSource<Section, NSManagedObject>
{
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = Section(rawValue: Int16(section))!
        switch sec {
        case .message: return "Message"
        case .student: return "Student"
        case .teacher: return "Teacher"
        }
    }
    
    
    
}
