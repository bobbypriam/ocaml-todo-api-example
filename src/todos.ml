open Ezpostgresql.Pool
open Lwt_result.Infix

let pool = create ~conninfo:(Config.db_connection_url) ~size:10 ()

type todo = {
  id: int;
  content: string;
}

type error =
  | Database_error

let get_all () =
  let%lwt todo_result =
    all ~query:"SELECT * FROM todos" pool >|= fun rows ->
    let result = Array.map (fun row -> {
          id = int_of_string row.(0);
          content = row.(1);
        }) rows in
    Array.to_list result
  in
  match todo_result with
  | Ok todo_list -> Ok todo_list |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return


let add content =
  let%lwt result =
    command ~query:"INSERT INTO todos (content) VALUES ($1)"
      ~params:[| content |] pool
  in
  match result with
  | Ok () -> Ok () |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return


let remove id =
  let%lwt result =
    command ~query:"DELETE FROM todos WHERE id = $1"
      ~params:[| string_of_int id |] pool
  in
  match result with
  | Ok () -> Ok () |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return


let clear () =
  let%lwt result =
    command ~query:"DELETE FROM todos" pool
  in
  match result with
  | Ok () -> Ok () |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return
