type model = {
  team: teamMember list;
  stories: story list;
  simulatedStories: simulatedStory list;
  config: storyConfig list;
} 
and
teamMember = {
  name: string;
  roles: role list;
}
and
role =
| Developer
| QA
| Accepter
and
story = {
  name: string;
  duration: step list;
}
and
step = {
  activeDuration: int;
  processStep: processStep;
}
and
processStep =
| Development
| QA
| Acceptance
and
simulatedStory = {
    name: string;
    steps: phase list;
}
and
phase = {
  doneBy: teamMember list;
  startedOn: int;
  endedOn: int;
  phaseType: phaseType;
}
and
phaseType =
| Waiting of processStep
| Doing of processStep
| Done
and
storyConfig = {
  processStep: processStep;
  minDuration: int;
  maxDuration: int;
}