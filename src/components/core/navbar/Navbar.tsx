import {
  Navbar,
  Group,
  Code,
  ScrollArea,
  createStyles,
  ActionIcon,
  useMantineColorScheme,
} from "@mantine/core";
import {
  IconNotes,
  IconCalendarStats,
  IconGauge,
  IconPresentationAnalytics,
  IconTrophy,
  IconSun,
  IconMoonStars,
} from "@tabler/icons";
import { UserButton } from "./UserButton";
import { LinksGroup } from "./LinksGroup";
import Logo from "../Logo";
import { useColorScheme } from "@mantine/hooks";
import { useAuth } from "../../../hooks/useAuth";

const mockdata = [
  { label: "Dashboard", icon: IconGauge, link: "/app/dashboard" },
  {
    label: "Problems of the Week",
    icon: IconNotes,
    link: "/app/potw",
  },
  {
    label: "Upcoming Events",
    icon: IconCalendarStats,
    link: "/app/events",
  },
  {
    label: "Project Gallery",
    icon: IconPresentationAnalytics,
    link: "/app/projects",
  },
  { label: "Leetcode Contest", icon: IconTrophy, link: "/app/contest" },
];

const useStyles = createStyles((theme) => ({
  navbar: {
    backgroundColor:
      theme.colorScheme === "dark" ? theme.colors.dark[6] : theme.white,
    paddingBottom: 0,
  },

  header: {
    padding: theme.spacing.md,
    paddingTop: 0,
    marginLeft: -theme.spacing.md,
    marginRight: -theme.spacing.md,
    color: theme.colorScheme === "dark" ? theme.white : theme.black,
    borderBottom: `1px solid ${
      theme.colorScheme === "dark" ? theme.colors.dark[4] : theme.colors.gray[3]
    }`,
  },

  links: {
    marginLeft: -theme.spacing.md,
    marginRight: -theme.spacing.md,
  },

  linksInner: {
    paddingTop: theme.spacing.xl,
    paddingBottom: theme.spacing.xl,
  },

  footer: {
    marginLeft: -theme.spacing.md,
    marginRight: -theme.spacing.md,
    borderTop: `1px solid ${
      theme.colorScheme === "dark" ? theme.colors.dark[4] : theme.colors.gray[3]
    }`,
  },
}));

export function NavbarNested() {
  const { classes } = useStyles();
  const links = mockdata.map((item) => (
    <LinksGroup {...item} key={item.label} />
  ));

  const { toggleColorScheme, colorScheme } = useMantineColorScheme();
  const { session } = useAuth();

  return (
    <Navbar
      height={"100vh"}
      width={{ sm: 300 }}
      p="md"
      className={classes.navbar}
    >
      <Navbar.Section className={classes.header}>
        <Group position="apart">
          <Logo />
          <Group>
            <Code sx={{ fontWeight: 700 }}>0.0.1</Code>
            <ActionIcon
              variant="default"
              onClick={() => toggleColorScheme()}
              size={30}
            >
              {colorScheme === "dark" ? (
                <IconSun size={16} />
              ) : (
                <IconMoonStars size={16} />
              )}
            </ActionIcon>
          </Group>
        </Group>
      </Navbar.Section>

      <Navbar.Section grow className={classes.links} component={ScrollArea}>
        <div className={classes.linksInner}>{links}</div>
      </Navbar.Section>

      <Navbar.Section className={classes.footer}>
        <UserButton
          image={session?.user?.image || "Loading..."}
          name={session?.user?.name || "Loading..."}
          email={session?.user?.email || "Loading..."}
        />
      </Navbar.Section>
    </Navbar>
  );
}
