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
  useMantineTheme,
} from "@mantine/core";
import { Dropzone, IMAGE_MIME_TYPE } from "@mantine/dropzone";
import { IconFile, IconPhoto, IconUpload, IconX } from "@tabler/icons";
import Image from "next/image";
import React, { useState } from "react";
import { trpc } from "../../utils/trpc";
import NewResourceModal from "./NewResourceModal";
import ResourceCard from "./ResourceCard";

const ResourcesRoot = () => {
  const [isCreateResourceOpen, setIsCreateResourceOpen] = useState(false);

  const { isLoading, data: resources } = trpc.useQuery([
    "resource.getResources",
  ]);

  return (
    <>
      <Title>Resources</Title>
      <TextInput label="Search Resources" mt={20} />
      <Grid mt={30}>
        {resources?.map((resource) => (
          <Grid.Col span={4} key={resource.id}>
            <ResourceCard
              title={resource.title}
              description={resource.description}
              type={resource.type}
              url={resource.link}
            />
          </Grid.Col>
        ))}
      </Grid>
      <Button
        style={{ position: "absolute", right: 10, bottom: 10 }}
        onClick={() => setIsCreateResourceOpen(true)}
      >
        Add Resource
      </Button>
      <NewResourceModal
        isCreateResourceOpen={isCreateResourceOpen}
        setIsCreateResourceOpen={setIsCreateResourceOpen}
      />
    </>
  );
};

export default ResourcesRoot;
