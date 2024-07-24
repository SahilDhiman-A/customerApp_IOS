//
//  FaqViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/14/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var selectedRowIndex = -1
    @IBOutlet weak var faqTableView: UITableView!
    
    
    //MARK: B2C User Questions
    private let homeFaqQuestions = [faqHomeQuestion.ques1, faqHomeQuestion.ques2, faqHomeQuestion.ques3, faqHomeQuestion.ques4, faqHomeQuestion.ques5, faqHomeQuestion.ques6, faqHomeQuestion.ques7,faqHomeQuestion.ques8, faqHomeQuestion.ques9, faqHomeQuestion.ques10, faqHomeQuestion.ques11, faqHomeQuestion.ques12, faqHomeQuestion.ques13, faqHomeQuestion.ques14, faqHomeQuestion.ques15, faqHomeQuestion.ques16, faqHomeQuestion.ques17,faqHomeQuestion.ques18, faqHomeQuestion.ques19, faqHomeQuestion.ques20, faqHomeQuestion.ques21, faqHomeQuestion.ques22, faqHomeQuestion.ques23, faqHomeQuestion.ques24,faqHomeQuestion.ques25, faqHomeQuestion.ques26, faqHomeQuestion.ques27, faqHomeQuestion.ques28, faqHomeQuestion.ques29, faqHomeQuestion.ques30, faqHomeQuestion.ques31,faqHomeQuestion.ques32, faqHomeQuestion.ques33, faqHomeQuestion.ques34, faqHomeQuestion.ques35, faqHomeQuestion.ques36, faqHomeQuestion.ques37, faqHomeQuestion.ques38, faqHomeQuestion.ques39, faqHomeQuestion.ques40, faqHomeQuestion.ques41,faqHomeQuestion.ques42, faqHomeQuestion.ques43, faqHomeQuestion.ques44, faqHomeQuestion.ques45, faqHomeQuestion.ques46, faqHomeQuestion.ques47, faqHomeQuestion.ques48, faqHomeQuestion.ques49, faqHomeQuestion.ques50, faqHomeQuestion.ques51, faqHomeQuestion.ques52]
  
    //MARK: B2C User Answer
    private let homeFaqAnswer = [faqHomeAnswer.ans1, faqHomeAnswer.ans2, faqHomeAnswer.ans3, faqHomeAnswer.ans4, faqHomeAnswer.ans5, faqHomeAnswer.ans6, faqHomeAnswer.ans7,faqHomeAnswer.ans8, faqHomeAnswer.ans9, faqHomeAnswer.ans10, faqHomeAnswer.ans11, faqHomeAnswer.ans12, faqHomeAnswer.ans13, faqHomeAnswer.ans14, faqHomeAnswer.ans15, faqHomeAnswer.ans16, faqHomeAnswer.ans17,faqHomeAnswer.ans18, faqHomeAnswer.ans19, faqHomeAnswer.ans20, faqHomeAnswer.ans21, faqHomeAnswer.ans22, faqHomeAnswer.ans23, faqHomeAnswer.ans24,faqHomeAnswer.ans25, faqHomeAnswer.ans26, faqHomeAnswer.ans27, faqHomeAnswer.ans28, faqHomeAnswer.ans29, faqHomeAnswer.ans30, faqHomeAnswer.ans31,faqHomeAnswer.ans32, faqHomeAnswer.ans33, faqHomeAnswer.ans34, faqHomeAnswer.ans35, faqHomeAnswer.ans36, faqHomeAnswer.ans37, faqHomeAnswer.ans38, faqHomeAnswer.ans39, faqHomeAnswer.ans40, faqHomeAnswer.ans41,faqHomeAnswer.ans42, faqHomeAnswer.ans43, faqHomeAnswer.ans44, faqHomeAnswer.ans45, faqHomeAnswer.ans46, faqHomeAnswer.ans47, faqHomeAnswer.ans48, faqHomeAnswer.ans49, faqHomeAnswer.ans50, faqHomeAnswer.ans51, faqHomeAnswer.ans52]
    
    //MARK: B2B User Questions
    private let businessFaqQuestions = [faqBusinessQuestion.ques1, faqBusinessQuestion.ques2, faqBusinessQuestion.ques3, faqBusinessQuestion.ques4, faqBusinessQuestion.ques5, faqBusinessQuestion.ques6, faqBusinessQuestion.ques7,faqBusinessQuestion.ques8, faqBusinessQuestion.ques9, faqBusinessQuestion.ques10, faqBusinessQuestion.ques11, faqBusinessQuestion.ques12, faqBusinessQuestion.ques13, faqBusinessQuestion.ques14, faqBusinessQuestion.ques15, faqBusinessQuestion.ques16, faqBusinessQuestion.ques17,faqBusinessQuestion.ques18, faqBusinessQuestion.ques19, faqBusinessQuestion.ques20, faqBusinessQuestion.ques21, faqBusinessQuestion.ques22, faqBusinessQuestion.ques23, faqBusinessQuestion.ques24,faqBusinessQuestion.ques25]
      
        //MARK: B2B User Answer
       private let businessFaqAnswer = [faqBusinessAnswer.ans1, faqBusinessAnswer.ans2, faqBusinessAnswer.ans3, faqBusinessAnswer.ans4, faqBusinessAnswer.ans5, faqBusinessAnswer.ans6, faqBusinessAnswer.ans7,faqBusinessAnswer.ans8, faqBusinessAnswer.ans9, faqBusinessAnswer.ans10, faqBusinessAnswer.ans11, faqBusinessAnswer.ans12, faqBusinessAnswer.ans13, faqBusinessAnswer.ans14, faqBusinessAnswer.ans15, faqBusinessAnswer.ans16, faqBusinessAnswer.ans17,faqBusinessAnswer.ans18, faqBusinessAnswer.ans19, faqBusinessAnswer.ans20, faqBusinessAnswer.ans21, faqBusinessAnswer.ans22, faqBusinessAnswer.ans23, faqBusinessAnswer.ans24,faqBusinessAnswer.ans25]
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: TableView delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if AppDelegate.sharedInstance.segmentType==segment.userB2C
         {
            return homeFaqQuestions.count
         }
         else
         {
            return businessFaqQuestions.count
         }
            return homeFaqQuestions.count
        }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          var cell : FaqTableViewCell? = (faqTableView.dequeueReusableCell(withIdentifier: TableViewCellName.faqTableViewCell) as! FaqTableViewCell)
          
          if cell == nil {
              cell = FaqTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.faqTableViewCell)
          }
        
        // use for B2C List
        if AppDelegate.sharedInstance.segmentType==segment.userB2C
        {
            cell!.faqQues.text = homeFaqQuestions[indexPath.row]
            cell?.faqImg.image = UIImage(named: "canarrow")
            cell!.faqAns.text = ""
            if selectedRowIndex == indexPath.row
            {
                cell?.faqImg.image = UIImage(named: "uparrow")
                cell!.faqAns.text = homeFaqAnswer[indexPath.row]
            }
        }
        else
        {
            // use for B2B List
            cell!.faqQues.text = businessFaqQuestions[indexPath.row]
            cell?.faqImg.image = UIImage(named: "canarrow")
            cell!.faqAns.text = ""
            if selectedRowIndex == indexPath.row
             {
               cell?.faqImg.image = UIImage(named: "uparrow")
               cell!.faqAns.text = businessFaqAnswer[indexPath.row]
             }
        }
          return cell!
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedRowIndex == -1 {
               // open new row
               selectedRowIndex = indexPath.row
               tableView.reloadRows(at: [indexPath], with: .automatic)
           } else {
               // close already opened row
               let previousOpenedRow = selectedRowIndex
               selectedRowIndex = -1
               tableView.reloadRows(at: [IndexPath(row: previousOpenedRow, section: 0)], with: .automatic)
               
               // open new row
                if (previousOpenedRow != selectedRowIndex && previousOpenedRow != indexPath.row)
                {
                    selectedRowIndex = indexPath.row
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
           }
      }

      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if indexPath.row == selectedRowIndex
          {
              return UITableView.automaticDimension
          }
          return UITableView.automaticDimension
      }
    
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
}
