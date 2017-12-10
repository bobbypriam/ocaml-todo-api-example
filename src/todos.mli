type todo = {
  id: int;
  content: string;
}

val get_all : unit -> todo list Lwt.t

val add : string -> unit Lwt.t

val remove : int -> unit Lwt.t

val clear : unit -> unit Lwt.t
