import { Button, Group, NumberInput, Stack, TextInput } from "@mantine/core";
import { useForm } from "@mantine/form";
import { showNotification } from "@mantine/notifications";
import React from "react";
import { trpc } from "../../utils/trpc";

interface Props {
  number: number;
  name: string;
}
const EditWeekContent = ({ number, name }: Props) => {
  const form = useForm({
    initialValues: {
      weekNumber: number,
      weekName: name,
    },
  });

  const utils = trpc.useContext();
  const updateWeek = trpc.useMutation(["potw.updateWeek"]);

  const handleUpdateWeek = ({
    weekNumber,
    weekName,
  }: {
    weekNumber: number;
    weekName: string;
  }) => {
    updateWeek.mutate(
      {
        oldWeekNumber: number,
        newWeekNumber: weekNumber,
        title: weekName,
      },
      {
        onSuccess: () => {
          utils.invalidateQueries(["potw.getAllWeeks"]);
          utils.invalidateQueries(["potw.getCurrentWeek", number]);
          showNotification({
            message: "Semana actualizada",
            color: "green",
          });
        },
        onError: () => {
          showNotification({
            message: "Error al actualizar la semana",
            color: "red",
          });
        },
      }
    );
  };

  return (
    <Stack>
      <form onSubmit={form.onSubmit(handleUpdateWeek)}>
        <NumberInput label="Numero" {...form.getInputProps("weekNumber")} />
        <TextInput label="Nombre" {...form.getInputProps("weekName")} />
        <Group position="right" mt={20}>
          <Button loading={updateWeek.isLoading} type="submit">
            Subir
          </Button>
        </Group>
      </form>
    </Stack>
  );
};

export default EditWeekContent;
