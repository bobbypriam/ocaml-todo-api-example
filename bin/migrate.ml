open Ezpostgresql

let migrate () =
  let _ =
    let open Lwt_result.Infix in
    print_endline "creating todo table." ;
    connect ~conninfo:(Config.db_connection_url) () >>= fun conn ->
    command
      ~query:"
        CREATE TABLE IF NOT EXISTS todos (
          id SERIAL NOT NULL PRIMARY KEY,
          content VARCHAR
        )
      "
      conn >>= fun () ->
    finish conn
  in
  Lwt.return_unit


let () = Lwt_main.run (migrate ())
