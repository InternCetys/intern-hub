import {
  Paper,
  Group,
  Anchor,
  Title,
  Badge,
  Avatar,
  Tooltip,
} from "@mantine/core";
import { User, UserStatusOnProblem } from "@prisma/client";
import { IconExternalLink } from "@tabler/icons";
import React, { useState } from "react";
import ProblemDrawer from "./ProblemDrawer";

interface Props {
  id: string;
  name: string;
  link: string;
  difficulty: string;
  solvedBy: (UserStatusOnProblem & { user: User })[];
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
            {solvedBy.map((user) => (
              <Tooltip label={user.user.name} withArrow>
                <Avatar radius="xl" src={user.user.image} />
              </Tooltip>
            ))}
          </Avatar.Group>
        </Group>
      </Paper>
      <ProblemDrawer
        problemId={id}
        name={name}
        onClose={() => setOpenProblemDetailsDrawer(false)}
        opened={openProblemDetailsDrawer}
        solvedBy={solvedBy}
      />
    </>
  );
};

export default ProblemCard;
