open Ezpostgresql

let migrate () =
  print_endline "creating todo table." ;
  let%lwt conn = connect ~conninfo:(Config.db_connection_url) () in
  let%lwt () =
    command
      ~query:"
        CREATE TABLE IF NOT EXISTS todos (
          id SERIAL NOT NULL PRIMARY KEY,
          content VARCHAR
        )
      "
      conn in
  finish conn


let () = Lwt_main.run (migrate ())
