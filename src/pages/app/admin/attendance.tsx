import Head from "next/head";
import React from "react";
import AttendanceRoot from "../../../components/attendance/AttendanceRoot";
import ProtectedRoute from "../../../components/core/ProtectedRoute";
import Shell from "../../../components/core/Shell";

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
          <AttendanceRoot />
        </Shell>
      </ProtectedRoute>
    </>
  );
};

export default potw;
