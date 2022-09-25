import { Button, Group, Modal, NumberInput, TextInput } from "@mantine/core";
import { useForm } from "@mantine/form";
import { showNotification } from "@mantine/notifications";
import { getWeek } from "date-fns";
import React from "react";
import { trpc } from "../../utils/trpc";

interface Props {
  opened: boolean;
  onClose: () => void;
}

const NewWeekModal = ({ opened, onClose }: Props) => {
  const form = useForm({
    initialValues: {
      weekNumber: getWeek(new Date()),
      weekTitle: "",
    },
  });

  const utils = trpc.useContext();
  const createWeek = trpc.useMutation(["potw.createWeek"]);

  const handleCreateWeek = async ({
    weekNumber,
    weekTitle,
  }: {
    weekNumber: number;
    weekTitle: string;
  }) => {
    createWeek.mutate(
      {
        number: weekNumber,
        name: weekTitle,
      },
      {
        onSuccess: () => {
          utils.invalidateQueries(["potw.getAllWeeks"]);
          utils.invalidateQueries(["potw.getCurrentWeek"]);
          utils.invalidateQueries(["potw.getProblemsByWeek"]);
          onClose();
        },
        onError: () => {
          showNotification({
            message: "Error al crear la semana",
            color: "red",
          });
        },
      }
    );
  };
  return (
    <Modal opened={opened} onClose={onClose} title="Agregar Semana">
      <form onSubmit={form.onSubmit(handleCreateWeek)}>
        <NumberInput label="Numero" {...form.getInputProps("weekNumber")} />
        <TextInput label="Nombre" {...form.getInputProps("weekTitle")} />
        <Group position="right" mt={20}>
          <Button type="submit">Agregar Semana</Button>
        </Group>
      </form>
    </Modal>
  );
};

export default NewWeekModal;
