//
//  MovieService.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import Foundation
import Alamofire
import Kingfisher

protocol MovieService {
    
    func getNowPlaying(page : Int, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void)
   
    func getPopular(page : Int, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void)
    func getTopRated(page : Int, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void)
    func getUpcoming(page : Int, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void)
    
    func getMovieDetail(movieId : Int, onCompletion : @escaping (MovieDetail?, LocalizedError?)->Void)
    
    func getLatest()
    
    func getMovieBackdrop(imageUrl : String, onCompletion : @escaping (UIImage?, LocalizedError?)->Void)
    func getMoviePoster(imageUrl : String, onCompletion : @escaping (UIImage?, LocalizedError?)->Void)
    
    func getGenreList(onCompletion : @escaping (GetMovieGenresResponse?, LocalizedError?)->Void)
    
    func genreIdToString(genreId : Int)->String?
    
    func searchMovie(keyword : String, page : Int, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void)
}

class MovieServiceApi  : MovieService {
    
    private var genreDictionary = [Int : String]()
    private var isGenreReady : Bool = false
    
    weak var coordinator : Coordinator?
    
    init(){
        getGenreList { [unowned self] (response, err) in
            if let error = err {
                self.coordinator?.showDialog(title: "Terjadi Kesalahan", message: error.localizedDescription)
            } else {
                response?.genres.forEach({ [weak self] (genre) in
                    self?.genreDictionary[genre.id] = genre.name
                })
                isGenreReady = true
            }
        }
    }
    deinit {
        print("Movie Service Deinit")
    }
    
    func searchMovie(keyword: String, page : Int, onCompletion: @escaping (GetMovieResponse?, LocalizedError?) -> Void) {
        let url = ConstantsConfig.BASE_URL + "search/movie"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY,
            "query" : keyword,
            "page" : page
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseData { (response) in
            let data = NetworkManager.decode(data: response.data, modelType: GetMovieResponse.self) as? GetMovieResponse
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func genreIdToString(genreId : Int)->String?{
        if isGenreReady {
            return genreDictionary[genreId]
        } else{
            return nil
        }
    }
    
    func getMovieDetail(movieId: Int, onCompletion: @escaping (MovieDetail?, LocalizedError?) -> Void) {
        let url = ConstantsConfig.BASE_URL + "movie/\(movieId)"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseData { (response) in
            let data = NetworkManager.decode(data: response.data, modelType: MovieDetail.self) as? MovieDetail
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func getGenreList(onCompletion: @escaping (GetMovieGenresResponse?, LocalizedError?) -> Void) {
        let url = ConstantsConfig.BASE_URL + "genre/movie/list"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseData { (response) in
            let data = NetworkManager.decode(data: response.data, modelType: GetMovieGenresResponse.self) as? GetMovieGenresResponse
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func getTopRated(page : Int = 1, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void) {
        let url = ConstantsConfig.BASE_URL + "movie/top_rated"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY,
            "page" : page,
            "region" : ConstantsConfig.REGION
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding:URLEncoding.default).responseData { response in
            
            let data = NetworkManager.decode(data: response.data, modelType: GetMovieResponse.self) as? GetMovieResponse
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func getUpcoming(page : Int = 1, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void) {
        let url = ConstantsConfig.BASE_URL + "movie/upcoming"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY,
            "page" : page,
            "region" : ConstantsConfig.REGION
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding:URLEncoding.default).responseData { response in
            
            let data = NetworkManager.decode(data: response.data, modelType: GetMovieResponse.self) as? GetMovieResponse
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func getLatest() {
        //
    }
    
    func getPopular(page : Int = 1, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void) {
        let url = ConstantsConfig.BASE_URL + "movie/popular"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY,
            "page" : page,
            "region" : ConstantsConfig.REGION
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding:URLEncoding.default).responseData { response in
            
            let data = NetworkManager.decode(data: response.data, modelType: GetMovieResponse.self) as? GetMovieResponse
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func getNowPlaying(page : Int = 1, onCompletion : @escaping (GetMovieResponse?, LocalizedError?)->Void){
        
        let url = ConstantsConfig.BASE_URL + "movie/now_playing"
        
        let params : [String:Any] = [
            "api_key" : ConstantsConfig.API_KEY,
            "page" : page,
            "region" : ConstantsConfig.REGION
        ]
        
        NetworkManager.shared.session.request(url, method: .get, parameters: params, encoding:URLEncoding.default).responseData { response in
            
            let data = NetworkManager.decode(data: response.data, modelType: GetMovieResponse.self) as? GetMovieResponse
            
            guard let theData = data else {
                let errResponse = NetworkManager.decode(data:response.data, modelType: ErrorResponse.self) as! ErrorResponse
                onCompletion(nil, GeneralError.errorWithMessage(message: errResponse.status_message))
                return
            }
            
            onCompletion(theData, nil)
        }
    }
    
    func getMovieBackdrop(imageUrl : String, onCompletion : @escaping (UIImage?, LocalizedError?)->Void){
        let url = ConstantsConfig.IMAGE_BASE_URL + ConstantsConfig.IMAGE_BACKDROP_SIZE + imageUrl
        
        let resource = ImageResource(downloadURL: URL.init(string: url)!)
        
        KingfisherManager.shared.retrieveImage(with: resource) { (result) in
            switch result {
            case.success(let value):
                onCompletion(value.image, nil)
                break
            case.failure(let error):
                onCompletion(nil, GeneralError.errorWithMessage(message: error.localizedDescription))
                break
            }
        }
    }
    
    func getMoviePoster(imageUrl : String, onCompletion : @escaping (UIImage?, LocalizedError?)->Void){
        let url = ConstantsConfig.IMAGE_BASE_URL + ConstantsConfig.IMAGE_POSTER_SIZE + imageUrl
        
        let resource = ImageResource(downloadURL: URL.init(string: url)!)
        
        KingfisherManager.shared.retrieveImage(with: resource) { (result) in
            switch result {
            case.success(let value):
                onCompletion(value.image, nil)
                break
            case.failure(let error):
                onCompletion(nil, GeneralError.errorWithMessage(message: error.localizedDescription))
                break
            }
        }
    }
    
}
