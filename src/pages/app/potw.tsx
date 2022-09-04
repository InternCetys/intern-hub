import Head from "next/head";
import React from "react";
import { NavbarNested } from "../../components/core/navbar/Navbar";

const potw = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <NavbarNested />
    </>
  );
};

export default potw;
