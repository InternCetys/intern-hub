import {
  Anchor,
  Badge,
  Button,
  Group,
  Select,
  Stack,
  Table,
  TextInput,
} from "@mantine/core";
import { useForm } from "@mantine/form";
import { showNotification } from "@mantine/notifications";
import { ProblemDifficulty } from "@prisma/client";
import { setISODay } from "date-fns";
import React, { useState } from "react";
import { trpc } from "../../utils/trpc";

interface Props {
  weekNumber: number;
  weekId: string;
}

interface DifficultySelect {
  value: ProblemDifficulty;
  label: string;
}

interface FormValues {
  name: string;
  link: string;
  difficulty: ProblemDifficulty;
}

const DifficultyBadgeColor = {
  EASY: "green",
  MEDIUM: "yellow",
  HARD: "red",
  INSANE: "violet",
};

const difficulties: DifficultySelect[] = [
  { label: "Easy", value: ProblemDifficulty.EASY },
  { label: "Medium", value: ProblemDifficulty.MEDIUM },
  { label: "Hard", value: ProblemDifficulty.HARD },
  { label: "Insane", value: ProblemDifficulty.INSANE },
];

const EditProblemContent = ({ weekNumber, weekId }: Props) => {
  const [isEditing, setIsEditing] = useState<string | null>(null);

  const { data: problems } = trpc.useQuery([
    "potw.getProblemsByWeek",
    { week: weekNumber, filter: "ALL" },
  ]);

  const utils = trpc.useContext();

  const createProblem = trpc.useMutation(["potw.createProblem"]);
  const editProblem = trpc.useMutation(["potw.editProblem"]);
  const deleteProblem = trpc.useMutation(["potw.deleteProblem"]);

  const form = useForm<FormValues>({
    initialValues: {
      name: "",
      link: "",
      difficulty: "EASY",
    },
  });

  const handleCreateProblem = async (values: FormValues) => {
    createProblem.mutate(
      {
        title: values.name,
        difficulty: values.difficulty,
        week: weekId,
        link: values.link,
      },
      {
        onSuccess: () => {
          showNotification({
            message: "Problema creado correctamente",
            color: "green",
          });
          utils.invalidateQueries(["potw.getProblemsByWeek"]);
        },
        onError: () => {
          showNotification({
            message: "Error al crear problema",
            color: "red",
          });
        },
      }
    );
  };

  const handleEditProblem = async (values: FormValues) => {
    if (!isEditing) return;
    editProblem.mutate(
      {
        id: isEditing,
        title: values.name,
        difficulty: values.difficulty,
        week: weekId,
        link: values.link,
      },
      {
        onSuccess: () => {
          showNotification({
            message: "Problema editado correctamente",
            color: "green",
          });
          utils.invalidateQueries(["potw.getProblemsByWeek"]);
          form.reset();
        },
        onError: () => {
          showNotification({
            message: "Error al editar problema",
            color: "red",
          });
        },
      }
    );

    setIsEditing(null);
  };

  const handleDeleteProblem = async (id: string) => {
    deleteProblem.mutate(id, {
      onSuccess: () => {
        showNotification({
          message: "Problema eliminado correctamente",
          color: "green",
        });
        utils.invalidateQueries(["potw.getProblemsByWeek"]);
      },
      onError: () => {
        showNotification({
          message: "Error al borrar el problema",
          color: "red",
        });
      },
    });
  };

  return (
    <>
      <Stack>
        <form
          onSubmit={form.onSubmit((values) => {
            isEditing ? handleEditProblem(values) : handleCreateProblem(values);
          })}
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
              label="Dificultad"
              style={{ width: "32%" }}
              searchable
              data={difficulties}
              {...form.getInputProps("difficulty")}
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
            <Button
              type="submit"
              loading={editProblem.isLoading || createProblem.isLoading}
            >
              {isEditing ? "Editar Problema" : "Subir Problema"}
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
            <th>Dificultad</th>
            <th>Acción</th>
          </tr>
        </thead>
        <tbody>
          {problems &&
            problems.map((problem, i) => (
              <tr key={problem.id}>
                <td>#{i + 1}</td>
                <td>{problem.title}</td>
                <td>
                  <Anchor href={problem.link} target={"_blank"}>
                    {problem.link}
                  </Anchor>
                </td>
                <td>
                  <Badge color={DifficultyBadgeColor[problem.difficulty]}>
                    {problem.difficulty}
                  </Badge>
                </td>
                <td>
                  <Group>
                    <Button
                      size="xs"
                      variant="light"
                      disabled={!!isEditing}
                      onClick={() => {
                        setIsEditing(problem.id);
                        form.setFieldValue("name", problem.title);
                        form.setFieldValue("link", problem.link);
                        form.setFieldValue("difficulty", problem.difficulty);
                      }}
                    >
                      Editar
                    </Button>
                    <Button
                      size="xs"
                      color="red"
                      variant="light"
                      disabled={!!isEditing}
                      onClick={() => handleDeleteProblem(problem.id)}
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

export default EditProblemContent;
