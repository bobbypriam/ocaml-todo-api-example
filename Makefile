build:
	jbuilder build @install --dev

run: build
	jbuilder exec tododb

migrate: build
	jbuilder exec tododb_migrate

clean:
	jbuilder clean
