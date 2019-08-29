//
//  Repository.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import RealmSwift
import RxSwift

private func abstractMethod() -> Never {
    fatalError("abstract method")
}

class AbstractRespository<T> {
    func queryFirst() -> T? {
        abstractMethod()
    }
    
    func save(_ entity: T) {
        abstractMethod()
    }
    
    func deleteAll() {
        abstractMethod()
    }
}

final class Repository<T: RealmRepresentable>:
AbstractRespository<T> where T == T.RealmType.DomainType, T.RealmType: Object {
    
    private var configuration: Realm.Configuration
    
    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    deinit {
        print("Repository::deinit")
    }
    
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.configuration = configuration
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    override func queryFirst() -> T? {
        return self.realm.objects(T.RealmType.self).first?.asDomain()
    }
    
    override func save(_ entity: T) {
        do {
            try self.realm.write {
                self.realm.create(T.RealmType.self, value: entity.asRealm(),
                                  update: Realm.UpdatePolicy.modified)
            }
        } catch {
        }
    }
    
    override func deleteAll() {
        do {
            try self.realm.write {
                self.realm.delete(self.realm.objects(T.RealmType.self))
            }
        } catch {
        }
    }
}
