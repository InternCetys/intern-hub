import {
  Group,
  Paper,
  Timeline,
  Title,
  Text,
  Stack,
  Button,
  Image,
  Center,
} from "@mantine/core";
import React, { useState, useEffect } from "react";
import NextEvent from "./NextEvent";
import FullCalendar from "@fullcalendar/react";
import interactionPlugin from "@fullcalendar/interaction";
import timeGridPlugin from "@fullcalendar/timegrid";

const EventsRoot = () => {
  const [date, setDate] = useState(new Date());
  console.log(date);
  return (
    <Stack spacing="xl">
      <Title>Upcoming Events</Title>
      <Center mt="20px">
        <NextEvent />
        <FullCalendar plugins={[timeGridPlugin, interactionPlugin]} />
      </Center>
    </Stack>
  );
};

export default EventsRoot;
