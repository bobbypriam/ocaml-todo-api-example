all:
	jbuilder build @install

run: all
	jbuilder exec tododb

migrate: all
	jbuilder exec tododb_migrate
