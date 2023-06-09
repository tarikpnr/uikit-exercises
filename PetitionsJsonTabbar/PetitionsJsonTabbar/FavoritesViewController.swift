//
//  FavoritesViewController.swift
//  PetitionsJsonTabbar
//
//  Created by Tarık Fatih PINARCI on 11.05.2023.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var favoritePetitions = [Petition]()
  var appTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Favorite petition list"
    setupUI()
  }
  
  func setupUI(){
    view.backgroundColor = .white
    let mainVC = ViewController()
    
    appTableView = {
      let tableView = UITableView()
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.frame = view.bounds
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "petitionCell")
      return tableView
    }()
    
    appTableView.delegate = self
    appTableView.dataSource = self

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(onRightBarButtonItemPressed))

    
    view.addSubview(appTableView)

    performSelector(inBackground: #selector(getPetitionsData), with: nil)


  }

  @objc func getPetitionsData() {
    var finalURLString: String = ""
    if navigationController?.tabBarItem.tag == 0 {
      finalURLString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      finalURLString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }

    if let url = URL(string: finalURLString){
      if let data = try? Data(contentsOf: url){
        self.favoritePetitions =  self.parsePetitionsData(from: data).results
        appTableView.performSelector(onMainThread: #selector(appTableView.reloadData), with: nil, waitUntilDone: false)
      }
    }
  }

  func parsePetitionsData(from data:Data)-> Petitions {
    let decoder = JSONDecoder()
    return try! decoder.decode(Petitions.self, from: data)
  }

  @objc func onRightBarButtonItemPressed() {
    let alertVC = UIAlertController(title: "Information", message: "This data's source is:\n\n \(navigationController?.tabBarItem.tag==0 ?"https://www.hackingwithswift.com/samples/petitions-0.json":" https://www.hackingwithswift.com/samples/petitions-1.json")" , preferredStyle: .alert)

    alertVC.addAction(.init(title: "Ok", style: .default))

    present(alertVC, animated: true)
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoritePetitions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "petitionCell", for: indexPath)
    cell.accessoryType = .disclosureIndicator
    var content = cell.defaultContentConfiguration()
    content.text = favoritePetitions[indexPath.row].title
    content.textProperties.numberOfLines = 1
    content.secondaryText = favoritePetitions[indexPath.row].body
    cell.selectionStyle = .none
    content.secondaryTextProperties.numberOfLines = 2
    cell.contentConfiguration = content
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailVC = DetailViewController()
    detailVC.selectedPetition = favoritePetitions[indexPath.row]
    detailVC.title = favoritePetitions[indexPath.row].title
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
}
