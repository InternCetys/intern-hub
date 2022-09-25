import {
  Accordion,
  Avatar,
  Button,
  Card,
  Group,
  NumberInput,
  Stack,
  Title,
  Text,
} from "@mantine/core";
import { useRouter } from "next/router";
import React from "react";
import { trpc } from "../../utils/trpc";
import EditProblemContent from "./EditProblemContent";
import EditResourceContent from "./EditResourceContent";
import EditWeekContent from "./EditWeekContent";

const charactersList = [
  {
    id: "bender",
    image:
      "https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/000000/external-content-influencer-marketing-flaticons-lineal-color-flat-icons-9.png",
    label: "Editar contenido de la semana",
    description: "Numero y titulo",
  },

  {
    id: "carol",
    image:
      "https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/000000/external-videos-modelling-agency-flaticons-lineal-color-flat-icons-2.png",
    label: "Editar recursos de la semana",
    description: "Tutoriales, videos, etc",
  },

  {
    id: "homer",
    image: "https://img.icons8.com/clouds/100/000000/box-important.png",
    label: "Editar problemas de la semana",
    description: "Dificultad, orden, temas, etc.",
  },
];

interface AccordionLabelProps {
  label: string;
  image: string;
  description: string;
}

const WeekEditorRoot = () => {
  const router = useRouter();
  const weekId = router.query.week as string;

  const {
    data: currentWeek,
    isLoading: isLoadingWeek,
    isFetching: isFetchingWeek,
  } = trpc.useQuery(["potw.getCurrentWeekById", weekId]);

  const accordionChildren = [
    <EditWeekContent
      name={currentWeek?.title || ""}
      number={currentWeek?.number || 0}
    />,
    <EditResourceContent />,
    <EditProblemContent
      weekNumber={currentWeek?.number || 0}
      weekId={weekId}
    />,
  ];
  const items = charactersList.map((item, i) => (
    <Accordion.Item value={item.id} key={item.label}>
      <Accordion.Control>
        <AccordionLabel {...item} />
      </Accordion.Control>
      <Accordion.Panel>{accordionChildren[i]}</Accordion.Panel>
    </Accordion.Item>
  ));

  return (
    <>
      <Title>Semana {currentWeek?.number}</Title>
      {!isLoadingWeek && (
        <Accordion chevronPosition="right" variant="contained" mt={20}>
          {items}
        </Accordion>
      )}
    </>
  );
};

export default WeekEditorRoot;

function AccordionLabel({ label, image, description }: AccordionLabelProps) {
  return (
    <Group noWrap>
      <Avatar src={image} radius="xl" size="lg" />
      <div>
        <Text>{label}</Text>
        <Text size="sm" color="dimmed" weight={400}>
          {description}
        </Text>
      </div>
    </Group>
  );
}
