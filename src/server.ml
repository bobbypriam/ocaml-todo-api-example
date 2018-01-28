open Opium.Std
open Lwt.Infix

let index_page = get "/" (fun _req -> `String "Hello TodoDB\n" |> respond')

let todos_list_handler () =
  let open Ezjsonm in
  match%lwt Todos.get_all () with
  | Ok todos ->
    let result_json =
      list (fun (todo : Todos.todo) ->
          dict [("id", int todo.id); ("content", string todo.content)]
        ) todos in
    Lwt.return @@ `Json result_json
  | Error Todos.Database_error ->
    Lwt.return @@ `Json (dict [("error", string "Database error.")])

let todos_add_handler req =
  App.json_of_body_exn req >>= (fun json ->
      let open Ezjsonm in
      let json_value = value json in
      let content = get_string (find json_value ["content"]) in
      match%lwt Todos.add content with
      | Ok () ->
        Lwt.return @@ `Json (dict [ ("ok", bool true) ])
      | Error Todos.Database_error ->
        Lwt.return @@ `Json (dict [("error", string "Database error.")])
    )

let todos_list_route =
  get "/todos" (fun _req -> todos_list_handler () >>= respond')

let todos_add_route =
  post "/todos" (fun req -> todos_add_handler req >>= respond')

let start () =
  App.empty
  |> index_page
  |> todos_list_route
  |> todos_add_route
  |> App.run_command
