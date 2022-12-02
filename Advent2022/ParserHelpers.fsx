open FParsec
let defaultedValue (r:ParserResult<'a, unit>) : 'a =
    match r with
    | Success (x,_,_) -> x
    | Failure _ -> Unchecked.defaultof<'a>
let runParser p s = run p s |> defaultedValue 
let test p s =
    match run p s with
    | Success (x,_,_) -> sprintf "Success: %A" x
    | Failure (x,_,_) -> sprintf "Failed: %s" x