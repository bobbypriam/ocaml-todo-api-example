open Opium.Std
open Lwt.Infix

module Handlers (Todos : Todos.S) = struct
  open Ezjsonm

  let todos_list_handler () =
    match%lwt Todos.get_all () with
    | Ok todos ->
      Lwt.return @@ `Json (list (fun (todo : Todos.todo) ->
          dict [("id", int todo.id); ("content", string todo.content)]
        ) todos)
    | Error Todos.Database_error ->
      Lwt.return @@ `Json (dict [("error", string "Database error.")])

  let todos_add_handler req =
    App.json_of_body_exn req >>= (fun json ->
        let json_value = value json in
        let content = get_string (find json_value ["content"]) in
        match%lwt Todos.add content with
        | Ok () ->
          Lwt.return @@ `Json (dict [ ("ok", bool true) ])
        | Error Todos.Database_error ->
          Lwt.return @@ `Json (dict [("error", string "Database error.")])
      )
end

let start () =
  let module T = Todos.Make(Db) in
  let module H = Handlers(T) in

  let index_route = get "/" (fun _req -> `String "Hello TodoDB\n" |> respond') in

  let todos_list_route =
    get "/todos" (fun _req -> H.todos_list_handler () >>= respond') in

  let todos_add_route =
    post "/todos" (fun req -> H.todos_add_handler req >>= respond') in

  App.empty
  |> index_route
  |> todos_list_route
  |> todos_add_route
  |> App.run_command
