import {
  Affix,
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
  Skeleton,
  Stack,
  Text,
  Title,
  Tooltip,
} from "@mantine/core";
import { showNotification } from "@mantine/notifications";
import { IconBrandYoutube, IconExternalLink, IconLink } from "@tabler/icons";
import Link from "next/link";
import React, { useState } from "react";
import { useUser } from "../../hooks/useUser";
import { trpc } from "../../utils/trpc";
import ProblemCard from "./ProblemCard";

type ProblemFilters = "ALL" | "NOT_SOLVED" | "FREQUENCY" | "DIFFICULTY";

const PotwRoot = () => {
  const [selectedFilter, setSelectedFilter] = useState<ProblemFilters>("ALL");

  const { user } = useUser();

  const { data: problems, isLoading } = trpc.useQuery([
    "potw.getProblemsByWeek",
    { week: 1, filter: selectedFilter },
  ]);

  const { data: week, isLoading: isLoadingWeek } = trpc.useQuery([
    "potw.getCurrentWeek",
    1,
  ]);

  const { data: resources, isLoading: isLoadingResources } = trpc.useQuery([
    "potw.getResourcesByWeek",
    { week: 1 },
  ]);

  return (
    <div>
      <Group>
        <Title>Problemas de la Semana</Title>
        <Code sx={{ fontWeight: 700 }}>2.0</Code>
      </Group>
      {isLoadingWeek && (
        <Skeleton visible={true} width="40%" height={40} mt={20}></Skeleton>
      )}
      <Title order={2} mt={20}>
        Tema: {week?.title}
      </Title>
      <Group mt={10}>
        {resources &&
          resources.map((resource) => (
            <Paper withBorder shadow={"md"} p={10} key={resource.id}>
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
          value={selectedFilter}
          onChange={(value: ProblemFilters) => setSelectedFilter(value)}
          data={[
            { value: "ALL", label: "Todos" },
            { value: "DIFFICULTY", label: "Dificultad" },
            { value: "FREQUENCY", label: "Frecuencia" },
            { value: "NOT_SOLVED", label: "No resueltos" },
          ]}
        />
      </Paper>

      <Stack mt={30}>
        {isLoading && (
          <>
            <Skeleton visible={true}>
              <ProblemCard
                name=""
                difficulty="EASY"
                link=""
                id=""
                status={[]}
              />
            </Skeleton>
            <Skeleton visible={true}>
              <ProblemCard
                name=""
                difficulty="EASY"
                link=""
                id=""
                status={[]}
              />
            </Skeleton>
            <Skeleton visible={true}>
              <ProblemCard
                name=""
                difficulty="EASY"
                link=""
                id=""
                status={[]}
              />
            </Skeleton>
          </>
        )}
        {problems &&
          problems.map((problem) => (
            <ProblemCard
              key={problem.id}
              name={problem.title}
              difficulty={problem.difficulty}
              link={problem.link}
              id={problem.id}
              status={problem.userStatus}
            />
          ))}
      </Stack>
      {user?.admin && (
        <Affix position={{ bottom: 20, right: 20 }}>
          <Link href={`admin/potw-manager/${week?.id}`}>
            <Button>Editar Problemas de la Semana</Button>
          </Link>
        </Affix>
      )}
    </div>
  );
};

export default PotwRoot;
