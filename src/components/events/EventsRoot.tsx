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
  Box,
} from "@mantine/core";
import React, { useState, useEffect } from "react";
import NextEvent from "./NextEvent";
import FullCalendar from "@fullcalendar/react";
import interactionPlugin from "@fullcalendar/interaction";
import DayGridView from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";

const EventsRoot = () => {
  const [date, setDate] = useState(new Date());
  return (
    <Stack spacing="xl">
      <Title>Upcoming Events</Title>
      <Box sx={{ padding: "20px" }}>
        <Center>
          <NextEvent />
        </Center>
        <Box sx={{ padding: "20px 200px" }}>
          <FullCalendar
            plugins={[DayGridView, interactionPlugin]}
            events={[{ title: "platica Mau1", date: "2022-10-13" }]}
          />
        </Box>
      </Box>
    </Stack>
  );
};

export default EventsRoot;
