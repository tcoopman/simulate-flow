open Tea.App
open Tea.Html
open Model
open Basics



type msg =
  | GenerateRandomStory
  | Simulate
  [@@bs.deriving {accessors}] 

let thomas = {
  name = "Thomas"; roles = [Developer]
}
let guido = {
  name = "Guido"; roles = [Developer]
}
let paul = {
  name = "Paul"; roles = [QA]
}
let michel = {
  name = "Michel"; roles =[Accepter]
}

let init () = {
  team = [
    thomas; paul; michel; guido
  ];
  stories = [];
  config = [
    {
      processStep = Development;
      minDuration = 1;
      maxDuration = 6;
    };
    {
      processStep = QA;
      minDuration = 1;
      maxDuration = 6;
    };
    {
      processStep = Acceptance;
      minDuration = 1;
      maxDuration = 6;
    }
  ];
  simulatedStories = []
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
    List.iter (fun step -> Js.log step.activeDuration) newStory.duration;
    {model with stories = newStory :: model.stories}
  | Simulate ->
    Js.log (List.length model.stories);
    match Simulation.simulate model model.stories with
    | Result.Ok simulatedStories -> 
      Js.log "success";
      Js.log (List.length simulatedStories);
      {model with simulatedStories = simulatedStories}
    | Result.Error e -> 
      let _ = begin match e with
      | Simulation.NoStoriesToSimulate -> Js.log "No stories to simulate"
      | Simulation.NoMemberAvailable -> Js.log "No member available"
      | Simulation.NoStepsInStory -> Js.log "No steps in story";
      | Simulation.NoTeamMembers -> Js.log "No team members";
      end in
      model

let phaseTypeToColor = function
  | Waiting Development -> "#DB2B39"
  | Doing Development -> "#EE9EA5"
  | Waiting QA -> "#29335C"
  | Doing QA -> "#9DA2B4"
  | Waiting Acceptance -> "#F3A712"
  | Doing Acceptance -> "#F9D793"
  | Done -> "#F8E8D3"

let viewSimulatedStory index story =
  let module Svg = Tea.Svg in
  let module SvgA = Tea.Svg.Attributes in
  let scale = 20 in
  let viewPhase phase =
    let x = (phase.startedOn - 1) * scale |> string_of_int in
    let width = (phase.endedOn - phase.startedOn + 1) * scale |> string_of_int in
    let names =
      phase.doneBy
      |> List.map (fun (x:teamMember) -> x.name)
      |> List.fold_left (^) ""
    in
    Svg.g [] [
      Svg.rect [SvgA.x x; SvgA.y "0"; SvgA.width width; SvgA.height "40"; SvgA.fill <| phaseTypeToColor phase.phaseType] [];
      Svg.text' [SvgA.x x; SvgA.y "20"; SvgA.width width; SvgA.height "40"; SvgA.fill "black"; SvgA.fontSize "20"] [Svg.text names];
    ]
  in
  let transform =
    "translate(0," ^ string_of_int (index * scale * 2) ^ ")"
  in
  Svg.g [SvgA.transform transform] (List.map viewPhase story.steps)

let viewSimulation simulation =
  let module Svg = Tea.Svg in
  let module SvgA = Tea.Svg.Attributes in
  Svg.svg [SvgA.width "800"; SvgA.height "800"] (List.mapi viewSimulatedStory simulation)

let viewConfig model =
  let viewStory (story:story) =
    let viewSteps steps =
      let viewStep (step:step) = 
        begin match step.processStep with
        | Development -> "Development " ^ (string_of_int step.activeDuration) ^ ", "
        | QA -> "QA " ^ (string_of_int step.activeDuration) ^ ", "
        | Acceptance -> "Acceptance " ^ (string_of_int step.activeDuration) ^ ", "
        end
        |> text
      in
      span [] (List.map viewStep steps)
    in
    div [] [
      h4 [] [text story.name];
      viewSteps story.duration;
    ]
  in
  let viewTeamMember (member:teamMember) =
    let string_of_roles roles =
      let string_of_role role =
        match role with
        | Developer -> "Developer"
        | QA -> "QA"
        | Accepter -> "Accepter"
      in
      List.fold_left (fun acc role -> (string_of_role role) ^ ", " ^ acc) "" roles
    in
    div [] [
      span [] [text <| "Name: " ^ member.name];
      span [] [text " | "];
      span [] [text <| "Roles: " ^ (string_of_roles member.roles)]
    ]
  in
  div []
    [
      div [] [
        h3 [] [text "Stories"];
        p [] [text <| "There are " ^ (string_of_int <| List.length model.stories) ^ " stories"];
        div [] (List.map viewStory model.stories);
        button [onClick generateRandomStory] [text "Generate random story"];
      ];
      div [] [
        h3 [] [text "Team members"];
        p [] [text "These are the team members"];
        div [] (List.map viewTeamMember model.team);
      ];
    ]

let view model =
  div
    []
    [
      h1 [] [text "Simulate flow"];
      p [] [text "Generate some random stories and then simulate"];
      h2 [] [text "Config"];
      viewConfig model;
      h2 [] [text "Simulation" ];
      button [onClick simulate] [text "Simulate Story"];
      viewSimulation model.simulatedStories
    ]


let main =
  beginnerProgram { 
    model = init ();
    update;
    view;
  }