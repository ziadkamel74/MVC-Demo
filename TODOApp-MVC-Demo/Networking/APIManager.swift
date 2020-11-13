//
//  APIManager.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    /// Log user in with email and password
    class func login(with user: UserData, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        request(APIRouter.login(user)) { (response) in
            completion(response)
        }
    }
    
    /// Register new user to the database
    class func register(with user: UserData, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        request(APIRouter.signUp(user)) { (response) in
            completion(response)
        }
    }
    
    /// Adding new task to the database
    class func addNewTask(with task: TaskData, completion: @escaping (_ success: Bool) -> Void) {
        requestBool(APIRouter.addTask(task)) { (succeeded) in
            completion(succeeded)
        }
        
    }
    
    /// Loading all tasks associated with authenticated user from database
    class func getAllTasks(completion: @escaping (Result<TaskResponse, Error>) -> Void) {
        request(APIRouter.getTodos) { (response) in
            completion(response)
        }
    }
    
    /// Loading authenticated user info from the database
    class func getUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        request(APIRouter.getUserData) { (response) in
            completion(response)
        }
    }
    
    /// Logging current user out from database
    class func logOut(completion: @escaping (_ success: Bool) -> Void) {
        requestBool(APIRouter.logout) { (succeeded) in
            completion(succeeded)
        }
    }
    
    /// Deleting task associated with authenticated user  from the database by task id
    class func deleteTask(with id: String, completion: @escaping (_ success: Bool) -> Void) {
        requestBool(APIRouter.deleteTask(id)) { (deleted) in
            completion(deleted)
        }
    }
    
    /// Upload image by authenticated user
    class func uploadImage(with imageData: Data, completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token]
        
        AF.upload(multipartFormData: { (formData) in
            formData.append(imageData, withName: ParameterKeys.avatar, fileName: FormData.fileName, mimeType: FormData.mimeType)
        }, to: URLs.userAvatar, method: .post, headers: headers).response { response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    /// Get user image that has been uploaded
    class func getUserImage(with id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        requestData(APIRouter.getImage(id)) { (response) in
            completion(response)
        }
    }
    
    /// Delete user image from the database
    class func deleteUserImage(completion: @escaping (_ success: Bool) -> Void) {
        requestBool(APIRouter.deleteImage) { (deleted) in
            completion(deleted)
        }
    }
    
    /// Delete and remove user from the database
    class func deleteUser(completion: @escaping (_ success: Bool) -> Void) {
        requestBool(APIRouter.deleteUser) { (deleted) in
            completion(deleted)
        }
    }
    
    /// Update logged in user profile and save it to database
    class func updateUserProfile(_ user: UserData, completion: @escaping (_ success: Bool) -> Void) {
        requestBool(APIRouter.updateUser(user)) { (updated) in
            completion(updated)
        }
    }
    
}

extension APIManager {
    // MARK:- The request function to get results in a closure
    private static func request<T: Decodable>(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<T, Error>) -> Void) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK:- The request function to get bool in a closure
    private static func requestBool(_ urlConvertible: URLRequestConvertible, completion: @escaping (_ success: Bool) -> Void) {
        AF.request(urlConvertible).response { response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // MARK:- The request function to get data in a closure
    private static func requestData(_ urlConvertible: URLRequestConvertible, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(urlConvertible).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
