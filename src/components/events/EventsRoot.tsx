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
import React from "react";
import NextEvent from "./NextEvent";

const EventsRoot = () => {
  return (
    <Stack spacing="xl">
      <Title>Upcoming Events</Title>
      <Center mt="20px">
        <NextEvent />
      </Center>
    </Stack>
  );
};

export default EventsRoot;
