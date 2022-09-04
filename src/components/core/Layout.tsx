import React from "react";
import { NavbarNested } from "./navbar/Navbar";

interface Props {
  children: React.ReactNode;
}

const Layout = ({ children }: Props) => {
  return (
    <>
      <NavbarNested />
      {children}
    </>
  );
};

export default Layout;
