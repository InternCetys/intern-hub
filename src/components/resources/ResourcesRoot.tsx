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
  Loader,
} from "@mantine/core";
import { Dropzone, IMAGE_MIME_TYPE } from "@mantine/dropzone";
import { useDebouncedState } from "@mantine/hooks";
import { IconFile, IconPhoto, IconUpload, IconX } from "@tabler/icons";
import Image from "next/image";
import React, { useState } from "react";
import { useUser } from "../../hooks/useUser";
import { trpc } from "../../utils/trpc";
import NewResourceModal from "./NewResourceModal";
import ResourceCard from "./ResourceCard";

const ResourcesRoot = () => {
  const [isCreateResourceOpen, setIsCreateResourceOpen] = useState(false);

  const [searchQuery, setSearchQuery] = useDebouncedState("", 500);

  const { user } = useUser();

  const { isLoading, data: resources } = trpc.useQuery([
    "resource.getResources",
    { query: searchQuery },
  ]);

  return (
    <>
      <Group>
        <Title>Resources</Title>
        {isLoading && <Loader />}
      </Group>
      <TextInput
        label="Search Resources"
        mt={20}
        onChange={(e) => setSearchQuery(e.target.value)}
      />
      <Grid mt={30}>
        {resources?.map((resource) => (
          <Grid.Col span={4} key={resource.id}>
            <ResourceCard
              title={resource.title}
              description={resource.description}
              type={resource.type}
              url={resource.link}
              internSession={resource.internSession}
            />
          </Grid.Col>
        ))}
      </Grid>
      {user && user.admin && (
        <>
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
      )}
    </>
  );
};

export default ResourcesRoot;
