import { Card, Title,Text, Space  } from "@mantine/core";
import ProjectView from "./Cards";
import React from "react";

const ProjectRoot = () => {
  return (
    <div>
      <Title>Project Gallery</Title>
      <Space w="md" h="md" />
      <ProjectView />
      <Space w="md" h="md" />
      <ProjectView />
    </div>

  )
};

export default ProjectRoot;
