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

  const utils = trpc.useContext();

  const form = useForm<FormTypes>({
    initialValues: {
      title: "",
      description: "",
      type: "",
      session: "",
      file: null,
    },
    validate: {
      title: (value) => (value.length > 0 ? null : "Title is required"),
      description: (value) =>
        value.length > 0 ? null : "Description is required",
      type: (value: ResourceType) =>
        value.length > 0 ? null : "Type is required",
      session: (value) => (value.length > 0 ? null : "Session is required"),
    },
  });

  const handleFormSubmit = async (values: FormTypes) => {
    if (values.file === null) {
      showNotification({ message: "Please upload a file", color: "red" });
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
      showNotification({ message: "Resource created", color: "green" });
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
            label="Title"
            {...form.getInputProps("title")}
            withAsterisk
          />
          <Textarea
            withAsterisk
            label="Description"
            {...form.getInputProps("description")}
          />
          <Select
            withAsterisk
            label="Type"
            searchable
            data={resourceTypeSelectItems}
            {...form.getInputProps("type")}
          />
          <Select
            withAsterisk
            label="Linked Session"
            searchable
            data={internSessions || []}
            itemComponent={SelectItem}
            disabled={isLoadingInternSessions}
            {...form.getInputProps("session")}
          />
          <Input.Wrapper label="Upload Files" withAsterisk>
            <ResourceDropzone
              onDrop={(file) => form.setFieldValue("file", file)}
              onReject={(error) => form.setErrors({ file: error })}
              isLoading={isUploadingFile}
            />
          </Input.Wrapper>
          {form.values.file && (
            <Card shadow={"sm"} withBorder>
              <Group position="apart">
                <Group>
                  <IconFile />
                  {form.values.file.name}
                </Group>
                <ActionIcon color={"red"} variant={"light"}>
                  <IconTrash size={20} />
                </ActionIcon>
              </Group>
            </Card>
          )}
        </Stack>
        <Group position="right" mt={20}>
          <Button
            type="submit"
            loading={isUploadingFile || createResource.isLoading}
          >
            Upload Resource
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
