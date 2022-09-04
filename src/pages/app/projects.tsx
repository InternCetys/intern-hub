import Head from "next/head";
import Shell from "../../components/core/Shell";
import ProjectRoot from "../../components/project/ProjectRoot";

const projects = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <ProjectRoot />
      </Shell>
    </>
  );
};

export default projects;
