//
//  ViewController.swift
//  Class4
//
//  Created by 이용준 on 2022/05/08.
//

import UIKit

class ViewController: UIViewController {
    var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 120),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 80)
        
        ])
        view.backgroundColor = .systemBackground
        request()
    }
    
    func request() {
        
        // URLSessionConfiguration 생성 (세 가지 존재): .default / .ephemeral / .background
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // URLComponents를 생성하여 query 설정
        var urlComponents = URLComponents(string: "https://geek-jokes.sameerkumar.website/api?format=json")

        // URLComponents와 URLSession을 이용하여 URLSessionDataTask 생성
        guard let requestURL = urlComponents?.url else { return }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in

            // error가 존재하면 종료
            guard error == nil else { return }

            // status 코드가 200번대여야 성공적인 네트워크라 판단
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else { return }

            // response 데이터 획득, utf8인코딩을 통해 string형태로 변환
            guard let resultData = data else { return }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(SomeResponse.self, from: resultData)
                    print(6262, response)
                    self.label.text = response.joke
                } catch {
                    print(646464, error)
                }
            }
            

            
//            let resultString = String(data: resultData, encoding: .utf8)
//            print(resultData)
//            print(resultString)
        }

        // network 통신 실행
        dataTask.resume()
        
    }
}


class SomeResponse: Decodable {
    var joke: String
    enum CodingKeys: String, CodingKey {
        case joke
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.joke = try container.decode(String.self, forKey: .joke)

    }
}
