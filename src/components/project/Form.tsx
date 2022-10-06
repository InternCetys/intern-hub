import { Affix, Button, Modal, Textarea, TextInput } from "@mantine/core";
import React, { useState } from "react";
import BaseDemo from "./Dropzone";

function ProjectForm() {
    const [opened, setOpened] = useState(false);
    return (
        <>
          <Modal
            opened={opened}
            onClose={() => setOpened(false)}
            title="Upload a new project"
          >
            <TextInput
                placeholder='e.g: "RackDAT"'
                label="Project name"
                withAsterisk
            />
            <Textarea
                placeholder="Try to explain what is your project, and that shit"
                label="Project description"
                withAsterisk
                mt={5}
            />
            <BaseDemo></BaseDemo>
            <TextInput
                placeholder="Repository"
                label="Github repo"
                withAsterisk
                mt={5}
            />
          </Modal>
            <Affix position={{ bottom: 20, right: 20 }}>
              <Button onClick={() => setOpened(true)}> Upload new project </Button>
            </Affix>
        </>
    )
}

export default ProjectForm;