import { Card, Title,Text, Space, Grid, Button, Affix, Group, Modal } from "@mantine/core";
import { useState } from 'react';
import ProjectView from "./Cards";
import React from "react";
import Cards from "./Cards";

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
      <Modal
        opened={opened}
        onClose={() => setOpened(false)}
        title="Introduce yourself!"
      >
        
      </Modal>
      <Affix position={{ bottom: 20, right: 20 }}>
        <Button onClick={() => setOpened(true)}> Upload new project </Button>
      </Affix>
    </>

  )
};

export default ProjectRoot;
