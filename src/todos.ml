open Ezpostgresql.Pool

let pool = create ~conninfo:(Config.db_connection_url) ~size:10 ()

type todo = {
  id: int;
  content: string;
}

let get_all () =
  let%lwt rows = all ~query:"SELECT * FROM todos" pool in
  let result = Array.map (fun row -> {
        id = int_of_string row.(0);
        content = row.(1);
      }) rows in
  Lwt.return @@ Array.to_list result


let add content =
  command ~query:"INSERT INTO todos (content) VALUES ($1)"
    ~params:[| content |] pool


let remove id =
  command ~query:"DELETE FROM todos WHERE id = $1"
    ~params:[| string_of_int id |] pool


let clear () =
  command ~query:"DELETE FROM todos" pool
