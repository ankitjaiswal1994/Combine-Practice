//
//  ViewController.swift
//  CombineDemo
//
//  Created by Ankit Jaiswal on 28/08/21.
//

import UIKit
import Combine

enum MyError: Error {
    case subscribeError
}

class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = MyError

    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print(input)
        return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("completed")
    }
}

struct School {
    let name: String
    let noOfStudent: CurrentValueSubject<Int, Never>
    
    init(name: String, no: Int) {
        self.name = name
        self.noOfStudent = CurrentValueSubject(no)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let school = School.init(name: "Alpha d School", no: 100)
        
        var pub = CurrentValueSubject<School, Never>(school)
        

        pub
            .flatMap{
                $0.noOfStudent
            }
            .sink {
            print("school", $0)
        }
        
        school.noOfStudent.value += 1
        let school1 = School.init(name: "Alpha 1 School", no: 80)

        pub.send(school1)

//        // Do any additional setup after loading the view.
//        let subscriber = StringSubscriber()
//        let subject = PassthroughSubject<String, MyError>()
//
//        subject.subscribe(subscriber)
//
//        let subscription = subject.sink { completion in
//            print("completed sink")
//        } receiveValue: { value in
//            print("Sink value", value)
//        }
//
//        subject.send("A")
//        subscription.cancel()
//        subject.send("B")
//
//
//        ["A", "b"].publisher.collect(1).sink {
//            print($0)
//        }
//
//        [1, 2, 3].publisher.map {
//            $0 + 1
//        }.sink {
//            print($0)
//        }
    }
}

