module main

import src.cli
import src.server
import rb

struct BackendFilip {
mut:
	cli cli.Cli
}

fn main() {
	mut bef := BackendFilip{}

	if bef.cli.arguments.add_db != "" {
		bef.cli.config.add_database(bef.cli.arguments.add_db)
		exit(0)
	}
	else if bef.cli.arguments.remove_db != "" {
		bef.cli.config.remove_database(bef.cli.arguments.remove_db)
		exit(0)
	}
	else if bef.cli.arguments.is_get_db {
		rb.Event{name: "database"}.println(bef.cli.config.get_database_str())
		exit(0)
	}
	else if bef.cli.arguments.is_token {
		rb.Event{name: "token"}.println("BEF_CLIENT: ${cli.get_token(32).self}")
		rb.Event{name: "token"}.println("BEF_SERVER: ${cli.get_token(64).self}")
		exit(0)
	}
	else if bef.cli.arguments.is_server {
		server.new(bef.cli.config)
	}
}
