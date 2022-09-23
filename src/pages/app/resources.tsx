import { GetServerSideProps } from "next";
import Head from "next/head";
import Shell from "../../components/core/Shell";
import ProjectRoot from "../../components/project/ProjectRoot";
import ResourcesRoot from "../../components/resources/ResourcesRoot";

const Resources = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <ResourcesRoot />
        </Shell>
    </>
  );
};

export default Resources;
