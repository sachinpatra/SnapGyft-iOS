//
//  CardDetailTableController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/23/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import expanding_collection
import Alertift
import KRProgressHUD

class CardDetailTableController: ExpandingTableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    private lazy var qrcodeSection: SectionFormer = {
        var qrCodeRow: LabelRowFormer<CardDetailQRCodeCell> = {
            LabelRowFormer<CardDetailQRCodeCell>(instantiateType: .Nib(nibName: "CardDetailQRCodeCell")) {
                let inputString = "This is SnapGyft Member App"
                let base64EncodedString = inputString.base64Encoded()
                print("sachin Encoded = \(base64EncodedString!)")
                let qrcode = DCQRCode(info: base64EncodedString!, size: CGSize(width: 300, height: 300))
                qrcode.positionOuterColor = UIColor.formerSubColor()
                let image = qrcode.image()
                $0.qrcodeImageView.image = image
                KRProgressHUD.dismiss()
                
                }.configure {
                    $0.rowHeight = 270
            }
        }()
        return SectionFormer(rowFormer: qrCodeRow)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Amazon"
        self.navigationItem.setHidesBackButton(true, animated: false)

       
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Custom Methods
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    private func configureForm() {
        let redeemRow = LabelRowFormer<CenterLabelCell>()
            .configure {
                $0.text = "Redeem"
            }.onSelected(onRedeemBtnSelected)
        let createSpaceHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>() {
                $0.contentView.backgroundColor = .clear
                }.configure {
                    $0.viewHeight = 30
            }
        }
        
        let registerSection = SectionFormer(rowFormer: redeemRow)
            .set(headerViewFormer: createSpaceHeader())
        
        former.append(sectionFormer: registerSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
    }
    
    
    // MARK: Actions
    private func onRedeemBtnSelected(rowFormer: RowFormer) {
        rowFormer.former?.deselect(animated: true)
        
        Alertift.alert(title: "SnapGyft", message: "Are you sure!! You want redeem")
            .action(.cancel("Cancel"))
            .action(.default("OK")) { _ in
                KRProgressHUD.show(withMessage: nil) {
                    self.former.insertUpdate(sectionFormer: self.qrcodeSection, toSection: self.former.numberOfSections, rowAnimation: .top)
                    //Start Animate to show badge
                    let qrCodeCell =  self.qrcodeSection.firstRowFormer?.cellInstance as! CardDetailQRCodeCell
                    let imageViewPosition : CGPoint = qrCodeCell.qrcodeImageView.convert(qrCodeCell.qrcodeImageView.bounds.origin, to: self.view)
                    let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: qrCodeCell.qrcodeImageView.frame.size.width, height: qrCodeCell.qrcodeImageView.frame.size.height))
                    imgViewTemp.image = qrCodeCell.qrcodeImageView.image
                    self.animation(tempView: imgViewTemp)

                }
            }.show()
    }
    
    
    func animation(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 1.0,
                       animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
                tempView.frame.origin.x = (self.tabBarController?.tabBar.frame.origin.x)! + 320
                tempView.frame.origin.y = (self.tabBarController?.tabBar.frame.origin.y)!
                
            }, completion: { _ in
                tempView.removeFromSuperview()
                if let item = self.tabBarController?.tabBar.items?[3] {
                    item.badgeValue = "1"
                }
            })
        })
    }
    
    @IBAction func backButtonHandler(_ sender: AnyObject) {
        popTransitionAnimation()
    }

}

// MARK: UIScrollViewDelegate
extension CardDetailTableController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}

