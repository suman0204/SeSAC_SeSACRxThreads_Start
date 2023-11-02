//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/02.
//

import Foundation
import RxSwift

class BirthdayViewModel {
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let year = BehaviorSubject(value: 2020)
    let month = BehaviorSubject(value: 12)
    let day = BehaviorSubject(value: 22)
    
    let disposeBag = DisposeBag()

    init() {
        
        birthday // 데이트피커로 부터 받아온 날짜를 각 년, 월, 일 label에 전달한다
            .subscribe(with: self) { owner, date in
                
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                owner.year.onNext(component.year!) //옵셔널 바인딩 필요
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
                
            } onDisposed: { owner in
                print("birthday dispose")
            }
            .disposed(by: disposeBag) // 즉시 리소스 정리
    }
}
