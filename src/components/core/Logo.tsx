import { Badge, Group, Text } from "@mantine/core";
import React from "react";

const Logo = () => {
  return (
    <Group>
      <Text>Intern Hub</Text>
      {process.env.NODE_ENV === "development" && <Badge>Dev</Badge>}
    </Group>
  );
};

export default Logo;
