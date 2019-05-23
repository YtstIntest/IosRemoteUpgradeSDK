//
//  RemoteUpdateManage.swift
//  IosRemoteUpgrade
//
//  Created by xialiang on 2019/5/23.
//  Copyright © 2019 xialiang. All rights reserved.
//

import UIKit
import HandyJSON


open class RemoteUpdateManage: NSObject {
    var timer = Timer()
    
    /// 查询已经升级的车辆任务列表
    ///
    /// - Parameters:
    ///   - vin: 车辆vin
    ///   - pi: 页面索引
    ///   - ps: 页面大小
    ///   - uDate: 日期时间
    public func getUpdateTaskList(vin:String,pi:Int,ps:Int,uDate:String, success:@escaping (UpdateVehicleTaskModel) -> (Void),failed:@escaping (String) -> (Void)) -> Void {
        NetWorkRequest(.getUpdateTaskList(vin: vin, pi: pi, ps: ps, uDate: uDate), completion: {(jsonString)-> (Void)in
            if let mappedObject = JSONDeserializer<BaseResponse<UpdateVehicleTaskModel>>.deserializeFrom(json: jsonString) {
                // 从字符串转换为对象实例
                success(mappedObject.body)
            }
        }, failed:{(failedCallback)-> (Void)in
            failed(failedCallback)
        })
        
    }
    
    
    /// 查询当前车辆升级任务
    ///
    /// - Parameters:
    ///   - vin: 车辆vin
    ///   - uDate: 日期时间
    ///   - taskcarId: 车辆升级任务id
    public func queryCarUpdateTask(vin:String,uDate:String,taskcarId:String,success:@escaping (CurrentVehicleTaskModel) -> (Void),failed:@escaping (String) -> (Void)) -> Void {
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {(asdq)->(Void)in
                NetWorkRequest(.queryCarUpdateTask(vin: vin, uDate: uDate, taskcarId: taskcarId), completion: {(jsonString)->(Void)in
                    if let mappedObject = JSONDeserializer<BaseResponse<CurrentVehicleTaskModel>>.deserializeFrom(json: jsonString) {
                        // 从字符串转换为对象实例
                        success(mappedObject.body)
                        
                    }
                }, failed: {(failedCallback)->(Void)in
                    failed(failedCallback)
                    
                })
                
            })
        } else {
            print("版本过低")
            
        }
    }
    
    /// 确认升级任务
    ///
    /// - Parameters:
    ///   - taskcarId: 车辆升级任务id
    ///   - uDate: 日期时间
    ///   - type: 确认类型
    ///   - result: 确认结果
    public func confirmUpdate(taskcarId:String,uDate:String,type:Int,result:Int,success:@escaping (UpdateConfirInterfaceModel) -> (Void),failed:@escaping (String) -> (Void)) -> Void {
        NetWorkRequest(.confirmUpgrade(taskcarId: taskcarId, uDate: uDate, type: type, result: result), completion: {(jsonString)->(Void)in
            if let mappedObject = JSONDeserializer<BaseResponse<UpdateConfirInterfaceModel>>.deserializeFrom(json: jsonString) {
                // 从字符串转换为对象实例
                success(mappedObject.body)
            }
            
        }, failed: {(failedCallback)->(Void)in
            failed(failedCallback)
        })
        
    }
    
    
    /// 清除定时任务
    public func clearTask() -> Void {
        timer.invalidate()
    }
    
    
    
}
