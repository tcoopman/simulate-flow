open Tea.App
open Tea.Html

let (<|) f a = f a 

type model = {
  team: teamMember list;
  stories: story list;
  simulation: simulatedStory list;
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
simulatedStory = phase list
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

type msg =
  | GenerateRandomStory
  [@@bs.deriving {accessors}] 

let thomas = {
  name = "Thomas"; roles = [Developer]
}
let paul = {
  name = "Paul"; roles = [QA]
}
let michel = {
  name = "Michel"; roles =[Accepter]
}

let init () = {
  team = [
    thomas; paul; michel
  ];
  stories = [];
  config = [
    {
      processStep = Development;
      minDuration = 2;
      maxDuration = 10;
    };
    {
      processStep = QA;
      minDuration = 1;
      maxDuration = 4;
    };
    {
      processStep = Acceptance;
      minDuration = 1;
      maxDuration = 2;
    }
  ];
  simulation = [
    [ 
      {
        doneBy = [];
        startedOn = 1;
        endedOn = 5;
        phaseType = Waiting Development;
      };
      {
        doneBy = [thomas];
        startedOn = 5;
        endedOn = 10;
        phaseType = Doing Development;
      };
      {
        doneBy = [];
        startedOn = 10;
        endedOn = 15;
        phaseType = Waiting QA;
      };
      {
        doneBy = [paul];
        startedOn = 15;
        endedOn = 18;
        phaseType = Doing QA;
      };
      {
        doneBy = [];
        startedOn = 18;
        endedOn = 25;
        phaseType = Waiting Acceptance;
      };
      {
        doneBy = [michel];
        startedOn = 25;
        endedOn = 30;
        phaseType = Doing Acceptance;
      };
      {
        doneBy = [];
        startedOn = 30;
        endedOn = 50;
        phaseType = Done;
      };
    ]
  ]
}


let update model = function
  | GenerateRandomStory ->
    let randBetween min max = (Random.int (max - min)) + min in
    let randomStep config = 
      {processStep = config.processStep; activeDuration = randBetween config.minDuration config.maxDuration}
    in
    let steps = List.map randomStep model.config in
    let newStory = {
      name = "RandomStory";
      duration = steps;
    }
    in
    Js.log newStory;
    {model with stories = newStory :: model.stories}

let phaseTypeToColor = function
  | Waiting Development -> "#DB2B39"
  | Doing Development -> "#EE9EA5"
  | Waiting QA -> "#29335C"
  | Doing QA -> "#9DA2B4"
  | Waiting Acceptance -> "#F3A712"
  | Doing Acceptance -> "#F9D793"
  | Done -> "#F8E8D3"

let viewStory story =
  let module Svg = Tea.Svg in
  let module SvgA = Tea.Svg.Attributes in
  let viewPhase phase =
    let scale = 20 in
    let x = (phase.startedOn - 1) * scale |> string_of_int in
    let width = (phase.endedOn - phase.startedOn) * scale |> string_of_int in
    let names =
      phase.doneBy
      |> List.map (fun x -> x.name)
      |> List.fold_left (^) ""
    in
    Svg.g [] [
      Svg.rect [SvgA.x x; SvgA.y "0"; SvgA.width width; SvgA.height "40"; SvgA.fill <| phaseTypeToColor phase.phaseType] [];
      Svg.text' [SvgA.x x; SvgA.y "20"; SvgA.width width; SvgA.height "40"; SvgA.fill "black"; SvgA.fontSize "20"] [Svg.text names];
    ]
  in
  Svg.svg [SvgA.width "800"] (List.map viewPhase story)

let viewSimulation simulation =
  div [] (List.map viewStory simulation)

let viewConfig model =
  div []
    [
      button [onClick generateRandomStory] [text "Generate random story"];
    ]

let view model =
  div
    []
    [
      h1 [] [text "Config"];
      viewConfig model;
      h1 [] [text "Simulation" ];
      viewSimulation model.simulation
    ]


let main =
  beginnerProgram { 
    model = init ();
    update;
    view;
  }