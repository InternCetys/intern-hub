import Head from "next/head";
import React from "react";
import { NavbarNested } from "../../components/core/navbar/Navbar";
import ProtectedRoute from "../../components/core/ProtectedRoute";
import Shell from "../../components/core/Shell";
import PotwRoot from "../../components/potw/PotwRoot";

const potw = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <ProtectedRoute>
        <Shell>
          <PotwRoot />
        </Shell>
      </ProtectedRoute>
    </>
  );
};

export default potw;
