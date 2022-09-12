import {
  Badge,
  Button,
  Card,
  Group,
  Title,
  Text,
  Grid,
  TextInput,
  Modal,
  Select,
  Stack,
} from "@mantine/core";
import { IconFile } from "@tabler/icons";
import Image from "next/image";
import React, { useState } from "react";

const ResourcesRoot = () => {
  const [isCreateResourceOpen, setIsCreateResourceOpen] = useState(false);
  return (
    <>
      <Title>Resources</Title>
      <TextInput label="Search Resources" mt={20} />
      <Grid mt={30}>
        <Grid.Col span={4}>
          <Card shadow="sm" p="lg" radius="md" withBorder>
            <IconFile />
            <Group position="apart" mt="md" mb="xs">
              <Text weight={500}>Presentacion Proyectos</Text>
              <Badge color="pink" variant="light">
                Slides
              </Badge>
            </Group>

            <Text size="sm" color="dimmed">
              Como crear un proyecto nuevo
            </Text>
            <Button variant="light" color="blue" fullWidth mt="md" radius="md">
              Descargar
            </Button>
          </Card>
        </Grid.Col>
        <Grid.Col span={4}>
          <Card shadow="sm" p="lg" radius="md" withBorder>
            <IconFile />
            <Group position="apart" mt="md" mb="xs">
              <Text weight={500}>Presentacion Proyectos</Text>
              <Badge color="pink" variant="light">
                Slides
              </Badge>
            </Group>

            <Text size="sm" color="dimmed">
              Como crear un proyecto nuevo
            </Text>
            <Button variant="light" color="blue" fullWidth mt="md" radius="md">
              Descargar
            </Button>
          </Card>
        </Grid.Col>
        <Grid.Col span={4}>
          <Card shadow="sm" p="lg" radius="md" withBorder>
            <IconFile />
            <Group position="apart" mt="md" mb="xs">
              <Text weight={500}>Presentacion Proyectos</Text>
              <Badge color="pink" variant="light">
                Slides
              </Badge>
            </Group>

            <Text size="sm" color="dimmed">
              Como crear un proyecto nuevo
            </Text>
            <Button variant="light" color="blue" fullWidth mt="md" radius="md">
              Descargar
            </Button>
          </Card>
        </Grid.Col>
      </Grid>
      <Button
        style={{ position: "absolute", right: 10, bottom: 10 }}
        onClick={() => setIsCreateResourceOpen(true)}
      >
        Add Resource
      </Button>
      <Modal
        opened={isCreateResourceOpen}
        onClose={() => setIsCreateResourceOpen(false)}
        title="Add Resource"
      >
        <Stack>
          <TextInput label="Title" />
          <TextInput label="Description" />
          <Select
            label="Category"
            searchable
            data={[
              { label: "Slides", value: "slide" },
              { label: "Website", value: "website" },
              { label: "Document", value: "document" },
              { label: "Video", value: "video" },
            ]}
          />
          <Select
            label="Linked Session"
            searchable
            data={[
              { label: "Slides", value: "slide" },
              { label: "Website", value: "website" },
              { label: "Document", value: "document" },
              { label: "Video", value: "video" },
            ]}
          />
        </Stack>
      </Modal>
    </>
  );
};

export default ResourcesRoot;
