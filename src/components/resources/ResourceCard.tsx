import { Card, Group, Badge, Button, Text, Space, Stack } from "@mantine/core";
import { showNotification } from "@mantine/notifications";
import { IconFile } from "@tabler/icons";
import React from "react";
import { supabase } from "../../utils/supabase";

interface Props {
  title: string;
  url: string;
  type: string;
  description: string;
}

const ResourceCard = ({ title, description, type, url }: Props) => {
  const isWebsiteLink = url.startsWith("http");

  const handleDownload = async () => {
    if (isWebsiteLink) {
      window.open(url, "_blank");
    }

    const downloadedFile = await supabase.storage
      .from("resources")
      .download(url);

    if (!downloadedFile.data) {
      showNotification({
        message: "Error downloading file",
        title: "Error",
        color: "red",
      });
      return;
    }

    const a = document.createElement("a");
    a.href = window.URL.createObjectURL(downloadedFile.data);
    a.download = url.split("/")[1];
    a.click();
  };

  return (
    <Card shadow="sm" p="lg" radius="md" withBorder style={{ height: "240px" }}>
      <Stack justify={"space-around"}>
        <div>
          <IconFile />
          <Group position="apart" mt="md" mb="xs">
            <Text weight={500}>{title}</Text>
            <Badge color="pink" variant="light">
              {type}
            </Badge>
          </Group>

          <Text
            size="sm"
            color="dimmed"
            lineClamp={2}
            style={{ height: "50px" }}
          >
            {description}
          </Text>
        </div>
        <Button
          variant="light"
          color="blue"
          fullWidth
          mt="md"
          radius="md"
          onClick={() => handleDownload()}
        >
          {isWebsiteLink ? "Open" : "Download"}
        </Button>
      </Stack>
    </Card>
  );
};

export default ResourceCard;