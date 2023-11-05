//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let test = UISwitch()
//    let isOn = Observable.of(true) //Observable 이벤트를 생성하고 전달하는 것만 가능하다
//    let isOn = BehaviorSubject(value: true) //값을 전달하고 받는 것도 가능하다
    let isOn = PublishSubject<Bool>() //초기값이 없다

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testSwitch()
//        incrementExample()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        bind()
        
        aboutCombineLatest()
        
    }
    
    func aboutCombineLatest() {
        let a = PublishSubject<Int>() //BehaviorSubject(value: 3)
        let b = PublishSubject<String>() //BehaviorSubject(value: "가")
        
        //combineLatest는 이벤트 방출(next)이 한 번이라도 일어나야 동작한다
        Observable.combineLatest(a, b) { first, second in
            return "결과: \(first) 그리고 \(second)"
        }
        .subscribe(with: self) { owner, data in
            print(data)
        }
        .disposed(by: disposeBag)
        
        a.onNext(2)
        a.onNext(8)
        a.onNext(5)
        
        b.onNext("나")
        b.onNext("다")
    }
    
    func bind() {
        
        //빈 문자열이 들어가는 것이 이벤트이기 때문에 combineLatest가 동작
        let email = emailTextField.rx.text.orEmpty //UITextFiled를 rx로 사용하기 위해서 랩핑
        let password = passwordTextField.rx.text.orEmpty
        
        let validation = Observable.combineLatest(email, password) { email, password in
            return email.count > 8 && password.count > 6
        }
        
        validation
            .subscribe(with: self) { owner, value in
                owner.signInButton.backgroundColor = value ? UIColor.blue : UIColor.red
                owner.emailTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
                owner.passwordTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
            }
            .disposed(by: disposeBag)
//            .bind(to: signInButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(with: self) { owner, value in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func incrementExample() {
        let incrementValue = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let incrementValue2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let incrementValue3 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

        incrementValue
            .subscribe(with: self) { owner, value in
                print("next - \(value)")
            } onError: { owner, error in
                print("error - \(error)")
            } onCompleted: { owener in
                print("completed")
            } onDisposed: { owenr in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        incrementValue2
            .subscribe(with: self) { owner, value in
                print("next - \(value)")
            } onError: { owner, error in
                print("error - \(error)")
            } onCompleted: { owener in
                print("completed")
            } onDisposed: { owenr in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        incrementValue3
            .subscribe(with: self) { owner, value in
                print("next - \(value)")
            } onError: { owner, error in
                print("error - \(error)")
            } onCompleted: { owener in
                print("completed")
            } onDisposed: { owenr in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.disposeBag = DisposeBag()
//            incrementValue.dispose()
//            incrementValue2.dispose()
//            incrementValue3.dispose()
        }

    }
    
    func testSwitch() {
        view.addSubview(test)
        test.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.leading.equalTo(100)
        }
        
        
//        isOn
//            .subscribe { value in
//                self.test.setOn(value, animated: false)
//            }
//            .disposed(by: disposeBag)
//
        isOn
            .bind(to: test.rx.isOn) //rxcocoa
            .disposed(by: disposeBag)
        
        isOn.onNext(true) //구독 이후에 이벤트를 전달해야 실행된다!!

        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
            self.isOn.onNext(false)
        }
        
        //UIKit
//        test.setOn(true, animated: false)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
//            self.test.setOn(false, animated: false)
//        }
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
