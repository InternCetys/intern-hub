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
  Loader,
  Center,
  AspectRatio,
  Button,
  Dialog,
  TextInput,
  Badge,
  Tooltip,
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
import { useEffect, useState } from "react";
import { trpc } from "../../utils/trpc";
import AttendanceForm from "./AttendanceForm";
import People from "../../assets/people.svg";
import Image from "next/image";
import { inferProcedureOutput } from "@trpc/server";
import { AppRouter } from "../../server/router";
import { useForm } from "@mantine/form";

const TODAY = startOfToday();

type Attendance = inferProcedureOutput<
  AppRouter["_def"]["queries"]["attendance.getAttendanceByDate"]
>;

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

  const { isLoading: isLoadingInternSession, data: internSession } =
    trpc.useQuery(["attendance.isInternSession", selectedDate.toISOString()]);

  const handleCalendarDateChange = (date: Date) => {
    setSelectedDate(date);
    setCalendarOpen(false);
    cancelEdit();
  };

  const handleAddDaysToSelectedDate = (days: number) => {
    setSelectedDate(addDays(selectedDate, days));
    cancelEdit();
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

  return (
    <>
      <Title>Active Users</Title>
      <AttendanceForm
        selectedMembers={selectedMembers}
        setSelectedMembers={setSelectedMembers}
        isEditing={isEditing}
        cancelEdit={cancelEdit}
        selectedDate={selectedDate}
      />
      <Stack mt={20}>
        <Group position={"apart"}>
          <Group>
            <Title order={2}>{format(selectedDate, "PPPP")}</Title>
            {internSession && (
              <Tooltip label={internSession.title}>
                <Badge color="green">Intern Session</Badge>
              </Tooltip>
            )}

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
        <Grid>{renderAttendantList(isLoading, attendance)}</Grid>
        <InternSessionDialog isOpen={!internSession} date={selectedDate} />
      </Stack>
    </>
  );
};

const renderAttendantList = (
  isLoading: boolean,
  userAttendance: Attendance | undefined
) => {
  if (isLoading) {
    return (
      <Center style={{ width: "100%" }}>
        <Loader />
      </Center>
    );
  }

  if (!isLoading && !userAttendance?.users) {
    return (
      <Center style={{ width: "100%" }}>
        <Stack>
          <Image src={People} width="400px" height="400px" />
          <Center>
            <Text>No attendance found for this day</Text>
          </Center>
        </Stack>
      </Center>
    );
  }

  return (
    userAttendance &&
    userAttendance.users.map((attendant) => (
      <Grid.Col span={4} key={attendant.userId}>
        <Paper shadow={"md"} p={10}>
          <Group>
            <Avatar src={attendant.user.image} />
            <div>
              <Text size={15}>{attendant.user.name}</Text>
              <Text size={12} style={{ opacity: 0.5 }}>
                {attendant.user.email}
              </Text>
            </div>
          </Group>
        </Paper>
      </Grid.Col>
    ))
  );
};

interface InternSessionDialogProps {
  isOpen: boolean;
  date: Date;
}
const InternSessionDialog = ({ isOpen, date }: InternSessionDialogProps) => {
  const utils = trpc.useContext();

  const form = useForm({
    initialValues: {
      title: "",
    },
  });

  const addDayAsInternSession = trpc.useMutation(
    "attendance.addDayAsInternSession",
    {
      onSuccess: () => {
        utils.invalidateQueries([
          "attendance.isInternSession",
          date.toISOString(),
        ]);
      },
    }
  );

  useEffect(() => {
    form.reset();
  }, [date]);

  return (
    <Dialog opened={isOpen} withCloseButton size="lg" radius="md">
      <Text size="sm" style={{ marginBottom: 10 }} weight={500}>
        Add this day as an Intern Session?
      </Text>

      <form
        onSubmit={form.onSubmit((values) =>
          addDayAsInternSession.mutate({
            date: date.toISOString(),
            title: values.title,
          })
        )}
      >
        <Group align="flex-end">
          <TextInput
            placeholder="Title"
            style={{ flex: 1 }}
            {...form.getInputProps("title")}
          />
          <Button type="submit" loading={addDayAsInternSession.isLoading}>
            Submit
          </Button>
        </Group>
      </form>
    </Dialog>
  );
};
export default AttendanceRoot;
