let create_pool () =
  match Caqti_lwt.connect_pool ~max_size:10 (Uri.of_string Config.db_connection_url) with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)
