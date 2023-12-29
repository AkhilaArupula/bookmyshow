import UIKit
import CoreData

var showList = [Show]()

class ShowTableView: UITableViewController
{
    var firstLoad = true
    
    func noDeletedShows() -> [Show]
    {
        var noDeletedShowLists = [Show]()
        for show in showList
        {
            if(show.deletedDate == nil)
            {
                noDeletedShowLists.append(show)
            }
        }
        return noDeletedShowLists
    }
    
    override func viewDidLoad()
    {
        if(firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Show")
            do {
                let result:NSArray = try context.fetch(request) as NSArray
                for result in result
                {
                    let show = result as! Show
                    showList.append(show)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCellID", for: indexPath) as! Showcell
        
        let thisShow: Show!
        thisShow = noDeletedShows()[indexPath.row]
        
        showCell.titleLabel.text = thisShow.title
        showCell.descLabel.text = thisShow.desc
        
        return showCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noDeletedShows().count
    }
    
    override func viewDidAppear(_ animated: Bool) 
    {
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showCellID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showCellID")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let showDetail = segue.destination as? ShowDetailVC
            
            let selectedShow : Show!
            selectedShow = noDeletedShows()[indexPath.row]
            showDetail!.selectedShow = selectedShow
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    /*override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            tableView.beginUpdates()
            showList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }*/
    
    
}

