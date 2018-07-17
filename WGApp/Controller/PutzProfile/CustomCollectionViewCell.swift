import UIKit

@IBDesignable
class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
    
    func setBackgroundColor(actWeekStart: Date){
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd.MM.yy"
        if (actWeekStart == HomeScreenVC.thisWeekStart) {
            print("actweekstart \(outFormatter.string(from: actWeekStart)) == this \(outFormatter.string(from: HomeScreenVC.thisWeekStart!))")
            self.backgroundColor = UIColor.init(named: "GREEN")
        } else {
            self.backgroundColor = UIColor.init(named: "WHITE")
        }
    }
    
}
