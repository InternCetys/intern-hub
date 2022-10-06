import { Card, Title,Text, Space, Grid, Button, Affix, Group, Modal } from "@mantine/core";
import { useState } from 'react';
import ProjectView from "./Cards";
import React from "react";
import Cards from "./Cards";
import ProjectForm from "./Form"

const ProjectRoot = () => {
  const [opened, setOpened] = useState(false);
  return (
    <>
      <Title>Project Gallery</Title>
      <Space w="lg" h="lg" />
      <Grid>
        <Grid.Col span={4}>
          <Space w="md" />
          <ProjectView />
        </Grid.Col>
        <Grid.Col span={4}>
          <Space w="md" />
          <ProjectView />
        </Grid.Col>
        <Grid.Col span={4}>
          <Space w="md" />
          <ProjectView />
        </Grid.Col>
        <Grid.Col span={4}>
          <Space w="md" />
          <ProjectView />
        </Grid.Col>
      </Grid>
      <ProjectForm></ProjectForm>
    </>

  )
};

export default ProjectRoot;
