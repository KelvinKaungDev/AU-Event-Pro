import Foundation
import Alamofire

struct EventViewModel {
    static var shared = EventViewModel()
    
    func fetchEvent(completion: @escaping ([Events]) -> ()) {
        guard let url = URL(string: "https://events-au.vercel.app/event/getAll") else { return }
        AF.request(url).responseDecodable(of: EventModel.self) { response in
            switch response.result {
            case .success(let unit):
                completion(unit.message)
            case .failure(let userFetcherror):
                print(userFetcherror.localizedDescription)
            }
        }
    }
    
    func approveEvent(id: String, adminId: String) {
        guard let url = URL(string: "https://events-au.vercel.app/admin/\(adminId)/approveEvent/\(id)") else { return }
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .put, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Response JSON: \(value)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
}
