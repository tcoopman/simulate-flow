let (<|) f a = f a 

module Result = struct
    include Js.Result

    let map f r =
        match r with
        | Error e -> Error e
        | Ok x -> Ok (f x)

    let andThen f r =
        match r with
        | Error e -> Error e
        | Ok x -> f x
end