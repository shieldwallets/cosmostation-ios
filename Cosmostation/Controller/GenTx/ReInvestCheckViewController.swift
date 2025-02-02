//
//  ReInvestCheckViewController.swift
//  Cosmostation
//
//  Created by yongjoo on 05/06/2019.
//  Copyright © 2019 wannabit. All rights reserved.
//

import UIKit
import Alamofire
import GRPC
import NIO

class ReInvestCheckViewController: BaseViewController, PasswordViewDelegate {
    
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var rewardDenomLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var feeDenomLabel: UILabel!
    @IBOutlet weak var validatorLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var currentDelegateAmount: UILabel!
    @IBOutlet weak var currentDenom: UILabel!
    @IBOutlet weak var expectedDelegateAmount: UILabel!
    @IBOutlet weak var expectedDenom: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var pageHolderVC: StepGenTxViewController!
    var mDpDecimal:Int16 = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.account = BaseData.instance.selectAccountById(id: BaseData.instance.getRecentAccountId())
        self.chainType = WUtils.getChainType(account!.account_base_chain)
        self.pageHolderVC = self.parent as? StepGenTxViewController
        WUtils.setDenomTitle(chainType, rewardDenomLabel)
        WUtils.setDenomTitle(chainType, feeDenomLabel)
        WUtils.setDenomTitle(chainType, currentDenom)
        WUtils.setDenomTitle(chainType, expectedDenom)
    }
    
    func onUpdateView() {
        mDpDecimal = WUtils.mainDivideDecimal(chainType)
        
        if (WUtils.isGRPC(chainType)) {
            rewardLabel.attributedText = WUtils.displayAmount2(pageHolderVC.mReinvestReward!.amount, rewardLabel.font, mDpDecimal, mDpDecimal)
            feeLabel.attributedText = WUtils.displayAmount2((pageHolderVC.mFee?.amount[0].amount)!, feeLabel.font, mDpDecimal, mDpDecimal)
            
            let currentDelegation = BaseData.instance.getDelegated_gRPC(pageHolderVC.mTargetValidator_gRPC?.operatorAddress)
            let expectedDelegation = currentDelegation.adding(NSDecimalNumber.init(string: pageHolderVC.mReinvestReward!.amount))
            currentDelegateAmount.attributedText = WUtils.displayAmount2(currentDelegation.stringValue, currentDelegateAmount.font, mDpDecimal, mDpDecimal)
            expectedDelegateAmount.attributedText = WUtils.displayAmount2(expectedDelegation.stringValue, expectedDelegateAmount.font, mDpDecimal, mDpDecimal)
            
            validatorLabel.text = pageHolderVC.mTargetValidator_gRPC?.description_p.moniker
            memoLabel.text = pageHolderVC.mMemo
            
        } else {
            rewardLabel.attributedText = WUtils.displayAmount2(pageHolderVC.mReinvestReward!.amount, rewardLabel.font, mDpDecimal, mDpDecimal)
            feeLabel.attributedText = WUtils.displayAmount2((pageHolderVC.mFee?.amount[0].amount)!, feeLabel.font, mDpDecimal, mDpDecimal)
            
            let currentDelegation = BaseData.instance.delegatedAmountByValidator(self.pageHolderVC.mTargetValidator!.operator_address)
            let expected = currentDelegation.adding(NSDecimalNumber.init(string: pageHolderVC.mReinvestReward!.amount))
            currentDelegateAmount.attributedText = WUtils.displayAmount2(currentDelegation.stringValue, currentDelegateAmount.font, mDpDecimal, mDpDecimal)
            expectedDelegateAmount.attributedText = WUtils.displayAmount2(expected.stringValue, expectedDelegateAmount.font, mDpDecimal, mDpDecimal)
            
            validatorLabel.text = pageHolderVC.mTargetValidator?.description.moniker
            memoLabel.text = pageHolderVC.mMemo
            
        }
    }
    
    override func enableUserInteraction() {
        self.onUpdateView()
        self.backBtn.isUserInteractionEnabled = true
        self.confirmBtn.isUserInteractionEnabled = true
    }

    @IBAction func onClickBack(_ sender: UIButton) {
        self.backBtn.isUserInteractionEnabled = false
        self.confirmBtn.isUserInteractionEnabled = false
        pageHolderVC.onBeforePage()
    }
    
    func checkIsWasteFee() -> Bool {
        let rewardSum = NSDecimalNumber.init(string: pageHolderVC.mReinvestReward!.amount)
        if (NSDecimalNumber.init(string: pageHolderVC.mFee!.amount[0].amount).compare(rewardSum).rawValue > 0 ) {
            return true
        }
        return false
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        if (checkIsWasteFee()) {
            let disableAlert = UIAlertController(title: NSLocalizedString("fee_over_title", comment: ""), message: NSLocalizedString("fee_over_msg", comment: ""), preferredStyle: .alert)
            disableAlert.addAction(UIAlertAction(title: NSLocalizedString("close", comment: ""), style: .default, handler: { [weak disableAlert] (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(disableAlert, animated: true) {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                disableAlert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            }
            return
        }
        
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
                if (self.chainType == ChainType.KAVA_MAIN || self.chainType == ChainType.KAVA_TEST) {
                    guard let info = res as? [String : Any] else {
                        _ = BaseData.instance.deleteBalance(account: account)
                        self.hideWaittingAlert()
                        self.onShowToast(NSLocalizedString("error_network", comment: ""))
                        return
                    }
                    let accountInfo = KavaAccountInfo.init(info)
                    _ = BaseData.instance.updateAccount(WUtils.getAccountWithKavaAccountInfo(account, accountInfo))
                    BaseData.instance.updateBalances(account.account_id, WUtils.getBalancesWithKavaAccountInfo(account, accountInfo))
                    self.onGenReinvest()
                    
                } else {
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
                    self.onGenReinvest()
                    
                }
                
            case .failure( _):
                self.hideWaittingAlert()
                self.onShowToast(NSLocalizedString("error_network", comment: ""))
            }
        }
    }
    
    func onGenReinvest() {
        DispatchQueue.global().async {
            var msgList = Array<Msg>()
            let rewardMsg = MsgGenerator.genGetRewardMsg(self.pageHolderVC.mAccount!.account_address,
                                                         self.pageHolderVC.mTargetValidator!.operator_address,
                                                         self.chainType!)
            
            let delegatemsg = MsgGenerator.genDelegateMsg(self.pageHolderVC.mAccount!.account_address,
                                                          self.pageHolderVC.mTargetValidator!.operator_address,
                                                          self.pageHolderVC.mReinvestReward!,
                                                          self.chainType!)
            msgList.append(rewardMsg)
            msgList.append(delegatemsg)
            
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
//                    print("params ", params)
                    let request = Alamofire.request(BaseNetWork.broadcastUrl(self.chainType), method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
                    request.validate()
                    request.responseJSON { response in
                        var txResult = [String:Any]()
                        switch response.result {
                        case .success(let res):
                            print("ReInvest ", res)
                            if let result = res as? [String : Any]  {
                                txResult = result
                            }
                        case .failure(let error):
                            print("ReInvest error ", error)
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
                    
                }catch {
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
            let reqTx = Signer.genSignedReInvestTxgRPC(auth!, self.pageHolderVC.mTargetValidator_gRPC!.operatorAddress, self.pageHolderVC.mReinvestReward!,
                                                       self.pageHolderVC.mFee!, self.pageHolderVC.mMemo!,
                                                       self.pageHolderVC.privateKey!, self.pageHolderVC.publicKey!,
                                                       BaseData.instance.getChainId(self.chainType))
            
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = BaseNetWork.getConnection(self.chainType!, group)!
            defer { try! channel.close().wait() }
            
            do {
                let response = try Cosmos_Tx_V1beta1_ServiceClient(channel: channel).broadcastTx(reqTx).response.wait()
//                print("response ", response.txResponse.txhash)
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
