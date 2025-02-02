//
//  IntroViewController.swift
//  Cosmostation
//
//  Created by yongjoo on 25/03/2019.
//  Copyright © 2019 wannabit. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class IntroViewController: BaseViewController, PasswordViewDelegate, SBCardPopupDelegate {

    @IBOutlet weak var bottomLogoView: UIView!
    @IBOutlet weak var bottomControlView: UIView!
    
    var accounts:Array<Account>?
    var lockPasses = false;
    var toAddChain: ChainType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lockPasses = false;
        accounts = BaseData.instance.selectAllAccounts()
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                BaseData.instance.setFCMToken(token)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.topItem?.title = "";
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //update okex chain
        BaseData.instance.upgradeAaccountAddressforOk()
        onCheckPassWordState()
////        //check for keyway udpate
//        if (BaseData.instance.onCheckKeyWayUpdated() == false) {
//            onCheckPassWordState()
//        } else {
//            onKeyWayUpdate()
//        }
    }
    
//    func onKeyWayUpdate() {
//        DispatchQueue.main.async(execute: {
//            let dbAlert = UIAlertController(title: "DB Upgrading", message: " ", preferredStyle: .alert)
//            self.present(dbAlert, animated: true, completion: nil)
//            
//            let allAccounts = BaseData.instance.selectAllAccounts()
//            var progress = 0
//            dbAlert.message = "\nplease wait\n\n1/" + String(allAccounts.count)
//            DispatchQueue.global(qos: .background).async(execute: {
//                for account in allAccounts {
//                    BaseData.instance.upgradeKeyWay2(account)
//                    progress += 1
//                    DispatchQueue.main.async(flags: .barrier, execute: {
//                        dbAlert.message = "\nplease wait\n\n" + String(progress) + "/" + String(allAccounts.count)
//                    })
//                }
//                DispatchQueue.main.async(execute: {
//                    dbAlert.dismiss(animated: true, completion: nil);
//                    self.onCheckPassWordState()
//                })
//            })
//        })
//    }
    
    func onCheckPassWordState() {
        if (BaseData.instance.getUsingAppLock() == true && BaseData.instance.hasPassword() && !lockPasses) {
            let passwordVC = UIStoryboard(name: "Password", bundle: nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
            self.navigationItem.title = ""
            self.navigationController!.view.layer.add(WUtils.getPasswordAni(), forKey: kCATransition)
            passwordVC.mTarget = PASSWORD_ACTION_INTRO_LOCK
            passwordVC.resultDelegate = self
            self.navigationController?.pushViewController(passwordVC, animated: false)
            
        } else {
            self.onCheckAppVersion()
        }
    }
    
    func onStartInitJob() {
        if (accounts!.count <= 0) {
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                self.bottomLogoView.alpha = 0.0
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                    self.bottomControlView.alpha = 1.0
                }, completion: nil)
            })
            
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if (appDelegate.userInfo != nil) {
                if let userInfo = appDelegate.userInfo,
                    let notifyto = userInfo["notifyto"] as? String {
                    appDelegate.userInfo = nil
                    let notiAccount = BaseData.instance.selectAccountByAddress(address: notifyto)
                    if (notiAccount != nil) {
                        BaseData.instance.setRecentAccountId(notiAccount!.account_id)
                        BaseData.instance.setLastTab(2)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.onStartMainTab()
                        }
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.onStartMainTab()
                }
            }
        }
    }
    
    
    @IBAction func onClickCreate(_ sender: Any) {
        self.onShowSelectChainDialog(true)
    }
    
    override func onChainSelected(_ chainType: ChainType) {
        self.toAddChain = chainType
        let popupVC = NewAccountTypePopup(nibName: "NewAccountTypePopup", bundle: nil)
        let cardPopup = SBCardPopupViewController(contentViewController: popupVC)
        cardPopup.resultDelegate = self
        cardPopup.show(onViewController: self)
    }
    
    func passwordResponse(result: Int) {
        if (result == PASSWORD_RESUKT_OK) {
            self.lockPasses = true
        }
    }
    
    func SBCardPopupResponse(type: Int, result: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(490), execute: {
            var tagetVC:BaseViewController?
            if (result == 1) {
                tagetVC = UIStoryboard(name: "Init", bundle: nil).instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
                tagetVC?.chainType = self.toAddChain!
                
            } else if (result == 2) {
                tagetVC = UIStoryboard(name: "Init", bundle: nil).instantiateViewController(withIdentifier: "RestoreViewController") as! RestoreViewController
                tagetVC?.chainType = self.toAddChain!
                
            } else if (result == 3) {
                tagetVC = UIStoryboard(name: "Init", bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
                
            } else if (result == 4) {
                tagetVC = UIStoryboard(name: "Init", bundle: nil).instantiateViewController(withIdentifier: "KeyRestoreViewController") as! KeyRestoreViewController
                tagetVC?.chainType = self.toAddChain!
                
            }
            if (tagetVC != nil) {
                tagetVC?.hidesBottomBarWhenPushed = true
                self.navigationItem.title = ""
                self.navigationController?.pushViewController(tagetVC!, animated: true)
            }
        })
    }
    
    func onCheckAppVersion() {
        let request = Alamofire.request(CSS_VERSION, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]);
        request.responseJSON { (response) in
            switch response.result {
            case .success(let res):
                guard let responseData = res as? NSDictionary else {
                    self.onShowNetworkAlert()
                    return
                }
                
                let enable = responseData.object(forKey: "enable") as? Bool ?? false
                let latestVersion = responseData.object(forKey: "version") as? Int ?? 0
                let appVersion = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0") ?? 0
                
                if (!enable) {
                    self.onShowDisableAlert()
                } else {
                    if (latestVersion > appVersion) {
                        self.onShowUpdateAlert()
                    } else {
                        self.onStartInitJob()
                    }
                }
                
            case .failure(let error):
                print("onCheckAppVersion ", error)
                self.onShowNetworkAlert()
            }
        }
        
    }
    
    func onShowNetworkAlert() {
        let netAlert = UIAlertController(title: NSLocalizedString("error_network", comment: ""), message: NSLocalizedString("error_network_msg", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("retry", comment: ""), style: .default, handler: { (UIAlertAction) in
            self.onCheckAppVersion()
        })
        netAlert.addAction(action)
        self.present(netAlert, animated: true, completion: nil)
    }
    
    func onShowDisableAlert() {
        let disableAlert = UIAlertController(title: NSLocalizedString("error_disable", comment: ""), message: NSLocalizedString("error_disable_msg", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .default, handler: { (UIAlertAction) in
            exit(-1)
        })
        disableAlert.addAction(action)
        self.present(disableAlert, animated: true, completion: nil)
    }
    
    func onShowUpdateAlert() {
        let updateAlert = UIAlertController(title: NSLocalizedString("update_title", comment: ""), message: NSLocalizedString("update_msg", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("go_appstore", comment: ""), style: .default, handler: { (UIAlertAction) in
            let urlAppStore = URL(string: "itms-apps://itunes.apple.com/app/id1459830339")
            if(UIApplication.shared.canOpenURL(urlAppStore!)) {
                UIApplication.shared.open(urlAppStore!, options: [:], completionHandler: nil)
            }
        })
        updateAlert.addAction(action)
        self.present(updateAlert, animated: true, completion: nil)
    }
    
}
