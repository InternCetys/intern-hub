import Head from "next/head";
import Shell from "../../components/core/Shell";
import EventsRoot from "../../components/events/EventsRoot";

const events = () => {
  return (
    <>
      <Head>
        <title>Intern Hub</title>
        <meta name="description" content="CETYS Intern Hub" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Shell>
        <EventsRoot />
      </Shell>
    </>
  );
};

export default events;
