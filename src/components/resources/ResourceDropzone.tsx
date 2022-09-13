import { Group, Center, useMantineTheme, Text } from "@mantine/core";
import {
  Dropzone,
  FileWithPath,
  IMAGE_MIME_TYPE,
  PDF_MIME_TYPE,
} from "@mantine/dropzone";
import { IconUpload, IconX, IconPhoto } from "@tabler/icons";
import React from "react";

interface Props {
  onDrop: (files: FileWithPath) => void;
  onReject: (error: string) => void;
  maxSize?: number;
  isLoading: boolean;
}

const ResourceDropzone = ({
  onDrop,
  onReject,
  maxSize = 3 * 1024 ** 2,
  isLoading,
}: Props) => {
  const theme = useMantineTheme();

  return (
    <Dropzone
      loading={isLoading}
      onDrop={(files) => onDrop(files[0])}
      onReject={(files) => {
        onReject(files[0].errors[0].message);
      }}
      maxSize={maxSize}
      maxFiles={1}
      accept={[...IMAGE_MIME_TYPE, ...PDF_MIME_TYPE]}
    >
      <Group
        position="center"
        spacing="xl"
        style={{ minHeight: 220, pointerEvents: "none" }}
      >
        <Dropzone.Accept>
          <IconUpload
            size={50}
            stroke={1.5}
            color={
              theme.colors[theme.primaryColor][
                theme.colorScheme === "dark" ? 4 : 6
              ]
            }
          />
        </Dropzone.Accept>
        <Dropzone.Reject>
          <IconX
            size={50}
            stroke={1.5}
            color={theme.colors.red[theme.colorScheme === "dark" ? 4 : 6]}
          />
        </Dropzone.Reject>
        <Dropzone.Idle>
          <Center>
            <IconPhoto size={50} stroke={1.5} />
          </Center>
          <Text size="xl" inline align="center">
            Drag the resource here or click to select files
          </Text>
        </Dropzone.Idle>
      </Group>
    </Dropzone>
  );
};

export default ResourceDropzone;
