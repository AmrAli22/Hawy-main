//
//  PopularQuestionsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/10/2022.
//

import UIKit
import Alamofire

class PopularQuestionsViewController: BaseViewViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var questionsTable: UITableView!
    
    var questions = [PopularQuestionsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsTable.delegate = self
        questionsTable.dataSource = self
        questionsTable.separatorStyle = .none
        questionsTable.rowHeight = 50
        questionsTable.estimatedRowHeight = UITableView.automaticDimension
        getQuestions()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getQuestions() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/faq", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(PopularQuestionsModel.self, from: response.data!)
                
                if productResponse.message == "Unauthenticated." {
                    
                    let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                        
                        
                        let story = UIStoryboard(name: "Authentication", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }
                    //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    //alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.questions = productResponse.item ?? []
                    self.questionsTable.reloadData()
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}

extension PopularQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return questions.count
        
        if questions[section].expand ?? false {
            return 2
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = questionsTable.dequeueReusableCell(withIdentifier: "PopularQuestionsTableViewCelll", for: indexPath) as? PopularQuestionsTableViewCell else { return UITableViewCell() }
            
            let item = questions[indexPath.section]
            
            cell.questionLabel.text = item.name ?? ""
            //cell.answerLabel.text = item.answer ?? ""
            
            if item.expand == true {
                cell.MPLabel.text = "-"
            }else {
                cell.MPLabel.text = "+"
            }
            
            return cell
            
        }else {
            guard let cell = questionsTable.dequeueReusableCell(withIdentifier: "PopularQuestionsTableViewCell", for: indexPath) as? PopularQuestionsTableViewCell else { return UITableViewCell() }
            
            let item = questions[indexPath.section]
            
            cell.questionLabel.text = item.answer ?? ""
            //cell.answerLabel.text = item.answer ?? ""
            
            return cell
        }
        
//        guard let cell = questionsTable.dequeueReusableCell(withIdentifier: "PopularQuestionsTableViewCell", for: indexPath) as? PopularQuestionsTableViewCell else { return UITableViewCell() }
//
//        let item = questions[indexPath.row]
//
//        cell.questionLabel.text = item.name ?? ""
//        cell.answerLabel.text = item.answer ?? ""
//
//        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let isExpand = (questions[indexPath.section].expand ?? false)
            questions[indexPath.section].expand = !isExpand
            
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
            
        }else {
            
            
            
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
