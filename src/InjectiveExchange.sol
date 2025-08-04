// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IExchangeModule} from "./lib/Exchange.sol";
import {ExchangeTypes} from "./lib/ExchangeTypes.sol";

contract InjectiveExchange {
    address constant exchangeContract = 0x0000000000000000000000000000000000000065;
    IExchangeModule exchange = IExchangeModule(exchangeContract);

    /***************************************************************************
     * calling the precompile directly
    ****************************************************************************/

    // deposit funds into subaccount belonging to this contract
    function deposit(
        string calldata subaccountID,
        string calldata denom,
        uint256 amount
    ) external returns (bool) {
        try exchange.deposit(address(this), subaccountID, denom, amount) returns (bool success) {
            return success;
        } catch Error(string memory reason) {
            revert(string(abi.encodePacked("Deposit error: ", reason)));
        } catch {
            revert("Unknown error during deposit");
        }
    }

    // withdraw funds from a subaccount belonging to this contract
    function withdraw(
        string calldata subaccountID,
        string calldata denom,
        uint256 amount
    ) external returns (bool) {
        try exchange.withdraw(address(this), subaccountID, denom, amount) returns (bool success) {
            return success;
        } catch Error(string memory reason) {
            revert(string(abi.encodePacked("Withdraw error: ", reason)));
        } catch {
            revert("Unknown error during withdraw");
        }
    }

    function subaccountPositions(
        string calldata subaccountID
    ) external view returns (IExchangeModule.DerivativePosition[] memory positions) {
        return exchange.subaccountPositions(subaccountID);
    }

    function createDerivativeLimitOrder(
        IExchangeModule.DerivativeOrder calldata order
    ) external returns (IExchangeModule.CreateDerivativeLimitOrderResponse memory response) {
        try exchange.createDerivativeLimitOrder(address(this), order) returns (IExchangeModule.CreateDerivativeLimitOrderResponse memory resp) {
            return resp;
        } catch Error(string memory reason) {
            revert(string(abi.encodePacked("CreateDerivativeLimitOrder error: ", reason)));
        } catch {
            revert("Unknown error during createDerivativeLimitOrder");
        }
    }

    function cancelDerivativeOrder(
        string calldata marketID,
        string calldata subaccountID,
        string calldata orderHash,
        int32 orderMask,
        string calldata cid
    ) external returns (bool success) {
        try exchange.cancelDerivativeOrder(
            address(this),
            marketID,
            subaccountID,
            orderHash,
            orderMask,
            cid
        ) returns (bool result) {
            return result;
        } catch Error(string memory reason) {
            revert(string(abi.encodePacked("CancelDerivativeOrder error: ", reason)));
        } catch {
            revert("Unknown error during cancelDerivativeOrder");
        }
    }

    function createSpotLimitOrder(
        IExchangeModule.SpotOrder calldata order
    ) external returns (IExchangeModule.CreateSpotLimitOrderResponse memory response) {
        try exchange.createSpotLimitOrder(address(this), order) returns (IExchangeModule.CreateSpotLimitOrderResponse memory resp) {
            return resp;
        } catch Error(string memory reason) {
            revert(string(abi.encodePacked("CreateSpotLimitOrder error: ", reason)));
        } catch {
            revert("Unknown error during createSpotLimitOrder");
        }
    }

    function cancelSpotOrder(
        string calldata marketID,
        string calldata subaccountID,
        string calldata orderHash,
        string calldata cid
    ) external returns (bool success) {
        try exchange.cancelSpotOrder(
            address(this),
            marketID,
            subaccountID,
            orderHash,
            cid
        ) returns (bool result) {
            return result;
        } catch Error(string memory reason) {
            revert(string(abi.encodePacked("CancelSpotOrder error: ", reason)));
        } catch {
            revert("Unknown error during cancelSpotOrder");
        }
    }
}