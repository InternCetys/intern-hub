import {
  Center,
  Title,
  Text,
  Container,
  createStyles,
  Button,
} from "@mantine/core";
import { signOut } from "next-auth/react";
import React from "react";

const useStyles = createStyles((theme) => ({
  root: {
    paddingTop: 80,
    paddingBottom: 80,
  },

  label: {
    textAlign: "center",
    fontWeight: 900,
    fontSize: 220,
    lineHeight: 1,
    marginBottom: theme.spacing.xl * 1.5,
    color:
      theme.colorScheme === "dark"
        ? theme.colors.dark[4]
        : theme.colors.gray[2],

    [theme.fn.smallerThan("sm")]: {
      fontSize: 120,
    },
  },

  title: {
    fontFamily: `Greycliff CF, ${theme.fontFamily}`,
    textAlign: "center",
    fontWeight: 900,
    fontSize: 38,

    [theme.fn.smallerThan("sm")]: {
      fontSize: 32,
    },
  },

  description: {
    maxWidth: 500,
    margin: "auto",
    marginTop: theme.spacing.xl,
    marginBottom: theme.spacing.xl * 1.5,
  },
}));

const NoAccess = () => {
  const { classes } = useStyles();
  return (
    <Container className={classes.root}>
      <div className={classes.label}>ERROR</div>
      <Title className={classes.title}>
        Oops, no eres parte de Club Intern
      </Title>
      <Text
        color="dimmed"
        size="lg"
        align="center"
        className={classes.description}
      >
        Si esto es un error, comunícate con cualquier admin para que te de
        acceso
      </Text>
      <Center>
        <Button
          onClick={() => signOut({ redirect: true, callbackUrl: "/login" })}
        >
          Cerrar Sesion
        </Button>
      </Center>
    </Container>
  );
};

export default NoAccess;
