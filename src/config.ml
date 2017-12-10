(* Connections *)
let db_connection_url =
  try Sys.getenv "DATABASE_URL"
  with Not_found -> "postgresql://localhost:5432"
