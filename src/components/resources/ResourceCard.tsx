import { Card, Group, Badge, Button, Text, Space, Stack } from "@mantine/core";
import { showNotification } from "@mantine/notifications";
import { InternSession } from "@prisma/client";
import { IconFile } from "@tabler/icons";
import React from "react";
import { supabase } from "../../utils/supabase";

interface Props {
  title: string;
  url: string;
  type: string;
  description: string;
  internSession: InternSession | null;
}

const ResourceCard = ({
  title,
  description,
  type,
  url,
  internSession,
}: Props) => {
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
    <Card shadow="sm" p="lg" radius="md" withBorder>
      <Stack>
        <div>
          <IconFile />
          <Group position="apart" mt="md" mb="xs">
            <Text weight={500}>{title}</Text>
            <Badge color="pink" variant="light">
              {type}
            </Badge>
          </Group>

          <div style={{ height: "50px" }}>
            <Text size="sm" color="dimmed" lineClamp={2}>
              {description}
            </Text>
          </div>
        </div>
        {internSession && (
          <div>
            <Card withBorder shadow={"sm"}>
              <Text size="sm">Ligado a sesión: </Text>
              <Text size="sm" color="dimmed" lineClamp={2}>
                {internSession.title}
              </Text>
            </Card>
          </div>
        )}

        <div
          style={{
            flex: 1,
            display: "flex",
            flexDirection: "column",
            justifyContent: "end",
          }}
        >
          <Button
            variant="light"
            color="blue"
            fullWidth
            mt="md"
            radius="md"
            onClick={() => handleDownload()}
          >
            {isWebsiteLink ? "Abrir" : "Descargar"}
          </Button>
        </div>
      </Stack>
    </Card>
  );
};

export default ResourceCard;
