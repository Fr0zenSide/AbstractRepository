//
//  UserRepositoryProtocol.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 16/04/2024.
//

import Foundation

public protocol UserRepositoryProtocol: RepositoryProtocol where InputModelType == User, OutputModelType == User {}
