import {
  Modal,
  Stack,
  TextInput,
  Select,
  Group,
  Button,
  Text,
  useMantineTheme,
  Center,
  Input,
  Textarea,
  Card,
  ActionIcon,
  Tabs,
  Affix,
} from "@mantine/core";
import React, { useState } from "react";
import BaseDemo from "./Dropzone";
import { Dropzone, IMAGE_MIME_TYPE } from "@mantine/dropzone";
import { useForm } from "@mantine/form";
import {
  IconUpload,
  IconX,
  IconPhoto,
  IconFile,
  IconTrash,
} from "@tabler/icons";
import { trpc } from "../../utils/trpc";
import type { InternSession, ResourceType } from "@prisma/client";
import { supabase } from "../../utils/supabase";
import { showNotification } from "@mantine/notifications";
import { useMutation } from "react-query";
import { applyValueAnnotations } from "superjson/dist/plainer";

interface Props {
  isCreateProjectOpen: boolean;
  setIsCreateProjectOpen: React.Dispatch<React.SetStateAction<boolean>>;
}

interface FormTypes {
  title: string;
  description: string;
  image: File | null;
  repo: string;
}

const utils = trpc.useContext();

  const form = useForm<FormTypes>({
    initialValues: {
      title: "",
      description: "",
      image: null,
      repo: "",
    },

    validate: {
      title: (value) => (value.length > 0 ? null : "El título es requerido"),
      description: (value) =>
        value.length > 0 ? null : "La descripción es requerida",
      repo: (value) =>
        value.length > 0 ? null : "El link del repositorio de github es requerido",
    },
  });

function ProjectForm() {
    const [opened, setOpened] = useState(false);
    return (
        <>
          <Modal
            opened={opened}
            onClose={() => setOpened(false)}
            title="Upload a new project"
          >
            <TextInput
                placeholder='e.g: "RackDAT"'
                label="Project name"
                withAsterisk
            />
            <Textarea
                placeholder="Try to explain what is your project, and that shit"
                label="Project description"
                withAsterisk
                mt={5}
            />
            <BaseDemo></BaseDemo>
            <TextInput
                placeholder="Repository"
                label="Github repo"
                withAsterisk
                mt={5}
            />
          </Modal>
            <Affix position={{ bottom: 20, right: 20 }}>
              <Button onClick={() => setOpened(true)}> Upload new project </Button>
            </Affix>
        </>
    )
}

export default ProjectForm;