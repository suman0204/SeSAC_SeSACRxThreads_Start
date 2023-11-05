//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/02.
//

import Foundation
import RxSwift

class PhoneViewModel {
    
    let phone = BehaviorSubject(value: "010")
    let buttonColor = BehaviorSubject(value: ButtonColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        
//        phone
//            .map { $0.count > 10 }
//            .subscribe { value in
//                print("==\(value)")
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                self.buttonColor.onNext(color)
//                
//                self.buttonEnabled.onNext(value)
////                self.buttonEnabled.on(.next(value)) // 위의 코드와 동일한 의미
//            }
//            .disposed(by: disposeBag)
//        
//        phone
//            .map { $0.count > 10 }
//            .withUnretained(self) //RxSwift6에서 등장 // weak self를 해주지 않아도 메모리 누수를 관리해줌
//            .subscribe { object, value in
//                print("==\(value)")
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                object.buttonColor.onNext(color)
//                
//                object.buttonEnabled.onNext(value)
////                self.buttonEnabled.on(.next(value)) // 위의 코드와 동일한 의미
//            }
//            .disposed(by: disposeBag)
        
        phone
            .map { $0.count > 10 }
            .subscribe(with: self, onNext: { owner, value in
                print("==\(value)")
                let color = value ? ButtonColor.blue : ButtonColor.red
                owner.buttonColor.onNext(color)
                
                owner.buttonEnabled.onNext(value)
//                self.buttonEnabled.on(.next(value)) // 위의 코드와 동일한 의미
            })

            .disposed(by: disposeBag)
        
    }
    
}
