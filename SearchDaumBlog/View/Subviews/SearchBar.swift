//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by 이석원 on 2023/03/29.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit


class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    //서치버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    //서치바 외부로 내보낼 이벤트
    
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attirbute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        //searchbar keyboard searchButton Tapped
        //button tapped
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped)
            .disposed(by: disposeBag)
        
        //키보드 내리기
        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
         
        
    }
    
    private func attirbute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        
        
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12.0)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
}

extension Reactive where Base: SearchBar {
    var endEditing : Binder<Void> {
        return Binder(base) { base , _ in
            base.endEditing(true)
        }
    }
    
}
