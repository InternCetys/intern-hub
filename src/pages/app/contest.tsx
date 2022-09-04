import Head from "next/head";
import ContestRoot from "../../components/contest/ContestRoot";
import Shell from "../../components/core/Shell";

const contest = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <ContestRoot />
      </Shell>
    </>
  );
};

export default contest;
