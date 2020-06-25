//
//  ProjectCollectionViewCell.swift
//  BetterProfessor
//
//  Created by Hunter Oppel on 6/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell {
    var project: Project? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet var projectNameLabel: UILabel!
    @IBOutlet var projectTypeLabel: UILabel!
    @IBOutlet var completedButton: UIButton!

    private func updateViews() {
        guard let project = project else { return }

        projectNameLabel.text = project.projectName
        projectTypeLabel.text = project.projectType

        switch project.completed {
        case true:
            completedButton.isSelected = true
        case false:
            completedButton.isSelected = false
        }
    }
}
