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
	else if bef.cli.arguments.is_token {
		rb.Event{name: "token"}.println(cli.get_token().self)
		exit(0)
	}
	else if bef.cli.arguments.is_server {
		server.new(bef.cli.config)
	}
}
