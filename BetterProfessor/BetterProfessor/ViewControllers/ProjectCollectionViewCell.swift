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

        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
