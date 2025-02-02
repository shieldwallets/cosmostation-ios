//
//  VoteDetailsViewController.swift
//  Cosmostation
//
//  Created by 정용주 on 2020/05/16.
//  Copyright © 2020 wannabit. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import GRPC
import NIO

class VoteDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var voteDetailTableView: UITableView!
    @IBOutlet weak var btnVote: UIButton!
    @IBOutlet weak var loadingImg: LoadingImageView!
    var refresher: UIRefreshControl!
    
    var proposalId: String?
    var mMintscanProposalDetail: MintscanProposalDetail?
    var mMyVote: Vote?
    var mMyVote_gRPC: Cosmos_Gov_V1beta1_Vote?
    var mCertikMyVote_gRPC: Shentu_Gov_V1alpha1_Vote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.account = BaseData.instance.selectAccountById(id: BaseData.instance.getRecentAccountId())
        self.chainType = WUtils.getChainType(account!.account_base_chain)
        
        self.voteDetailTableView.delegate = self
        self.voteDetailTableView.dataSource = self
        self.voteDetailTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.voteDetailTableView.register(UINib(nibName: "VoteInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "VoteInfoTableViewCell")
        self.voteDetailTableView.register(UINib(nibName: "VoteTallyTableViewCell", bundle: nil), forCellReuseIdentifier: "VoteTallyTableViewCell")
        self.voteDetailTableView.rowHeight = UITableView.automaticDimension
        self.voteDetailTableView.estimatedRowHeight = UITableView.automaticDimension
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(onFetch), for: .valueChanged)
        refresher.tintColor = UIColor.white
        voteDetailTableView.addSubview(refresher)
        
        self.loadingImg.onStartAnimation()
        self.onFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("title_vote_detail", comment: "")
        self.navigationItem.title = NSLocalizedString("title_vote_detail", comment: "")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func onUpdateView() {
        self.loadingImg.onStopAnimation()
        self.loadingImg.isHidden = true
        self.voteDetailTableView.reloadData()
        self.voteDetailTableView.isHidden = false
        self.btnVote.isHidden = false
        self.refresher.endRefreshing()
    }
    
    func onClickLink() {
        let link = WUtils.getProposalExplorer(self.chainType!, proposalId!)
        guard let url = URL(string: link) else { return }
        self.onShowSafariWeb(url)
    }
    
    
    @IBAction func onClickVote(_ sender: UIButton) {
        if (!account!.account_has_private) {
            self.onShowAddMenomicDialog()
            return
        }

        let mainDenom = WUtils.getMainDenom(chainType)
        if (mMintscanProposalDetail?.proposal_status?.contains("VOTING") == false) {
            self.onShowToast(NSLocalizedString("error_not_voting_period", comment: ""))
            return
        }
        
        if (WUtils.isGRPC(chainType!)) {
            if (BaseData.instance.mMyDelegations_gRPC.count <= 0) {
                self.onShowToast(NSLocalizedString("error_no_bonding_no_vote", comment: ""))
                return
            }
            let feeAmount = WUtils.getEstimateGasFeeAmount(chainType!, TASK_TYPE_VOTE, 0)
            if (BaseData.instance.getAvailableAmount_gRPC(mainDenom).compare(feeAmount).rawValue < 0) {
                self.onShowToast(NSLocalizedString("error_not_enough_fee", comment: ""))
                return
            }

        } else {
            if (BaseData.instance.mMyDelegations.count <= 0) {
                self.onShowToast(NSLocalizedString("error_no_bonding_no_vote", comment: ""))
                return
            }
            let feeAmount = WUtils.getEstimateGasFeeAmount(chainType!, TASK_TYPE_VOTE, 0)
            if (BaseData.instance.availableAmount(mainDenom).compare(feeAmount).rawValue < 0) {
                self.onShowToast(NSLocalizedString("error_not_enough_fee", comment: ""))
                return
            }
        }

        let txVC = UIStoryboard(name: "GenTx", bundle: nil).instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
        txVC.mProposeId = proposalId
        txVC.mProposalTitle = mMintscanProposalDetail?.title
        txVC.mProposer = WUtils.onProposalProposer(mMintscanProposalDetail)
        txVC.mType = TASK_TYPE_VOTE
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(txVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            return onBindVoteInfo(tableView)
        } else {
            return onBindTally(tableView)
        }
    }
    
    func onBindVoteInfo(_ tableView: UITableView) -> UITableViewCell {
        let cell:VoteInfoTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"VoteInfoTableViewCell") as? VoteInfoTableViewCell
        if (mMintscanProposalDetail != nil) {
            cell?.statusImg.image = WUtils.onProposalStatusImg(mMintscanProposalDetail)
            cell?.statusTitle.text = WUtils.onProposalStatusTxt(mMintscanProposalDetail)
            cell?.proposalTitle.text = mMintscanProposalDetail?.title
            cell?.proposerLabel.text = WUtils.onProposalProposer(mMintscanProposalDetail)
            cell?.proposalTypeLabel.text = mMintscanProposalDetail?.proposal_type
            cell?.voteStartTime.text = WUtils.sifNodeTimeToString(mMintscanProposalDetail?.voting_start_time)
            cell?.voteEndTime.text = WUtils.sifNodeTimeToString(mMintscanProposalDetail?.voting_end_time)
            cell?.voteDescription.text = mMintscanProposalDetail?.description
            if let requestCoin = mMintscanProposalDetail?.content?.amount?[0] {
                WUtils.showCoinDp(requestCoin, cell!.requestAmountDenom, cell!.requestAmount, chainType!)
            } else {
                cell!.requestAmountDenom.text = "N/A"
            }
        }
        cell?.actionLink = {
            self.onClickLink()
        }
        cell?.actionToggle = {
            cell?.voteDescription.isScrollEnabled = !(cell?.voteDescription.isScrollEnabled)!
            self.voteDetailTableView.reloadData()
        }
        return cell!
    }
    
    func onBindTally(_ tableView: UITableView) -> UITableViewCell {
        let cell:VoteTallyTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"VoteTallyTableViewCell") as? VoteTallyTableViewCell
        if (mMintscanProposalDetail != nil) {
            cell?.onUpdateCards(chainType, mMintscanProposalDetail!)
        }
        if (chainType == ChainType.CERTIK_MAIN) {
            cell?.onCheckMyVote_gRPC(mCertikMyVote_gRPC?.deposit.option)
        } else if (WUtils.isGRPC(chainType!)) {
            cell?.onCheckMyVote_gRPC(mMyVote_gRPC?.option)
        } else {
            cell?.onCheckMyVote(mMyVote)
        }
        return cell!
    }
    
    @objc func onFetch() {
        mFetchCnt = 2
        onFetchMintscanProposl(proposalId!)
        if (chainType == ChainType.CERTIK_MAIN) {
            onFetchCertikProposalMyVote_gRPC(self.proposalId!, self.account!.account_address)
            
        } else if (WUtils.isGRPC(chainType!)) {
            onFetchProposalMyVote_gRPC(self.proposalId!, self.account!.account_address)
            
        } else {
            onFetchMyVote(proposalId!, account!.account_address)
        }
    }
    
    var mFetchCnt = 0
    func onFetchFinished() {
        self.mFetchCnt = self.mFetchCnt - 1
        if (mFetchCnt > 0) { return }
        
        self.onUpdateView()
    }
    
    func onFetchMintscanProposl(_ id: String) {
        let url = BaseNetWork.mintscanProposalDetail(chainType!, id)
        let request = Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
        request.responseJSON { (response) in
            switch response.result {
            case .success(let res):
                if let responseData = res as? NSDictionary {
                    self.mMintscanProposalDetail = MintscanProposalDetail.init(responseData)
                }
                
            case .failure(let error):
                print("onFetchMintscanProposl ", error)
            }
            self.onFetchFinished()
        }
    }
    
    func onFetchMyVote(_ id: String, _ address: String) {
        let request = Alamofire.request(BaseNetWork.voteUrl(chainType, id, address), method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
        request.responseJSON { (response) in
            switch response.result {
            case .success(let res):
                guard let rawVote = res as? [String : Any], rawVote["error"] == nil else {
                    self.onFetchFinished()
                    return
                }
                let cosmosVote = CosmosVote.init(rawVote)
                self.mMyVote = cosmosVote.result
                
            case .failure(let error):
                print("onFetchMyVote ", error)
            }
            self.onFetchFinished()
        }
    }
    
    func onFetchProposalMyVote_gRPC(_ proposal_id: String, _ address: String) {
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async(execute: { self.onFetchFinished() });
                let channel = BaseNetWork.getConnection(self.chainType!, MultiThreadedEventLoopGroup(numberOfThreads: 1))!
                defer { try! channel.close().wait() }

                let req = Cosmos_Gov_V1beta1_QueryVoteRequest.with { $0.voter = address; $0.proposalID = UInt64(proposal_id)! }
                if let response = try? Cosmos_Gov_V1beta1_QueryClient(channel: channel).vote(req, callOptions:BaseNetWork.getCallOptions()).response.wait() {
                    self.mMyVote_gRPC = response.vote
                }
                try channel.close().wait()
                
            } catch {
                print("onFetchProposalMyVote_gRPC failed: \(error)")
            }
            DispatchQueue.main.async(execute: { self.onFetchFinished() });
        }
    }
    
    func onFetchCertikProposalMyVote_gRPC(_ proposal_id: String, _ address: String) {
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async(execute: { self.onFetchFinished() });
                let channel = BaseNetWork.getConnection(self.chainType!, MultiThreadedEventLoopGroup(numberOfThreads: 1))!
                defer { try! channel.close().wait() }

                let req = Shentu_Gov_V1alpha1_QueryVoteRequest.with { $0.voter = address; $0.proposalID = UInt64(proposal_id)! }
                if let response = try? Shentu_Gov_V1alpha1_QueryClient(channel: channel).vote(req, callOptions:BaseNetWork.getCallOptions()).response.wait() {
                    self.mCertikMyVote_gRPC = response.vote
                }
                try channel.close().wait()
                
            } catch {
                print("onFetchCertikProposalMyVote_gRPC failed: \(error)")
            }
            DispatchQueue.main.async(execute: { self.onFetchFinished() });
        }
    }
}
