import {
  Grid,
  Paper,
  Stack,
  Title,
  Text,
  Avatar,
  Group,
  Skeleton,
} from "@mantine/core";
import { format } from "date-fns";
import { useState } from "react";
import { trpc } from "../../utils/trpc";
import AttendanceForm from "./AttendanceForm";

const TODAY = new Date().toISOString();

const AttendanceRoot = () => {
  const { isLoading, data: attendance } = trpc.useQuery([
    "attendance.getAttendanceByDate",
    TODAY, // may lead to bugs
  ]);

  return (
    <>
      <Title>Active Users</Title>
      <AttendanceForm />
      <Stack mt={20}>
        <Title order={2}>{format(new Date(), "PPPP")}</Title>
        <Grid>
          {isLoading && (
            <>
              <Skeleton height={20} />
              <Skeleton mt={6} height={20} />
              <Skeleton mt={6} height={20} />
            </>
          )}
          {attendance &&
            attendance.users.map((userAttendence) => (
              <Grid.Col span={4}>
                <Paper shadow={"md"} p={10}>
                  <Group>
                    <Avatar src={userAttendence.user.image} />
                    <div>
                      <Text size={15}>{userAttendence.user.name}</Text>
                      <Text size={12} style={{ opacity: 0.5 }}>
                        {userAttendence.user.email}
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
