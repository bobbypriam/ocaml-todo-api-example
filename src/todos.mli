type todo

val todo_of_string : string -> todo

val string_of_todo : todo -> string

val get_all : unit -> todo list Lwt.t

val add : todo -> unit Lwt.t

val remove : todo -> unit Lwt.t

val clear : unit -> unit Lwt.t
