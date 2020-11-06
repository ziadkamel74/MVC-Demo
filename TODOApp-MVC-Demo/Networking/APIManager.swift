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
    class func login(with email: String, password: String, completion: @escaping (_ error: Error?, _ loginData: LoginResponse?) -> Void) {
        
        let headers: HTTPHeaders = [HeaderKeys.contentType: HeaderValues.appJSON]
        let params: [String: Any] = [ParameterKeys.email: email,
                                     ParameterKeys.password: password]
        
        AF.request(URLs.login, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let loginData = try decoder.decode(LoginResponse.self, from: data)
                completion(nil, loginData)
            } catch let error {
                print(error.localizedDescription)
                completion(error, nil)
            }
        }
    }
    
    /// Register new user to the database
    class func register(with user: UserData, completion: @escaping (_ error: Error?, _ loginData: LoginResponse?) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.contentType: HeaderValues.appJSON]
        let params: [String: Any] = [ParameterKeys.name: user.name,
                                     ParameterKeys.email: user.email,
                                     ParameterKeys.password: user.password!,
                                     ParameterKeys.age: user.age]
        
        AF.request(URLs.register, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response { respone in
            guard respone.error == nil else {
                completion(respone.error, nil)
                return
            }
            guard let data = respone.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let loginData = try decoder.decode(LoginResponse.self, from: data)
                completion(nil, loginData)
            } catch let error {
                completion(error, nil)
            }
        }
    }
    
    /// Adding new task to the database
    class func addNewTask(with task: TaskData, completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token,
                                    HeaderKeys.contentType: HeaderValues.appJSON]
        let params: [String: Any] = [ParameterKeys.description: task.description]
        
        AF.request(URLs.baseTask, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                print(response.error!.localizedDescription)
                completion(false)
                return
            }
            guard let _ = response.data else {
                print("didn't get any data from API")
                return
            }
            completion(true)
        }
    }
    
    /// Loading all tasks associated with authenticated user from database
    class func getAllTasks(completion: @escaping (_ error: Error?, _ tasksData: [TaskData]?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token,
                                    HeaderKeys.contentType: HeaderValues.appJSON]
        
        AF.request(URLs.baseTask, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                completion(response.error, nil)
                return
            }
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tasksData = try decoder.decode(TaskResponse.self, from: data).data
                completion(nil, tasksData)
            } catch {
                completion(error, nil)
            }
        }
    }
    
    /// Loading authenticated user info from the database
    class func getUserData(completion: @escaping (_ error: Error?, _ userData: UserData?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token,
                                    HeaderKeys.contentType: HeaderValues.appJSON]
        
        AF.request(URLs.userData, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response { response in
            
            guard response.error == nil else {
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: data)
                completion(nil, userData)
            } catch let error {
                completion(error, nil)
            }
        }
    }
    
    /// Logging current user out from database
    class func logOut(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token,
                                    HeaderKeys.contentType: HeaderValues.appJSON]
        
        AF.request(URLs.logout, method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                completion(false, response.error)
                return
            }
            completion(true, nil)
        }
    }
    
    /// Deleting task associated with authenticated user  from the database by task id
    class func deleteTask(with id: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token, HeaderKeys.contentType: HeaderValues.appJSON]
        
        AF.request(URLs.baseTask + "/\(id)", method: HTTPMethod.delete, parameters: nil, encoding: URLEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
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
    class func getUserImage(with id: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let userID = id + "/\(ParameterKeys.avatar)"
        
        AF.request(URLs.baseAuth + "/\(userID)", method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { response in
            
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            completion(response.data, nil)
        }
    }
    
    /// Delete user image from the database
    class func deleteUserImage(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token]
        AF.request(URLs.userAvatar, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Delete and remove user from the database
    class func deleteUser(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token]
        
        AF.request(URLs.userData, method: .delete, encoding: URLEncoding.default, headers: headers).response { response in
            guard response.error == nil, response.data != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Update logged in user profile and save it to database
    class func updateUserProfile(name: String?, age: Int?, email: String?, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        let headers: HTTPHeaders = [HeaderKeys.contentType: HeaderValues.appJSON, HeaderKeys.authorization: HeaderValues.bearer + token]
        var params: [String: Any] = [:]
        if let name = name {
            params[ParameterKeys.name] = name
        }
        if let age = age {
            params[ParameterKeys.age] = age
        }
        if let email = email {
            params[ParameterKeys.email] = email
        }
        
        AF.request(URLs.userData, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).response { response in
            guard response.error == nil, response.data != nil else {
                completion(false, response.error)
                return
            }
            completion(true, nil)
        }
    }
    
}
