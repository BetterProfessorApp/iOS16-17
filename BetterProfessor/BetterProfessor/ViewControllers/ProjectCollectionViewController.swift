//
//  ProjectCollectionViewController.swift
//  BetterProfessor
//
//  Created by Hunter Oppel on 6/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class ProjectCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "ProjectCell"

    private var studentName: String?
    private var projects = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func updateViews() {
        collectionView.reloadData()
    }

    private func fetchProjects() {
        guard let studentName = studentName else { return }

        BackendController.shared.fetchAllProjects { projects, error in
            if let error = error {
                NSLog("Failed to fetch projects with error: \(error)")
                return
            }

            guard let projects = projects else {
                NSLog("No projects found")
                return
            }

            // We only want to display projects associated with the particular student so I filter it here
            for project in projects {
                if project.studentName == studentName {
                    self.projects.append(project)
                }
            }

            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return projects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProjectCollectionViewCell else { fatalError() }

        cell.project = projects[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
