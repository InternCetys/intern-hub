import {
  Anchor,
  Avatar,
  Badge,
  Button,
  Card,
  Code,
  Group,
  Paper,
  Popover,
  SegmentedControl,
  Stack,
  Text,
  Title,
  Tooltip,
} from "@mantine/core";
import { showNotification } from "@mantine/notifications";
import { IconBrandYoutube, IconExternalLink, IconLink } from "@tabler/icons";
import React from "react";
import { trpc } from "../../utils/trpc";
import ProblemCard from "./ProblemCard";

const PotwRoot = () => {
  const { data: problems, isLoading } = trpc.useQuery([
    "potw.getProblemsByWeek",
    { week: 1, filter: "ALL" },
  ]);

  const { data: week, isLoading: isLoadingWeek } = trpc.useQuery([
    "potw.getCurrentWeek",
    1,
  ]);

  const { data: resources, isLoading: isLoadingResources } = trpc.useQuery([
    "potw.getResourcesByWeek",
    { week: 1 },
  ]);

  const utils = trpc.useContext();

  const createWeek = trpc.useMutation(["potw.createWeek"]);
  const createProblem = trpc.useMutation(["potw.createProblem"]);

  const handleCreateWeek = async () => {
    createWeek.mutate(
      {
        number: 1,
        name: "Arreglos",
      },
      {
        onSuccess: () => {
          utils.invalidateQueries(["potw.getCurrentWeek"]);
          utils.invalidateQueries(["potw.getProblemsByWeek"]);
        },
        onError: () => {
          showNotification({
            message: "Error al crear la semana",
            color: "red",
          });
        },
      }
    );
  };

  const handleCreateProblem = async () => {
    if (!week) return;

    createProblem.mutate(
      {
        title: "Two Sum",
        difficulty: "INSANE",
        week: week?.id,
        link: "https://leetcode.com",
      },
      {
        onSuccess: () => {
          utils.invalidateQueries(["potw.getProblemsByWeek"]);
        },
        onError: () => {
          showNotification({
            message: "Error al crear problema",
            color: "red",
          });
        },
      }
    );
  };

  return (
    <div>
      <Group>
        <Title>Problemas de la Semana</Title>
        <Code sx={{ fontWeight: 700 }}>2.0</Code>
      </Group>
      <Title order={2} mt={20}>
        Tema: {week?.title}
      </Title>
      <Group mt={10}>
        {resources &&
          resources.map((resource) => (
            <Paper withBorder shadow={"md"} p={10}>
              <Group>
                <IconBrandYoutube />
                <Text>{resource.title}</Text>
              </Group>
            </Paper>
          ))}
      </Group>

      <Paper mt={20}>
        <Text weight={700}>Filtrar por:</Text>
        <SegmentedControl
          data={[
            { value: "diff", label: "Dificultad" },
            { value: "freq", label: "Frecuencia" },
            { value: "unso", label: "No resueltos" },
          ]}
        />
      </Paper>

      <Stack mt={10}>
        {problems &&
          problems.map((problem) => (
            <ProblemCard
              name={problem.title}
              difficulty={problem.difficulty}
              link={problem.link}
              id={problem.id}
              status={problem.userStatus}
            />
          ))}
      </Stack>
      <Button onClick={handleCreateWeek}>Crear Semana</Button>
      <Button onClick={handleCreateProblem}>Crear Problema</Button>
    </div>
  );
};

export default PotwRoot;
