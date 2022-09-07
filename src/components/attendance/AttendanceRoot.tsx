import {
  Grid,
  Paper,
  Stack,
  Title,
  Text,
  Avatar,
  Group,
  Skeleton,
  ActionIcon,
  Popover,
  useMantineTheme,
  CloseButton,
} from "@mantine/core";
import { Calendar } from "@mantine/dates";
import {
  IconArrowLeft,
  IconArrowRight,
  IconArrowsCross,
  IconCalendar,
  IconCross,
  IconCrossOff,
  IconEdit,
  IconHomeCancel,
} from "@tabler/icons";
import { addDays, format, isSameDay, isToday, startOfToday } from "date-fns";
import { useState } from "react";
import { trpc } from "../../utils/trpc";
import AttendanceForm from "./AttendanceForm";

const TODAY = startOfToday();

const AttendanceRoot = () => {
  const theme = useMantineTheme();

  const [selectedDate, setSelectedDate] = useState(TODAY);
  const [calendarOpen, setCalendarOpen] = useState(false);

  const [isEditing, setIsEditing] = useState(false);
  const [selectedMembers, setSelectedMembers] = useState<string[]>([]);

  const { isLoading, data: attendance } = trpc.useQuery([
    "attendance.getAttendanceByDate",
    selectedDate.toISOString(),
  ]);

  const handleCalendarDateChange = (date: Date) => {
    setSelectedDate(date);
    setCalendarOpen(false);
    cancelEdit();
  };

  const handleAddDaysToSelectedDate = (days: number) => {
    setSelectedDate(addDays(selectedDate, days));
    cancelEdit();
  };

  const renderDayStyle = (date: Date) => {
    if (isToday(date)) {
      return {
        backgroundColor: theme.colors.blue[7],
        color: theme.white,
      };
    }

    if (isSameDay(date, selectedDate)) {
      return {
        backgroundColor: theme.colors.gray[1],
      };
    }

    return {};
  };

  const handleEdit = () => {
    setIsEditing(true);
    const usersIds = attendance?.users.map((user) => user.userId) || [];
    setSelectedMembers(usersIds);
  };

  const cancelEdit = () => {
    setIsEditing(false);
    setSelectedMembers([]);
  };

  return (
    <>
      <Title>Active Users</Title>
      <AttendanceForm
        selectedMembers={selectedMembers}
        setSelectedMembers={setSelectedMembers}
        isEditing={isEditing}
        cancelEdit={cancelEdit}
      />
      <Stack mt={20}>
        <Group position={"apart"}>
          <Group>
            <Title order={2}>{format(selectedDate, "PPPP")}</Title>
            {attendance && (
              <ActionIcon onClick={() => handleEdit()}>
                <IconEdit size={30} />
              </ActionIcon>
            )}
            {isEditing && (
              <CloseButton size={30} onClick={() => cancelEdit()} />
            )}
          </Group>
          <Group>
            <ActionIcon>
              <IconArrowLeft
                size={30}
                onClick={() => handleAddDaysToSelectedDate(-1)}
              />
            </ActionIcon>
            <Popover opened={calendarOpen} onChange={setCalendarOpen}>
              <Popover.Target>
                <ActionIcon onClick={() => setCalendarOpen((o) => !o)}>
                  <IconCalendar size={30} />
                </ActionIcon>
              </Popover.Target>
              <Popover.Dropdown>
                <Calendar
                  onChange={handleCalendarDateChange}
                  dayStyle={renderDayStyle}
                />
              </Popover.Dropdown>
            </Popover>
            <ActionIcon onClick={() => handleAddDaysToSelectedDate(1)}>
              <IconArrowRight size={30} />
            </ActionIcon>
          </Group>
        </Group>
        <Grid>
          {isLoading && (
            <>
              <Skeleton height={20} />
              <Skeleton mt={6} height={20} />
              <Skeleton mt={6} height={20} />
            </>
          )}
          {attendance &&
            attendance.users.map((userAttendance) => (
              <Grid.Col span={4} key={userAttendance.userId}>
                <Paper shadow={"md"} p={10}>
                  <Group>
                    <Avatar src={userAttendance.user.image} />
                    <div>
                      <Text size={15}>{userAttendance.user.name}</Text>
                      <Text size={12} style={{ opacity: 0.5 }}>
                        {userAttendance.user.email}
                      </Text>
                    </div>
                  </Group>
                </Paper>
              </Grid.Col>
            ))}
        </Grid>
      </Stack>
    </>
  );
};

export default AttendanceRoot;
