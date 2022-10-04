import {
  Grid,
  Paper,
  Title,
  Text,
  Stack,
  Group,
  Button,
  Affix,
} from "@mantine/core";
import Link from "next/link";
import React, { useState } from "react";
import { trpc } from "../../utils/trpc";
import NewWeekModal from "./NewWeekModal";

const PotwManagerRoot = () => {
  const { data: weeks, isLoading: isLoadingWeeks } = trpc.useQuery([
    "potw.getAllWeeks",
  ]);

  const [isModalOpen, setIsModalOpen] = useState(false);

  return (
    <>
      <Title>POTW Manager</Title>
      <Title order={2} mt={30}>
        Semanas
      </Title>
      <Grid mt={10}>
        {weeks &&
          weeks.map((week) => (
            <Grid.Col span={4} key={week.id}>
              <Link href={`potw-manager/${week.id}`}>
                <Paper withBorder shadow={"md"} p={10}>
                  <Title order={5}>Semana #{week.number}</Title>
                  <Text>{week.title}</Text>
                </Paper>
              </Link>
            </Grid.Col>
          ))}
      </Grid>
      <Affix position={{ bottom: 20, right: 20 }}>
        <Button onClick={() => setIsModalOpen(true)}>Crear Semana</Button>
      </Affix>
      <NewWeekModal
        opened={isModalOpen}
        onClose={() => setIsModalOpen(false)}
      />
    </>
  );
};

export default PotwManagerRoot;
