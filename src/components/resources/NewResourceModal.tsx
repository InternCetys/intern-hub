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
} from "@mantine/core";
import { Dropzone, IMAGE_MIME_TYPE } from "@mantine/dropzone";
import { useForm } from "@mantine/form";
import {
  IconUpload,
  IconX,
  IconPhoto,
  IconFile,
  IconTrash,
} from "@tabler/icons";
import React, { forwardRef, useState } from "react";
import { trpc } from "../../utils/trpc";
import type { InternSession, ResourceType } from "@prisma/client";
import ResourceDropzone from "./ResourceDropzone";
import { supabase } from "../../utils/supabase";
import { showNotification } from "@mantine/notifications";
import { useMutation } from "react-query";

interface Props {
  isCreateResourceOpen: boolean;
  setIsCreateResourceOpen: React.Dispatch<React.SetStateAction<boolean>>;
}

interface FormTypes {
  title: string;
  description: string;
  type: ResourceType | "";
  session: string;
  file: File | null;
  link: string;
}
const resourceTypeSelectItems: Array<{ label: string; value: ResourceType }> = [
  { label: "Document", value: "DOCUMENT" },
  { label: "Video", value: "VIDEO" },
  { label: "Slides", value: "SLIDES" },
  { label: "PDF", value: "PDF" },
  { label: "Other", value: "OTHER" },
];

const NewResourceModal = ({
  isCreateResourceOpen,
  setIsCreateResourceOpen,
}: Props) => {
  const { isLoading: isLoadingInternSessions, data: internSessions } =
    trpc.useQuery(["internSessions.getInternSessionsForSelectInput"]);

  const [isUploadingFile, setIsUploadingFile] = useState(false);
  const [activeTab, setActiveTab] = useState<string | null>("file");

  const utils = trpc.useContext();

  const form = useForm<FormTypes>({
    initialValues: {
      title: "",
      description: "",
      type: "",
      session: "",
      file: null,
      link: "",
    },
    validate: {
      title: (value) => (value.length > 0 ? null : "El título es requerido"),
      description: (value) =>
        value.length > 0 ? null : "La descripción es requerida",
      type: (value: ResourceType) =>
        value.length > 0 ? null : "El tipo es requerido",
      session: (value) => (value.length > 0 ? null : "La sesión es requerida"),
    },
  });

  const handleFormSubmit = async (values: FormTypes) => {
    if (activeTab === "link") {
      if (values.type === "") {
        return;
      }
      createResource.mutate({
        title: values.title,
        description: values.description,
        type: values.type,
        fileURL: values.link,
        session: values.session,
      });
      return;
    }

    if (values.file === null) {
      showNotification({ message: "Por favor sube un archivo", color: "red" });
      return;
    }

    setIsUploadingFile(true);

    const fileLink = await supabase.storage
      .from("resources")
      .upload("public/" + values.file.name, values.file);

    setIsUploadingFile(false);

    if (fileLink.error) {
      showNotification({ message: "Error uploading file", color: "red" });
      return;
    }

    if (values.type === "") {
      return;
    }

    createResource.mutate({
      title: values.title,
      description: values.description,
      type: values.type,
      fileURL: fileLink.data.path,
      session: values.session,
    });

    setIsCreateResourceOpen(false);
    form.reset();
  };

  const createResource = trpc.useMutation(["resource.createResource"], {
    onSuccess: () => {
      utils.invalidateQueries("resource.getResources");
      showNotification({ message: "Recurso creado", color: "green" });
      setIsCreateResourceOpen(false);
    },
  });

  return (
    <Modal
      opened={isCreateResourceOpen}
      onClose={() => setIsCreateResourceOpen(false)}
      title="Add Resource"
    >
      <form onSubmit={form.onSubmit(handleFormSubmit)}>
        <Stack>
          <TextInput
            label="Título"
            {...form.getInputProps("title")}
            withAsterisk
          />
          <Textarea
            withAsterisk
            label="Descripción"
            {...form.getInputProps("description")}
          />
          <Select
            withAsterisk
            label="Tipo"
            searchable
            data={resourceTypeSelectItems}
            {...form.getInputProps("type")}
          />
          <Select
            withAsterisk
            label="Sesión de Intern"
            searchable
            data={internSessions || []}
            itemComponent={SelectItem}
            disabled={isLoadingInternSessions}
            {...form.getInputProps("session")}
          />
          <Tabs
            defaultValue="file"
            value={activeTab}
            onTabChange={setActiveTab}
          >
            <Tabs.List>
              <Tabs.Tab value="file">Archivo</Tabs.Tab>
              <Tabs.Tab value="link">Link</Tabs.Tab>
            </Tabs.List>
            <Tabs.Panel value="file" pt="xs">
              <Input.Wrapper label="Subir Archivo">
                <ResourceDropzone
                  onDrop={(file) => form.setFieldValue("file", file)}
                  onReject={(error) => form.setErrors({ file: error })}
                  isLoading={isUploadingFile}
                />
              </Input.Wrapper>
              {form.values.file && (
                <Card shadow={"sm"} withBorder mt="xs">
                  <Group position="apart">
                    <Group>
                      <IconFile />
                      {form.values.file.name}
                    </Group>
                    <ActionIcon
                      color={"red"}
                      variant={"light"}
                      onClick={() => form.setFieldValue("file", null)}
                    >
                      <IconTrash size={20} />
                    </ActionIcon>
                  </Group>
                </Card>
              )}
            </Tabs.Panel>
            <Tabs.Panel value="link" pt="xs">
              <TextInput
                label="URL"
                {...form.getInputProps("link")}
                withAsterisk
              />
            </Tabs.Panel>
          </Tabs>
        </Stack>
        <Group position="right" mt={20}>
          <Button
            type="submit"
            loading={isUploadingFile || createResource.isLoading}
          >
            Subir Recurso
          </Button>
        </Group>
      </form>
    </Modal>
  );
};

interface ItemProps {
  label: string;
  description: string;
}
const SelectItem = forwardRef<HTMLDivElement, ItemProps>(
  ({ label, description, ...others }: ItemProps, ref) => (
    <div ref={ref} {...others}>
      <Group noWrap>
        <div>
          <Text size="sm">{label}</Text>
          <Text size="xs" color="dimmed">
            {description}
          </Text>
        </div>
      </Group>
    </div>
  )
);

SelectItem.displayName = "SelectItem";

export default NewResourceModal;
