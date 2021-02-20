import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var prevCityBtn: UIButton!
    @IBOutlet weak var nextCityBtn: UIButton!
    
    let url = Constants.host
    var myData: Model?
    let cities=["Astana","Moskow","Tokyo"]
    var cityId=0
    private var decoder: JSONDecoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        //table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableCell")
        tableView.rowHeight=71
        
        //collection
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        cityName.text = cities[cityId]
        fetchData()
        bgImage() 
    }

    @IBAction func tapToPrev(_ sender: Any) {
        if cityId != 0{
            cityId -= 1
            cityName.text = cities[cityId]
        }
    }
    
    @IBAction func tapToNext(_ sender: Any) {
        if cityId != cities.count-1{
            cityId += 1
            cityName.text = cities[cityId]
        }
    }
    
     
    func bgImage(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "images/wheather.jpg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func updateUI(){
       
       // prevCityBtn.isEnabled=false
       
        
        temp.text = "\(myData?.current?.temp ?? 0.0)"
        feelsLikeTemp.text = "\(myData?.current?.feels_like ?? 0.0)"
        desc.text = myData?.current?.weather?.first?.description
        collectionView.reloadData()
    }
    
    func fetchData(){
        AF.request(url).responseJSON { (response) in
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                guard let answer = try? self.decoder.decode(Model.self, from: data) else{ return }
                self.myData = answer
                self.updateUI()
            case .failure(let err):
                print(err.errorDescription ?? "")
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
        //return myData?.daily?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableCell
       let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
    
        let item = myData?.hourly?[indexPath.item]

        cell.dayLabel.text=" \(getDate(count: indexPath.row))"
        cell.tempLabel.text="\(item?.temp ?? 0.0)ºC / \(item?.feels_like ?? 0.0 )ºC"
        cell.cloudsLabel.text=item?.weather?.first?.description
 
        return cell
    }
    
    func getDate(count: Int)->String{
        if count==0{
            return "Today"
        }
        else if count==1{
            return "Tomorrow"
        }
        else{
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day,
                                             value: count,
                                             to: today)
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
        
        return dateFormatter.string(from: nextDate!)
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myData?.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        let item = myData?.hourly?[indexPath.item]
        cell.temp.text = "\(item?.temp ?? 0.0)"
        cell.feelsLike.text = "\(item?.feels_like ?? 0.0)"
        cell.desc.text = item?.weather?.first?.description
        
        return cell

    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


