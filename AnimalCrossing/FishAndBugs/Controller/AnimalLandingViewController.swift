//
//  AnimalLandingViewController.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/18.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

@available(iOS 11.0, *)
class AnimalLandingViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!

    private let viewModel: AnimalViewModel = AnimalViewModel()
    private var bag: DisposeBag! = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.data(forKey: "fish80") == nil {
            self.progressView.progress = 0.25
            for id in 1...80 {
                animalApiRequest(id: id, type: "fish")
            }
        } else if UserDefaults.standard.data(forKey: "bugs80") == nil {
            for id in 1...80 {
                animalApiRequest(id: id, type: "bugs")
            }
        } else {
            self.progressView.progress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: "jump", sender: self)
            })
        }
    }

    private func animalApiRequest(id: Int, type: String) {
        viewModel.requestData(id: id, type: type).subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            guard result else { return }
        }, onError: { (Error) in
            print(Error)
        }, onCompleted: {
            if type == "fish" {
                self.progressView.progress = 0.5
                if UserDefaults.standard.data(forKey: "fish80") != nil {
                    for id in 1...80 {
                        self.animalApiRequest(id: id, type: "bugs")
                    }
                }
            } else {
                self.progressView.progress = 0.75
                if UserDefaults.standard.data(forKey: "bugs80") != nil {
                    self.progressView.progress = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.performSegue(withIdentifier: "jump", sender: self)
                    })
                }
            }
        }, onDisposed: nil).disposed(by: bag)
    }
}
