module main

import src.cli
import src.server

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
	else if bef.cli.arguments.is_server {
		server.new(bef.cli.config)
	}
}
