//
//  SerialTaskQueue.swift
//  Chatty
//
//  Created by zuber on 2018/10/18.
//  Copyright © 2018年 zuber. All rights reserved.
//

import Foundation

public typealias TaskClosure = (_ completion: @escaping () -> Void) -> Void

public protocol SerialTaskQueueProtocol {
  func addTask(_ task: @escaping TaskClosure)
  func start()
  func stop()
  func flushQueue()
  var isEmpty: Bool { get }
  var isStopped: Bool { get }
}

public final class SerialTaskQueue: SerialTaskQueueProtocol {
  public private(set) var isBusy = false
  public private(set) var isStopped = true
  
  private var tasksQueue = [TaskClosure]()
  
  public init() {}
  
  public func addTask(_ task: @escaping TaskClosure) {
    self.tasksQueue.append(task)
    self.maybeExecuteNextTask()
  }
  
  public func start() {
    self.isStopped = false
    self.maybeExecuteNextTask()
  }
  
  public func stop() {
    self.isStopped = true
  }
  
  public func flushQueue() {
    self.tasksQueue.removeAll()
  }
  
  public var isEmpty: Bool {
    return self.tasksQueue.isEmpty
  }
  
  private func maybeExecuteNextTask() {
    if !self.isStopped && !self.isBusy {
      if !self.isEmpty {
        let firstTask = self.tasksQueue.removeFirst()
        self.isBusy = true
        firstTask({ [weak self] () -> Void in
          self?.isBusy = false
          self?.maybeExecuteNextTask()
        })
      }
    }
  }
}
