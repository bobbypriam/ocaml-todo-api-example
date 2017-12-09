# TodoDB

An example project of building a Postgresql-backed API in OCaml using Opium and Ezpostgresql.

## Getting started

These commands are run using opam 2.0.

```bash
$ opam pin add -yn tododb .

$ opam install --deps-only tododb

# Temporary until ezpostgresql is available in opam
$ opam pin add ezpostgresql git+https://github.com/bobbypriambodo/ezpostgresql.git

$ jbuilder build @install

# Migrate the database; make sure you have postgresql running
# on localhost:5432
$ jbuilder exec tododb_migrate

$ jbuilder exec tododb
```
