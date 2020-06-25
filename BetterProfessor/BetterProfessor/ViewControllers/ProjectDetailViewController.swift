//
//  ProjectDetailViewController.swift
//  BetterProfessor
//
//  Created by Hunter Oppel on 6/25/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

protocol ProjectDetailDelegate {
    func didCreateProject() -> Void
}

class ProjectDetailViewController: UIViewController {

    @IBOutlet var projectNameTextField: UITextField!
    @IBOutlet var projectTypeTextField: UITextField!
    @IBOutlet var completedButton: UIButton!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!

    var project: Project?
    var student: Student?
    var delegate: ProjectDetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if project != nil {
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

    @IBAction func toggleCompleteState(_ sender: Any) {
        completedButton.isSelected.toggle()
    }

    @IBAction func saveProject(_ sender: Any) {
        guard let projectName = projectNameTextField.text,
            !projectName.isEmpty,
            let projectType = projectTypeTextField.text,
            !projectType.isEmpty,
            let notes = notesTextView.text,
            let student = student else { return }

        if let project = project {
            updateProject(project: project, projectName: projectName, projectType: projectType, notes: notes, student: student)
        } else {
            createProject(projectName: projectName, projectType: projectType, notes: notes, student: student)
        }
    }

    private func createProject(projectName: String, projectType: String, notes: String, student: Student) {
        // swiftlint:disable:next all
        BackendController.shared.createProject(name: projectName, studentID: "\(student.id)", projectType: projectType, dueDate: dueDatePicker.date, description: notes, completed: completedButton.isSelected) { result, error in
            if let error = error {
                NSLog("Failed to create project with error: \(error)")
                return
            }

            if result {
                NSLog("Successfully created project 🙌")
            }

            DispatchQueue.main.async {
                self.delegate?.didCreateProject()
            }
        }

        navigationController?.popViewController(animated: true)
    }

    private func updateProject(project: Project, projectName: String, projectType: String, notes: String, student: Student) {
        // swiftlint:disable:next all
        BackendController.shared.updateProject(project: project, name: projectName, studentID: "\(student.id)", projectType: projectType, dueDate: dueDatePicker.date, description: notes, completed: completedButton.isSelected) { result, error in
            if let error = error {
                NSLog("Failed to update project with error: \(error)")
                return
            }

            if result {
                NSLog("Successfully updated project 🙌")
            }

            DispatchQueue.main.async {
                self.delegate?.didCreateProject()
            }
        }

        navigationController?.popViewController(animated: true)
    }
}

