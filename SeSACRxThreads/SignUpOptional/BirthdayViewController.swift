//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    //ViewModel로 이관
//    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
//    let year = BehaviorSubject(value: 2020)
////    let year = Observable.of(2020)
//    let month = BehaviorSubject(value: 12)
//    let day = BehaviorSubject(value: 22)
    
    let viewModel = BirthdayViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        viewModel.year
            .observe(on: MainScheduler.instance) // Schedular - Main Thread에서 동작하게 해주는 코드
            .map { "\($0)년" }
            .subscribe(with: self) { owner, value in
                owner.yearLabel.text = value
            } onDisposed: { owner in
                print("yaer dispose")
            }
            .disposed(by: disposeBag)
        
        viewModel.month
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = "\(value)월"
            } onDisposed: { owner in
                print("month dispose")
            }
            .disposed(by: disposeBag)
        
        viewModel.day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date // 데이트피커에서 선택한 날짜가 birthday값에 전달
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
        //vm에서 꺼내온 birthday에서 다시 vm에 존재하는 year, month, day에 보내준다?..
//        viewModel.birthday // 데이트피커로 부터 받아온 날짜를 각 년, 월, 일 label에 전달한다
//            .subscribe(with: self) { owner, date in
//                
//                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
//                
//                owner.viewModel.year.onNext(component.year!) //옵셔널 바인딩 필요
//                owner.viewModel.month.onNext(component.month!)
//                owner.viewModel.day.onNext(component.day!)
//
//            } onDisposed: { owner in
//                print("birthday dispose")
//            }
//            .disposed(by: disposeBag)
//            .dispose() // 즉시 리소스 정리
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
