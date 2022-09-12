import Head from "next/head";
import React from "react";
import AttendanceRoot from "../../../components/attendance/AttendanceRoot";
import Shell from "../../../components/core/Shell";

const potw = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <AttendanceRoot />
      </Shell>
    </>
  );
};

export default potw;
