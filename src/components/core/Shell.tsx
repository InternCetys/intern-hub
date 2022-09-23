import { AppShell, LoadingOverlay, Title } from "@mantine/core";
import { useRouter } from "next/router";
import React, { useEffect, useState } from "react";
import { trpc } from "../../utils/trpc";
import { NavbarNested } from "./navbar/Navbar";

interface Props {
  children: React.ReactNode;
}
const Shell = ({ children }: Props) => {
  const router = useRouter();
  const { data, isLoading } = trpc.useQuery(["user.getUserRoles"], {
    onSuccess: (data) => {
      if (!data?.isInternMember) {
        router.push("/noaccess");
      }
    },
  });

  return (
    <AppShell navbar={<NavbarNested isAdmin={data?.admin || false} />}>
      {children}
    </AppShell>
  );
};

export default Shell;
