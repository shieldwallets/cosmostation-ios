//
//  GenDenom3ViewController.swift
//  Cosmostation
//
//  Created by yongjoo jung on 2021/12/28.
//  Copyright © 2021 wannabit. All rights reserved.
//

import UIKit
import GRPC
import NIO

class GenDenom3ViewController: BaseViewController, PasswordViewDelegate {
    
    @IBOutlet weak var txFeeAmountLabel: UILabel!
    @IBOutlet weak var txFeeDenomLabel: UILabel!
    @IBOutlet weak var denomIdLabel: UILabel!
    @IBOutlet weak var denomNameLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var pageHolderVC: StepGenTxViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.account = BaseData.instance.selectAccountById(id: BaseData.instance.getRecentAccountId())
        self.chainType = WUtils.getChainType(account!.account_base_chain)
        self.pageHolderVC = self.parent as? StepGenTxViewController
    }
    
    override func enableUserInteraction() {
        self.onUpdateView()
        self.btnBack.isUserInteractionEnabled = true
        self.btnConfirm.isUserInteractionEnabled = true
    }
    
    func onUpdateView() {
        WUtils.showCoinDp(pageHolderVC.mFee!.amount[0].denom, pageHolderVC.mFee!.amount[0].amount, txFeeDenomLabel, txFeeAmountLabel, chainType!)
        denomIdLabel.text = pageHolderVC.mNFTDenomId
        denomNameLabel.text = pageHolderVC.mNFTDenomName
        memoLabel.text = pageHolderVC.mMemo
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.btnBack.isUserInteractionEnabled = false
        self.btnConfirm.isUserInteractionEnabled = false
        pageHolderVC.onBeforePage()
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        let passwordVC = UIStoryboard(name: "Password", bundle: nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        self.navigationItem.title = ""
        self.navigationController!.view.layer.add(WUtils.getPasswordAni(), forKey: kCATransition)
        passwordVC.mTarget = PASSWORD_ACTION_CHECK_TX
        passwordVC.resultDelegate = self
        self.navigationController?.pushViewController(passwordVC, animated: false)
    }
    
    func passwordResponse(result: Int) {
        if (result == PASSWORD_RESUKT_OK) {
            self.onFetchgRPCAuth(account!)
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

            do {
                var reqTx: Cosmos_Tx_V1beta1_BroadcastTxRequest!
                if (self.chainType == ChainType.IRIS_MAIN) {
                    reqTx = Signer.genSignedIssueNftDenomIrisTxgRPC(auth!,
                                                                    self.account!.account_address,
                                                                    self.pageHolderVC.mNFTDenomId!,
                                                                    self.pageHolderVC.mNFTDenomName!,
                                                                    self.pageHolderVC.mFee!, self.pageHolderVC.mMemo!,
                                                                    self.pageHolderVC.privateKey!, self.pageHolderVC.publicKey!,
                                                                    BaseData.instance.getChainId(self.chainType))
                    
                    
                    
                } else if (self.chainType == ChainType.CRYPTO_MAIN) {
                    reqTx = Signer.genSignedIssueNftDenomCroTxgRPC(auth!,
                                                                   self.account!.account_address,
                                                                   self.pageHolderVC.mNFTDenomId!,
                                                                   self.pageHolderVC.mNFTDenomName!,
                                                                   self.pageHolderVC.mFee!, self.pageHolderVC.mMemo!,
                                                                   self.pageHolderVC.privateKey!, self.pageHolderVC.publicKey!,
                                                                   BaseData.instance.getChainId(self.chainType))
                }
                
                let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
                defer { try! group.syncShutdownGracefully() }
                
                let channel = BaseNetWork.getConnection(self.chainType!, group)!
                defer { try! channel.close().wait() }
                
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
