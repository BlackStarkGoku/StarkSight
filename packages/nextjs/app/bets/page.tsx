"use client";
import { useAccount } from "@starknet-react/core";
import {
  Alert,
  AlertDescription,
  AlertTitle,
} from "../Uikit/components/ui/alert";
import { Info } from "lucide-react";
import UserPositions from "./UserPositions";

function Page() {
  const { address, status, chainId, ...props } = useAccount();
  return (
    <div>
      {status === "disconnected" ? (
        <Alert className="w-fit">
          <Info className="h-4 w-4" />
          <AlertTitle>No positions</AlertTitle>
          <AlertDescription>Please connect your wallet</AlertDescription>
        </Alert>
      ) : (
        <>
          <UserPositions />
        </>
      )}
    </div>
  );
}

export default Page;
