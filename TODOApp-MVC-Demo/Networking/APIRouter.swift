//
//  APIRouter.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 11/12/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    // The endpoint name
    case login(_ user: UserData)
    case signUp(_ user: UserData)
    case updateUser(_ user: UserData)
    case addTask(_ task: TaskData)
    case deleteTask(_ id: String)
    case getImage(_ id: String)
    case getTodos, getUserData, logout, deleteImage, deleteUser
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .signUp, .logout, .addTask:
            return .post
        case .getTodos, .getUserData, .getImage:
            return .get
        case .deleteTask, .deleteImage, .deleteUser:
            return .delete
        case .updateUser:
            return .put
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - url
    private var url: String {
        switch self {
        case .login:
            return URLs.login
        case .signUp:
            return URLs.register
        case .logout:
            return URLs.logout
        case .addTask, .getTodos:
            return URLs.baseTask
        case .getUserData, .deleteUser, .updateUser:
            return URLs.userData
        case .deleteTask(let id):
            return URLs.baseTask + "/\(id)"
        case .getImage(let id):
            return URLs.base + "/user/\(id)/\(ParameterKeys.avatar)"
        case .deleteImage:
            return URLs.userAvatar
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try url.asURL())
        
        //httpMethod
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .getTodos, .addTask, .getUserData, .deleteTask, .updateUser:
            if let token = UserDefaultsManager.shared().token {
                urlRequest.setValue(HeaderValues.bearer + token, forHTTPHeaderField: HeaderKeys.authorization)
                urlRequest.setValue(HeaderValues.appJSON, forHTTPHeaderField: HeaderKeys.contentType)
            }
        case .login, .signUp:
            urlRequest.setValue(HeaderValues.appJSON, forHTTPHeaderField: HeaderKeys.contentType)
        case .logout, .deleteImage, .deleteUser:
            if let token = UserDefaultsManager.shared().token {
            urlRequest.setValue(HeaderValues.bearer + token, forHTTPHeaderField: HeaderKeys.authorization)
            }
        default:
            break
        }
        
        // HTTP Body
        let httpBody: Data? = {
            switch self {
            case .login(let body):
                return encodeToJSON(body)
            case .signUp(let body):
                return encodeToJSON(body)
            case .addTask(let body):
                return encodeToJSON(body)
            case .updateUser(let body):
                return encodeToJSON(body)
            default:
                return nil
            }
        }()
        urlRequest.httpBody = httpBody
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get, .delete:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

extension APIRouter {
    private func encodeToJSON<T: Encodable>(_ body: T) -> Data? {
        do {
            let anyEncodable = AnyEncodable(body)
            let jsonData = try JSONEncoder().encode(anyEncodable)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
}

// type-erasing wrapper
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
