
import UIKit

class NewsListVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerBlocks()
        viewModel.viewDidLoad()
        
    }
    
    // MARK: - FUNCTIONS
    
    func setupTableView() {
        // register table View
        tableView.register(UINib(nibName: ViewModel.Configurations.newsTVCell, bundle: nil), forCellReuseIdentifier: ViewModel.Configurations.newsTVCell)
        
        tableView.separatorColor = UIColor.clear
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
    func registerBlocks(){
        viewModel.reloadTV = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.navigateToDetailVC = { [weak self] data in
            guard let self = self else {return}
            let vc = NewsDetailVC.loadFromNib()
            vc.viemModel.articleObj = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.showErrorDialog = { [weak self] title , message in
            guard let self = self else {return}
            showAlert(title: title, message: message)
        }
    }
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
