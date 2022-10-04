import { Card, Title,Text, Space, Grid  } from "@mantine/core";
import ProjectView from "./Cards";
import React from "react";
import Cards from "./Cards";

const ProjectRoot = () => {
  return (
    <div>
      <Title>Project Gallery</Title>
      <Space w="md" h="md" />
      <Grid>
        <Space w="md" h="md" />
        <ProjectView />
        <Space w="md" h="md" />
        <ProjectView />
      </Grid>
    </div>

  )
};

export default ProjectRoot;
