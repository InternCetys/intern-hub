import {
  Avatar,
  Badge,
  Button,
  Drawer,
  Group,
  Paper,
  Stack,
  Title,
} from "@mantine/core";
import { showNotification } from "@mantine/notifications";
import { ProblemStatus, UserStatusOnProblem } from "@prisma/client";
import { User } from "next-auth";
import React from "react";
import { trpc } from "../../utils/trpc";

interface Props {
  problemId: string;
  opened: boolean;
  onClose: () => void;
  name: string;
  solvedBy: (UserStatusOnProblem & { user: User })[];
}

const ProblemDrawer = ({
  problemId,
  opened,
  onClose,
  name,
  solvedBy,
}: Props) => {
  const updateUserStatus = trpc.useMutation(["potw.updateProblemUserStatus"]);

  const utils = trpc.useContext();

  const handleUpdateUserStatus = async (status: ProblemStatus) => {
    updateUserStatus.mutate(
      {
        problem: problemId,
        status: status,
      },
      {
        onSuccess: () => {
          utils.invalidateQueries(["potw.getProblemsByWeek"]);
        },
        onError: () => {
          showNotification({
            message: "Error al actualizar tu status",
            color: "red",
          });
        },
      }
    );
  };

  return (
    <Drawer
      opened={opened}
      onClose={onClose}
      title={name}
      position="right"
      padding="xl"
      size="xl"
    >
      <Title order={4}>Status</Title>
      <Stack my={20}>
        {solvedBy.map((user) => (
          <Paper withBorder shadow="md" p={10}>
            <Group position="apart">
              <Group>
                <Avatar />
                <Title order={5}>{user.user.name}</Title>
              </Group>
              <Badge color={"green"}>{user.status}</Badge>
            </Group>
          </Paper>
        ))}
      </Stack>
      <Stack>
        <Button fullWidth onClick={() => handleUpdateUserStatus("ATTEMPTED")}>
          Marcar como en progreso
        </Button>
        <Button
          fullWidth
          color="green"
          onClick={() => handleUpdateUserStatus("SOLVED")}
        >
          Marcar como resuelto
        </Button>
      </Stack>
    </Drawer>
  );
};

export default ProblemDrawer;
