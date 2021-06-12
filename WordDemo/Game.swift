//
//  Game.swift
//  WordDemo
//
//  Created by anshul shah on 12/06/21.
//

import Foundation

class GameManager: NSObject{
    
    static var shared: GameManager = GameManager()
    var levelQueue: [Level] = []
    var selectedLevel:  Level?
    
    var score: Int = 0
    
    override init() {
        super.init()
        self.levelQueue = (loadJson() ?? [])
    }
    
    func loadJson() -> [Level]? {
        if let url = Bundle.main.url(forResource: "logo", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try? decoder.decode([Level].self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func getNextLevel() -> Level?{
        if levelQueue.count > 0{
            self.selectedLevel = levelQueue.first
            levelQueue.removeFirst()
            return self.selectedLevel
        }
        return nil
    }
}



