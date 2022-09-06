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
import React, { Dispatch, forwardRef, SetStateAction, useState } from "react";
import { trpc } from "../../utils/trpc";

interface ItemProps extends React.ComponentPropsWithoutRef<"div"> {
  image: string;
  label: string;
  description: string;
}

const AttendanceForm = () => {
  const { isLoading, data: users } = trpc.useQuery([
    "user.getAllUsersForSelectInput",
  ]);

  const [selectedMembers, setSelectedMembers] = useState<string[]>([]);

  const createAttendance = trpc.useMutation(["attendance.createAttendance"]);

  const handleAttendanceSubmit = () => {
    createAttendance.mutate({
      day: new Date().toISOString(),
      users: selectedMembers,
    });
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
              label="Member Attendance"
              placeholder="Search for a member"
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
              onChange={setSelectedMembers}
            />
            <Button
              fullWidth
              onClick={handleAttendanceSubmit}
              loading={createAttendance.isLoading}
            >
              Submit
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

export default AttendanceForm;
