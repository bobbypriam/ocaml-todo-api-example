open Ezpostgresql

let migrate () =
  print_endline "creating todo table." ;
  let%lwt conn = connect ~conninfo:"postgresql://localhost:5432" () in
  let%lwt () =
    command
      ~query:
        "CREATE TABLE IF NOT EXISTS todos (content VARCHAR PRIMARY KEY)"
      conn in
  finish conn


let () = Lwt_main.run (migrate ())
