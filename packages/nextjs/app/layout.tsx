import type { Metadata } from "next";
import { ScaffoldStarkAppWithProviders } from "~~/components/ScaffoldStarkAppWithProviders";
import "~~/styles/globals.css";
import { ThemeProvider } from "~~/components/ThemeProvider";

export const metadata: Metadata = {
  title: "Scaffold-Stark",
  description: "Fast track your starknet journey",
  icons: "/logo.ico",
};

const ScaffoldStarkApp = ({ children }: { children: React.ReactNode }) => {
  return (
    <html suppressHydrationWarning>
      <body>
        <ThemeProvider enableSystem defaultTheme="dark" attribute="class">
          <ScaffoldStarkAppWithProviders>
            <div className=" min-h-screen flex justify-center px-4">
              <div className=" mx-auto w-full max-w-7xl pt-12">{children}</div>
            </div>
          </ScaffoldStarkAppWithProviders>
        </ThemeProvider>
      </body>
    </html>
  );
};

export default ScaffoldStarkApp;
