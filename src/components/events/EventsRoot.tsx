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
import Calendar from "./Calendar";
import { trpc } from "../../utils/trpc";

const EventsRoot = () => {
  return (
    <Stack spacing="xl">
      <Title>Upcoming Events</Title>
      <Box sx={{ padding: "20px" }}>
        <Center>
          <NextEvent />
        </Center>
        <Box sx={{ padding: "20px 200px" }}>
          <Calendar />
        </Box>
      </Box>
    </Stack>
  );
};

export default EventsRoot;
