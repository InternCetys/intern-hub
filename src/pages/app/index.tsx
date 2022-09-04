import { NavbarNested } from "../../components/core/navbar/Navbar";
import type { NextPage } from "next";
import Head from "next/head";
import { trpc } from "../../utils/trpc";
import Shell from "../../components/core/Shell";

const Home: NextPage = () => {
  const { data } = trpc.useQuery(["example.hello", { text: "from tRPC" }]);

  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <h1>Home</h1>
      </Shell>
    </>
  );
};

export default Home;
