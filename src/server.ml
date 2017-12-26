open Opium.Std

let index_page = get "/" (fun _req -> `String "Hello TodoDB\n" |> respond')

let todos_list =
  get "/todos" (fun _req ->
      let open Ezjsonm in
      match%lwt Todos.get_all () with
      | Ok todos ->
        let result_json =
          list (fun (todo : Todos.todo) ->
              dict [("id", int todo.id); ("content", string todo.content)]
            ) todos in
        `Json result_json |> respond'
      | Error Todos.Database_error ->
        `Json (dict [("error", string "Database error.")]) |> respond'
    )

let todos_add =
  post "/todos" (fun req ->
      let promise = req |> App.json_of_body_exn in
      Lwt.bind promise (fun json ->
          let open Ezjsonm in
          let json_value = value json in
          let content = get_string (find json_value ["content"]) in
          match%lwt Todos.add content with
          | Ok () ->
            `Json (dict [ ("ok", bool true) ]) |> respond'
          | Error Todos.Database_error ->
            `Json (dict [("error", string "Database error.")]) |> respond'
        )
    )

let start () =
  App.empty
  |> index_page
  |> todos_list
  |> todos_add
  |> App.run_command
