import { Card, Title,Text, Space, Grid, Button, Affix } from "@mantine/core";
import ProjectView from "./Cards";
import React from "react";
import Cards from "./Cards";

const ProjectRoot = () => {
  return (
    <div>
      <Title>Project Gallery</Title>
      <Affix position={{ top: 25, right: 25 }}>
        <Button> Upload new project </Button>
      </Affix>
      <Space w="lg" h="lg" />
      <Grid>
        <Space w="md" h="md" />
        <ProjectView />
        <Space w="md" h="md" />
        <ProjectView />
        <Space w="md" h="md" />
        <ProjectView />
        <Space w="md" h="md" />
        <ProjectView />
        <Space w="md" h="md" />
        <ProjectView />
      </Grid>
    </div>

  )
};

export default ProjectRoot;
