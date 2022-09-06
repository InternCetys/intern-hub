import { Button, Group, Paper, Stack, Title, Text, Image } from "@mantine/core";
import { IconCalendarPlus } from "@tabler/icons";
const NextEvent = () => {
  return (
    <Paper shadow="lg" withBorder style={{ width: "70%" }}>
      <Group position="apart">
        <Stack
          spacing="xl"
          p="md"
          style={{ border: "0px solid black", height: "300px" }}
          justify="space-between"
        >
          <Stack style={{ border: "0px solid black" }}>
            <Title>Next Event</Title>
            <Text color="dimmed" italic size={"lg"}>
              Para cuando
            </Text>
            <Text>Descricion del evento</Text>
          </Stack>
          <Button leftIcon={<IconCalendarPlus />}>Add a google calendar</Button>
        </Stack>
        <div style={{ padding: 0, width: "50%" }}>
          <Image
            radius="md"
            src="https://images.unsplash.com/photo-1511216335778-7cb8f49fa7a3?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=720&q=80"
            alt="imagen descriptiva"
          />
        </div>
      </Group>
    </Paper>
  );
};
export default NextEvent;
