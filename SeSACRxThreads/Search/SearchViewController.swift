//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        title = "\(Int.random(in: 1...100))"
    }
}

class SearchViewController: UIViewController {
     
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    
    var data = ["A", "B", "C", "AB", "D", "ABC"]
     
    lazy var items = BehaviorSubject(value: data)
    
//    var items = BehaviorSubject(value: ["A", "B", "C"])
//    var items = BehaviorSubject(value: Array(100...150).map { "안녕하세요 \($0)"})
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()
        
        setSearchController()
        
    }
     
    func bind() {
        
        items // cellForRowAt
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .green
                
                cell.downloadButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("downloadButton tap")
                        owner.navigationController?.pushViewController(SampleViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag) // cell에 들어있는 disposeBag과 연결
            }
            .disposed(by: disposeBag)
        
        //didSelectRowAt
//        tableView.rx.itemSelected
//            .subscribe(with: self) { owner, indexPath in
//                print(indexPath)
//            }
//            .disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)

        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map { "셀 선택 \($0) \($1)"}
            .bind(to: navigationItem.rx.title)
//            .subscribe(with: self, onNext: { owner, value in
//                owner.navigationItem.title = value
//            })
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
            .disposed(by: disposeBag)
        
        
        
        //SearchBar에 입력한 text를 리턴시 클릭 시 배열에 추가
        //입력된 text 옵셔널 바인딩 -> append -> reloadData
        //SearchBarDelegate searchButtonClicked
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { void, text in
                return text
            })
            .subscribe(with: self, onNext: { owner, text in
                print(text)
                owner.data.insert(text, at: 0)
                owner.items.onNext(owner.data)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print(value)
                
                let result = value == "" ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
                
                print("==실시간 검색== \(value)")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
