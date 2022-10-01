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
  status: (UserStatusOnProblem & { user: User })[];
}

const badgeColor = {
  NOT_ATTEMPTED: "gray",
  ATTEMPTED: "blue",
  SOLVED: "green",
};

const ProblemDrawer = ({ problemId, opened, onClose, name, status }: Props) => {
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
        {status.length === 0 && (
          <Paper shadow="sm" p="xl" withBorder>
            No hay usuarios que hayan intentado este problema
          </Paper>
        )}
        <Stack style={{ overflowY: "auto", height: "75vh" }}>
          {status.map((user) => (
            <Paper withBorder shadow="md" p={10} key={user.userId}>
              <Group position="apart">
                <Group>
                  <Avatar src={user.user.image} radius="xl" />
                  <Title order={5}>{user.user.name}</Title>
                </Group>
                <Badge color={badgeColor[user.status]}>{user.status}</Badge>
              </Group>
            </Paper>
          ))}
        </Stack>
      </Stack>
      <Stack>
        <Button
          fullWidth
          onClick={() => handleUpdateUserStatus("ATTEMPTED")}
          loading={updateUserStatus.isLoading}
        >
          Marcar como en progreso
        </Button>
        <Button
          fullWidth
          color="green"
          onClick={() => handleUpdateUserStatus("SOLVED")}
          loading={updateUserStatus.isLoading}
        >
          Marcar como resuelto
        </Button>
      </Stack>
    </Drawer>
  );
};

export default ProblemDrawer;
