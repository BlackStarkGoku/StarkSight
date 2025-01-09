"use client";

import { Address as AddressType, sepolia } from "@starknet-react/chains";
import { MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { useNetwork } from "@starknet-react/core";
import Image from "next/image";
import GenericModal from "./CustomConnectButton/GenericModal";
import { useTheme } from "next-themes";

export const BlockExplorerSepolia = () => {
  const { chain: ConnectedChain } = useNetwork();

  const sepoliaBlockExplorers = [
    {
      name: "Starkscan",
      img: "/sn-symbol-gradient.png",
      link: "https://sepolia.starkscan.co/",
    },
    {
      name: "Voyager",
      img: "/voyager-icon.svg",
      link: "https://sepolia.voyager.online/",
    },
    {
      name: "Stark Compass",
      img: "/starkcompass-icon.svg",
      link: "https://starkcompass.com/sepolia/",
    },
  ];

  const { resolvedTheme } = useTheme();
  const isDarkMode = resolvedTheme === "dark";

  // Render only on sepolia chain
  if (ConnectedChain?.id !== sepolia.id) {
    return null;
  }

  return (
    <div>
      <label
        htmlFor="sepolia-blockexplorer-modal"
        className="btn btn-sm gap-1 border border-[#32BAC4] font-normal shadow-none"
      >
        <MagnifyingGlassIcon className="h-4 w-4 text-[#32BAC4]" />
        <span>Block Explorer</span>
      </label>
      <input
        type="checkbox"
        id="sepolia-blockexplorer-modal"
        className="modal-toggle"
      />
      <GenericModal modalId="sepolia-blockexplorer-modal">
        <>
          <div className="flex items-center justify-between">
            <h3 className="text-xl font-bold">Sepolia Block Explorers</h3>
            <label
              htmlFor="sepolia-blockexplorer-modal"
              className="btn btn-circle btn-ghost btn-sm"
            >
              ✕
            </label>
          </div>
          <div className="mb-4 mt-6">
            <div className="flex flex-col gap-4">
              {sepoliaBlockExplorers.length &&
                sepoliaBlockExplorers.map((blockexplorer, id) => (
                  <a
                    href={blockexplorer.link}
                    target="_blank"
                    className={`modal-border btn-sm flex h-12 items-center gap-4 rounded-[4px] px-6 transition-all ${
                      isDarkMode ? "hover:bg-[#385183]" : "hover:bg-slate-200"
                    } border`}
                    key={id}
                  >
                    <div className="relative flex h-6 w-6">
                      <Image
                        alt="Starknet Developers Hub"
                        className="cursor-pointer"
                        fill
                        sizes="1.5rem"
                        src={blockexplorer.img}
                      />
                    </div>
                    <p className="m-0 text-sm">{blockexplorer.name}</p>
                  </a>
                ))}
            </div>
          </div>
        </>
      </GenericModal>
    </div>
  );
};
