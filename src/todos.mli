module type S = sig
  type todo = {
    id: int;
    content: string;
  }

  type error =
    | Database_error

  val get_all : unit -> (todo list, error) result Lwt.t

  val add : string -> (unit, error) result Lwt.t

  val remove : int -> (unit, error) result Lwt.t

  val clear : unit -> (unit, error) result Lwt.t
end

module Make (Db : module type of Db) : S
