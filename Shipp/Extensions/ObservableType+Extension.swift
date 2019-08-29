//
//  ObservableType+Extension.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 27/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
    
    func trackActivity(_ activityTracker: ActivityTracker) -> Observable<E> {
        return activityTracker.trackActivityOfObservable(self)
    }
}
