import {
  Paper,
  Group,
  Anchor,
  Title,
  Badge,
  Avatar,
  Tooltip,
  Dialog,
  useMantineTheme,
} from "@mantine/core";
import { ProblemDifficulty, User, UserStatusOnProblem } from "@prisma/client";
import { IconExternalLink } from "@tabler/icons";
import React, { useCallback, useMemo, useState } from "react";
import { useUser } from "../../hooks/useUser";
import ProblemDrawer from "./ProblemDrawer";

interface Props {
  id: string;
  name: string;
  link: string;
  difficulty: ProblemDifficulty;
  status: (UserStatusOnProblem & { user: User })[];
}

const DifficultyBadgeColor = {
  EASY: "green",
  MEDIUM: "yellow",
  HARD: "red",
  INSANE: "violet",
};

const ProblemCard = ({ id, name, link, difficulty, status }: Props) => {
  const [openProblemDetailsDrawer, setOpenProblemDetailsDrawer] =
    useState(false);

  const theme = useMantineTheme();

  const { user } = useUser();
  const solvedBy = useMemo(() => {
    return status.filter((s) => s.status === "SOLVED");
  }, [status]);

  const solvedBySpliced = useMemo(() => {
    return status
      .filter((s) => s.status === "SOLVED")
      .splice(0, Math.min(4, status.length));
  }, [status]);

  const userSolved = useMemo(() => {
    if (!user) return false;
    return !!status.find((s) => s.userId === user.id && s.status === "SOLVED");
  }, [status, user]);

  const userAttempted = useMemo(() => {
    if (!user) return false;
    return !!status.find(
      (s) => s.userId === user.id && s.status === "ATTEMPTED"
    );
  }, [status, user]);

  return (
    <>
      <Paper
        shadow={"md"}
        withBorder
        p={15}
        style={{
          borderLeft: `5px solid ${
            theme.colors[DifficultyBadgeColor[difficulty]][4]
          }`,
        }}
      >
        <Group position="apart">
          <Group>
            <Anchor href={link} target="_blank">
              <Group spacing={10}>
                <Title order={5}>{name}</Title>
                <IconExternalLink size={20} />
              </Group>
            </Anchor>
            <Badge color={DifficultyBadgeColor[difficulty]}>{difficulty}</Badge>
            {userSolved && <Badge color={"yellow"}>Solved</Badge>}
            {userAttempted && <Badge color={"blue"}>Attempted</Badge>}
          </Group>
          {/* <pre>{JSON.stringify(solvedBy, null, 2)}</pre> */}
          <Avatar.Group
            spacing="sm"
            onClick={() => setOpenProblemDetailsDrawer(true)}
            style={{ cursor: "pointer" }}
          >
            {solvedBySpliced.map((user) => (
              <Tooltip label={user.user.name} withArrow key={user.userId}>
                <Avatar radius="xl" src={user.user.image} />
              </Tooltip>
            ))}
            <Avatar radius="xl">
              {solvedBy.length - solvedBySpliced.length}+
            </Avatar>
          </Avatar.Group>
        </Group>
      </Paper>
      <ProblemDrawer
        problemId={id}
        name={name}
        onClose={() => setOpenProblemDetailsDrawer(false)}
        opened={openProblemDetailsDrawer}
        status={status}
      />
    </>
  );
};

export default ProblemCard;
