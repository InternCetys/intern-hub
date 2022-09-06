import Head from "next/head";
import Shell from "../../components/core/Shell";
import ProfileRoot from "../../components/Profile/ProfileRoot";

const profile = () => {
    return (
      <>
        <Head>
          <title>Intern Hub</title>
          <meta name="description" content="CETYS Intern Hub" />
          <link rel="icon" href="/favicon.ico" />
        </Head>
        <Shell>
          <ProfileRoot />
        </Shell>
      </>
    );
};

export default profile;
