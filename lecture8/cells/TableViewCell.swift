
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    
    static let identifier = String(describing: TableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addGradientBgHorizontal(
            firstColor: UIColor(red: 0.45, green: 0.46, blue: 0.64, alpha: 1.00),
            secondColor:UIColor(red: 0.72, green: 0.82, blue: 0.96, alpha: 1.00))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
 
