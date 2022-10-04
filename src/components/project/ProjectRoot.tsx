import { Title, Affix, Button } from "@mantine/core";
import React from "react";
import Card from "./Card";

const ProjectRoot = () => {
  return (
    <div>
      <Title>Project Gallery</Title>
      <Affix position={{ top: 60, right: 25 }}>
        <Button>Upload new project</Button>
      </Affix>
      <Card></Card>
    </div>
  );
};

export default ProjectRoot;
