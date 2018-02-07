build:
	jbuilder build @install --dev

run:
	jbuilder exec tododb --dev

migrate:
	jbuilder exec tododb_migrate --dev

rollback:
	jbuilder exec tododb_rollback --dev

clean:
	jbuilder clean
