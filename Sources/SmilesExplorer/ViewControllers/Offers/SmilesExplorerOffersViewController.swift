//
//  SmilesExplorerOffersViewController.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import UIKit
import SmilesUtilities
import Combine
import LottieAnimationManager
import SmilesLanguageManager
import SmilesFontsManager
import SmilesLoader
import SmilesOffers

class SmilesExplorerOffersViewController: UIViewController {

    // MARK: - OUTLETS -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var confirmBtn: UICustomButton!
    @IBOutlet weak var skipBtn: UICustomButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var categoryId = 973 //TODO: init it -1
    
    // MARK: - PROPERTIES -
    private var input: PassthroughSubject<SmilesExplorerOffersViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerOffersViewModel = {
        return SmilesExplorerOffersViewModel()
    }()
    private var response:OffersCategoryResponseModel?

    var currentPage = 1
    var isLoading = false
    var hasMoreData = true
    
    // MARK: - ACTIONS -

    
    @IBAction func confirmPressed(_ sender: UIButton) {

    }
    
    @IBAction func skipPressed(_ sender: UIButton) {

    }
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.bind(to: viewModel)
        loadMoreItems()
//        SmilesLoader.show(on: self.view)
        // Do any additional setup after loading the view.
    }
    
    init() {
        super.init(nibName: "SmilesExplorerOffersViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    func setupUI(){
        titleLbl.text = response?.listTitle
        detailsLbl.text = response?.listSubtitle
        skipBtn.layer.borderColor = #colorLiteral(red: 0.431372549, green: 0.2352941176, blue: 0.5098039216, alpha: 1)
        setupCollectionView()
    }
    private func setUpNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = SmilesLanguageManager.shared.getLocalizedString(for: "Pick a ticket")
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        self.navigationItem.titleView = locationNavBarTitle
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func bind(to viewModel: SmilesExplorerOffersViewModel) {
        input = PassthroughSubject<SmilesExplorerOffersViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .getSmilesExplorerOffersDidSucceed(let response):
                    var response = response
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    guard response.offers?.count ?? 0 > 0 else {
                        self?.hasMoreData = false
                        return
                    }
                    response.offers?.append(contentsOf: self?.response?.offers ?? [])
                    self?.response = response
                    self?.hasMoreData = self?.response?.offersCount ?? 0 > self?.response?.offers?.count ?? 0
                    self?.isLoading = false
                    self?.currentPage += 1
                    self?.collectionView.reloadData()
                case .getSmilesExplorerOffersDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - Pagination
    
    func loadMoreItems() {
        print("fetching \(currentPage)")
        isLoading = true
        input.send(.fetchSmilesExplorerOffers(page: currentPage))
    }
    
    
}
extension SmilesExplorerOffersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.response?.offers?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentCount = response?.offers?.count ?? 0
        if currentCount > 0 && indexPath.row == currentCount - 1 && !isLoading && hasMoreData {
            loadMoreItems()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketOffersCollectionCell", for: indexPath) as! TicketOffersCollectionCell
        cell.offer = self.response?.offers?[indexPath.row]
        return cell
    }
    func setupCollectionView(){
        collectionView.register(UINib(nibName: String(describing: TicketOffersCollectionCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: TicketOffersCollectionCell.self))
        collectionView.collectionViewLayout = setupCollectionViewLayout()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(250)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            return section
        }
    }
}
