import { AppShell, LoadingOverlay, Title } from "@mantine/core";
import { useRouter } from "next/router";
import React, { useEffect, useState } from "react";
import { useUser } from "../../hooks/useUser";
import { trpc } from "../../utils/trpc";
import { NavbarNested } from "./navbar/Navbar";

interface Props {
  children: React.ReactNode;
}
const Shell = ({ children }: Props) => {
  const { user } = useUser();

  return (
    <AppShell navbar={<NavbarNested isAdmin={user?.admin || false} />}>
      {children}
    </AppShell>
  );
};

export default Shell;
