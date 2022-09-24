import { Center, Loader } from "@mantine/core";
import React, { useEffect, useState } from "react";
import { useUser } from "../../hooks/useUser";

interface Props {
  children: React.ReactNode;
  admin?: boolean;
}

const ProtectedRoute = ({ children, admin = false }: Props) => {
  const { user, isLoading } = useUser();

  useEffect(() => {
    if (isLoading) return;

    if (!user) {
      window.location.href = "/login";
      return;
    }

    if (!user.admin && admin) {
      window.location.href = "/app";
      return;
    }
  }, [user, isLoading]);

  if (isLoading) {
    return (
      <Center style={{ height: "100vh", width: "100vw" }}>
        <Loader variant="dots" />
      </Center>
    );
  }
  return <>{children}</>;
};

export default ProtectedRoute;
