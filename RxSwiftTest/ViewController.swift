//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by BaglaiB on 04.04.2020.
//  Copyright © 2020 bogdan. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ViewController: UIViewController {


    lazy var uiButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("touch me", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(touchHandler(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()

    }

    private func setupConstraints() {
        self.uiButton.setContentCompressionResistancePriority(.required, for: NSLayoutConstraint.Axis.horizontal)
        self.uiButton.setContentCompressionResistancePriority(.required, for: NSLayoutConstraint.Axis.vertical)
        self.uiButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    }


    @objc func touchHandler(sender: UIResponder) {
        print("Button touched, sender: \(sender)")
    }

    
    func rx() {
                // https://github.com/SebastianBoldt/Learn-and-Master-RxSwift

                // https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md
                """
                    Observables aka Sequences
                    Disposing
                    Implicit Observable guarantees
                    Creating your first Observable (aka observable sequence)
                    Creating an Observable that performs work
                    Sharing subscription and share operator
                    Operators
                    Playgrounds
                    Custom operators
                    Error handling
                    Debugging Compile Errors
                    Debugging
                    Enabling Debug Mode
                    Debugging memory leaks
                    KVO
                    UI layer tips
                    Making HTTP requests
                    RxDataSources
                    Driver
                    Traits: Driver, Single, Maybe, Completable
                    Examples
                """


                //https://swiftbook.ru/post/tutorials/rxswift-in-10-minutes/

                let disposeBag = DisposeBag()

                // 1. Наблюдаемые последовательности
                let stringSequence = Observable.just("Observable string")

                stringSequence.subscribe { (event) in
                    print("stringSequence event:\(event)")
                }.disposed(by: disposeBag)

                // 2. Subjects

                // PublishSubject ??

                // Variable !!! deprecated.
                    let variable = Variable("variable")

                    variable.asObservable().subscribe(onNext: { (nextValue) in
                        print("variable onNext:\(nextValue)")
                    }, onError: { (error) in
                        print("v onError:\(error)")
                    }, onCompleted: {
                        print("variable onCompleted")
                    }, onDisposed: {
                        print("variable onDisposed")
                    }).disposed(by: disposeBag)

                    variable.value =  "first str"
                    variable.value = "second str"


                // BehaviorSubject
                let behaviorSubject = BehaviorSubject(value: "Initial value")

                behaviorSubject.subscribe(onNext: { (nextValue) in
                    print("behaviorSubject onNext:\(nextValue)")
                }, onError: { (error) in
                    print("behaviorSubject onError:\(error)")
                }, onCompleted: {
                    print("behaviorSubject onCompleted")
                }, onDisposed: {
                    print("behaviorSubject onDisposed")
                }).disposed(by: disposeBag)

                behaviorSubject.onNext("first str")
                behaviorSubject.onCompleted()
                behaviorSubject.onNext("second str")

                // PublishSubject
                let publishSubject = PublishSubject<Int>()

                publishSubject.distinctUntilChanged().subscribe(onNext: { (nextValue) in
                    print("publishSubject onNext:\(nextValue)")
                }, onError: { (error) in
                    print("publishSubject onError:\(error)")
                }, onCompleted: {
                    print("publishSubject onCompleted")
                }, onDisposed: {
                    print("publishSubject onDisposed")
                }).disposed(by: disposeBag)


                publishSubject.onNext(1)
                publishSubject.onNext(1)
                publishSubject.onNext(1)
                publishSubject.onNext(2)
                publishSubject.onNext(3)
                publishSubject.onNext(4)



                // 4. Преобразования

                print("Преобразования")
                Observable.of(1,2,3,4).map { value in
                  return value * 10
                }.subscribe(onNext:{
                  print($0)
                })

        //        let sequence1  = Observable.of(1,2)
        //        let sequence2  = Observable.of(1,2)
        //        let sequenceOfSequences = Observable.of(sequence1,sequence2)
        //        sequenceOfSequences.flatMap{ return $0 }.subscribe(onNext:{
        //            print($0)
        //        })

                Observable.of(1,2,3,4,5).scan(0) { seed, value in
                    return seed + value
                }.subscribe(onNext:{
                    print($0)
                })

        //        Observable.of(1,2,3,4,5).buffer(timeSpan: RxTimeInterval.seconds(5), count: 3, scheduler: ImmediateSchedulerType).subscribe(onNext:{
        //            print($0)
        //        })

                Observable.of(2,30,22,5,60,1).filter{$0 > 10}.subscribe(onNext:{
                      print($0)
                })

                Observable.of(1,2,2,1,3).distinctUntilChanged().subscribe(onNext:{
                    print($0)
                })

        //        Debounce
        //        TakeDuration
        //        Skip




                // 6. Combine

                Observable.of(2,3).startWith(1).subscribe(onNext:{
                    print($0)
                })

        //        let publish1 = PublishSubject<Int>()
        //        let publish2 = PublishSubject<Int>()
        //        Observable.of(publish1,publish2).merge().subscribe(onNext:{
        //            print($0)
        //        })
        //        publish1.onNext(20)
        //        publish1.onNext(40)
        //        publish1.onNext(60)
        //        publish2.onNext(1)
        //        publish1.onNext(80)
        //        publish2.onNext(2)
        //        publish1.onNext(100)


        //        let a = Observable.of(1,2,3,4,5)
        //        let b = Observable.of("a","b","c","d")
        //        Observable.zip(a,b){ return ($0,$1) }.subscribe {
        //            print($0)
        //        }


                // 7. Сторонние действия
                Observable.of(1,2,3,4,5).do(onNext: {
                    $0 * 10 // This has no effect on the actual subscription
                }).subscribe(onNext:{
                    print($0)
                })

                // 8. Schedulers

        //        let publish11 = PublishSubject<Int>()
        //        let publish22 = PublishSubject<Int>()
        //        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        //        Observable.of(publish11,publish22)
        //                  .observeOn(concurrentScheduler)
        //                  .merge()
        //                  .subscribeOn(MainScheduler())
        //                  .subscribe(onNext:{
        //            print($0)
        //        })
        //        publish11.onNext(20)
        //        publish11.onNext(40)


    }

}

