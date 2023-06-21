//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Furkan on 21.06.2023.
//

import Foundation
import UIKit
import CoreData


class DataPersistenceManager {
    
    
    enum DatabaseError : Error {
        case failedToSaveData
        case failedtoFetchData
        case failedDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func donwloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        
        do{
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) ->Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        }catch {
            completion(.failure(DatabaseError.failedtoFetchData))
        }
    }
    
    func deletetitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // asking the database manager to delete certain object
        
        do {
            try context.save()
            completion(.success(()))
        } catch{
                completion(.failure(DatabaseError.failedDeleteData))
        }
    }
}
