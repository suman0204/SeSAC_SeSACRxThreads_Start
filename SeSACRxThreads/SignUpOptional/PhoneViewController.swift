//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
//    let phone = BehaviorSubject(value: "010") //나중에 viewModel로 이동
//    let buttonColor = BehaviorSubject(value: UIColor.red) //나중에 viewModel로 이동 -> VC가 값에 대한 정보를 알지 못하게 된다
//    let buttonEnabled = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    let viewModel = PhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        
        viewModel.buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.buttonColor
            .map { $0.buttonColor }
            .bind(to: nextButton.rx.backgroundColor, phoneTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        viewModel.buttonColor
            .map { $0.buttonColor.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.phone
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
//        viewModel.phone
//            .map { $0.count > 10 }
//            .subscribe { value in
//                print("==\(value)")
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                self.viewModel.buttonColor.onNext(color)
//                
//                self.viewModel.buttonEnabled.onNext(value)
////                self.buttonEnabled.on(.next(value)) // 위의 코드와 동일한 의미
//            }
//            .disposed(by: disposeBag)
//        
//        viewModel.phone
//            .map { $0.count > 10 }
//            .withUnretained(self) //RxSwift6에서 등장 // weak self를 해주지 않아도 메모리 누수를 관리해줌
//            .subscribe { object, value in
//                print("==\(value)")
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                object.viewModel.buttonColor.onNext(color)
//                
//                object.viewModel.buttonEnabled.onNext(value)
////                self.buttonEnabled.on(.next(value)) // 위의 코드와 동일한 의미
//            }
//            .disposed(by: disposeBag)
//        
//        viewModel.phone
//            .map { $0.count > 10 }
//            .subscribe(with: self, onNext: { owner, value in
//                print("==\(value)")
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                owner.viewModel.buttonColor.onNext(color)
//                
//                owner.viewModel.buttonEnabled.onNext(value)
////                self.buttonEnabled.on(.next(value)) // 위의 코드와 동일한 의미
//            })
//
//            .disposed(by: disposeBag)
//        
        phoneTextField.rx.text.orEmpty
            .subscribe { value in //textField에 입력되는 값을 phone이라는 subject에 담아준다
                let result = value.formated(by: "###-####-####")
                print(value, result)
                self.viewModel.phone.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

//xcode 15
//#Preview {
//    PhoneViewController()
//}


enum ButtonColor {
    case red
    case blue
    
    var buttonColor: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        }
    }
}
