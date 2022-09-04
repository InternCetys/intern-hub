import { AppShell } from "@mantine/core";
import React from "react";
import { NavbarNested } from "./navbar/Navbar";

interface Props {
  children: React.ReactNode;
}
const Shell = ({ children }: Props) => {
  return <AppShell navbar={<NavbarNested />}>{children}</AppShell>;
};

export default Shell;
