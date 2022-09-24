import {
  Anchor,
  Avatar,
  Badge,
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
import { IconBrandYoutube, IconExternalLink, IconLink } from "@tabler/icons";
import React from "react";
import ProblemCard from "./ProblemCard";

const PotwRoot = () => {
  return (
    <div>
      <Group>
        <Title>Problemas de la Semana</Title>
        <Code sx={{ fontWeight: 700 }}>2.0</Code>
      </Group>
      <Title order={2} mt={20}>
        Tema: Arreglos
      </Title>
      <Group mt={10}>
        <Paper withBorder shadow={"md"} p={10}>
          <Group>
            <IconBrandYoutube />
            <Text>Tutorial de Arreglos</Text>
          </Group>
        </Paper>
        <Paper withBorder shadow={"md"} p={10} style={{ cursor: "pointer" }}>
          <Group>
            <IconBrandYoutube />
            <Text>Técnica de Dos Punteros</Text>
          </Group>
        </Paper>
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
        <ProblemCard name="Two Sum" difficulty="Easy" />
      </Stack>
    </div>
  );
};

export default PotwRoot;
