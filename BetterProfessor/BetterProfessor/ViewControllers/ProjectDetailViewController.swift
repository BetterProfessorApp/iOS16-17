//
//  ProjectDetailViewController.swift
//  BetterProfessor
//
//  Created by Hunter Oppel on 6/25/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {

    @IBOutlet var projectNameTextField: UITextField!
    @IBOutlet var projectTypeTextField: UITextField!
    @IBOutlet var completedButton: UIButton!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!

    var project: Project?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = project {
            self.updateViews()
        }
    }

    private func updateViews() {
        guard let project = project else { return }

        projectNameTextField.text = project.projectName
        projectTypeTextField.text = project.projectType
        dueDatePicker.date = project.dueDate
        notesTextView.text = project.description

        switch project.completed {
        case true:
            completedButton.isSelected = true
        case false:
            completedButton.isSelected = false
        }
    }
}
