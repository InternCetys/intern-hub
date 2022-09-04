import Head from "next/head";
import React from "react";
import { NavbarNested } from "../../components/core/navbar/Navbar";
import Shell from "../../components/core/Shell";
import DashboardRoot from "../../components/dashbaord/DashboardRoot";
import PotwRoot from "../../components/potw/PotwRoot";

const dashboard = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <DashboardRoot />
      </Shell>
    </>
  );
};

export default dashboard;
