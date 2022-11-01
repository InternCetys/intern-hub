import { Card, Title,Text, Space, Grid, Button, Affix, Group, Modal } from "@mantine/core";
import { useState } from 'react';
import ProjectView from "./Cards";
import React from "react";
import Cards from "./Cards";
import ProjectForm from "./NewProjectModal"

const ProjectRoot = () => {
  const [opened, setOpened] = useState(false);
  return (
    <>
      <Title>Project Gallery</Title>
      <Affix position={{ top: 60, right: 25 }}>
        <Button>Upload new project</Button>
      </Affix>
      <Card></Card>
    </>
  );
};

export default ProjectRoot;
