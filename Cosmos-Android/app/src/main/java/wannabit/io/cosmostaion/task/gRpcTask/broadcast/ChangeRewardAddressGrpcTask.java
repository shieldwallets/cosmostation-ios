package wannabit.io.cosmostaion.task.gRpcTask.broadcast;

import org.bitcoinj.crypto.DeterministicKey;

import cosmos.auth.v1beta1.Auth;
import cosmos.auth.v1beta1.QueryGrpc;
import cosmos.auth.v1beta1.QueryOuterClass;
import cosmos.tx.v1beta1.ServiceGrpc;
import cosmos.tx.v1beta1.ServiceOuterClass;
import io.grpc.stub.StreamObserver;
import wannabit.io.cosmostaion.R;
import wannabit.io.cosmostaion.base.BaseApplication;
import wannabit.io.cosmostaion.base.BaseChain;
import wannabit.io.cosmostaion.cosmos.Signer;
import wannabit.io.cosmostaion.crypto.CryptoHelper;
import wannabit.io.cosmostaion.dao.Account;
import wannabit.io.cosmostaion.dao.Password;
import wannabit.io.cosmostaion.model.type.Fee;
import wannabit.io.cosmostaion.network.ChannelBuilder;
import wannabit.io.cosmostaion.task.CommonTask;
import wannabit.io.cosmostaion.task.TaskListener;
import wannabit.io.cosmostaion.task.TaskResult;
import wannabit.io.cosmostaion.utils.WKey;
import wannabit.io.cosmostaion.utils.WLog;

import static wannabit.io.cosmostaion.base.BaseChain.getChain;
import static wannabit.io.cosmostaion.base.BaseConstant.ERROR_CODE_INVALID_PASSWORD;
import static wannabit.io.cosmostaion.base.BaseConstant.TASK_GRPC_BROAD_REWARD_ADDRESS_CHANGE;

public class ChangeRewardAddressGrpcTask extends CommonTask {
    private BaseChain   mBaseChain;
    private Account     mAccount;
    private String      mToRewardAddress;
    private String      mMemo;
    private Fee         mFees;

    private QueryOuterClass.QueryAccountResponse mAuthResponse;
    private DeterministicKey    deterministicKey;

    public ChangeRewardAddressGrpcTask(BaseApplication app, TaskListener listener, BaseChain basechain, Account mAccount, String mToRewardAddress, String mMemo, Fee mFees) {
        super(app, listener);
        this.mBaseChain = basechain;
        this.mAccount = mAccount;
        this.mToRewardAddress = mToRewardAddress;
        this.mMemo = mMemo;
        this.mFees = mFees;
        this.mResult.taskType = TASK_GRPC_BROAD_REWARD_ADDRESS_CHANGE;
    }

    @Override
    protected TaskResult doInBackground(String... strings) {
        Password checkPw = mApp.getBaseDao().onSelectPassword();
        if (!CryptoHelper.verifyData(strings[0], checkPw.resource, mApp.getString(R.string.key_password))) {
            mResult.isSuccess = false;
            mResult.errorCode = ERROR_CODE_INVALID_PASSWORD;
            return mResult;
        }

        try {
            String entropy = CryptoHelper.doDecryptData(mApp.getString(R.string.key_mnemonic) + mAccount.uuid, mAccount.resource, mAccount.spec);
            deterministicKey = WKey.getKeyWithPathfromEntropy(getChain(mAccount.baseChain), entropy, Integer.parseInt(mAccount.path), mAccount.newBip44);

            QueryGrpc.QueryBlockingStub authStub = QueryGrpc.newBlockingStub(ChannelBuilder.getChain(mBaseChain));
            QueryOuterClass.QueryAccountRequest request = QueryOuterClass.QueryAccountRequest.newBuilder().setAddress(mAccount.address).build();
            mAuthResponse = authStub.account(request);
            mResult.isSuccess = true;

        } catch (Exception e) {
            WLog.e( "ClaimRewardsGrpcTask "+ e.getMessage());
            mResult.isSuccess = false;
        }
        return mResult;
    }

    @Override
    protected void onPostExecute(TaskResult taskResult) {
        if (!taskResult.isSuccess) {
            if (mListener != null) mListener.onTaskResponse(taskResult);
            return;
        }

        //broadCast
        ServiceGrpc.ServiceStub txService = ServiceGrpc.newStub(ChannelBuilder.getChain(mBaseChain));
        ServiceOuterClass.BroadcastTxRequest broadcastTxRequest = Signer.getGrpcRewardAddressChangeReq(mAuthResponse, mToRewardAddress, mFees, mMemo, deterministicKey, getChain(mAccount.baseChain));
        txService.broadcastTx(broadcastTxRequest, new StreamObserver<ServiceOuterClass.BroadcastTxResponse>() {
            @Override
            public void onNext(ServiceOuterClass.BroadcastTxResponse value) {
//                WLog.w("onNext " +  value + "  " + value.getTxResponse());
                mResult.resultData = value.getTxResponse().getTxhash();
                if (value.getTxResponse().getCode() > 0) {
                    mResult.errorCode = value.getTxResponse().getCode();
                    mResult.errorMsg = value.getTxResponse().getRawLog();
                    mResult.isSuccess = false;
                } else {
                    mResult.isSuccess = true;
                }
                if (mListener != null) {
                    mListener.onTaskResponse(mResult);
                }
            }

            @Override
            public void onError(Throwable t) { }

            @Override
            public void onCompleted() { WLog.w("onCompleted "); }
        });
    }
}
