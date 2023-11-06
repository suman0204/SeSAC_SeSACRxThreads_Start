//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    
        aboutUnicast()
        aboutMulticast()
        requestExample()
    }
    
    func requestExample() {
        let request = BasicAPIManager.fetchData().share()
        
        request
            .subscribe(with: self) { owner, value in
//                print(value)
                print("1")
            }
            .disposed(by: disposeBag)
        
        request
            .subscribe(with: self) { owner, value in
//                print(value.results.count)
                print("2")
            }
            .disposed(by: disposeBag)
        
        request
            .map { data in
                "\(data.results.count)개의 검색 결과"
            }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    func aboutUnicast() { //Observable
        
        let random = Observable<Int>.create { value in
            value.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        random
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        random
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        random
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    func aboutMulticast() { //Subject
        
        let random = BehaviorSubject(value: 100)
        
        random.onNext(Int.random(in: 1...100))
        
        random
            .subscribe(with: self) { owner, value in
                print("multicast", value)
            }
            .disposed(by: disposeBag)
        
        random
            .subscribe(with: self) { owner, value in
                print("multicast", value)
            }
            .disposed(by: disposeBag)
        
        random
            .subscribe(with: self) { owner, value in
                print("multicast", value)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
