//
//  StepChangeCheckViewController.swift
//  Cosmostation
//
//  Created by yongjoo on 23/05/2019.
//  Copyright © 2019 wannabit. All rights reserved.
//

import UIKit
import Alamofire
import GRPC
import NIO

class StepChangeCheckViewController: BaseViewController, PasswordViewDelegate {
    

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var rewardAddressChangeFee: UILabel!
    @IBOutlet weak var rewardAddressChangeDenom: UILabel!
    @IBOutlet weak var currentRewardAddress: UILabel!
    @IBOutlet weak var newRewardAddress: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    var pageHolderVC: StepGenTxViewController!
    var mDpDecimal:Int16 = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.account = BaseData.instance.selectAccountById(id: BaseData.instance.getRecentAccountId())
        self.chainType = WUtils.getChainType(account!.account_base_chain)
        self.pageHolderVC = self.parent as? StepGenTxViewController
        WUtils.setDenomTitle(chainType, rewardAddressChangeDenom)
    }
    
    func onUpdateView() {
        mDpDecimal = WUtils.mainDivideDecimal(chainType)
        let feeAmout = WUtils.localeStringToDecimal((pageHolderVC.mFee?.amount[0].amount)!)
        rewardAddressChangeFee.attributedText = WUtils.displayAmount2(feeAmout.stringValue, rewardAddressChangeFee.font, mDpDecimal, mDpDecimal)
        currentRewardAddress.text = pageHolderVC.mCurrentRewardAddress
        newRewardAddress.text = pageHolderVC.mToChangeRewardAddress
        currentRewardAddress.adjustsFontSizeToFitWidth = true
        newRewardAddress.adjustsFontSizeToFitWidth = true
        memoLabel.text = pageHolderVC.mMemo
    }
    
    override func enableUserInteraction() {
        self.onUpdateView()
        self.btnBack.isUserInteractionEnabled = true
        self.btnConfirm.isUserInteractionEnabled = true
    }
    
    @IBAction func onClickBefore(_ sender: UIButton) {
        self.btnBack.isUserInteractionEnabled = false
        self.btnConfirm.isUserInteractionEnabled = false
        pageHolderVC.onBeforePage()
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        let title = NSLocalizedString("reward_address_warnning_title", comment: "")
        let msg1 = NSLocalizedString("reward_address_notice_msg", comment: "")
        let msg2 = NSLocalizedString("reward_address_notice_msg2", comment: "")
        let msg = msg1 + msg2
        let range = (msg as NSString).range(of: msg2)
        let noticeAlert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let attributedMessage: NSMutableAttributedString = NSMutableAttributedString(
            string: msg,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
            ]
        )
        attributedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14.0), range: range)
        attributedMessage.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        noticeAlert.setValue(attributedMessage, forKey: "attributedMessage")
        noticeAlert.addAction(UIAlertAction(title: NSLocalizedString("continue", comment: ""), style: .destructive, handler: { _ in
            self.onShowPasswordCheck()
        }))
        noticeAlert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(noticeAlert, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            noticeAlert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    func onShowPasswordCheck() {
        let passwordVC = UIStoryboard(name: "Password", bundle: nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        self.navigationItem.title = ""
        self.navigationController!.view.layer.add(WUtils.getPasswordAni(), forKey: kCATransition)
        passwordVC.mTarget = PASSWORD_ACTION_CHECK_TX
        passwordVC.resultDelegate = self
        self.navigationController?.pushViewController(passwordVC, animated: false)
    }
    
    func passwordResponse(result: Int) {
        if (result == PASSWORD_RESUKT_OK) {
            if (WUtils.isGRPC(chainType)) {
                self.onFetchgRPCAuth(pageHolderVC.mAccount!)
            } else {
                self.onFetchAccountInfo(pageHolderVC.mAccount!)
            }
        }
    }
    
    func onFetchAccountInfo(_ account: Account) {
        self.showWaittingAlert()
        let request = Alamofire.request(BaseNetWork.accountInfoUrl(chainType, account.account_address), method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
        request.responseJSON { (response) in
            switch response.result {
            case .success(let res):
                guard let responseData = res as? NSDictionary,
                    let info = responseData.object(forKey: "result") as? [String : Any] else {
                        _ = BaseData.instance.deleteBalance(account: account)
                        self.hideWaittingAlert()
                        self.onShowToast(NSLocalizedString("error_network", comment: ""))
                        return
                }
                let accountInfo = AccountInfo.init(info)
                _ = BaseData.instance.updateAccount(WUtils.getAccountWithAccountInfo(account, accountInfo))
                BaseData.instance.updateBalances(account.account_id, WUtils.getBalancesWithAccountInfo(account, accountInfo))
                self.onGenModifyRewardAddressTx()
                
            case .failure( _):
                self.hideWaittingAlert()
                self.onShowToast(NSLocalizedString("error_network", comment: ""))
            }
        }
    }
    
    func onGenModifyRewardAddressTx() {
        DispatchQueue.global().async {
            let msg = MsgGenerator.genGetModifyRewardAddressMsg(self.pageHolderVC.mAccount!.account_address,
                                                                self.pageHolderVC.mToChangeRewardAddress!,
                                                                self.chainType!)
            var msgList = Array<Msg>()
            msgList.append(msg)
            
            let stdMsg = MsgGenerator.getToSignMsg(BaseData.instance.getChainId(self.chainType),
                                                   String(self.pageHolderVC.mAccount!.account_account_numner),
                                                   String(self.pageHolderVC.mAccount!.account_sequence_number),
                                                   msgList,
                                                   self.pageHolderVC.mFee!,
                                                   self.pageHolderVC.mMemo!)
            
            let stdTx = KeyFac.getStdTx(self.pageHolderVC.privateKey!, self.pageHolderVC.publicKey!,
                                        msgList, stdMsg,
                                        self.pageHolderVC.mAccount!, self.pageHolderVC.mFee!, self.pageHolderVC.mMemo!)
 
            DispatchQueue.main.async(execute: {
                let postTx = PostTx.init("sync", stdTx.value)
                let encoder = JSONEncoder()
                encoder.outputFormatting = .sortedKeys
                let data = try? encoder.encode(postTx)
                
                do {
                    let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    let request = Alamofire.request(BaseNetWork.broadcastUrl(self.chainType), method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
                    request.responseJSON { response in
                        var txResult = [String:Any]()
                        switch response.result {
                        case .success(let res):
                            print("AddressChange ", res)
                            if let result = res as? [String : Any]  {
                                txResult = result
                            }
                        case .failure(let error):
                            print("AddressChange error ", error)
                            if (response.response?.statusCode == 500) {
                                txResult["net_error"] = 500
                            }
                        }
                        
                        if (self.waitAlert != nil) {
                            self.waitAlert?.dismiss(animated: true, completion: {
                                self.onStartTxDetail(txResult)
                            })
                        }
                    }
                    
                } catch {
                    print(error)
                }
            });
        
        }
    }
    
    
    
    func onFetchgRPCAuth(_ account: Account) {
        self.showWaittingAlert()
        DispatchQueue.global().async {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = BaseNetWork.getConnection(self.chainType!, group)!
            defer { try! channel.close().wait() }
            
            let req = Cosmos_Auth_V1beta1_QueryAccountRequest.with {
                $0.address = account.account_address
            }
            do {
                let response = try Cosmos_Auth_V1beta1_QueryClient(channel: channel).account(req).response.wait()
                self.onBroadcastGrpcTx(response)
            } catch {
                print("onFetchgRPCAuth failed: \(error)")
            }
        }
    }
    
    func onBroadcastGrpcTx(_ auth: Cosmos_Auth_V1beta1_QueryAccountResponse?) {
        DispatchQueue.global().async {
            let reqTx = Signer.genSignedSetRewardAddressTxgRPC(auth!, self.pageHolderVC.mToChangeRewardAddress!,
                                                               self.pageHolderVC.mFee!, self.pageHolderVC.mMemo!,
                                                               self.pageHolderVC.privateKey!, self.pageHolderVC.publicKey!,
                                                               BaseData.instance.getChainId(self.chainType))
            
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = BaseNetWork.getConnection(self.chainType!, group)!
            defer { try! channel.close().wait() }
            
            do {
                let response = try Cosmos_Tx_V1beta1_ServiceClient(channel: channel).broadcastTx(reqTx).response.wait()
                DispatchQueue.main.async(execute: {
                    if (self.waitAlert != nil) {
                        self.waitAlert?.dismiss(animated: true, completion: {
                            self.onStartTxDetailgRPC(response)
                        })
                    }
                });
            } catch {
                print("onBroadcastGrpcTx failed: \(error)")
            }
        }
    }
}
