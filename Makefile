build:
	jbuilder build @install --dev

run:
	jbuilder exec tododb --dev

migrate:
	jbuilder exec tododb_migrate --dev

clean:
	jbuilder clean
