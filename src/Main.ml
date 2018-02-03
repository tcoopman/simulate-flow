open Tea.App
open Tea.Html

let (<|) f a = f a 

type model = {
  team: teamMember list;
  simulation: story list;
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
story = phase list
and
phase = {
  doneBy: teamMember list;
  startedOn: int;
  endedOn: int;
  phaseType: phaseType;
}
and
phaseType =
| ReadyForDevelopment
| InDevelopment
| ReadyForQA
| InQA
| ReadyForAcceptance
| Acceptance
| Done

type msg =
  | NoOp
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
  simulation = [
    [ 
      {
        doneBy = [];
        startedOn = 1;
        endedOn = 5;
        phaseType = ReadyForDevelopment;
      };
      {
        doneBy = [thomas];
        startedOn = 5;
        endedOn = 10;
        phaseType = InDevelopment;
      };
      {
        doneBy = [];
        startedOn = 10;
        endedOn = 15;
        phaseType = ReadyForQA;
      };
      {
        doneBy = [paul];
        startedOn = 15;
        endedOn = 18;
        phaseType = InQA;
      };
      {
        doneBy = [];
        startedOn = 18;
        endedOn = 25;
        phaseType = ReadyForAcceptance;
      };
      {
        doneBy = [michel];
        startedOn = 25;
        endedOn = 30;
        phaseType = Acceptance;
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

let phaseTypeToColor = function
  | ReadyForDevelopment -> "#DB2B39"
  | InDevelopment -> "#EE9EA5"
  | ReadyForQA -> "#29335C"
  | InQA -> "#9DA2B4"
  | ReadyForAcceptance -> "#F3A712"
  | Acceptance -> "#F9D793"
  | Done -> "#F8E8D3"

let update model = function
  | NoOp -> model

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

let view model =
  div
    []
    [ h1 [] [text "Simulation" ];
      viewSimulation model.simulation
    ]


let main =
  beginnerProgram { 
    model = init ();
    update;
    view;
  }