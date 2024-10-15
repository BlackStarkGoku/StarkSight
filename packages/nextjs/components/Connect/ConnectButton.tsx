"use client";

// @refresh reset

import { useAutoConnect, useNetworkColor } from "~~/hooks/scaffold-stark";
import { useTargetNetwork } from "~~/hooks/scaffold-stark/useTargetNetwork";
import { getBlockExplorerAddressLink } from "~~/utils/scaffold-stark";
import { useAccount, useNetwork } from "@starknet-react/core";
import { Address } from "@starknet-react/chains";
import { useEffect, useState } from "react";

import { Balance } from "../scaffold-stark";
import { WrongNetworkDropdown } from "../scaffold-stark/CustomConnectButton/WrongNetworkDropdown";
import { AddressInfoDropdown } from "../scaffold-stark/CustomConnectButton/AddressInfoDropdown";
import { AddressQRCodeModal } from "../scaffold-stark/CustomConnectButton/AddressQRCodeModal";
import ConnectModal from "../scaffold-stark/CustomConnectButton/ConnectModal";
import { Button } from "~~/app/Uikit/components/ui/button";
import { Label } from "~~/app/Uikit/components/ui/label";
import { Input } from "~~/app/Uikit/components/ui/input";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "~~/app/Uikit/components/ui/dialog";
import ConnectWallets from "./ConnectWallets";
import ConnectedDropdown from "./ConnectedDropdown";

/**
 * Custom Connect Button (watch balance + custom design)
 */
export const ConnectButton = () => {
  useAutoConnect();
  const networkColor = useNetworkColor();
  const { targetNetwork } = useTargetNetwork();
  const { account, status, address: accountAddress } = useAccount();

  const [accountChainId, setAccountChainId] = useState<bigint>(0n);
  const { chain } = useNetwork();
  const blockExplorerAddressLink = accountAddress
    ? getBlockExplorerAddressLink(targetNetwork, accountAddress)
    : undefined;

  // effect to get chain id and address from account
  useEffect(() => {
    if (account) {
      const getChainId = async () => {
        const chainId = await account.channel.getChainId();
        setAccountChainId(BigInt(chainId as string));
      };

      getChainId();
    }
  }, [account]);

  if (status === "disconnected")
    return (
      <Dialog>
        <DialogTrigger asChild>
          <Button
            className="border-primary text-primary hover:text-primary"
            variant={"outline"}
          >
            Connect Wallet
          </Button>
        </DialogTrigger>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>Connect a Wallet</DialogTitle>
          </DialogHeader>
          <ConnectWallets />
        </DialogContent>
      </Dialog>
    );

  if (accountChainId !== targetNetwork.id) {
    return <WrongNetworkDropdown />;
  }

  return (
    <>
      {/*  <div className="flex flex-col items-center max-sm:mt-2">
        <Balance
          address={accountAddress as Address}
          className="h-auto min-h-0"
        />
        <span className="ml-1 text-xs" style={{ color: networkColor }}>
          {chain.name}
        </span>
      </div> */}
      <ConnectedDropdown
        address={accountAddress as Address}
        displayName={""}
        ensAvatar={""}
        blockExplorerAddressLink={blockExplorerAddressLink}
      />
    </>
  );
};
