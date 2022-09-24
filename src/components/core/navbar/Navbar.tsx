import {
  Navbar,
  Group,
  Code,
  ScrollArea,
  createStyles,
  ActionIcon,
  useMantineColorScheme,
  Menu,
} from "@mantine/core";
import {
  IconNotes,
  IconCalendarStats,
  IconGauge,
  IconPresentationAnalytics,
  IconTrophy,
  IconSun,
  IconMoonStars,
  IconLogout,
  IconUser,
  IconLock,
  IconFile,
} from "@tabler/icons";
import { UserButton } from "./UserButton";
import { LinksGroup } from "./LinksGroup";
import Logo from "../Logo";
import { useColorScheme } from "@mantine/hooks";
import { useAuth } from "../../../hooks/useAuth";
import { useState } from "react";
import { signOut } from "next-auth/react";

const userLinks = [
  {
    label: "Dashboard",
    icon: IconGauge,
    link: "/app/dashboard",
    disabled: true,
  },
  {
    label: "Problemas de la Semana",
    icon: IconNotes,
    link: "/app/potw",
  },
  {
    label: "Eventos",
    icon: IconCalendarStats,
    link: "/app/events",
    disabled: true,
  },
  {
    label: "Galería de Proyectos",
    icon: IconPresentationAnalytics,
    link: "/app/projects",
    disabled: true,
  },
  {
    label: "Recursos",
    icon: IconFile,
    link: "/app/resources",
  },
  {
    label: "Concursos",
    icon: IconTrophy,
    link: "/app/contest",
    disabled: true,
  },
];

const adminLinks = [
  {
    label: "Admin",
    icon: IconLock,
    links: [
      { label: "Usuarios Activos", link: "/app/admin/attendance" },
      { label: "Stats", link: "/app/admin/stats" },
    ],
  },
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

interface Props {
  isAdmin: boolean;
}

export function NavbarNested({ isAdmin }: Props) {
  const { classes } = useStyles();

  const mergedLinks = [...userLinks, ...(isAdmin ? adminLinks : [])];

  const links = mergedLinks.map((item) => (
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

      <Menu
        trigger="hover"
        openDelay={100}
        closeDelay={100}
        width={200}
        position={"right-end"}
        withArrow
      >
        <Menu.Target>
          <Navbar.Section className={classes.footer}>
            <UserButton
              admin={isAdmin}
              image={session?.user?.image || "Loading..."}
              name={session?.user?.name || "Loading..."}
              email={session?.user?.email || "Loading..."}
            />
          </Navbar.Section>
        </Menu.Target>
        <Menu.Dropdown>
          <Menu.Label>Configuracion</Menu.Label>
          <Menu.Item icon={<IconUser />}>Perfil</Menu.Item>
          <Menu.Item
            icon={<IconLogout />}
            color={"red"}
            onClick={() => signOut({ redirect: true, callbackUrl: "/login" })}
          >
            Cerrar Sesion
          </Menu.Item>
        </Menu.Dropdown>
      </Menu>
    </Navbar>
  );
}
