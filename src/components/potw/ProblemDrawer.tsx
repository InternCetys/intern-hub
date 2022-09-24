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
import React from "react";

interface Props {
  opened: boolean;
  onClose: () => void;
  name: string;
  solvedBy: string[];
}

const ProblemDrawer = ({ opened, onClose, name }: Props) => {
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
        <Paper withBorder shadow="md" p={10}>
          <Group position="apart">
            <Group>
              <Avatar />
              <Title order={5}>Daniel</Title>
            </Group>
            <Badge color={"green"}>Resuelto</Badge>
          </Group>
        </Paper>
        <Paper withBorder shadow="md" p={10}>
          <Group position="apart">
            <Group>
              <Avatar />
              <Title order={5}>Oscar</Title>
            </Group>
            <Badge color="green">Resuelto</Badge>
          </Group>
        </Paper>
        <Paper withBorder shadow="md" p={10}>
          <Group position="apart">
            <Group>
              <Avatar />
              <Title order={5}>Adrian</Title>
            </Group>
            <Badge>En progreso</Badge>
          </Group>
        </Paper>
        <Paper withBorder shadow="md" p={10}>
          <Group position="apart">
            <Group>
              <Avatar />
              <Title order={5}>Solis</Title>
            </Group>
            <Badge color="gray">No iniciado</Badge>
          </Group>
        </Paper>
      </Stack>
      <Stack>
        <Button fullWidth>Marcar como en progreso</Button>
        <Button fullWidth color="green">
          Marcar como resuelto
        </Button>
      </Stack>
    </Drawer>
  );
};

export default ProblemDrawer;
