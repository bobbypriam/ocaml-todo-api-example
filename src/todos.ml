open Ezpostgresql.Pool

let pool = create ~conninfo:(Config.db_connection_url) ~size:10 ()

type todo = Todo of string

let todo_of_string content = Todo content

let string_of_todo (Todo content) = content

let get_all () =
  let%lwt rows = all ~query:"SELECT * FROM todos" pool in
  let result = Array.map (fun row -> Todo row.(1)) rows in
  Lwt.return @@ Array.to_list result


let add (Todo content) =
  command ~query:"INSERT INTO todos (content) VALUES ($1)"
    ~params:[| content |] pool


let remove (Todo content) =
  command ~query:"DELETE FROM todos WHERE content = $1"
    ~params:[| content |] pool


let clear () =
  command ~query:"DELETE FROM todos" pool
