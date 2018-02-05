open Basics
open Model


type simulationFailureResults =
    | NoStoriesToSimulate
    | NoTeamMembers
    | NoStepsInStory
    | NoMemberAvailable

type simulationConfig = {
    currentDay: int;
    availableTeam: teamMember list;
}

let newSimulationConfig config =
    {
        currentDay = 1;
        availableTeam = config.team;
    }

let findMemberToWorkOnIt processStep availablePeople = 
    let hasRole member role =
        List.exists (fun r -> r == role) member.roles
    in
    let (available, remaining) = List.partition (fun member ->
        match processStep with
        | Development -> hasRole member Developer
        | QA -> hasRole member QA
        | Acceptance -> hasRole member Accepter
    ) availablePeople in
    match available with
    | [] -> (None, remaining)
    | hd::tl -> (Some hd, tl @ remaining)

type story = {
    name: string;
    doneSteps: doneStep list;
    activeStep: workingOnStep option;
    nextSteps: step list;
}
and workingOnStep = {
    activeDuration: int;
    startDate: int;
    endDate: int;
    processStep: processStep;
    peopleWorkingOnIt: teamMember list;
}
and doneStep = {
    activeDuration: int;
    startDate: int;
    endDate: int;
    processStep: processStep;
}


let firstWorkOnActiveStories day availablePeople stories =
    let (activeStories, otherStories) = List.partition (fun story -> Js.Option.isSome story.activeStep) stories in
    List.fold_left (fun (availablePeople, processStories, availableNextDay) story -> 
        match (story.activeStep, story.nextSteps) with
        | (Some step, _) ->
            let endDate = day in
            if (endDate - step.startDate >= (step.activeDuration - 1)) then
                let doneStep = {
                    activeDuration = step.activeDuration;
                    startDate = step.startDate;
                    endDate = endDate;
                    processStep = step.processStep;
                } in
                let workingStory = {story with activeStep = None; doneSteps = doneStep :: story.doneSteps} in
                (* Js.log "done on!";
                Js.log doneStep.activeDuration;
                Js.log doneStep.startDate;
                Js.log doneStep.endDate;
                Js.log (List.map (fun (x:teamMember) -> x.name) step.peopleWorkingOnIt); *)
                (availablePeople, workingStory :: processStories, availableNextDay @ step.peopleWorkingOnIt)
            else
                let step = { step with endDate = day; } in
                let workingStory = { story with activeStep = Some step } in
                (availablePeople, workingStory :: processStories, availableNextDay)
        | (None, step::nexts) ->
            let (member, others) = findMemberToWorkOnIt step.processStep availablePeople in
            begin match member with
            | None -> 
                (availablePeople, story :: processStories, availableNextDay)
            | Some member -> 
                let step = {
                    activeDuration = step.activeDuration;
                    startDate = day;
                    endDate = day;
                    processStep = step.processStep;
                    peopleWorkingOnIt = [member];
                } in
                let workingStory = {story with 
                    activeStep = Some step;
                    nextSteps = nexts;
                }in
                (others, workingStory :: processStories, availableNextDay)
            end
        | (None, []) ->
            (availablePeople, story :: processStories, availableNextDay)
    ) (availablePeople, [], []) (activeStories @ otherStories)
    

let workOnStories day availablePeople stories =
    firstWorkOnActiveStories day availablePeople stories

let removeDone stories =
    let isDone story =
        match (story.activeStep, story.nextSteps) with
        | (Some _, _) -> false
        | (None, _hd::_) -> false
        | _ -> true
    in
    List.partition isDone stories

let rec simulate' config stories done_ =
    let processStepToPhaseStep processStep =
        match processStep with
        | Development -> Doing Development
        | Acceptance -> Doing Acceptance
        | QA -> Doing QA
    in
    let doneToOutput () = 
        List.map (fun story -> 
            let steps = List.map (fun (step:doneStep) -> {
                doneBy = [];
                startedOn = step.startDate;
                endedOn = step.endDate;
                phaseType = processStepToPhaseStep step.processStep
            }) story.doneSteps in
            {
            name = story.name;
            steps = steps;
            }
        ) done_
    in
    (* Js.log "before simulate";
    Js.log (List.length stories);
    Js.log (List.length done_); *)
    match stories with
    | [] -> doneToOutput ()
    | _ -> 
        let (team, stories, teamForNextDay) = workOnStories config.currentDay config.availableTeam stories in
        let (newDone, stories) = removeDone stories in
        let config = {config with availableTeam = (team @ teamForNextDay); currentDay = config.currentDay + 1} in
        if (config.currentDay > 50) then
            doneToOutput ()
        else
            simulate' config stories (done_ @ newDone)


let validatePreConditions config stories =
    match (stories, config.team) with
    | ([], _) -> Js.Result.Error NoStoriesToSimulate
    | (_, []) -> Js.Result.Error NoTeamMembers
    | _ -> Js.Result.Ok true

let storiesToSimulationStories stories =
    List.map (fun (story: Model.story) -> {
        name = story.name;
        doneSteps = [];
        activeStep = None;
        nextSteps = story.duration;
    }) stories

let simulate config stories =
    let stories = storiesToSimulationStories stories in
    Result.(
        validatePreConditions config stories
        |> map (fun _ -> newSimulationConfig config)
        |> map (fun simulationConfig -> simulate' simulationConfig stories [])
    )