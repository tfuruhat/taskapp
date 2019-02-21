//
//  InputViewController.swift
//  taskapp
//
//  Created by ふるふる on 2019/02/18.
//  Copyright © 2019 Tsuyoshi Furuhata. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 背景をタップしたら dissmissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        categoryTextField.text = task.category
        datePicker.date = task.date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write
        {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.category = self.categoryTextField.text!
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissKeyboard()
    {
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    //タスクのローカル通知を登録
    func setNotification(task: Task)
    {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定（中身がない場合メッセージ無しで音だけの通知になるので(xxなし)を表示）
        if task.title == ""
        {
            content.title = "(タイトルなし)"
        }
        else
        {
            content.title = task.title
        }
        if task.contents == ""
        {
            content.body = "(内容なし)"
        }
        else
        {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger(日付マッチ)を作成
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, trigger からローカル通知を作成(identiferが同じだとローカル通知を上書き保存)
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request)
        {
            (error) in print(error ?? "ローカル通知登録 OK")
            // error が nilならローカル通知の登録に成功。errorならプリント文表示
        }
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests
        {
            (requests: [UNNotificationRequest]) in
            for request in requests
            {
                print("/----------")
                print(request)
                print("-----------")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
