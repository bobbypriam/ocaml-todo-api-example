let pool =
  match Caqti_lwt.connect_pool ~max_size:10 (Uri.of_string Config.db_connection_url) with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)

type todo = {
  id: int;
  content: string;
}


type error =
  | Database_error


module Q = struct
  let get_all_todos =
    Caqti_request.collect
      Caqti_type.unit
      Caqti_type.(tup2 int string)
      "SELECT id, content FROM todos"

  let add_todo =
    Caqti_request.exec
      Caqti_type.string
      "INSERT INTO todos (content) VALUES (?)"

  let remove_todo =
    Caqti_request.exec
      Caqti_type.int
      "DELETE FROM todos WHERE id = ?"

  let clear_todos =
    Caqti_request.exec
      Caqti_type.unit
      "DELETE FROM todos"
end

let get_all_internal (module Db : Caqti_lwt.CONNECTION) =
  Db.fold Q.get_all_todos (fun (id, content) acc ->
    { id = id; content = content } :: acc
  ) () []

let get_all () =
  let%lwt todo_result = Caqti_lwt.Pool.use get_all_internal pool in
  match todo_result with
  | Ok todo_list -> Ok todo_list |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return


let add_internal content (module Db : Caqti_lwt.CONNECTION) =
  Db.exec Q.add_todo content

let add content =
  let%lwt result = Caqti_lwt.Pool.use (add_internal content) pool in
  match result with
  | Ok () -> Ok () |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return


let remove_internal id (module Db : Caqti_lwt.CONNECTION) =
  Db.exec Q.remove_todo id

let remove id =
  let%lwt result = Caqti_lwt.Pool.use (remove_internal id) pool in
  match result with
  | Ok () -> Ok () |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return


let clear_internal (module Db : Caqti_lwt.CONNECTION) =
  Db.exec Q.clear_todos ()

let clear () =
  let%lwt result = Caqti_lwt.Pool.use clear_internal pool in
  match result with
  | Ok () -> Ok () |> Lwt.return
  | Error _e -> Error Database_error |> Lwt.return
