//
//  ViewController.swift
//  Class4
//
//  Created by 이용준 on 2022/05/08.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var label = UILabel()
    var snapKitLabel = UILabel()
    
    var chuck: Chuck?
    var cat: Cat?
    
    
    override func viewDidLoad() {
        // view init ->
        //========
        // view did load
        // view will appear
        // view did appear
        
        ///
        // view willl disappear
        // view did disappear
        //=========
        // view did disload
    
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
        setupBySnapkit()
//        request()
//        req()
        catFacts()
        
    }
    
    func setupBySnapkit() {
        view.addSubview(snapKitLabel)
        snapKitLabel.lineBreakMode = .byCharWrapping
        snapKitLabel.numberOfLines = 0
        snapKitLabel.backgroundColor = .blue
        snapKitLabel.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    
    
    
    func catFacts() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var urlcomp = URLComponents(string: "https://cat-fact.herokuapp.com/facts")
        guard let requestURL = urlcomp?.url else {return}
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            
            //error
            guard error == nil else { return }
            
            //status
            
            //data
            guard let resultData = data else { return }
            DispatchQueue.main.async {
                do {
                    
                    let response = try JSONDecoder().decode([Cat].self, from: resultData)
                    //                               print(response.text)
                    self.cat = response[0]
                    self.label.text = response[0].fun
                    self.snapKitLabel.text = response[1].fun
                } catch {
                    print("error \(error)")
                }
            }
        }
        dataTask.resume()
        
    }
    
    func req() {
        //https://api.chucknorris.io/jokes/random
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var urlcomponent = URLComponents(string: "https://api.chucknorris.io/jokes/random")
        guard let requestURL = urlcomponent?.url else { return }
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in

            // error가 존재하면 종료
            guard error == nil else { return }

            // status 코드가 200번대여야 성공적인 네트워크라 판단
//            let successsRange = 200..<300
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successsRange.contains(statusCode) else { return }

            // response 데이터 획득, utf8인코딩을 통해 string형태로 변환
            guard let resultData = data else { return }
//            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Chuck.self, from: resultData)
                    print(response.value)
                    self.chuck = response
                    self.label.text = response.value
                } catch {
                    print("error \(error)")
                }
//            }

            
//            DispatchQueue.main.async {
//                do {
//                    let response = try JSONDecoder().decode(SomeResponse.self, from: resultData)
//                    print(6262, response)
//                    self.label.text = response.joke
//                } catch {
//                    print(646464, error)
//                }
//            }
            
            
        }
        dataTask.resume()
        
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
//            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(SomeResponse.self, from: resultData)
                    print(6262, response)
                    self.label.text = response.joke
                } catch {
                    print(646464, error)
                }
//            }
            
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

class Cat: Decodable {
    var fun: String
    
    enum CodingKeys: String, CodingKey {
        case fun = "text"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.fun = try container.decode(String.self, forKey: .fun)
        
    }
    
}

class Chuck: Decodable {
    var iconURL: String
    var id: String
    var url: String
    var value: String
//    init () {
//        self.iconURL = "
//    }
    
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case id
        case url
        case value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.iconURL = try container.decode(String.self, forKey: .iconUrl)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)
        self.value = try container.decode(String.self, forKey: .value)
        
    }
    
    
}
