open Ezpostgresql

let%lwt conn = Ezpostgresql.connect ~conninfo:"postgresql://localhost:5432" ()

type todo = Todo of string

let todo_of_string content = Todo content

let string_of_todo (Todo content) = content

let get_all () =
  let%lwt rows = all ~query:"SELECT * FROM todos" conn in
  let result = Array.map (fun row -> Todo row.(0)) rows in
  Lwt.return @@ Array.to_list result


let add (Todo content) =
  command ~query:"INSERT INTO todos (content) VALUES ($1)"
    ~params:[| content |] conn


let remove (Todo content) =
  command ~query:"DELETE FROM todos WHERE content = $1"
    ~params:[| content |] conn


let clear () =
  command ~query:"DELETE FROM todos" conn
