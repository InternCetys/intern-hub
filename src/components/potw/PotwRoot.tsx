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
import { getWeek } from "date-fns";
import Link from "next/link";
import React, { useState } from "react";
import { useUser } from "../../hooks/useUser";
import { getRelativeWeek } from "../../utils/dates";
import { trpc } from "../../utils/trpc";
import ProblemCard from "./ProblemCard";

type ProblemFilters = "ALL" | "NOT_SOLVED" | "FREQUENCY" | "DIFFICULTY";

const PotwRoot = () => {
  const [selectedFilter, setSelectedFilter] = useState<ProblemFilters>("ALL");
  const [selectedWeek, setSelectedWeek] = useState(getRelativeWeek());

  const { user } = useUser();

  const { data: problems, isLoading } = trpc.useQuery([
    "potw.getProblemsByWeek",
    { week: selectedWeek, filter: selectedFilter },
  ]);

  const { data: week, isLoading: isLoadingWeek } = trpc.useQuery([
    "potw.getCurrentWeek",
    selectedWeek,
  ]);

  const { data: resources, isLoading: isLoadingResources } = trpc.useQuery([
    "potw.getResourcesByWeek",
    { week: selectedWeek },
  ]);

  const handleNextWeek = () => {
    setSelectedWeek((prev) => Math.min(prev + 1, getRelativeWeek()));
  };

  const handlePreviousWeek = () => {
    setSelectedWeek((prev) => Math.max(1, prev - 1));
  };

  const handleCurrentWeek = () => {
    setSelectedWeek(getRelativeWeek());
  };

  return (
    <div>
      <Group>
        <Title>Problemas de la Semana</Title>
        <Code sx={{ fontWeight: 700 }}>2.0</Code>
      </Group>
      {isLoadingWeek && (
        <Skeleton visible={true} width="40%" height={40} mt={20}></Skeleton>
      )}
      <Group mt={10} position="apart">
        <Group>
          <Title order={2}>Tema: {week?.title}</Title>
          <Badge>Semana {selectedWeek}</Badge>
        </Group>
      </Group>
      <Group mt={10}>
        {resources &&
          resources.map((resource) => (
            <Paper
              withBorder
              shadow={"md"}
              p={10}
              key={resource.id}
              style={{ cursor: "pointer" }}
            >
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
        <Affix position={{ bottom: 70, right: 20 }}>
          <Link href={`admin/potw-manager/${week?.id}`}>
            <Button>Editar Problemas de la Semana</Button>
          </Link>
        </Affix>
      )}
      <Affix position={{ bottom: 20, right: 20 }}>
        <Group>
          <Button
            onClick={() => handlePreviousWeek()}
            disabled={selectedWeek === 1}
          >
            Semana Anterior
          </Button>
          <Button onClick={() => handleCurrentWeek()}>Semana Actual</Button>
          <Button
            onClick={() => handleNextWeek()}
            disabled={selectedWeek === getRelativeWeek()}
          >
            Siguiente Semana
          </Button>
        </Group>
      </Affix>
    </div>
  );
};

export default PotwRoot;
