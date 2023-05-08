// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract GasContract {

    //Constants
    uint256 private immutable totalSupply; // cannot be updated
    uint8 private constant tradeFlag = 1;
    uint8 private constant basicFlag = 0;
    uint8 private constant dividendFlag = 1;
    address private contractOwner;
    uint8 public tradePercent = 12;
    bool private isReady;

    uint256 private paymentCounter = 0;
    mapping(address => uint256) public balances;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }
    PaymentType constant defaultPayment = PaymentType.Unknown;

    History[] public paymentHistory; // when a payment was updated

    struct Payment {
        PaymentType paymentType;
        bool adminUpdated;
        address recipient;
        address admin; // administrators address
        //TODO would have converted to bytes8 but not supported in tests
        string recipientName; // max 8 characters
        uint256 paymentID;
        uint256 amount;
    }

    struct History {
        uint256 lastUpdate;
        address updatedBy;
        uint256 blockNumber;
    }
    uint256 wasLastOdd = 1;
    mapping(address => uint256) public isOddWhitelistUser;

    struct ImportantStruct {
        uint256 amount;
        uint256 bigValue;
        uint8 valueA; // max 3 digits
        uint8 valueB; // max 3 digits
        bool paymentStatus;
        address sender;
    }
    mapping(address => ImportantStruct) public whiteListStruct;

    // Custom errors
    error OnlyAdminError();
    error NotAdminOrOwnerError();
    error NotWhitelistedError();
    error TierLevelTooHighError();
    error InsufficientBalanceError();
    error InvalidPaymentIDError();
    error RecipientNameTooLongError();
    error IDGreaterThanZeroError();
    error AmountGreaterThanZeroError();
    error NonZeroAddressRequiredError();
    error UserAlreadyWhitelistedError();
    error InvalidAmountError();
    error AmountMustBeGreaterThanThreeError();
    error PaymentStatusError();
    error InsufficientBalanceForWhitelistError();
    error ContractHackedError();
    error InvalidTransferAmountError();

    modifier onlyAdminOrOwner() {
        address senderOfTx = msg.sender;
            if (senderOfTx != contractOwner || !_checkForAdmin(senderOfTx)) {
                revert NotAdminOrOwnerError();
            }
        _;
    }

    modifier checkIfWhiteListed() {
        uint256 usersTier = whitelist[msg.sender];
        if (usersTier == 0) {
            revert NotWhitelistedError();
        }
        if (usersTier >= 4) {
            revert TierLevelTooHighError();
        }
        _;
    }

    event AddedToWhitelist(address userAddress, uint256 tier);
    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(address admin, uint256 ID, uint256 amount, string recipient);
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        //TODO reduce to 4 iterations
        for (uint256 i = 0; i < administrators.length;) {
            if (_admins[i] != address(0)) {
                administrators[i] = _admins[i];
                if (_admins[i] == contractOwner) {
                    balances[contractOwner] = totalSupply;
                    emit supplyChanged(_admins[i], totalSupply);
                } else {
                    balances[_admins[i]] = 0;
                    emit supplyChanged(_admins[i], 0);
                }
            }
            unchecked { ++i; }
        }
    }

    function getPaymentHistory() external view returns (History[] memory paymentHistory_) {
        paymentHistory_ = paymentHistory;
    }

    function _checkForAdmin(address _user) private view returns (bool admin_) {
        //TODO reduce to 4 iterations
        for (uint256 i = 0; i < administrators.length;) {
            if (administrators[i] == _user) {
                admin_ = true;
                break;
            }
            unchecked { ++i; }
        }
    }

    function balanceOf(address _user) external view returns (uint256 balance_) {
        balance_ = balances[_user];
    }

    function _getTradingMode() private pure returns (bool mode_) {
        if (tradeFlag == 1 || dividendFlag == 1) {
            mode_ = true;
        } else {
            mode_ = false;
        }
    }

    function addHistory(address _updateAddress, bool _tradeMode) internal returns (bool status_, bool tradeMode_) {
        History memory history;
        history.blockNumber = block.number;
        history.lastUpdate = block.timestamp;
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        bool[] memory status = new bool[](tradePercent);
        for (uint256 i = 0; i < tradePercent;) {
            status[i] = true;
            unchecked { ++i; }
        }
        tradeMode_ = _tradeMode;
        status_ = true;
    }

    function getPayments(address _user) external view returns (Payment[] memory payments_) {
        payments_ = payments[_user];
    }

    function transfer(address _recipient, uint256 _amount,  string calldata _name) external returns (bool status_) {
        address senderOfTx = msg.sender;
        if (balances[senderOfTx] < _amount) {
            revert InsufficientBalanceError();
        }
        if (bytes(_name).length >= 9) {
            revert RecipientNameTooLongError();
        }
        balances[senderOfTx] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.admin = address(0);
        payment.adminUpdated = false;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        payment.paymentID = ++paymentCounter;
        payments[senderOfTx].push(payment);
        bool[] memory status = new bool[](tradePercent);
        for (uint256 i = 0; i < tradePercent; ++i) {
            status[i] = true;
        }
        status_ = true;
    }

    function updatePayment(address _user, uint256 _ID, uint256 _amount, PaymentType _type) external onlyAdminOrOwner {
        if (_ID <= 0) {
            revert InvalidPaymentIDError();
        }
        if (_amount == 0) {
            revert InvalidAmountError();
        }
        if (_user == address(0)) {
            revert NonZeroAddressRequiredError();
        }

        address senderOfTx = msg.sender;

        for (uint256 i = 0; i < payments[_user].length; ++i) {
            if (payments[_user][i].paymentID == _ID) {
                payments[_user][i].adminUpdated = true;
                payments[_user][i].admin = _user;
                payments[_user][i].paymentType = _type;
                payments[_user][i].amount = _amount;
                bool tradingMode = _getTradingMode();
                addHistory(_user, tradingMode);
                emit PaymentUpdated(senderOfTx, _ID, _amount, payments[_user][i].recipientName);
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) external onlyAdminOrOwner {
        if (_tier >= 255) {
            revert TierLevelTooHighError();
        }
        whitelist[_userAddrs] = _tier;
        if (_tier > 3) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 3;
        } else if (_tier == 1) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 1;
        } else if (_tier > 0 && _tier < 3) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 2;
        }
        uint256 wasLastAddedOdd = wasLastOdd;
        if (wasLastAddedOdd == 1) {
            wasLastOdd = 0;
            isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        } else if (wasLastAddedOdd == 0) {
            wasLastOdd = 1;
            isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        } else {
            revert ContractHackedError();
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) external checkIfWhiteListed() {
        address senderOfTx = msg.sender;
        whiteListStruct[senderOfTx] = ImportantStruct(_amount, 0, 0, 0, true, msg.sender);

        if (balances[senderOfTx] < _amount) {
            revert InsufficientBalanceError();
        }
        if (_amount <= 3) {
            revert InvalidTransferAmountError();
        }
        balances[senderOfTx] -= _amount;
        balances[_recipient] += _amount;
        balances[senderOfTx] += whitelist[senderOfTx];
        balances[_recipient] -= whitelist[senderOfTx];
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256) {
        return (whiteListStruct[sender].paymentStatus, whiteListStruct[sender].amount);
    }

    receive() external payable {
        payable(msg.sender).transfer(msg.value);
    }
}
