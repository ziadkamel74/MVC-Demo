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
    
    class func getAllTasks(completion: @escaping (_ error: Error?, _ tasksResponse: TaskResponse?) -> Void) {
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
                let tasksData = try decoder.decode(TaskResponse.self, from: data)
                completion(nil, tasksData)
            } catch {
                completion(error, nil)
            }
        }
    }
    
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
    
    class func logOut(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared().token else { return }
        
        let headers: HTTPHeaders = [HeaderKeys.authorization: HeaderValues.bearer + token,
                                    HeaderKeys.contentType: HeaderValues.appJSON]
        
        AF.request(URLs.logout, method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: headers).response { response in
            guard response.error == nil else {
                print(response.error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
}
