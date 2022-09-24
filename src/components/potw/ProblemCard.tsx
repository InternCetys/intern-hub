import {
  Paper,
  Group,
  Anchor,
  Title,
  Badge,
  Avatar,
  Tooltip,
} from "@mantine/core";
import { IconExternalLink } from "@tabler/icons";
import React, { useState } from "react";
import ProblemDrawer from "./ProblemDrawer";

interface Props {
  id: string;
  name: string;
  link: string;
  difficulty: string;
  solvedBy: string[];
}
const ProblemCard = ({ id, name, link, difficulty, solvedBy }: Props) => {
  const [openProblemDetailsDrawer, setOpenProblemDetailsDrawer] =
    useState(false);

  return (
    <>
      <Paper
        shadow={"md"}
        withBorder
        p={15}
        style={{ borderLeft: "5px solid green", cursor: "pointer" }}
        onClick={() => setOpenProblemDetailsDrawer(true)}
      >
        <Group position="apart">
          <Group>
            <Anchor>
              <Group spacing={10}>
                <Title order={5}>{name}</Title>
                <IconExternalLink size={20} />
              </Group>
            </Anchor>
            <Badge color="green">{difficulty}</Badge>
          </Group>
          <Avatar.Group spacing="sm">
            <Tooltip label="Daniel Barocio" withArrow>
              <Avatar radius="xl">DB</Avatar>
            </Tooltip>
            <Tooltip label="Oscar Encinas" withArrow>
              <Avatar radius="xl">OE</Avatar>
            </Tooltip>
          </Avatar.Group>
        </Group>
      </Paper>
      <ProblemDrawer
        name={name}
        onClose={() => setOpenProblemDetailsDrawer(false)}
        opened={openProblemDetailsDrawer}
        solvedBy={[]}
      />
    </>
  );
};

export default ProblemCard;
