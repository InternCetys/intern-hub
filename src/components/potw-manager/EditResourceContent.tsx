import {
  Stack,
  Group,
  TextInput,
  Select,
  Button,
  Table,
  Anchor,
  Badge,
} from "@mantine/core";
import { useForm } from "@mantine/form";
import { showNotification } from "@mantine/notifications";
import { ResourceType } from "@prisma/client";
import React, { useState } from "react";
import { trpc } from "../../utils/trpc";

interface Props {
  weekNumber: number;
  weekId: string;
}

interface FormTypes {
  name: string;
  link: string;
  type: Extract<ResourceType, "VIDEO" | "DOCUMENT">;
}

const resourceType = [
  { label: "Video", value: ResourceType.VIDEO },
  { label: "Documentación", value: ResourceType.DOCUMENT },
];
const EditResourceContent = ({ weekId, weekNumber }: Props) => {
  const [isEditing, setIsEditing] = useState<string | null>(null);
  const { data: resources } = trpc.useQuery([
    "potw.getResourcesByWeek",
    { week: weekNumber },
  ]);

  const form = useForm<FormTypes>({
    initialValues: {
      name: "",
      link: "",
      type: ResourceType.VIDEO,
    },
  });

  const utils = trpc.useContext();
  const createResource = trpc.useMutation(["potw.createResource"]);
  const updateResource = trpc.useMutation(["potw.updateResource"]);

  const handleCreateResource = async (vals: FormTypes) => {
    createResource.mutate(
      {
        link: vals.link,
        title: vals.name,
        type: vals.type,
        week: weekId,
      },
      {
        onSuccess: () => {
          showNotification({
            message: "Recurso creado correctamente",
            color: "green",
          });
          utils.invalidateQueries(["potw.getResourcesByWeek"]);
        },
        onError: () => {
          showNotification({
            message: "Error al crear recurso",
            color: "red",
          });
        },
      }
    );
  };

  const handleUpdateResource = async (vals: FormTypes) => {
    if (!isEditing) return;
    updateResource.mutate(
      {
        id: isEditing,
        link: vals.link,
        title: vals.name,
        type: vals.type,
        week: weekId,
      },
      {
        onSuccess: () => {
          showNotification({
            message: "Recurso actualizado correctamente",
            color: "green",
          });
          utils.invalidateQueries(["potw.getResourcesByWeek"]);
        },
        onError: () => {
          showNotification({
            message: "Error al actualizar recurso",
            color: "red",
          });
        },
      }
    );
    setIsEditing(null);
    form.reset();
  };

  return (
    <>
      <Stack>
        <form
          onSubmit={form.onSubmit((vals) =>
            isEditing ? handleUpdateResource(vals) : handleCreateResource(vals)
          )}
        >
          <Group position="apart">
            <TextInput
              label="Nombre"
              style={{ width: "32%" }}
              {...form.getInputProps("name")}
            />
            <TextInput
              label="Link"
              style={{ width: "32%" }}
              {...form.getInputProps("link")}
            />
            <Select
              label="Tipo"
              style={{ width: "32%" }}
              searchable
              data={resourceType}
              {...form.getInputProps("type")}
            />
          </Group>
          <Group position="right" mt={10}>
            {isEditing && (
              <Button
                color="gray"
                onClick={() => {
                  form.reset();
                  setIsEditing(null);
                }}
              >
                Cancelar
              </Button>
            )}
            <Button type="submit">
              {isEditing ? "Editar Recurso" : "Subir Recurso"}
            </Button>
          </Group>
        </form>
      </Stack>
      <Table>
        <thead>
          <tr>
            <th>#</th>
            <th>Nombre</th>
            <th>Link</th>
            <th>Tipo</th>
            <th>Acción</th>
          </tr>
        </thead>
        <tbody>
          {resources &&
            resources.map((resource, i) => (
              <tr key={resource.id}>
                <td>#{i + 1}</td>
                <td>{resource.title}</td>
                <td>
                  <Anchor href={resource.link} target={"_blank"}>
                    {resource.link}
                  </Anchor>
                </td>
                <td>
                  <Badge>{resource.type}</Badge>
                </td>
                <td>
                  <Group>
                    <Button
                      size="xs"
                      variant="light"
                      disabled={!!isEditing}
                      onClick={() => {
                        setIsEditing(resource.id);
                        form.setFieldValue("name", resource.title);
                        form.setFieldValue("link", resource.link);
                        form.setFieldValue(
                          "type",
                          resource.type as Extract<
                            ResourceType,
                            "VIDEO" | "DOCUMENT"
                          >
                        );
                      }}
                    >
                      Editar
                    </Button>
                    <Button
                      size="xs"
                      color="red"
                      variant="light"
                      disabled={!!isEditing}
                    >
                      Borrar
                    </Button>
                  </Group>
                </td>
              </tr>
            ))}
        </tbody>
      </Table>
    </>
  );
};

export default EditResourceContent;
