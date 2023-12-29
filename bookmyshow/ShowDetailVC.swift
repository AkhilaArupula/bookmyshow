import UIKit
import CoreData
import StoreKit

class ShowDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var titleTF: UITextField!
    //@IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    //@IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedShow: Show? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
   // @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
   // @IBOutlet weak var dateTextField: UITextField!
    
    let images = ["Image1", "Image2", "Image3", "Image4", "Image5"]
    let titles = ["SALAAR", "Adhipursh", "Leo", "irugupatam ", "HiNanna"]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.image.image = UIImage(named: images[indexPath.row])
            cell.pTitle.text = titles[indexPath.row]
            cell.pSubTitle.text = "AVAILABLE NOW"
            return cell
        }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(selectedShow != nil)
        {
            titleTF.text = selectedShow?.title
            descTV.text = selectedShow?.desc
        }
        
    }
    
    
    
    @IBAction func rating(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    @IBAction func saveAction(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedShow == nil)
        {
        let entity = NSEntityDescription.entity(forEntityName: "Show", in: context)
        let newShow = Show(entity: entity!, insertInto: context)
        newShow.id = showList.count as NSNumber
        newShow.title = titleTF.text
        newShow.desc = descTV.text
        do
        {
            try context.save()
            showList.append(newShow)
            navigationController?.popViewController(animated: true)
        }
        catch
        {
            print("context save error")
        }
    }
        
    else
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Show")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let show = result as! Show
                if(show == selectedShow)
                {
                    show.title = titleTF.text
                    show.desc = descTV.text
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }
    }
        
    }
    
    @IBAction func bookButtonTapped(_ sender: UIButton) {
           guard let name = nameTextField.text, !name.isEmpty,
                 let date = dateTextField.text, !date.isEmpty else {
               // Show alert for incomplete fields
               return
           }
           // Perform booking logic here
           let confirmationMessage = "Booking confirmed for \(name) on \(date)"
           showAlert(message: confirmationMessage)
       }
   // @IBAction func bookButtonTapped(_ sender: Any) {
   // }
    
       func showAlert(message: String) {
           let alertController = UIAlertController(title: "Booking", message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alertController, animated: true, completion: nil)
       }
   }                         // @IBAction func saveAction(_ sender: Any) {
   /* @IBAction func DeleteShow(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Show")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let show = result as! Show
                if(show == selectedShow)
                {
                    show.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }
        
    }
}*/

class PostCell: UICollectionViewCell{
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pSubTitle: UILabel!
    
    override func awakeFromNib() {
        background.layer.cornerRadius = 10
        image.layer.cornerRadius = 10
    }
}

