import {
  Paper,
  Skeleton,
  Stack,
  MultiSelect,
  Button,
  Avatar,
  Group,
  Text,
} from "@mantine/core";
import { showNotification } from "@mantine/notifications";
import { IconCheck, IconX } from "@tabler/icons";
import { startOfToday } from "date-fns";
import { traceDeprecation } from "process";
import React, { Dispatch, forwardRef, SetStateAction, useState } from "react";
import { trpc } from "../../utils/trpc";

interface ItemProps extends React.ComponentPropsWithoutRef<"div"> {
  image: string;
  label: string;
  description: string;
}

interface Props {
  selectedMembers: string[];
  setSelectedMembers: (members: string[]) => void;
  isEditing: boolean;
  cancelEdit: () => void;
  selectedDate: Date;
}
const AttendanceForm = ({
  selectedMembers,
  setSelectedMembers,
  isEditing,
  cancelEdit,
  selectedDate,
}: Props) => {
  const { isLoading, data: users } = trpc.useQuery([
    "user.getAllUsersForSelectInput",
  ]);

  const utils = trpc.useContext();

  const createAttendance = trpc.useMutation(["attendance.createAttendance"], {
    onSuccess: () => {
      utils.invalidateQueries(["attendance.getAttendanceByDate"]);
      showNotification({
        message: "Asistencia creada correctamente",
        icon: <IconCheck />,
        color: "green",
      });
    },
  });

  const updateAttendance = trpc.useMutation(["attendance.updateAttendance"], {
    onSuccess: () => {
      utils.invalidateQueries(["attendance.getAttendanceByDate"]);
      cancelEdit();
      showNotification({
        message: "Asistencia actualizada correctamente",
        icon: <IconCheck />,
        color: "green",
      });
    },
  });

  const handleAttendanceSubmit = () => {
    if (isEditing) {
      updateAttendance.mutate({
        day: selectedDate.toISOString(),
        users: selectedMembers,
      });
      return;
    }

    createAttendance.mutate({
      day: selectedDate.toISOString(),
      users: selectedMembers,
    });

    setSelectedMembers([]);
  };

  return (
    <Paper mt={20}>
      <>
        {isLoading && (
          <>
            <Skeleton height={8} radius="xl" />
            <Skeleton height={8} mt={6} radius="xl" />
            <Skeleton height={8} mt={6} width="70%" radius="xl" />
          </>
        )}
        {users && (
          <Stack>
            <MultiSelect
              label="Asistencia"
              placeholder="Buscar miembro"
              itemComponent={SelectItem}
              data={users}
              searchable
              maxDropdownHeight={400}
              nothingFound="Nobody here"
              clearable
              filter={(value, selected, item) =>
                !selected &&
                (item.label
                  ?.toLowerCase()
                  .includes(value.toLowerCase().trim()) ||
                  item.description
                    ?.toLowerCase()
                    .includes(value.toLowerCase().trim()))
              }
              autoComplete="off"
              value={selectedMembers}
              onChange={setSelectedMembers}
            />
            <Button
              fullWidth
              onClick={handleAttendanceSubmit}
              loading={createAttendance.isLoading || updateAttendance.isLoading}
            >
              {isEditing ? "Actualizar Asistencia" : "Subir Asistencia"}
            </Button>
          </Stack>
        )}
      </>
    </Paper>
  );
};

const SelectItem = forwardRef<HTMLDivElement, ItemProps>(
  ({ image, label, description, ...others }: ItemProps, ref) => (
    <div ref={ref} {...others}>
      <Group noWrap>
        <Avatar src={image} />

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

export default AttendanceForm;
