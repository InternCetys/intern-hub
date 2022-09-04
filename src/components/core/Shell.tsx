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
  const { data, isLoading } = trpc.useQuery(["user.getIsInternMember"], {
    onSuccess: (data) => {
      if (!data?.isInternMember) {
        router.push("/noaccess");
      }
    },
  });

  return <AppShell navbar={<NavbarNested />}>{children}</AppShell>;
};

export default Shell;
