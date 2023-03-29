//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by 이석원 on 2023/03/29.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
